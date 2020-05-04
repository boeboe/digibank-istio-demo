FROM node:13.6.0-alpine3.11
LABEL maintainer="bartvanbos@gmail.com"

#RUN apt-get install -y nodejs npm

WORKDIR /app
# Install app dependencies
COPY . /app
RUN cd /app; npm install; npm prune --production
ENV NODE_ENV production
ENV PORT 3200

EXPOSE 3200
CMD [ "npm","start" ]
