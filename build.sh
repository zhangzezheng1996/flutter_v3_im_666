#!/usr/bin/env bash

pgyer_key=249d0a02125cc624510f76f462f53769
pgyer_secret=2043c58c68facf070a190ee33d81250d

# build the apk
echo "------------------------------  start build android apk  ------------------------------"
BUILD_START=$(date +%s)
flutter build apk --split-per-abi
BUILD_END=$(date +%s)
BUILD_TIME=$((BUILD_END - BUILD_START))
printf "flutter build apk took %s seconds.\n" $BUILD_TIME

echo "------------------------------  start upload apk  ------------------------------"
# upload apk to server
UPLOAD_START=$(date +%s)
FILENAME=build/app/outputs/apk/release/app-arm64-v8a-release.apk
FILE_SIZE=$(stat -f%z "$FILENAME")

curl -F "file=@$FILENAME" \
  -F "installType=1" \
  -F "password=" \
  -F "uKey=$pgyer_key" \
  -F "updateDescription=ducafecat" \
  -F "_api_key=$pgyer_secret" \
  https://upload.pgyer.com/apiv1/app/upload

UPLOAD_END=$(date +%s)
UPLOAD_TIME=$((UPLOAD_END - UPLOAD_START))
printf "\n"
printf "upload took %s seconds and size is $FILE_SIZE kb.\n" $UPLOAD_TIME

echo "------------------------------  start update apk  ------------------------------"

echo "download link: https://www.pgyer.com/ao0k"
