This builds an ESP32 firmware in a [container](https://github.com/bbusse/esphome-build) providing an [ESPHome](https://esphome.io/) build environment
Configuration files for the firmware target are kept in a [seperate repository](https://github.com/bbusse/esphome-cfg) and fetched during build

## Build
Configuration yaml files for ESPHome need to be supplied as build argument  
and are fetched from [esphome-cfg](https://github.com/bbusse/esphome-cfg)  
  
BME280
```
$ podman build . -t compost-0 --build-arg ESPHOME_CFG=compost-0.yaml
```
DHT22 / AM2302
```
$ podman build . -t greenhouse-1 --build-arg ESPHOME_CFG=greenhouse-1.yaml
```

## Resources
[ESPHome](https://esphome.io/)  
[ESPHome Source Code](https://github.com/esphome/esphome)  
[ESPHome Releases](https://github.com/esphome/esphome/releases)  
[ESPHome Configuration Files](https://github.com/bbusse/esphome-cfg)  
[BME280 Datasheet](https://www.bosch-sensortec.com/products/environmental-sensors/humidity-sensors-bme280/)  
[DHT22/AM2302 Datasheet](https://www.sparkfun.com/datasheets/Sensors/Temperature/DHT22.pdf)  
