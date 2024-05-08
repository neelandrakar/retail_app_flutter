const mongoose = require('mongoose');

const sapMasterSchema = mongoose.Schema({

    
    sapid: {
        type:Number,
        required: true
    },

    dealer_id: {
        type: Number,
        required: true
    },

    is_active: {
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

const SAPMaster = mongoose.model('SAPMaster', sapMasterSchema);
module.exports = SAPMaster;