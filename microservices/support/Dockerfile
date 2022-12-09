FROM node:lts-alpine
LABEL maintainer="bart@tetrate.io"

RUN apk add --no-cache curl openssl busybox-extras

WORKDIR /app
# Install app dependencies
COPY . /app
RUN cd /app; npm install --no-optional; npm prune --production
ENV NODE_ENV production
ENV PORT 4000

EXPOSE 4000
CMD [ "npm","start" ]
