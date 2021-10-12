#!/bin/bash
if [ $(echo "$ENABLE_PROXY_ON_EMULATOR" |tr [:upper:] [:lower:]) = "true" ]; then
    if [ ! -z "${HTTP_PROXY// }" ]; then
      if [[ $HTTP_PROXY == *"http"* ]]; then
        protocol="$(echo $HTTP_PROXY | grep :// | sed -e's,^\(.*://\).*,\1,g')"
        proxy="$(echo ${HTTP_PROXY/$protocol/})"
        echo "[EMULATOR] - Proxy: $proxy"

        IFS=':' read -r -a p <<< "$proxy"

        echo "[EMULATOR] - Proxy-IP: ${p[0]}"
        echo "[EMULATOR] - Proxy-Port: ${p[1]}"
        
        echo "Enable proxy on Android emulator. Please make sure that docker-container has internet access!"
        adb root

        echo "Set up the Proxy"
        adb shell "content update --uri content://telephony/carriers --bind proxy:s:"0.0.0.0" --bind port:s:"0000" --where "mcc=310" --where "mnc=260""
        sleep 5
        adb shell "content update --uri content://telephony/carriers --bind proxy:s:"${p[0]}" --bind port:s:"${p[1]}" --where "mcc=310" --where "mnc=260""

        if [ ! -z "${HTTP_PROXY_USER}" ]; then
          sleep 2
          adb shell "content update --uri content://telephony/carriers --bind user:s:"${HTTP_PROXY_USER}" --where "mcc=310" --where "mnc=260""
        fi
        if [ ! -z "${HTTP_PROXY_PASSWORD}" ]; then
          sleep 2
          adb shell "content update --uri content://telephony/carriers --bind password:s:"${HTTP_PROXY_PASSWORD}" --where "mcc=310" --where "mnc=260""
        fi

        adb unroot

        # Mobile data need to be restarted for Android 10 or higher
        adb shell svc data disable
        adb shell svc data enable
      else
        echo "Please use http:// in the beginning!"
      fi
    else
      echo "$HTTP_PROXY is not given! Please pass it through environment variable!"
      exit 1
    fi
else
  echo proxy on emulator wont be enabled since ENABLE_PROXY_ON_EMULATOR is set to $ENABLE_PROXY_ON_EMULATOR
fi