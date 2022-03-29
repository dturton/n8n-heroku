# 2. Start with a new clean image with just the code that is needed to run n8n
FROM node:16-alpine

ARG N8N_VERSION=0.169.0

# Update everything and install needed dependencies
RUN apk add --update graphicsmagick tzdata

USER root

# Install n8n and the also temporary all the packages
# it needs to build it correctly.
RUN apk --update add --virtual build-dependencies python3 build-base && \
	npm_config_user=root npm install -g n8n@${N8N_VERSION} && \
	apk del build-dependencies

RUN npm install -g @5stones/n8n-nodes-bigcommerce


WORKDIR /app

	# copy start script to container
COPY ./start.sh /

# make the script executable
RUN chmod +x /start.sh

CMD ["/start.sh"]


