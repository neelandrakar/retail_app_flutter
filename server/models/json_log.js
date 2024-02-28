const mongoose = require('mongoose');

const jsonLogSchema = mongoose.Schema({

    api_name: {
        type: String,
        required: true
    },

    request: {
        type: String,
        default: ''
    },

    response: {
        type: String,
        default: ''
    },

    post_user: {
        type: String,
        required: true
    },

    post_time: {
        type: Date,
        default: Date.now()
    }
});

const JsonLog = mongoose.model('JsonLog', jsonLogSchema);
module.exports = JsonLog;