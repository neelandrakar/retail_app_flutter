const mongoose = require('mongoose');

const stateSchema = mongoose.Schema({

    state_id: {
        type: Number,
        required: true
    },

    zone_id: {
        type: Number,
        required: true
    },

    state_name: {

        type: String,
        required: true
    },

    short_name: {

        type: String,
        required: true
    },

    state_color: {
        type: String,
        default: ''
    },

    state_group: {
        type: Number,
        default: 0
    },

    working_status: {

        type: Number,
        required: true
    },

    is_for_paint: {

        type: Number,
        required: true
    },

    sorting_order: {
        type: Number,
        required: true
    },

    state_language: {
        type: String,
        required: true
    }
});

const State = mongoose.model('State',stateSchema);
module.exports = State;