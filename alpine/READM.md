# Raspberry Pi Alpine Linux 

This Dockerfile creates a custom Alpine Linux image with the ability to configure the timezone and optionally add additional repositories. You can use this image as a base for your applications or services.

## Build the Image

To build the image, make sure you have Docker installed and follow these steps:

```bash
docker build -t kafebob/rpi-alpine --build-arg ALPINE_VERSION=latest .
```

Replace `kafebob/rpi-alpine` with the desired name for your image. You can adjust the `ALPINE_VERSION` variable according to the desired Alpine version.

## Run the Container

Once the image is built, you can run a container using the following command:

```bash
docker run -it --rm --name my_rpi_alpine kafebob/rpi-alpine
```

Replace `my_rpi_alpine` with the name you want to give your container. This command will open an interactive shell within the container.
