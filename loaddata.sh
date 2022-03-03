export TOKEN=$(gcloud auth print-access-token)

curl --location --request POST "https://firestore.googleapis.com/v1/projects/$GOOGLE_CLOUD_PROJECT/databases/(default)/documents/notes?documentId=b78dfdb" \
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
}"