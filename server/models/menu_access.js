const mongoose = require('mongoose');

const menuAccessSchema = mongoose.Schema({

    emp_id: {
        type: String,
        required: true
    },

    accessable_menus: [
        {
            type: String
        }
    ],

    created_on: {

        type: Date,
        default: Date.now()
    }
});

const MenuAccess = mongoose.model('MenuAccess',menuAccessSchema);
module.exports = MenuAccess;