'use strict';

const express = require('express');
const bodyParser = require('body-parser');
const { Configuration, OpenAIApi } = require("openai");

var app = express();

const configuration = new Configuration({
  apiKey: "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",
});
const openai = new OpenAIApi(configuration);

app.use(bodyParser.json());

app.all('*', function (req, res, next) {
    res.header("Access-Control-Allow-Origin", "*");
    res.header("Access-Control-Allow-Headers", "*");
    next();
});

app.post('/api/message', async function (req, res) {
  res.header("Content-Type", "application/json");
  console.log("Going to send message: " + req.body.message)

  const completion = await openai.createCompletion({
    model: "text-davinci-002", 
    prompt: req.body.message
  });

  let answer = ""
  for (let i = 0; i < completion.data.choices.length; i++) {
    answer += completion.data.choices[i].text + " ";
  }

  var payload = {
    context: req.body.context || {},
    message: answer || {}
  }

  console.log("return payload: " + completion.data.choices[0].text);
  console.log("return payload: " + completion.data.choices.length);
  res.status(200).json(payload);
});

app.get('/health', function (req, res) {
  res.status(200).send({'message': 'Still healthy!'});
});

module.exports = app;
