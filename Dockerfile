# To run the container:
# docker run -e COMMANDER_PASSWORD='xxx' \
#     -e PROVIDERS_AWSEC2_ACCESSKEYID='xxx' \
#     -e PROVIDERS_AWSEC2_SECRETACCESSKEY='xxx' \
#     -e PROVIDERS_AWSEC2_REGION='eu-west-1' \
#     -e PROVIDERS_AWSEC2_INSTANCE_INSTANCETYPE='t2.nano' \
#     -e PROVIDERS_AWSEC2_INSTANCE_IMAGEID='ami-06220275' \
#     -e INSTANCE_SCALING_MAX=1 \
#     -it --rm -p 8888:8888 -p 8889:8889 samgabrail/scraproxy

FROM mhart/alpine-node:8
EXPOSE 8888 8889
LABEL maintainer="Sam Gabrail"
WORKDIR /app

# Install Scrapoxy and dotenv
RUN npm install -g scrapoxy && npm install dotenv

# Add configuration
COPY tools/docker/config.js /app

# Start scrapoxy
CMD scrapoxy start /app/config.js -d