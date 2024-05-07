const mongoose = require('mongoose');

const dealerLiftingMasterSchema = mongoose.Schema({

    lifting_id: {
        type: Number,
        requried: true
    },

    invoice_no: {
        type: Number,
        requried: true
    },

    material_code: {
        type: Number,
        requried: true
    },

    material_desc: {
        type: String,
        requried: true
    },

    date: {
        type: Date,
        default: Date.now()
    },

    sapid: {
        type: Number,
        required: true
    },

    quantity: {
        type: Number,
        required: true
    },

    tagged_emps: [{
        type: String,
        default: []    
    }],

    truck_no: {
        type: String,
        requried: true
    },

    d_status: {
        type: Number,
        default: 0
    }

});

const DealerLiftingMaster = mongoose.model('DealerLiftingMaster', dealerLiftingMasterSchema);
module.exports = DealerLiftingMaster;