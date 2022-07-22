#!/bin/bash
 
listDevices() {
    # ------------------------------------------------------
    # Help
    # ------------------------------------------------------
    # usage: listdevices <USER> <PASSWORD> <CLIENT-ID> <CLIENT-SECRET>
    #
    # USER + PASSWORD -> your NetAtmo Website login
    # CLIENT_ID + CLIENT_SECRET -> your NetAtmo Application client ID/secret https://dev.netatmo.com/apps/createanapp#form
 
    # ------------------------------------------------------
    # Parsing Arguments
    # ------------------------------------------------------
    USER=$1
    PASS=$2
    CLIENT_ID=$3
    CLIENT_SECRET=$4
 
    # ------------------------------------------------------
    # Define some constants
    # ------------------------------------------------------
    URL_LOGIN="https://auth.netatmo.com/en-us/access/login"
    URL_POSTLOGIN="https://auth.netatmo.com/access/postlogin"
    API_GETMEASURECSV="https://api.netatmo.com/api/getstationsdata"

    # ------------------------------------------------------
    # Now let's fetch the data
    # ------------------------------------------------------
    # next we extract the access_token from the session cookie
    ACCESS_TOKEN=`curl --silent  --location --request POST "https://api.netatmo.com/oauth2/token" \
                       --form "grant_type=password" \
                       --form "client_id=${CLIENT_ID}" \
                       --form "client_secret=${CLIENT_SECRET}" \
                       --form "username=${USER}" \
                       --form "password=${PASS}" | jq -r '.access_token'`

    # build the POST data
    PARAM="access_token=$ACCESS_TOKEN"
 
    # now download json data
    curl --silent -d $PARAM $API_GETMEASURECSV
}
#____________________________________________________________________________________________________________________________________
 
listDevices "user@email.com" "mySecretPassword" "54d96a28a47b05254231hdrw" "nRQS3Jrps7x612OPDcWuIN854z2Rg"
