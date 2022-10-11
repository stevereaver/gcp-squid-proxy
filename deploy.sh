#!/bin/bash
ECHO=`which echo`
. ./config.sh
gcloud config set project $PROJECT_ID
gcloud services enable secretmanager.googleapis.com
gcloud services enable serviceusage.googleapis.com
gcloud services enable iam.googleapis.com
gcloud services enable cloudbuild.googleapis.com
gcloud services enable cloudresourcemanager.googleapis.com
gcloud services enable iap.googleapis.com
# Set Permissions
gcloud projects add-iam-policy-binding ${PROJECT_ID} --member serviceAccount:$(gcloud projects describe ${PROJECT_ID} --format 'value(projectNumber)')@cloudbuild.gserviceaccount.com --role roles/owner
# Submit Build
gcloud builds submit --config "cloudbuild.yaml" --timeout=1200s