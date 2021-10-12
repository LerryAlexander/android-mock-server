# android-mock-server

## If you are on a Linux system

### Prerequisites:

* Docker

### Getting Started

1) Start android + mock-server containers with following command:
    
    `docker-compose up -d`

## If you are on a Mac OS X

### Prerequisites:

* Docker
* Android Studio 
* Create an android emulator (API <= 28, without Play Store) using avd manager.

### Getting Started

1) Launch emulator device from command line:
    
    `emulator -writable-system -netdelay none -netspeed full @<EMULATOR_NAME>` --> replace <EMULATOR_NAME> with the emulator you want to use (run `emulator -list-avds` to list all device names)
2) Run following command to configure the whole setup
    
    `bash config/setup.sh`
    
3) Launch mock-server container with following command:
    
    `docker-compose up -d mock-server`

### Notes:

* The `setup.sh` file export environment variables, configure proxy on emulator, install ssl certificates, install sample apk and merge predefined mock expectations.
* Active expectations, received requests, proxied requests and matched expectations can be found at: http://localhost:1080/mockserver/dashboard
