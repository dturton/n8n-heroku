# 1. Create an image to build n8n
FROM node:16-alpine as builder

# Update everything and install needed dependencies
USER root

# Install all needed dependencies
RUN apk --update add --virtual build-dependencies python3 build-base ca-certificates && \
	npm_config_user=root npm install -g lerna

WORKDIR /data


RUN npm config set legacy-peer-deps true
RUN npm install -g lerna 
RUN npm install @5stones/n8n-nodes-bigcommerce
RUN npm install -g n8n
RUN npm install --production --loglevel notice
RUN lerna bootstrap --hoist -- --production
RUN npm run build


# 2. Start with a new clean image with just the code that is needed to run n8n
FROM node:16-alpine

USER root

RUN apk add --update graphicsmagick tzdata tini su-exec git

WORKDIR /data

# Install all needed dependencies
RUN npm_config_user=root npm install -g full-icu

# Install fonts
RUN apk --no-cache add --virtual fonts msttcorefonts-installer fontconfig && \
	update-ms-fonts && \
	fc-cache -f && \
	apk del fonts && \
	find  /usr/share/fonts/truetype/msttcorefonts/ -type l -exec unlink {} \;

ENV NODE_ICU_DATA /usr/local/lib/node_modules/full-icu

COPY --from=builder /data ./


EXPOSE 5678/tcp

CMD ["npm", "start"]
