FROM node:lts-alpine3.14
LABEL maintainer="bartvanbos@gmail.com"

RUN apk add curl busybox-extras

WORKDIR /app
# Install app dependencies
COPY . /app
RUN cd /app; npm install; npm prune --production
ENV NODE_ENV production
ENV PORT 3200

EXPOSE 3200
CMD [ "npm","start" ]
