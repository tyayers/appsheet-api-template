export TOKEN=$(gcloud auth print-access-token)

export COUNTER=0

while [ $COUNTER -le 5 ]
do
    RESULT=$(curl --location --request POST "https://firestore.googleapis.com/v1/projects/$GOOGLE_CLOUD_PROJECT/databases/(default)/documents/notes?documentId=b78dfdb" \
    --header "Authorization: Bearer $TOKEN" \
    --header "Content-Type: application/json" \
    --data-raw "{
        'fields': {
            'id': {
                'stringValue': 'b78dfdb'
            },
            'name': {
                'stringValue': 'Test note'
            },
            'text': {
                'stringValue': 'This is a test note'
            },
            'location': {
                'stringValue': 'Berlin, Germany'
            },
            'likes': {
                'integerValue': 7
            }
        }
    }")

    echo $RESULT

    if [[ "$RESULT" == *error* ]]
    then
        COUNTER=$(( $COUNTER + 1 ))
    else
        COUNTER=6
    fi

    sleep 2s
done