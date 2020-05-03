'use strict';

var server = require('./app');
var port = process.env.PORT;

console.log(`Running on ${port}`)

server.listen(port, function () {
    console.log('Server running on port: %d', port);
});
