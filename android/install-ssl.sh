#!/bin/bash
PEM_FILE_NAME=mock-server/certificate/CertificateAuthorityCertificate.pem
hash=$(openssl x509 -inform PEM -subject_hash_old -in $PEM_FILE_NAME | head -1)
OUT_FILE_NAME="$hash.0"

cp $PEM_FILE_NAME $OUT_FILE_NAME
openssl x509 -inform PEM -text -in $PEM_FILE_NAME -out /dev/null >> $OUT_FILE_NAME

echo "Saved to $OUT_FILE_NAME"

adb root
sleep 5

echo "mount"
adb remount

echo "push certificate"
adb push $OUT_FILE_NAME /system/etc/security/cacerts/

echo "add permissions"
adb shell "su 0 chmod 644 /system/etc/security/cacerts/$OUT_FILE_NAME"

echo "adb Reboot"
adb reboot
