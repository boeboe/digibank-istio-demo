FROM node:lts-alpine3.14
LABEL maintainer="bartvanbos@gmail.com"

RUN apk add curl busybox-extras

WORKDIR /app
# Install app dependencies
COPY . /app
RUN cd /app; npm install --no-optional; npm prune --production
ENV NODE_ENV production
ENV PORT 4000

EXPOSE 4000
CMD [ "npm","start" ]
