This repository contains recipes for building software for embedded systems. While the range of applications is manifold,
the examples given here relate to application for gardening / farming.  

It builds an ESP32 firmware in a [container](https://github.com/bbusse/esphome-build) providing an [ESPHome](https://esphome.io/) build environment  

Configuration files for the firmware target are kept in a [seperate repository](https://github.com/bbusse/esphome-cfg) and fetched during build  

Different kinds of sensors are used for various applications, mostly for measuring temperature and humidity but also
atmospheric pressure and fine dust where applicable

## Build
### Create an `argfile.conf`
This file must contain all the necessary variables  
An example is given below, adjust to your needs
```
WIFI_SSID="farm-nerds"
WIFI_PASSPHRASE="farm-nerds-passphrase"
HA_API_KEY="6C6eGlbYMw1sEYlURtpIOquRlSIk58sq9Bz46m5XDsk="
HA_OTA_PASSWORD="LjwgwKMVvRlMNWom68T/lA6nR5AwFmqA"
```
To create an individual random HA_API_KEY
```
# Create key
head -c32 /dev/random | uuencode -m 
```
### Build on Linux/BSD
Configuration yaml files for ESPHome need to be supplied as build argument  
and are fetched from [esphome-cfg](https://github.com/bbusse/esphome-cfg)  
  
#### Compost
DS18B20 / BME280
```
$ podman build . -t compost-0 --build-arg-file=argfile.conf --build-arg ESPHOME_CFG=compost-0.yaml
```

#### Greenhouse
DHT22 / AM2302
```
$ podman build . -t greenhouse-1 --build-arg-file=argfile.conf  --build-arg ESPHOME_CFG=greenhouse-1.yaml
```

#### Seedling box
BME280
```
$ podman build . -t seedling-box-0 --build-arg-file=argfile.conf --build-arg ESPHOME_CFG="seedling-box-0.yaml"
```

#### Weather station
BME680
```
$ podman build . -t weather --build-arg-file=argfile.conf --build-arg ESPHOME_CFG=weather.yaml
```

### Copy the built firmware from the running container to the local filesystem
```
$ export VARIANT=compost-0
$ podman run localhost/${VARIANT}
$ podman cp $(podman ps | awk '/'${VARIANT}'/ {print $1}'):/home/build/.esphome/build/${VARIANT}/.pioenvs/${VARIANT}/firmware-${VARIANT).bin .
```

### Build on Windows
#### Install Python including pip
[Python Download](https://www.python.org/ftp/python/3.13.0/python-3.13.0-amd64.exe)
#### Install esphome
```
$ pip install esphome
```

## Flash firmware
Connect your ESP32 for flashing
```
# Flash a bootloader
$ esptool.py write_flash 0x0 ~/Downloads/esp32_bootloader_v4.bin
# Flash the firmware
$ esptool.py write_flash 0x10000 firmware.bin
```

## Resources
### ESP32
[ESP32](https://en.wikipedia.org/wiki/ESP32)  

### ESPHome
[ESPHome](https://esphome.io/)  
[ESPHome Source Code](https://github.com/esphome/esphome)  
[ESPHome Releases](https://github.com/esphome/esphome/releases)  
[ESPHome Configuration Files](https://github.com/bbusse/esphome-cfg)  

### Sensors
[AS3935 Datasheet](https://github.com/sparkfun/SparkFun_AS3935_Lightning_Detector/blob/master/Documents/AS3935_Datasheet_EN_v2.pdf)  
[BME280 Datasheet](https://www.bosch-sensortec.com/products/environmental-sensors/humidity-sensors-bme280/)  
[BME680 Datasheet](https://www.bosch-sensortec.com/media/boschsensortec/downloads/datasheets/bst-bme680-ds001.pdf)  
[DHT22/AM2302 Datasheet](https://www.sparkfun.com/datasheets/Sensors/Temperature/DHT22.pdf)  
[DS18B20 Datasheet](https://www.analog.com/media/en/technical-documentation/data-sheets/DS18B20.pdf)  
[VEML6030](https://www.vishay.com/docs/84366/veml6030.pdf)  
[SPH0645LM4H](https://www.knowles.com/docs/default-source/model-downloads/kas-700-0137-crawford-mic-on-flex-product-brief-rev29may19.pdf)
