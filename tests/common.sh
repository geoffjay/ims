#
# Generate URL string
#
# This is intended to be internal to this file.
#
function __create_url {
  eval "$1='http://localhost:3003/api/$2s'"
}

#
# Create - POST
#
# TODO: Add -sI option to curl and output Location result (?)
# TODO: https://stackoverflow.com/questions/46507336/how-to-retrieve-the-real-redirect-location-header-with-curl-without-using-redi
#
function rest-create {
  local url
  __create_url url $1
  curl -X POST $url -H 'application/json'
}

#
# Read - GET
#
function rest-read {
  local url
  __create_url url $1
  curl -X GET $url
}

#
# Update - PUT
#
function rest-update {
  local url
  __create_url url $1
  curl -X PUT $url/$2 -H 'application/json' -d $3
}

#
# Delete - DELETE
#
function rest-delete {
  local url
  __create_url url $1
  curl -X DELETE $url/$2
}
