const express = require('express');
const employeeRouter = express.Router();
const Employee = require('../models/employee');
const Menu = require('../models/menu');
const auth = require('../middleware/auth');
const MenuAccess = require('../models/menu_access');

employeeRouter.post('/v1/api/create-menu', auth, async(req,res) => {

    try{

        const {menu_title, menu_subtitle, menu_image, menu_type, menu_color,menu_division, order} = req.body;

        let newMenu = Menu({
            menu_title,
            menu_subtitle,
            menu_image,
            menu_type,
            menu_color,
            menu_division,
            order
        });

        newMenu = await newMenu.save();
        
        res.json(newMenu);

    }catch (e) {
        res.status(500).json({ error: e.message });
      }

});

employeeRouter.get('/v1/api/fetch-dashboard-menus', auth, async(req,res) => {

    try{

        const emp_id = req.user;
        let myMenus = [];

        let myMenuAccess = await MenuAccess.find({
            emp_id: emp_id,
        });

        let allMenus = await Menu.find({
            d_status: 0,
            menu_type: 1
        });

        for(let i=0; i<allMenus.length; i++){

            for(let j=0; j<myMenuAccess[0].accessable_menus.length; j++){

                if(allMenus[i]._id=myMenuAccess[0].accessable_menus[j]){

                    myMenus.push(allMenus[i]);
                    break;
                }
            }
        }

        
        res.json(myMenus);

    }catch (e) {
        res.status(500).json({ error: e.message });
      }

});




module.exports = employeeRouter;