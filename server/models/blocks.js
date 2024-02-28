const mongoose = require('mongoose');

const blockSchema = mongoose.Schema({

    block_id: {
        type: Number,
        required: true
    },

    block_name: {
        type: String,
        required: true
    },

    district_id: {

        type: Number,
        required: true
    },

    cluster_id: {

        type: Number,
        required: true
    },

    state_id: {

        type: Number,
        required: true
    },

    d_status: {
        type: Number,
        default: 0
    }
});

const Block = mongoose.model('Block', blockSchema);
module.exports = Block;