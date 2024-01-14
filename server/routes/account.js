const express = require('express');
const accountRouter = express.Router();
const auth = require('../middleware/auth');
const AccountMaster = require('../models/account_master');
const Employee = require('../models/employee');

accountRouter.post('/v1/api/create-dealer', auth, async(req,res) => {

    try{

        const {account_name, p_account_id, password, contact_person_name,
               mobno, zone_id, state_id, cluster_id, district_id, block_id,
               street, area, police_station, city, pincode, work_for, account_type_id,
               potential, nod
            } = req.body;

        const emp_id = req.user;
        let all_districts = [];
        let AGM_RSM = '';
        let ASM = '';
        let SO = '';
        let ME = '';

        let fullAccountMaster = await AccountMaster.find();
        let account_id = fullAccountMaster.length+1;

        
        all_districts.push(district_id);

        let emp = await Employee.findById(emp_id);
        const emp_profile_id = emp.profile_id;

        if(emp_profile_id==2){
            AGM_RSM = emp_id;
        } else if(emp_profile_id==3){
            ASM = emp_id;
        } else if(emp_profile_id==5 || emp_profile_id==28){
            SO = emp_id;
        } else if(emp_profile_id==7 || emp_profile_id==23){
            ME = emp_id;
        }



        let account = AccountMaster({
            account_id,
            account_name,
            p_account_id,
            password,
            contact_person_name,
            mobno,
            zone_id,
            state_id,
            cluster_id,
            main_district: district_id,
            all_districts: all_districts,
            block_id,
            street,
            area,
            police_station,
            city,
            pincode,
            AGM_RSM,
            ASM,
            SO,
            ME,
            work_for,
            account_type_id,
            potential,
            nod,
            created_by: emp_id
        });
    
            account = await account.save();
            
            res.json(account);


    }catch (e) {
        res.status(500).json({ error: e.message });
      }

});


module.exports = accountRouter;