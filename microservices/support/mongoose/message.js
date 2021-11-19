const mongoose = require('mongoose');

var Schema = mongoose.Schema;
var Message = new Schema({
    uuid: String,
    message: String
});

module.exports = mongoose.model('Message', Message, "messages");
