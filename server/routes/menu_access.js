const express = require('express');
const menuAccessRouter = express.Router();
const Menu = require('../models/menu');
const Employee = require('../models/employee');
const auth = require('../middleware/auth');
const MenuAccess = require('../models/menu_access');

menuAccessRouter.post('/v1/api/give-menu-access', auth, async(req,res) => {

    try{

        const emp_id = req.user;
        let accesableMenus = [];
        let menus = await Menu.find({
            d_status: 0
        });

        let emp = await Employee.findById(emp_id);

        for(let i=0; i<menus.length; i++){

            accesableMenus.push(menus[i]._id);
        }

        let newAccess = MenuAccess({
            emp_id: emp_id,
            accessable_menus: accesableMenus
        })

        newAccess = await newAccess.save();

        res.json(newAccess);

    }catch (e) {
        res.status(500).json({ error: e.message });
      }
});

module.exports = menuAccessRouter;
