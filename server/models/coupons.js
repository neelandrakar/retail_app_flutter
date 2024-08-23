const mongoose = require('mongoose');

const couponSchema = mongoose.Schema({

    coupon_id: {
        type: Number,
        required: true,
    },

    merchant_id: {
        type: Number,
        required: true,
    },

    coupon_value: {
        type: Number,
        required: true
    },

    coupon_code: {
        type: String,
        required: true
    },

    allocated_to: {
        type: String,
        default: ""
    },

    is_allocated: {
        type: Boolean,
        default: false
    },

    allocated_type: {
        type: Date,
        default: null
    },

    is_used: {
        type: Boolean,
        default: false
    },

    used_on: {
        type: Date,
        default: null
    },

    d_status: {
        type: Boolean,  
        default: false
    },

    expiry_date:{
        type: Date,
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

const Coupon = mongoose.model('Coupon', couponSchema);
module.exports = Coupon;