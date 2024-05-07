const mongoose = require('mongoose');

const clusterSchema = mongoose.Schema({

    cluster_id: {
        type: Number,
        required: true
    },

    cluster_name: {
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

    cluster_color: {
        type: String,
        default: ''
    },

    d_status: {
        type: Number,
        default: 0
    },

    priority: {
        type: Number,
        required: true
    }
});

const Cluster = mongoose.model('Cluster', clusterSchema);
module.exports = Cluster;