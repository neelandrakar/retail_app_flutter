const mongoose = require('mongoose');

const visitHistorySchema = mongoose.Schema({

    dh_id: {
        type: Number,
        requried: true
    },

    account_id: {
        type: Number,
        requried: true
    },

    account_status:{
        type: String,
        requried: true
    },

    emp_id: {
        type: String,
        requried: true
    },
    
    date: {
        type: Date,
        requried: true
    },

    //1===> Visit, 2===> Call
    visit_call: {
        type: Number,
        requried: true
    },

    check_in_time: {
        type: Date,
        requried: true
    },

    check_out_time: {
        type: Date,
        requried: true
    },

    entry_time: {
        type: Date,
        default: Date.now()
    },

    selfie_image: {
        type: String,
        requried: true
    },

    visit_approval_status: {
        type: Number,
        default: 0
    },

    visit_approval_id: {
        type: String,
        default: 'NA'
    },

    visit_approval_date: {
        type: Date,
        default: null
    },

    visit_approval_remarks: {
        type: String,
        default: 'NA'
    },

    purpose_of_visit: {
        type: String,
        requried: true
    },

    gift_handed_over: {
        type: Boolean,
        requried: true
    },

    submitted_counter_potential: {
        type: Number,
        default: 0
    },

    submitted_sub_dealer_count: {
        type: Number,
        default: 0
    },

    submitted_business_survey:{
        type: String,
        default: 'NA'
    },

    discussion_details: {
        type: String,
        requried: true
    },

    action_plan_details: {
        type: String,
        requried: true
    },

    issue_details: {
        type: String,
        requried: true
    },

    follow_up_person: {
        type: String,
        requried: true
    },

    rating: {
        type: Number,
        requried: true
    },

    d_status: {
        type: Number,
        default: 0
    }
});

const VisitHistory = mongoose.model('VisitHistory', visitHistorySchema);
module.exports = VisitHistory;