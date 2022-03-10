gcloud services enable appengine.googleapis.com
gcloud services enable firestore.googleapis.com

if [[ $(gcloud app describe 2>&1 || true) == *'ERROR'* ]]; then echo 'No app engine or firestore instances found, creating...' && gcloud app create --region=europe-west && gcloud firestore databases create --region=europe-west; fi

echo 'Now updating service account with correct permissions..'

PROJECTNUMBER=$(gcloud projects list --filter=\"$(gcloud config get-value project)\" --format=\"value(PROJECT_NUMBER)\") && gcloud projects add-iam-policy-binding $GOOGLE_CLOUD_PROJECT --member=\"serviceAccount:$PROJECTNUMBER-compute@developer.gserviceaccount.com\" --role='roles/datastore.user'

echo 'Now loading some test data..' && ./loaddata.sh


