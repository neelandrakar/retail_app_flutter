const mongoose = require('mongoose');

const accountTargetSchema = mongoose.Schema({

    account_id: {
        type: Number,
        required: true
    },

    month: {
        type: Date,
        required: true
    },

    primary_target_taken: {
        type: Boolean,
        required: true
    },

    primary_target: {
        type: Number,
        required: true
    },

    secondary_target_taken: {
        type: Boolean,
        required: true
    },

    secondary_target: {
        type: Number,
        required: true
    },

    post_user: {
        type: String,
        required: true
    },

    post_time: {
        type: Date,
        default: Date.now()
    },

    updated_on: {
        type: Date,
        default: Date.now()
    },

    updated_on: {
        type: Date,
        required: true
    }


});

const AccountTarget = mongoose.model('AccountTarget', accountTargetSchema);
module.exports = AccountTarget;