const mongoose = require('mongoose');

const engineerTypeSchema = mongoose.Schema({

    engineer_type_id: {
        type: Number,
        required: true
    },

    is_active: {
        type: Number,
        required: true
    },

    engineer_title: {

        type: String,
        required: true
    },
});

const EngineerType = mongoose.model('EngineerType',engineerTypeSchema);
module.exports = EngineerType;