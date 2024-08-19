const mongoose = require('mongoose');

const loyaltyTierSchema = mongoose.Schema({

    tier_id: {
        type: Number,
        required: true
    },

    tier_name: {
        type: String,
        required: true
    },

    tier_img: {
        type: String,
        required: true
    },

    min_points: {
        type: Number,
        required: true
    },

    max_points: {
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
    }
});

const LoyaltyTier = mongoose.model('LoyaltyTier', loyaltyTierSchema);
module.exports = LoyaltyTier;