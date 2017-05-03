import urllib2
import json

PLACES = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=+34.068930,-118.445127&radius=10&key=AIzaSyA97g_413VB8u0zwlIr39HAy0VCk-7H0EQ"

response = urllib2.urlopen(PLACES)
data = json.load(response)
print data
