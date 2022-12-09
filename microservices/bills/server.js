'use strict';

const mongoose = require('mongoose');

var server = require('./app');
var port = process.env.PORT;

console.log(`Starting HTTP server on port ${port} after connecting to MongoDB at "${process.env.MONGO_URL}""`)

mongoose.set('strictQuery', true)
mongoose.connect(process.env.MONGO_URL, { useNewUrlParser: true , useUnifiedTopology: true })

mongoose.connection.on('error', function (err) {
  console.error('Error connecting to "%s":', process.env.MONGO_URL, err);
});

mongoose.connection.once('open', function() {
  console.log('Succesfully connected to "%s"', process.env.MONGO_URL);
  server.listen(port, function () {
    console.log('HTTP Server running on port %d', port);
  });
});
