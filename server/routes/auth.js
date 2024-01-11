const express = require('express');
const Employee = require('../models/employee');
const jwt = require('jsonwebtoken');
const bcryptjs = require('bcryptjs');
const authRouter = express.Router();


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
                res.status(200).json(employee);

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

        res.json(true);

    }catch(e){
        res.status(500).json({ error: e.message });
    }

    });

    

module.exports = authRouter;