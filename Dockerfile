# To run the container for AWS:
# docker run -e COMMANDER_PASSWORD='xxx' \
#     -e PROVIDERS_AWSEC2_ACCESSKEYID='xxx' \
#     -e PROVIDERS_AWSEC2_SECRETACCESSKEY='xxx' \
#     -e PROVIDERS_AWSEC2_REGION='eu-west-1' \
#     -e PROVIDERS_AWSEC2_INSTANCE_INSTANCETYPE='t2.nano' \
#     -e PROVIDERS_AWSEC2_INSTANCE_IMAGEID='ami-06220275' \
#     -e INSTANCE_SCALING_MAX=1 \
#     -it --rm -p 8888:8888 -p 8889:8889 samgabrail/scraproxy

# To run the container for DO:
# docker run -e COMMANDER_PASSWORD='xxx' \
#     -e PROVIDERS_TYPE='digitalocean' \
#     -e PROVIDERS_DIGITALOCEAN_TOKEN='xxx' \
#     -e PROVIDERS_DIGITALOCEAN_REGION='tor1' \
#     -e PROVIDERS_DIGITALOCEAN_SIZE='s-1vcpu-1gb' \
#     -e PROVIDERS_DIGITALOCEAN_SSHKEYNAME='My Mac (id_rsa.pub)' \
#     -e PROVIDERS_DIGITALOCEAN_IMAGENAME='forward-proxy' \
#     -e PROVIDERS_DIGITALOCEAN_NAME='ScraPoxy' \
#     -e INSTANCE_SCALING_MAX=1 \
#     -it --rm -p 8888:8888 -p 8889:8889 samgabrail/scraproxy

# Rebuilding from source and I already updated the source code in my forked repo to add the line fixed in the DO provider as per https://github.com/fabienvauchelles/scrapoxy/issues/196
FROM mhart/alpine-node:8
EXPOSE 8888 8889
LABEL maintainer="Sam Gabrail"
# Add source code
COPY . /app
WORKDIR /app
COPY tools/docker/config.js /app
# Install Scrapoxy
RUN npm install dotenv && npm install && npm build
# Start scrapoxy
CMD node server/index.js start /app/config.js -d

# Below is a fix for DO where the private IP is pulled instead of the public one as per https://github.com/fabienvauchelles/scrapoxy/issues/196
# I didn't end up using this image since it gave me some trouble in K8s and with Vault.
# FROM dysnix/scrapoxy:3.1.3
# LABEL maintainer="Sam Gabrail"

# # Install dotenv
# RUN npm install dotenv

# Below is the older image I used but is broken for DO
# FROM mhart/alpine-node:8
# EXPOSE 8888 8889
# LABEL maintainer="Sam Gabrail"
# WORKDIR /app

# # Install Scrapoxy and dotenv
# RUN npm install -g scrapoxy && npm install dotenv

# # Add configuration
# COPY tools/docker/config.js /app

# # Start scrapoxy
# CMD scrapoxy start /app/config.js -d

