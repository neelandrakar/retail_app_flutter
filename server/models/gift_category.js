const mongoose = require('mongoose');

const giftCategorySchema = mongoose.Schema({

    
    gift_category_name:{
        type: String,
        required: true
    },

    gift_category_id: {
        type: Number,
        required: true,
    },

    gift_category_logo: {
        type: String,
        required: true
    },

    d_status: {
        type: Boolean,
        default: true
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

const GiftCategory = mongoose.model('GiftCategory', giftCategorySchema);
module.exports = GiftCategory;