const mongoose = require('mongoose');

const districtCluster = mongoose.Schema({

    district_id: {
        type: Number,
        required: true
    },

    district_title: {
        type: String,
        required: true
    },

    zone_id: {

        type: Number,
        required: true
    },

    state_id: {

        type: Number,
        required: true
    },

    cluster_id: {

        type: Number,
        required: true
    },

    district_color: {
        type: String,
        default: ''
    },

    d_status: {
        type: Number,
        default: 0
    }
});

const District = mongoose.model('District', districtCluster);
module.exports = District;