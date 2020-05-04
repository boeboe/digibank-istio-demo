FROM node:13.6.0-alpine3.11
LABEL maintainer="bartvanbos@gmail.com"

RUN apk add python make gcc g++ curl busybox-extras

WORKDIR /app
# Install app dependencies
COPY . /app
RUN cd /app; npm install; npm prune --production
ENV NODE_ENV production
ENV PORT 3400

EXPOSE 3400
CMD [ "npm", "start" ]
