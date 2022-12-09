'use strict';
const express = require('express');
const bodyParser = require('body-parser');
const cookieParser = require('cookie-parser');
const session = require('express-session');
const mongoose = require('mongoose');
const mongostore = require('connect-mongo');
const request = require('request');

var app = express();

app.use(express.static(`${__dirname}/public`));
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({extended: false}));
app.use(cookieParser());
app.use(session({
    secret: process.env.SESSION_SECRET,
    store: mongostore.create({mongoUrl: process.env.MONGO_URL}),
    resave: true,
    saveUninitialized: true,
    cookie: {
        cookieName: 'connect.sid',
        secret: process.env.SESSION_SECRET,
        httpOnly: false,
        secure: false,
        ephemeral: true
    }
}));

require('./routes/auth')(app);
require('./routes/user')(app, request);
require('./routes/bills')(app, request);
require('./routes/accounts')(app, request);
require('./routes/transactions')(app, request);
require('./routes/support')(app, request);
require('./routes/health')(app);

var port = process.env.PORT;

console.log(`Starting HTTP server on port ${port} after connecting to MongoDB at "${process.env.MONGO_URL}""`)

mongoose.set('strictQuery', true)
mongoose.connect(process.env.MONGO_URL, { useNewUrlParser: true , useUnifiedTopology: true })

mongoose.connection.on('error', function (err) {
  console.error('Error connecting to "%s":', process.env.MONGO_URL, err);
});

mongoose.connection.once('open', function() {
  console.log('Succesfully connected to "%s"', process.env.MONGO_URL);
  app.listen(port, function () {
    console.log('Innovate portal running on port: %d', port);
  });
});
