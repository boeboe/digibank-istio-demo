'use strict';

const { WebClient, ErrorCode } = require('@slack/web-api');
const slack_token = process.env.SLACK_BOT_TOKEN;
const slack_channel_id = process.env.SLACK_CHANNEL_ID;
const slack_web = new WebClient(slack_token);

const express = require('express');
const bodyParser = require('body-parser');

var app = express();

app.use(bodyParser.json());

app.all('*', function (req, res, next) {
    res.header("Access-Control-Allow-Origin", "*");
    res.header("Access-Control-Allow-Headers", "*");
    next();
});

app.post('/api/message', async (req, res) => {
    res.header("Content-Type", "application/json");
    if (req.body.message) {
      try {
        var payload = {
          channel: slack_channel_id,
          text: req.body.message
        };

        // https://api.slack.com/methods/chat.postMessage
        await slack_web.chat.postMessage(payload);
        console.log(`Successfully send message "${req.body.message}" in channel ${slack_channel_id}`);
        res.status(200).send({'message': 'Message received and send to slack'});
      } catch (error) {
        if (error.code === ErrorCode.PlatformError) {
          console.log(error.data);
          res.status(500).send({'err': error.data});
        } else {
          console.log('Well, that was unexpected.');
          res.status(500).send({'err': 'Well, that was unexpected.'});
        }
      }
    } else {
      res.status(400).send({'err': 'missing message'});
    }
});

app.post('/api/message/fetch', async (req, res) => {
  res.header("Content-Type", "application/json");
  if (req.body.offset) {
    try {
      var payload = {
        channel: slack_channel_id,
        oldest: req.body.offset
      };

      // https://api.slack.com/methods/conversations.history
      const response = await slack_web.conversations.history(payload);
      console.log(`Successfully fetched ${response.messages.length} messages from channel ${slack_channel_id}`);
      res.status(200).send(response.messages);
    } catch (error) {
      if (error.code === ErrorCode.PlatformError) {
        console.log(error.data);
        res.status(500).send({'err': error.data});
      } else {
        console.log('Well, that was unexpected.');
        res.status(500).send({'err': 'Well, that was unexpected.t'});
      }
    }
  } else {
    res.status(400).send({'err': 'missing offset'});
  }
});

app.get('/health', function (req, res) {
  res.status(200).send({'message': 'Still healthy!'});
});

function initialSlackMsg () {
  (async ()=>{
    const message = "Digibank Microservice Demo Application initialised successfully :ghost:";
    try {
      var payload = {
        channel: slack_channel_id,
        text: message
      };

      // https://api.slack.com/methods/chat.postMessage
      await slack_web.chat.postMessage(payload);
      console.log(`Successfully send message "${message}" in channel ${slack_channel_id}`);
    } catch (error) {
      if (error.code === ErrorCode.PlatformError) {
        console.log(error.data);
      } else {
        console.log('Well, that was unexpected.');
      }
    }
  })()
}

initialSlackMsg();

module.exports = app;
