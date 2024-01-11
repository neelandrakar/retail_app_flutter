const mongoose = require('mongoose');

const attendanceTblSchema = mongoose.Schema({

    emp_id : {
        type: String,
        required: true
    },

    date: {
        type: Date,
        required: true
    },

    loginTime: {
        type: Date,
        default: null
    },

    logoutTime: {
        type: Date,
        default: null
    },
    
    startKM: {
        type: Number,
        default: 0
    },

    startOdometer: {
        type: String,
        default: ''
    },

    endKM: {
        type: Number,
        default: 0
    },

    endOdometer: {
        type: String,
        default: ''
    },

    vehicle: {
        type: Number,
        default: 0
    },

    login_location: {

        type: String,
        default: ''
    },

    logout_location: {

        type: String,
        default: ''
    },

    login_latitude: {

        type: Number,
        default: 0
    },

    login_longitude: {

        type: Number,
        default: 0
    },



    logout_latitude: {

        type: Number,
        default: 0
    },

    d_status: {

        type: Number,
        default: 0
    },

    logout_longtitude: {

        type: Number,
        default: 0
    },

    updated_at: {
        type: Date,
        required: true
    }
});

const AttendanceTbl = mongoose.model('AttendanceTbl', attendanceTblSchema);
module.exports = AttendanceTbl;