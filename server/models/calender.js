const mongoose = require('mongoose');

const calenderSchema = mongoose.Schema({

    date: {
        type: Date,
        required: true
    },

    d_status: {
        type: Number,
        default: 0
    },

    added_on: {
        type: Date,
        default: Date.now()
    }
});

const Calender = mongoose.model('Calender',calenderSchema);
module.exports = Calender;