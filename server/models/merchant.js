const mongoose = require('mongoose');

const merchantSchema = mongoose.Schema({

    
    merchant_name:{
        type: String,
        required: true
    },

    merchant_id: {
        type: Number,
        required: true,
    },

    merchant_type: {
        type: Number,
        required: true
    },

    merchant_logo: {
        type: String,
        required: true
    },

    d_status: {
        type: Boolean,
        default: false
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

const Merchant = mongoose.model('Merchant', merchantSchema);
module.exports = Merchant;