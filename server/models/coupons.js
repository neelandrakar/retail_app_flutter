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

const Coupon = mongoose.model('Coupon', couponSchema);
module.exports = Coupon;