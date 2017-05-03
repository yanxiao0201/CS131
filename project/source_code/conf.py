
# A configuration file for the Twisted Places proxy herd

# Google Places API key

WEBSITE="https://maps.googleapis.com/maps/api/place/nearbysearch/json?"

API_KEY=""

# TCP port numbers for each server instance (server ID: case sensitive)
# Please use the port numbers allocated by the TA.
PORT_NUM = {
    'Alford': 12000,
    'Ball': 12001,
    'Hamilton': 12002,
    'Holiday': 12003,
    'Welsh': 12004
}

PROJ_TAG="Fall 2016"

PARTNER = {
    'Alford': [12002,12004],
    'Ball': [12004,12003],
    'Hamilton': [12000,12003],
    'Holiday': [12001,12002],
    'Welsh': [12000,12001]
}
