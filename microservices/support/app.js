'use strict';

const express = require('express');
const bodyParser = require('body-parser');
const messages = require('./mongoose/message');
const { v4: uuidv4 } = require('uuid');

var app = express();

app.use(bodyParser.json());

app.all('*', function (req, res, next) {
    res.header("Access-Control-Allow-Origin", "*");
    res.header("Access-Control-Allow-Headers", "*");
    next();
});

app.post('/api/messages/create', async (req, res) => {
  var uuid = uuidv4();
  var newMessage = {
    uuid: uuid,
    message: req.body.message
  };
  messages.create(newMessage, function (err) {
    if (err) {
        console.log(err);
        res.status(500).send(err);
        return;
    }
    console.log("Message created");
    res.status(200).send({'message': 'Done!'});
  });
});

app.post('/api/messages/get', async (req, res) => {
  messages.find({'uuid': req.body.uuid}, function (err, results) {
    if (err) {
        console.log(err);
        res.status(500).send({'err': err});
        return;
    }
    res.status(200).send(results);
  });
});

app.get('/health', function (req, res) {
  res.status(200).send({'message': 'Still healthy!'});
});

module.exports = app;
