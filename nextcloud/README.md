# Nextcloud

Nextcloud for personal use, ready to use on a Raspberry Pi. It uses SQLite3, PHP7 and Nginx.
It's not ready to serve HTTPS because I'm expecting to handle these connections through a reverse proxy on another Rasperry Pi using Traefik.

If you just want to try

```
sudo docker run --rm \
 --name rpi-nextcloud \
 -p 8080:80 \
 -e TZ=Europe/Madrid \
 -e ADMIN_USER=admin \
 -e ADMIN_PASSWORD=password \
  kafebob/rpi-nextcloud
```

You will create a Nextcloud container with an admin user `admin` and password `password`

If you want to change default configuration for nextcloud database, next container will do that

```
sudo docker run --rm \
 --name rpi-nextcloud \
 -p 8080:80 \
 -e TZ=Europe/Madrid \
 -e ADMIN_USER=admin \
 -e ADMIN_PASSWORD=password \
 -e DB_TYPE=sqlite3 \
 -e DB_NAME=nextcloud \
 -e DB_USER=nextcloud \
 -e DB_PASSWORD=password \
 -e DB_HOST=localhost \
  kafebob/rpi-nextcloud
```

Also you can provide a list of trusted domains for your Nextcloud instance.

```
sudo docker run --rm \
 --name rpi-nextcloud \
 -p 8080:80 \
 -e TZ=Europe/Madrid \
 -e ADMIN_USER=admin \
 -e ADMIN_PASSWORD=password \
 -e DB_TYPE=sqlite3 \
 -e DB_NAME=nextcloud \
 -e DB_USER=nextcloud \
 -e DB_PASSWORD=password \
 -e DB_HOST=localhost \
 -e TRUSTED_DOMAINS=(nextcloud.example.com 192.168.1.5) \
  kafebob/rpi-nextcloud
```
