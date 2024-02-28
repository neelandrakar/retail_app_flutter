const mongoose = require('mongoose');

const accountConversionSchema = mongoose.Schema({

    account_id: {
        type: Number,
        required: true
    },

    from: {
        type: String,
        required: true
    },
    to: {
        type: String,
        required: true
    },
    post_time: {
        type: Date,
        default: Date.now()
    },

    post_user: {
        type: String,
        required: true
    }
});

const AccountConversion = mongoose.model('AccountConversion', accountConversionSchema);
module.exports = AccountConversion;