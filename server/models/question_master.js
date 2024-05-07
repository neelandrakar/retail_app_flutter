const mongoose = require('mongoose');

const questionMasterSchema = mongoose.Schema({

    question_id: {
        type: Number,
        required: true
    },

    question_parent_id: {
        type: Number,
        required: true
    },

    question_parent_name: {
        type: String,
        required: true
    },

    question: {
        type: String,
        required: true
    },


    //1==> Yes/No, 2==> TextField, 3==> Date
    answere_type: {
        type: Number,
        required: true
    },

    account_type_id: [
        {
            type: Number,
            required: true
        }
    ],

    account_status:[
        {
        type: String,
        required: true
        }
    ],

    is_mandatory:{
        type: Number,
        required: true
    },

    d_status:{
        type: Number,
        default: 0
    },

    added_on: {
        type: Date,
        default: new Date()
    }


});

const QuestionMaster = mongoose.model('QuestionMaster', questionMasterSchema);
module.exports = QuestionMaster;