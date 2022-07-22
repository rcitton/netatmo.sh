#!/bin/bash
 
getmeasurecsv() {
    # ------------------------------------------------------
    # Help
    # ------------------------------------------------------
    # usage: getmeasurecsv <USER> <PASSWORD> <CLIENT_ID> <CLIENT_SECRET> <DEVICE_ID> <MODULE_ID> <TYPE> <STARTDATE> <ENDDATE> <FORMAT>
    #
    # USER + PASSWORD -> your NetAtmo Website login
    # CLIENT_ID + CLIENT_SECRET -> your NetAtmo Application client ID/secret https://dev.netatmo.com/apps/createanapp#form
    # DEVICE_ID -> Base Station ID
    # MODULE_ID -> Module ID
    # TYPE -> Comma-separated list of sensors (Temperature,Humidity,etc.)
    # STARTDATE -> Begin export date in format YYYY-mm-dd HH:MM
    # ENDDATE -> End export date in format YYYY-mm-dd HH:MM
    # FORMAT -> csv or xls
 
    # ------------------------------------------------------
    # Parsing Arguments
    # ------------------------------------------------------
    USER=${1}
    PASS=${2}
    CLIENT_ID=${3}
    CLIENT_SECRET=${4}

    DEVICE_ID=${5}
    MODULE_ID=${6}
    TYPE=${7}
    DATETIMEBEGIN=${8}
    DATETIMEEND=${9}
    FORMAT=${10}
 
    # ------------------------------------------------------
    # Define some constants
    # ------------------------------------------------------
    URL_LOGIN="https://auth.netatmo.com/en-us/access/login"
    URL_POSTLOGIN="https://auth.netatmo.com/access/postlogin"
    API_GETMEASURECSV="https://api.netatmo.com/api/getmeasurecsv"

    # ------------------------------------------------------
    # Convert start and end date to timestamp
    # ------------------------------------------------------
    DATEBEGIN="$(date --date="$DATETIMEBEGIN" "+%d.%m.%Y")"
    TIMEBEGIN="$(date --date="$DATETIMEBEGIN" "+%H:%M")"
    DATE_BEGIN="$(date --date="$DATETIMEBEGIN" "+%s")"
    DATEEND="$(date --date="$DATETIMEEND" "+%d.%m.%Y")"
    TIMEEND="$(date --date="$DATETIMEEND" "+%H:%M")"
    DATE_END="$(date --date="$DATETIMEEND" "+%s")"

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
    PARAM="access_token=$ACCESS_TOKEN&device_id=$DEVICE_ID&type=$TYPE&module_id=$MODULE_ID&scale=max&format=$FORMAT&datebegin=$DATEBEGIN&timebegin=$TIMEBEGIN&dateend=$DATEEND&timeend=$TIMEEND&date_begin=$DATE_BEGIN&date_end=$DATE_END"

    # now download data as csv
    curl -d $PARAM $API_GETMEASURECSV
}
#____________________________________________________________________________________________________________________________________
 
getmeasurecsv "user@email.com" "mySecretPassword" "54d96a28a47b05254231hdrw" "nRQS3Jrps7x612OPDcWuIN854z2Rg" "12:23:45:56:78:33" "02:00:00:12:23:45" "Temperature,Humidity" "2015-05-17 10:00:00" "2015-05-18 12:00:00" "csv"
