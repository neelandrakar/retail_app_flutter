const express = require('express');
const Employee = require('../models/employee');
const auth = require('../middleware/auth');
const jwt = require('jsonwebtoken');
const bcryptjs = require('bcryptjs');
const authRouter = express.Router();
const Zone = require('../models/zone');
const State = require('../models/state_tbl');
const Cluster = require('../models/clusters');
const District = require('../models/districts');
const Block = require('../models/blocks');
const JsonLog = require('../models/json_log');

//Sign up
authRouter.post('/v1/api/signup', async (req,res) => {

    try{

        const {emp_name,username,mobno,password,email, reporting_to, profile_id,responsible_for,state_id,district_id,division, work_on} = req.body;

        console.log(req.body);

        if(mobno!=0){
            const existingUserViaMobno = await Employee.findOne({ mobno });
            if (existingUserViaMobno) {
              return res
                .status(400)
                .json({ msg: "User with same mobile number already exists!" });
            }}
    
            const existingUserViaUsername = await Employee.findOne({ username });
            if (existingUserViaUsername) {
              return res
                .status(400)
                .json({ msg: "User with same username already exists!" });
            }

            const hashedPassword = await bcryptjs.hash(password,8);
        
            let employee = new Employee({
              emp_name,
              username,
              email,
              mobno,
              password: hashedPassword,
              reporting_to,
              responsible_for,
              profile_id,
              state_id,
              district_id,
              division,
              work_on
            });
            
            employee = await employee.save();
            res.json(employee);

    }catch (e) {
        res.status(500).json({ error: e.message });
      }
});


//Sign in
authRouter.post('/v1/api/signin', async (req,res) => {

    try{

        const {username,password} = req.body;
        console.log(req.body);


        var employee = await Employee.findOne({ username });
        if(employee!=null){
            
            const isMatch = await bcryptjs.compare(password, employee.password);

            if(isMatch){

                const jwt_token = jwt.sign({id: employee._id},"PasswordKey");
                console.log(jwt_token);
                employee.jwt_token = jwt_token;
                employee = await employee.save();

                async function getDistrictNames(district_array){

                    let ditricts_names = [];
        
                    let district = await District.find({
                        district_id: { $in: district_array }
                    });
                    
                    for(let i=0; i<district.length; i++){
                        ditricts_names.push(district[i].district_title);
                    }
        
                    return district ? ditricts_names : [];
                }
        
                //Fetch state name 
                async function getStateNames(state_array){
        
                    let state_names = [];
        
                    let state = await State.find({
                        state_id: { $in: state_array }
                    });
                    
                    for(let i=0; i<state.length; i++){
                        state_names.push(state[i].state_name);
                    }
        
                    return state ? state_names : [];
                }
        
                async function getBlockName(get_block_id){
        
                    let block = await Block.find({
                        block_id: get_block_id
                    });
        
                    return block ? block[0].block_name : 'NA';
                }
        
                async function getClusterName(get_cluster_id){
        
                    let cluster = await Cluster.find({
                        cluster_id: get_cluster_id,
                        d_status: 0
                    });
        
                    return cluster ? cluster[0].cluster_name : 'NA';
                }

                async function getZoneData(get_state_id, zoneKey){

                    let state = await State.find({
                        state_id: { $in: get_state_id }
                    });
        
                    let get_zone_id = state[0].zone_id;
        
                    let zone = await Zone.find({
                        zone_id: get_zone_id
                    });
        
                    if(zoneKey==1){
                        return zone.length>0 ? zone[0].zone_name : 'NA';
                    } else if(zoneKey==2){
                        return zone.length>0 ? zone[0].zone_id : 0;
        
                    }
                }
                
                const updatedEmp = {
                    ...employee.toObject(),
                    'state_names': await getStateNames(employee.state_id),
                    'district_names': await getDistrictNames(employee.district_id),
                    'zone_name': await getZoneData(employee.state_id, 1),
                    'zone_id': await getZoneData(employee.state_id, 2)
                }

                res.status(200).json(updatedEmp);

            } else{
                res.status(400).json({ msg: 'Please enter correct password'});
   
            }


        } else {
            res.status(400).json({ msg: 'There is no user with this email address'});
    }
    }catch (e) {
        res.status(500).json({ error: e.message });
      }
});

    //Check if token is valid or not
    authRouter.post('/v1/api/checkToken', async (req,res)=>{

    try{
        
        const token = req.header('x-auth-token');
        console.log(token);
        if(!token) return res.json(false);
        
        const verified = jwt.verify(token,'PasswordKey');
        if(!verified) return res.json(false);

        const checkEmp = await Employee.findById(verified.id);
        if(!checkEmp) return res.json(false);

        let emp_id = '';

        if(checkEmp){
            emp_id = checkEmp._id;
            let newJsonLog = new JsonLog({
                post_user: emp_id,
                api_name: '/v1/api/checkToken',
                response: true
              });
              
              newJsonLog = await newJsonLog.save();
        }

        res.json(true);

    }catch(e){
        res.status(500).json({ error: e.message });
    }

    });


    authRouter.post('/v1/api/change-password', auth, async (req,res)=>{

        try{

            const{ old_password, new_password } = req.body;

            let employee = await Employee.findById(req.user);
            const isMatch = await bcryptjs.compare(old_password, employee.password);

            if(isMatch){
            const hashedPassword = await bcryptjs.hash(new_password,8);
            employee.password = hashedPassword;
            employee = await employee.save();
            res.status(200).json({msg: "Password has been updated!"});
            } else {

            res.status(500).json({error: "Please enter valid current password"});
            }
        }catch(e){
            res.status(500).json({ error: e.message });
        }
    });

    

module.exports = authRouter;