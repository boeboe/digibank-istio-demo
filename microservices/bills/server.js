'use strict';

const mongoose = require('mongoose');

var server = require('./app');
var port = process.env.PORT;

console.log(`Running on ${port}, connecting to ${process.env.MONGO_URL}`)

mongoose.connect(process.env.MONGO_URL, { useNewUrlParser: true , useUnifiedTopology: true },
    function (ignore, connection) {
        connection.onOpen();
        server.listen(port, function () {
            console.log('Server running on port: %d', port);
        });
    }
);
