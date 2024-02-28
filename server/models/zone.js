const mongoose = require('mongoose');

const zoneSchema = mongoose.Schema({

    zone_id: {
        type: Number,
        required: true
    },

    zone_name: {
        type: String,
        required: true
    }
});

const Zone = mongoose.model('Zone', zoneSchema);
module.exports = Zone;