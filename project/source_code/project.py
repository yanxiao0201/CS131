from twisted.internet import protocol, reactor, endpoints

import conf
import sys
import time
import urllib2
import json
import logging

locations = {}
intramsg = ""
#flooded = 0

class Echo(protocol.Protocol):#server code
    def connectionLost(self, reason):
        logging.info("[intra-server] {} has a connection lost: {}".format(server_id,reason.getErrorMessage()))

    def dataReceived(self, data):
        global locations
        #global flooded
        global intramsg

        cmd = data.strip()
        split = cmd.split()

        print("debug: {}".format(split))
        real_cmd = split[0]
        if real_cmd == "IAMAT":# this message comes from a client
           try:
               if len(split) != 4:
                   raise Exception
               message = "AT {}".format(server_id)
               timediff = time.time() - float(split[-1])
               if timediff > 0:
                   message += " +" + str(timediff)
               else:
                   message += " " + str(timediff)

               for j in split[1:len(split)]:
                   message += " "
                   message += j

               name = split[1]
               isnewest = True
               if name in locations:
                   if locations[name][1] < float(split[-1]):
                       locations[name] = [message, float(split[-1])]
                   else:
                       isnewest = False #not the newest location
               else:
                   locations[name] = [message, float(split[-1])]


               self.transport.write(message)
               self.transport.write("\n")
               logging.info("{} received message:{}\n".format(server_id,message))

           except Exception:
               self.transport.write("? " + data)
               self.transport.write("\n")
               logging.info("{} received invalid input:{}\n".format(server_id,data))

           else:
               if isnewest:
                   #flooded = flooded + 1
                   intramsg = message#+ " " + str(flooded)
                   for i in conf.PARTNER[server_id]:
                       reactor.connectTCP("localhost", i, ClientFactory())

        elif real_cmd == "AT": # this message comes from another server
            self.transport.write("{} received the message: {}\n".format(server_id,data))
            logging.info("[intra-server] {} received message: {}\n".format(server_id,data))

            name = split[3]
            newtime = float(split[-1])

            isflooded = False
            if name in locations:
                if locations[name][1] >= newtime: #already updated
                    isflooded = True # no need to flood
                else:
                    locations[name] = [data,newtime]
            else:
                locations[name] = [data,newtime]

            if (not isflooded):
                intramsg = data
                for i in conf.PARTNER[server_id]:
                    reactor.connectTCP("localhost",i, ClientFactory())

        elif real_cmd == "WHATSAT":
            try:
                if len(split) != 4:
                    raise Exception
                name = split[1]
                radius = int(split[2])
                upper = int(split[3])
                if radius > 50:
                    raise Exception
                elif upper > 20:
                    raise Exception
                elif not name in locations.keys():
                    raise Exception
                else:
                    msn = locations[name][0]

            except Exception:
                self.transport.write("? " + data)
                self.transport.write("\n")
                logging.info("{} received invalid input:{}\n".format(server_id,data))

            else:
                self.transport.write(msn + "\n")
                logging.info("{} sent message:{}\n".format(server_id,msn))
                try:
                    elements = msn.strip().split()
                    gps = elements[4].replace("+",",+").replace("-",",-").strip(',')
                    url = conf.WEBSITE + "location=" + gps + "&radius=" + str(radius * 1000) + "&key=" + conf.API_KEY
                    response = urllib2.urlopen(url)
                    answer = json.load(response)
                    tmp = answer["results"][:upper]
                    answer["results"] = tmp
                    self.transport.write(json.dumps(answer))
                    self.transport.write("\n")
                    logging.info("{} has success getting google place data\n".format(server_id))
                except Exception:
                    self.transprot.write("Error getting google place data\n")
                    logging.info("{} has error getting google place data\n".format(server_id))

        else:
             self.transport.write("? " + data)
             self.transport.write("\n")
             logging.info("{} received invalid input:{}\n".format(server_id,data))

class EchoFactory(protocol.Factory):
    def buildProtocol(self, addr):
        return Echo()

class MyClient(protocol.Protocol):#client code (when using server as a client)
    def connectionMade(self):
        self.transport.write(intramsg) #send to other server adding the flood indicator
        logging.info("[intra-server] {} sent message: {}]\n".format(server_id, intramsg))

    def connectionLost(self, reason):
        logging.info("[intra-server] {} has a connection lost: {}".format(server_id,reason.getErrorMessage()))

    def dataReceived(self, data):
        logging.info("[intra-server] {} received message: {}".format(server_id, data))
        self.transport.loseConnection()

class ClientFactory(protocol.ClientFactory):
    def buildProtocol(self, addr):
        return MyClient()

    def clientConnectionFailed(self,connector,reason):
        logging.info("[intra-server] {} has a connection lost: {}".format(server_id,reason.getErrorMessage()))

server_id = sys.argv[1]
server_port = conf.PORT_NUM[server_id]
logging.basicConfig(filename = "{}.log".format(server_id), level = logging.INFO)

endpoints.serverFromString(reactor, "tcp:{}".format(server_port)).listen(EchoFactory())
reactor.run()
