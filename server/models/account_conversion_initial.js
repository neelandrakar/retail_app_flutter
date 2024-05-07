const mongoose = require('mongoose');

const accountConversionInitialSchema = mongoose.Schema({

    account_id: {
        type: Number,
        required: true
    },

    account_status: {
        type: String,
        default: 'Survey'
    },
    month: {
        type: Date,
        required: true
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

const AccountConversionInitial = mongoose.model('AccountConversionInitial', accountConversionInitialSchema);
module.exports = AccountConversionInitial;