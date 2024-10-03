## Build
Configuration yaml files for ESPHome need to be supplied as build argument  
and are fetched from [esphome-cfg](https://github.com/bbusse/esphome-cfg)
```
$ podman build . -t compost-0 --build-arg ESPHOME_CFG=compost-0.yaml
$ podman build . -t greenhouse-1 --build-arg ESPHOME_CFG=greenhouse-1.yaml
```

## Resources
[ESPHome](https://esphome.io/)  
[ESPHome Source Code](https://github.com/esphome/esphome)  
[ESPHome Releases](https://github.com/esphome/esphome/releases)  
[Configuration Files](https://github.com/bbusse/esphome-cfg)
