'use strict';

var server = require('./app');
var port = process.env.PORT;

console.log(`Starting HTTP server on port ${port}`)

server.listen(port, function () {
    console.log('HTTP Server running on port: %d', port);
});
