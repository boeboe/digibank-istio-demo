'use strict';

const express = require('express');
const bodyParser = require('body-parser');
const { Configuration, OpenAIApi } = require("openai");

var app = express();

const configuration = new Configuration({
  apiKey: process.env.OPENAI_KEY,
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
  console.log("Going to send openai prompt: " + req.body.message)

  try {
    const completion = await openai.createCompletion({
      model: "text-davinci-003",
      max_tokens: 2048,
      prompt: req.body.message
    });

    var payload = {
      context: req.body.context || {},
      message: completion.data.choices[0].text || {}
    }

    console.log("Received openai response: " + completion.data.choices[0].text);
    res.status(200).json(payload);
  } catch (error) {
    if (error.response) {
      console.log(error.response.status);
      console.log(error.response.data);
    } else {
      console.log(error.message);
    }
  }
});

app.get('/health', function (req, res) {
  res.status(200).send({'message': 'Still healthy!'});
});

module.exports = app;
