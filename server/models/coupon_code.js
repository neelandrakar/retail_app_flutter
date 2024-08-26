const mongoose = require('mongoose');

const couponCodeSchema = mongoose.Schema({

    coupon_code_id: {
        type: Number,
        required: true,
    },

    coupon_code: {
        type: String,
        required: true
    },
    
    merchant_id: {
        type: Number,
        required: true,
    },

    coupon_value: {
        type: Number,
        required: true,
    },

    coupon_id: {
        type: Number,
        required: true,
    },

    allocated_to : {
        type: String,
        default: '',
    },

    allocation_date: {
        type: Date,
        default: null
    },

    expiry_date: {
        type: Date,
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

const CouponCode = mongoose.model('CouponCode', couponCodeSchema);
module.exports = CouponCode;