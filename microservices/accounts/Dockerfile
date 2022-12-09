FROM node:lts-alpine
LABEL maintainer="bartvanbos@gmail.com"

RUN apk add --no-cache curl openssl busybox-extras

WORKDIR /app
# Install app dependencies
COPY . /app
RUN cd /app; npm install; npm prune --production
ENV NODE_ENV production
ENV PORT 3400

EXPOSE 3400
CMD [ "npm", "start" ]
