const mongoose = require('mongoose');

const employeeSchema = mongoose.Schema({

    emp_name: {
        type: String,
        required: true
    },

    username: {
        type: String,
        required: true
    },

    mobno: {

        type: Number,
        required: true
    },

    password: {
        type: String,
        required: true
    },

    email: {
        type: String,
        default: ''
    },

    reporting_to: {

        type: String,
        required: true
    },

    profile_id: {

        type: Number,
        required: true
    },

    responsible_for: {

        type: Number,
        required: true
    },

    state_id: [{
        type: Number,
        required: true
    }],

    district_id: [{
        type: Number,
        required: true
    }],

    active: {

        type: Number,
        default: 1
    },

    division: {

        type: Number,
        required: true
    },

    work_on: {

        type: Number,
        required: true
    },

    joining_date: {

        type: Date,
        default: Date.now()
    },

    jwt_token: {
        type: String,
        default: ''
    },

    profile_pic: {

        type: String,
        default: ''
    }
});

const Employee = mongoose.model('Employee',employeeSchema);
module.exports = Employee;