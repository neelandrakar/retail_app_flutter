const mongoose = require('mongoose');

const loyaltyGiftCategorySchema = mongoose.Schema({

    category_id: {
        type: Number,
        required: true
    },

    category_name: {
        type: String,
        required: true
    },

    category_img: {
        type: String,
        required: true
    },

    account_type_id : [
        {
            type: Number,
            required: true
        }
    ],

    d_status: {
        type: Boolean,
        default: false
    },

    post_time: {
        type: Date,
        default: Date.now()
    }
});

const LoyaltyGiftCategory = mongoose.model('LoyaltyGiftCategory', loyaltyGiftCategorySchema);
module.exports = LoyaltyGiftCategory;
