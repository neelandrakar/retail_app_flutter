const mongoose = require('mongoose');

const loyaltyGiftSubCategorySchema = mongoose.Schema({

    sub_category_id: {
        type: Number,
        required: true
    },

    sub_category_name: {
        type: String,
        required: true
    },

    parent_category_id: {

        type: Number,
        required: true
    },

    sub_category_img: {
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


const LoyaltyGiftSubCategory = mongoose.model('LoyaltyGiftSubCategory', loyaltyGiftSubCategorySchema);
module.exports = LoyaltyGiftSubCategory;