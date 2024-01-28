# OpenVPN Docker Image

This Dockerfile creates a Raspberry Pi-compatible OpenVPN server using Alpine Linux. The image is based on [kafebob/rpi-alpine](https://hub.docker.com/r/kafebob/rpi-alpine) and includes necessary components for OpenVPN setup with Two-Factor Authentication (OTP) for an additional layer of security. You can enable OTP during the client setup process, and the image integrates with Google Authenticator for OTP generation.

This Dockerfile is built upon the foundation laid by [kylemanna/docker-openvpn](https://github.com/kylemanna/docker-openvpn). Special thanks to their contributions to the OpenVPN Docker ecosystem.

## Prerequisites

Before running the Docker commands, make sure you have Docker installed on your Raspberry Pi. Additionally, you will need to create a Docker volume to store server and client certificates and configuration files. Always keep this volume secure:

```bash
OVPN_DATA=ovpn-data
sudo docker volume create --name $OVPN_DATA
```

## Initialization

1. **Generate Initial Configuration:**

    Before running this step, set up a service like [noip.com](https://www.noip.com/) to access your internal network using a domain. This domain will be used to access your OpenVPN server configured on your Raspberry Pi.

    Also, make sure to map port 1194/udp from the external network to the internal IP of your Raspberry Pi in your router settings. This port forwarding ensures that external traffic reaches the OpenVPN server on your Raspberry Pi.

    Assuming the domain is `coyote.bipbip.com` and port forwarding is configured, initialize OpenVPN configuration:


   ```bash
   sudo docker run -v $OVPN_DATA:/etc/openvpn --rm kafebob/rpi-openvpn ovpn_genconfig -u udp://coyote.bipbip.com -2 -C AES-256-GCM
   ```

2. **Create CA Certificate:**

   ```bash
   sudo docker run -v $OVPN_DATA:/etc/openvpn --rm -it kafebob/rpi-openvpn ovpn_initpki
   ```

   During this step, you'll be asked for a password to protect the generated CA certificate private key. Remember this password for future client certificate creation.

## Start OpenVPN Server

```bash
sudo docker run -v $OVPN_DATA:/etc/openvpn -d -p 1194:1194/udp --name my-ovpn-server --cap-add=NET_ADMIN kafebob/rpi-openvpn
```

## Create a Client

1. **Choose a Client Name:**

   Before creating a client certificate, choose a name for the client/user. For example, let's use "luis-toubes" as the client name.

   ```bash
   CLIENTNAME=luis-toubes
   ```


2. **Create a client certificate:**

   ```bash
   sudo docker run -v $OVPN_DATA:/etc/openvpn --rm -it kafebob/rpi-openvpn easyrsa build-client-full $CLIENTNAME nopass
   ```

3. **Enable Two-Factor Authentication:**

   ```bash
   sudo docker run -v $OVPN_DATA:/etc/openvpn --rm -t kafebob/rpi-openvpn ovpn_otp_user $CLIENTNAME
   ```

   Scan the generated QR code with the Google Authenticator app to enable two-factor authentication for this username.

4. **Generate OVPN File:**

   ```bash
   sudo docker run -v $OVPN_DATA:/etc/openvpn --rm kafebob/rpi-openvpn ovpn_getclient $CLIENTNAME > $CLIENTNAME.ovpn
   ```

## Test OpenVPN Connection

Send the generated `$CLIENTNAME.ovpn` file to your mobile and load a new VPN account with this file using your preferred VPN client. Use the generated Google Authenticator token as the password.

Before testing the connection, check your current IP address using a service like [whatismyip.com](https://www.whatismyip.com/my-ip-information/). After connecting to the VPN, if everything is set up correctly, your IP address should change, indicating a successful connection through your home internet provider.