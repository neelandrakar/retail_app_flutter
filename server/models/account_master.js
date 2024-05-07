const mongoose = require('mongoose');

const accountMasterSchema = mongoose.Schema({

    account_id: {

        type: Number,
        required: true
    },

    account_name: {
        type: String,
        required: true
    },

    p_account_id: {
        type: Number,
        default: 0
    },

    password: {
        type: String,
        default: ''
    },

    sapid:{
        type : Number,
        default: 0
    },

    contact_person_name: {
        type: String,
        required: true
    },

    mobno: {
        type: Number,
        required: true
    },

    email: {

        type: String,
        default: ''
    },

    pan_no: {

        type: String,
        default: ''
    },

    card_no:{
        type: Number,
    },

    engineer_type:{
        type: Number
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

    main_district: {

        type: Number,
        required: true
    },

    all_districts: [{

        type: Number,
        required: true
    }],

    block_id: {

        type: Number,
        required: true
    },

    street: {

        type: String,
        default: ''
    },

    area: {

        type: String,
        default: ''
    },

    police_station: {

        type: String,
        default: ''
    },

    city: {

        type: String,
        default: ''
    },

    pincode: {

        type: Number,
        required: true
    },

    account_status: {

        type: String,
        default: 'Survey'
    },

    work_for: {

        type: Number,
        required: true
    },

    account_type_id: {

        type: Number,
        required: true
    },

    working_as_dealer: {

        type: Number
    },

    d_status: {

        type: Number,
        default: 0
    },

    latitude: {

        type: String,
        default: '0.0'
    },

    longitude: {

        type: String,
        default: '0.0'
    },

    home_location_img: {

        type: String,
        default: ''
    },

    office_longitude: {

        type: String,
        default: '0.0'
    },

    office_latitude: {

        type: String,
        default: '0.0'
    },

    office_location_img: {

        type: String,
        default: ''
    },

    referred_by: {
        type: String,
        default: ''
    },

    AGM_RSM: {

        type: String,
        default: ''
    },

    ASM: {

        type: String,
        default: ''
    },

    SO: {

        type: String,
        default: ''
    },

    ME: {

        type: String,
        default: ''
    },

    potential: {

        type: Number,
        default: 0
    },

    fcmtoken_id: {

        type: String,
        default: ''
    },

    profile_image: {

        type: String,
        default: ''
    },

    nod: {

        type: Number,
        // required: true
    },

    updated_on: {

        type: Date,
        default: null
    },

    created_on: {
        type: Date,
        default: Date.now()
    },

    created_by: {

        type: String,
        required: true
    },

    general_remarks: {

        type: String,
        default: ""
    },

    is_doubtful:{
        type: Number,
        default: 0
    }
});

const AccountMaster = mongoose.model('AccountMaster',accountMasterSchema);
module.exports = AccountMaster;