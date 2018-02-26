# Traefik

Traefik support ARM architecture but I wanted to provide custom setup

## Run

Remember to map your configuration file and acme.json

```
sudo docker run --rm \
  -p 8080:8080 \
  -p 80:80 \
  -p 443:443 \
  -v $PWD/acme.json:/etc/traefik/acme.json \
  -v $PWD/traefik.toml:/etc/traefik/traefik.toml \
  kafebob/rpi-traefik
```
