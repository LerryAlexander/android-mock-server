#!/bin/bash
function check_emulator_is_ready () {
  boot_completed=false
  while [ "$boot_completed" == false ]; do
    status=$(adb wait-for-device shell getprop sys.boot_completed | tr -d '\r')
    echo "Waiting for emulator to be ready"

    if [ "$status" == "1" ]; then
      boot_completed=true
      echo "Emulator is ready"
    else
      sleep 1
    fi
  done
}
check_emulator_is_ready

echo "EXPORTING ENVIRONMENT VARIABLES"
export ENABLE_PROXY_ON_EMULATOR=true
echo $ENABLE_PROXY_ON_EMULATOR
export HTTP_PROXY=http://$(ipconfig getifaddr en0):1080
echo $HTTP_PROXY
echo "INSTALLING SSL CERTIFICATE ON EMULATOR"
/bin/bash android/install-ssl.sh
check_emulator_is_ready
echo "ENABLE PROXY ON EMULATOR TO CONNECT TO MOCKSERVER"
/bin/bash android/enable-proxy-on-emulator.sh
check_emulator_is_ready
echo "INSTALLING APK ON EMULATOR"
/bin/bash android/install-apk.sh
check_emulator_is_ready
echo "INITIALIZING WITH DEFAULT MOCKS"
/bin/bash mock-server/merge-expectations.sh