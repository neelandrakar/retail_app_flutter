const mongoose = require('mongoose');

const menuSchema = mongoose.Schema({

    menu_title: {
        type: String,
        required: true
    },

    menu_subtitle: {
        type: String,
        default: ''
    },

    menu_image: {
        type: String,
        required: true
    },

    menu_type: {
        type: Number,
        required: true
    },

    menu_color: {
        type: String,
        required: true
    },

    nav_path: {
        type: String,
        required: true
    },

    d_status: {
        type: Number,
        default: 0
    },

    menu_division: {
        type: Number,
        required: true
    },

    order: {
        type: Number,
        required: true
    },

    created_on: {

        type: Date,
        default: Date.now()
    }
});

const Menu = mongoose.model('Menu',menuSchema);
module.exports = Menu;