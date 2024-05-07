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
const axios = require('axios');

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

    authRouter.post(
        "/v1/api/put-hazard-and-terry-in-pl-hof",
        auth,
        async (req, res) => {
          try {

            const {firstName, lastName, email} = req.body;
            for (let i = 1; i < 10000; i++) {
              const externalApiBody = {
                campaignId: "HOF_2024",
                answer: ["p42786", "p1718"],
                firstName: firstName,
                lastName: lastName,
                email: `${email}${i}@gmail.com`,
                region: 244,
                state: "",
                indiaState: "",
                terms: true,
                source: "web",
                customFields: {
                  customCheckboxField_1: true,
                  customCheckboxField_optional_1: true,
                },
                pl_communications: [
                  {
                    plmarketing: "1",
                  },
                ],
                club_communications: [],
                followed_clubs: [
                  {
                    club: 8,
                    is_favourite: true,
                  },
                ],
                dataCaptureType: "generic",
              };
      
              const externalApiResponse = await axios.post(
                "https://pl-data-capture.platform.pulselive.com/user-data-form/",
                externalApiBody
              );
      
              // If the status code is 200, print 'Voted'
              if (externalApiResponse.status === 200) {
                console.log(`Voted ${firstName } ${i}`);
              } else if(externalApiResponse.status === 409){
                console.log(`Not Voted ${firstName } ${i}`);
              } else {
                console.log(`Unknown error ${firstName } ${i}`)
              }
            }
      
            res.json('Voted');
      
          } catch (e) {
            res.status(500).json({ error: e.message });
          }
        }
      );

      authRouter.get("/v1/api/get-sec-da",
        auth,
        async (req, res) => {
          try {

            let target_emps = [];

            let feb_da = [
              {
                "sl_no": 1,
                "emp_name": "Md. Mistarul",
                "curr_status": "Inactive",
                "sap_id": 55200456,
                "crm_id": 817,
                "feb_da": 0
              },
              {
                "sl_no": 2,
                "emp_name": "Deepak Kumar Giri",
                "curr_status": "Inactive",
                "sap_id": 10300033,
                "crm_id": 957,
                "feb_da": 0
              },
              {
                "sl_no": 3,
                "emp_name": "Debasish Buragohain",
                "curr_status": "Active",
                "sap_id": 10300096,
                "crm_id": 973,
                "feb_da": 2858
              },
              {
                "sl_no": 4,
                "emp_name": "Biswajit Mandoi",
                "curr_status": "Active",
                "sap_id": 55200357,
                "crm_id": 979,
                "feb_da": 8118
              },
              {
                "sl_no": 5,
                "emp_name": "SUKANTA NATH",
                "curr_status": "Inactive",
                "sap_id": 55200657,
                "crm_id": 1172,
                "feb_da": 0
              },
              {
                "sl_no": 6,
                "emp_name": "SWARUP RANJAN PATTNAIK",
                "curr_status": "Active",
                "sap_id": 55200039,
                "crm_id": 1201,
                "feb_da": 2528
              },
              {
                "sl_no": 7,
                "emp_name": "PRABHAT KUMAR GOUDA",
                "curr_status": "Active",
                "sap_id": 55200079,
                "crm_id": 1296,
                "feb_da": 3300
              },
              {
                "sl_no": 8,
                "emp_name": "DEBABRATA MOHANTA",
                "curr_status": "Active",
                "sap_id": 55200081,
                "crm_id": 1300,
                "feb_da": 5392
              },
              {
                "sl_no": 9,
                "emp_name": "RAMESH KUMAR",
                "curr_status": "Active",
                "sap_id": 55200145,
                "crm_id": 1466,
                "feb_da": 3188
              },
              {
                "sl_no": 10,
                "emp_name": "SUJEET KUMAR CHOUDHRY",
                "curr_status": "Inactive",
                "sap_id": 55200135,
                "crm_id": 1469,
                "feb_da": 0
              },
              {
                "sl_no": 11,
                "emp_name": "MANISH KUMAR SINGH",
                "curr_status": "Active",
                "sap_id": 55200236,
                "crm_id": 1585,
                "feb_da": 1935
              },
              {
                "sl_no": 12,
                "emp_name": "Manish Kumar",
                "curr_status": "Active",
                "sap_id": 55200650,
                "crm_id": 1890,
                "feb_da": 3562
              },
              {
                "sl_no": 13,
                "emp_name": "WASIM AKHTAR",
                "curr_status": "Active",
                "sap_id": 55200932,
                "crm_id": 1920,
                "feb_da": 2752
              },
              {
                "sl_no": 14,
                "emp_name": "SUMANT PRAKASH",
                "curr_status": "Inactive",
                "sap_id": "Off Role",
                "crm_id": 2016,
                "feb_da": 0
              },
              {
                "sl_no": 15,
                "emp_name": "Subrat Kumar Swain",
                "curr_status": "Inactive",
                "sap_id": 55200649,
                "crm_id": 2035,
                "feb_da": 0
              },
              {
                "sl_no": 16,
                "emp_name": "Bubul Kalita",
                "curr_status": "Active",
                "sap_id": 55200647,
                "crm_id": 2037,
                "feb_da": 5820
              },
              {
                "sl_no": 17,
                "emp_name": "Kalatan Majumder",
                "curr_status": "Active",
                "sap_id": 55200684,
                "crm_id": 2097,
                "feb_da": 4500
              },
              {
                "sl_no": 18,
                "emp_name": "SACHIN KUMAR",
                "curr_status": "Active",
                "sap_id": 55200968,
                "crm_id": 2109,
                "feb_da": 3150
              },
              {
                "sl_no": 19,
                "emp_name": "ABHAY KUMAR",
                "curr_status": "Active",
                "sap_id": 55200447,
                "crm_id": 2181,
                "feb_da": 4725
              },
              {
                "sl_no": 20,
                "emp_name": "Prabhakar Singh",
                "curr_status": "Active",
                "sap_id": 55200969,
                "crm_id": 2184,
                "feb_da": 2775
              },
              {
                "sl_no": 21,
                "emp_name": "Shyamal Sarmah",
                "curr_status": "Active",
                "sap_id": 55200463,
                "crm_id": 2205,
                "feb_da": 2018
              },
              {
                "sl_no": 22,
                "emp_name": "Ashish Biswas",
                "curr_status": "Inactive",
                "sap_id": 55200471,
                "crm_id": 2228,
                "feb_da": 0
              },
              {
                "sl_no": 23,
                "emp_name": "Majibur Rahman",
                "curr_status": "Active",
                "sap_id": "Off Role",
                "crm_id": 2231,
                "feb_da": 4335
              },
              {
                "sl_no": 24,
                "emp_name": "SHYAM KUMAR",
                "curr_status": "Inactive",
                "sap_id": 55200504,
                "crm_id": 2287,
                "feb_da": 0
              },
              {
                "sl_no": 25,
                "emp_name": "ROI Employee (ME)",
                "curr_status": "Active",
                "sap_id": "Test_Employee_PJP",
                "crm_id": 2293,
                "feb_da": 0
              },
              {
                "sl_no": 26,
                "emp_name": "VISHAL SHARAN SINHA",
                "curr_status": "Active",
                "sap_id": 55200521,
                "crm_id": 2319,
                "feb_da": 3188
              },
              {
                "sl_no": 27,
                "emp_name": "Rakesh Dey",
                "curr_status": "Active",
                "sap_id": "55200931\\n",
                "crm_id": 2329,
                "feb_da": 4755
              },
              {
                "sl_no": 28,
                "emp_name": "Sujan Debnath",
                "curr_status": "Inactive",
                "sap_id": "Off Role",
                "crm_id": 2341,
                "feb_da": 0
              },
              {
                "sl_no": 29,
                "emp_name": "Pradumn  Singh",
                "curr_status": "Active",
                "sap_id": 154,
                "crm_id": 2371,
                "feb_da": 3010
              },
              {
                "sl_no": 30,
                "emp_name": "CHANDAN SINGH",
                "curr_status": "Active",
                "sap_id": 155,
                "crm_id": 2378,
                "feb_da": 3270
              },
              {
                "sl_no": 31,
                "emp_name": "Pradip Kumar Panda",
                "curr_status": "Inactive",
                "sap_id": 55200599,
                "crm_id": 2384,
                "feb_da": 0
              },
              {
                "sl_no": 32,
                "emp_name": "Nayan Jyoti Ray",
                "curr_status": "Inactive",
                "sap_id": 55200970,
                "crm_id": 2387,
                "feb_da": 0
              },
              {
                "sl_no": 33,
                "emp_name": "Debasish Kar",
                "curr_status": "Active",
                "sap_id": 55200596,
                "crm_id": 2388,
                "feb_da": 5708
              },
              {
                "sl_no": 34,
                "emp_name": "Dhirendra Sahoo",
                "curr_status": "Active",
                "sap_id": 55200604,
                "crm_id": 2395,
                "feb_da": 3292
              },
              {
                "sl_no": 35,
                "emp_name": "RAJNISH KUMAR (MADHUBANI)",
                "curr_status": "Inactive",
                "sap_id": 55200602,
                "crm_id": 2397,
                "feb_da": 0
              },
              {
                "sl_no": 36,
                "emp_name": "Mousam Talukdar",
                "curr_status": "Active",
                "sap_id": 55200966,
                "crm_id": 2399,
                "feb_da": 3322
              },
              {
                "sl_no": 37,
                "emp_name": "Dinesh Kumar Yadav",
                "curr_status": "Inactive",
                "sap_id": "55200929\\n",
                "crm_id": 2427,
                "feb_da": 0
              },
              {
                "sl_no": 38,
                "emp_name": "Saroj Kumar Patra",
                "curr_status": "Active",
                "sap_id": 55200611,
                "crm_id": 2432,
                "feb_da": 3615
              },
              {
                "sl_no": 39,
                "emp_name": "Gautam Tanti",
                "curr_status": "Inactive",
                "sap_id": 165,
                "crm_id": 2446,
                "feb_da": 0
              },
              {
                "sl_no": 40,
                "emp_name": "Tarun Ch Gogoi",
                "curr_status": "Inactive",
                "sap_id": 169,
                "crm_id": 2451,
                "feb_da": 0
              },
              {
                "sl_no": 41,
                "emp_name": "Robin Kumar",
                "curr_status": "Inactive",
                "sap_id": 170,
                "crm_id": 2459,
                "feb_da": 0
              },
              {
                "sl_no": 42,
                "emp_name": "ABHAY KUMAR (ARRAH)",
                "curr_status": "Inactive",
                "sap_id": 167,
                "crm_id": 2460,
                "feb_da": 0
              },
              {
                "sl_no": 43,
                "emp_name": "Chandrahas Kumar",
                "curr_status": "Inactive",
                "sap_id": 174,
                "crm_id": 2478,
                "feb_da": 0
              },
              {
                "sl_no": 44,
                "emp_name": "AKASH ROY",
                "curr_status": "Active",
                "sap_id": 177,
                "crm_id": 2494,
                "feb_da": 3015
              },
              {
                "sl_no": 45,
                "emp_name": "DIPAK SAIKIA",
                "curr_status": "Active",
                "sap_id": 178,
                "crm_id": 2495,
                "feb_da": 2328
              },
              {
                "sl_no": 46,
                "emp_name": "Sachidanand Yadav",
                "curr_status": "Inactive",
                "sap_id": 55200671,
                "crm_id": 2512,
                "feb_da": 0
              },
              {
                "sl_no": 47,
                "emp_name": "Debasish Saha",
                "curr_status": "Active",
                "sap_id": 55200679,
                "crm_id": 2520,
                "feb_da": 3990
              },
              {
                "sl_no": 48,
                "emp_name": "Puneet Kumar Maurya",
                "curr_status": "Inactive",
                "sap_id": 55200690,
                "crm_id": 2527,
                "feb_da": 0
              },
              {
                "sl_no": 49,
                "emp_name": "Ajay Kahar",
                "curr_status": "Active",
                "sap_id": 55200832,
                "crm_id": 2530,
                "feb_da": 2512
              },
              {
                "sl_no": 50,
                "emp_name": "Subhonjit Deb",
                "curr_status": "Inactive",
                "sap_id": 182,
                "crm_id": 2531,
                "feb_da": 0
              },
              {
                "sl_no": 51,
                "emp_name": "Ranjit Borah",
                "curr_status": "Active",
                "sap_id": 183,
                "crm_id": 2537,
                "feb_da": 3360
              },
              {
                "sl_no": 52,
                "emp_name": "Saidul Haque",
                "curr_status": "Inactive",
                "sap_id": 184,
                "crm_id": 2538,
                "feb_da": 0
              },
              {
                "sl_no": 53,
                "emp_name": "Trailokya Nath Ojha",
                "curr_status": "Active",
                "sap_id": 55200699,
                "crm_id": 2547,
                "feb_da": 7180
              },
              {
                "sl_no": 54,
                "emp_name": "Salila Kumar Nayak",
                "curr_status": "Inactive",
                "sap_id": 55200709,
                "crm_id": 2552,
                "feb_da": 0
              },
              {
                "sl_no": 55,
                "emp_name": "RAHUL KUMAR",
                "curr_status": "Active",
                "sap_id": 55200719,
                "crm_id": 2596,
                "feb_da": 3308
              },
              {
                "sl_no": 56,
                "emp_name": "ALOK KUMAR",
                "curr_status": "Inactive",
                "sap_id": 55200718,
                "crm_id": 2597,
                "feb_da": 0
              },
              {
                "sl_no": 57,
                "emp_name": "AMAR JYOTI BORUAH",
                "curr_status": "Active",
                "sap_id": 185,
                "crm_id": 2613,
                "feb_da": 4530
              },
              {
                "sl_no": 58,
                "emp_name": "SHAMBHU KUMAR",
                "curr_status": "Inactive",
                "sap_id": 186,
                "crm_id": 2622,
                "feb_da": 0
              },
              {
                "sl_no": 59,
                "emp_name": "Rajendra Kr. Nayak",
                "curr_status": "Inactive",
                "sap_id": 55200745,
                "crm_id": 2623,
                "feb_da": 0
              },
              {
                "sl_no": 60,
                "emp_name": "RUHUL AMIN SHEIKH",
                "curr_status": "Active",
                "sap_id": 187,
                "crm_id": 2624,
                "feb_da": 1208
              },
              {
                "sl_no": 61,
                "emp_name": "Ratan Kumar Sahu",
                "curr_status": "Active",
                "sap_id": 55201077,
                "crm_id": 2635,
                "feb_da": 4612
              },
              {
                "sl_no": 62,
                "emp_name": "KAMLESH KUMAR",
                "curr_status": "Active",
                "sap_id": 55200758,
                "crm_id": 2644,
                "feb_da": 2400
              },
              {
                "sl_no": 63,
                "emp_name": "Parvej Alam",
                "curr_status": "Active",
                "sap_id": "Off Role",
                "crm_id": 2645,
                "feb_da": 3188
              },
              {
                "sl_no": 64,
                "emp_name": "Ashutosh Das",
                "curr_status": "Inactive",
                "sap_id": 55200765,
                "crm_id": 2653,
                "feb_da": 0
              },
              {
                "sl_no": 65,
                "emp_name": "Shivraj Singh",
                "curr_status": "Inactive",
                "sap_id": 55200774,
                "crm_id": 2662,
                "feb_da": 0
              },
              {
                "sl_no": 66,
                "emp_name": "SAHIL RAJ",
                "curr_status": "Active",
                "sap_id": "Off Role",
                "crm_id": 2666,
                "feb_da": 1710
              },
              {
                "sl_no": 67,
                "emp_name": "DIBAKAR SARKAR",
                "curr_status": "Inactive",
                "sap_id": "Off Role",
                "crm_id": 2669,
                "feb_da": 0
              },
              {
                "sl_no": 68,
                "emp_name": "SUSANKAR DEY",
                "curr_status": "Inactive",
                "sap_id": "Off Role",
                "crm_id": 2670,
                "feb_da": 0
              },
              {
                "sl_no": 69,
                "emp_name": "SUMIT KUMAR DEB",
                "curr_status": "Active",
                "sap_id": "Off Role",
                "crm_id": 2675,
                "feb_da": 1372
              },
              {
                "sl_no": 70,
                "emp_name": "ANGSHUMAN BARUAH",
                "curr_status": "Inactive",
                "sap_id": 55200785,
                "crm_id": 2681,
                "feb_da": 0
              },
              {
                "sl_no": 71,
                "emp_name": "Brijwasi Bharadwaj",
                "curr_status": "Inactive",
                "sap_id": 55200786,
                "crm_id": 2682,
                "feb_da": 0
              },
              {
                "sl_no": 72,
                "emp_name": "Dibyaranjan Sahoo",
                "curr_status": "Active",
                "sap_id": 55200788,
                "crm_id": 2686,
                "feb_da": 2468
              },
              {
                "sl_no": 73,
                "emp_name": "NILOTPAL BHARADWAJ",
                "curr_status": "Inactive",
                "sap_id": 55200794,
                "crm_id": 2688,
                "feb_da": 0
              },
              {
                "sl_no": 74,
                "emp_name": "Shubham Shekhar",
                "curr_status": "Inactive",
                "sap_id": 55200800,
                "crm_id": 2693,
                "feb_da": 0
              },
              {
                "sl_no": 75,
                "emp_name": "ASHOK BHATTACHARJEE",
                "curr_status": "Inactive",
                "sap_id": "Off Role",
                "crm_id": 2707,
                "feb_da": 0
              },
              {
                "sl_no": 76,
                "emp_name": "RAKESH KUMAR SHARMA",
                "curr_status": "Inactive",
                "sap_id": "Off Role",
                "crm_id": 2708,
                "feb_da": 382
              },
              {
                "sl_no": 77,
                "emp_name": "BISHAL CHATTI",
                "curr_status": "Inactive",
                "sap_id": "Off Role",
                "crm_id": 2709,
                "feb_da": 0
              },
              {
                "sl_no": 78,
                "emp_name": "JIVAN KUMAR JAUNI",
                "curr_status": "Inactive",
                "sap_id": 55200815,
                "crm_id": 2718,
                "feb_da": 0
              },
              {
                "sl_no": 79,
                "emp_name": "Anil Kumar Yadav",
                "curr_status": "Active",
                "sap_id": "Off Role",
                "crm_id": 2732,
                "feb_da": 1582
              },
              {
                "sl_no": 80,
                "emp_name": "Shashwat Srivastava",
                "curr_status": "Inactive",
                "sap_id": "Off Role",
                "crm_id": 2733,
                "feb_da": 0
              },
              {
                "sl_no": 81,
                "emp_name": "Mukund Mishra",
                "curr_status": "Inactive",
                "sap_id": 55200824,
                "crm_id": 2758,
                "feb_da": 0
              },
              {
                "sl_no": 82,
                "emp_name": "Radha Raman",
                "curr_status": "Active",
                "sap_id": 55200829,
                "crm_id": 2759,
                "feb_da": 975
              },
              {
                "sl_no": 83,
                "emp_name": "ABHAY DAS",
                "curr_status": "Active",
                "sap_id": "Off Role",
                "crm_id": 2764,
                "feb_da": 5205
              },
              {
                "sl_no": 84,
                "emp_name": "JINTU RAJBONGSHI",
                "curr_status": "Active",
                "sap_id": "Off Role",
                "crm_id": 2765,
                "feb_da": 5048
              },
              {
                "sl_no": 85,
                "emp_name": "KAUSHIK BARUAH",
                "curr_status": "Inactive",
                "sap_id": "Off Role",
                "crm_id": 2766,
                "feb_da": 0
              },
              {
                "sl_no": 86,
                "emp_name": "Raj Kumar Gupta",
                "curr_status": "Inactive",
                "sap_id": 55200831,
                "crm_id": 2768,
                "feb_da": 0
              },
              {
                "sl_no": 87,
                "emp_name": "Atul Kumar",
                "curr_status": "Inactive",
                "sap_id": 55200840,
                "crm_id": 2777,
                "feb_da": 0
              },
              {
                "sl_no": 88,
                "emp_name": "Alok Srivastava",
                "curr_status": "Inactive",
                "sap_id": 55200846,
                "crm_id": 2779,
                "feb_da": 0
              },
              {
                "sl_no": 89,
                "emp_name": "Rashmi Ranjan Prusty",
                "curr_status": "Active",
                "sap_id": 55200851,
                "crm_id": 2791,
                "feb_da": 3570
              },
              {
                "sl_no": 90,
                "emp_name": "Santanu Kumar Priyadarsi",
                "curr_status": "Inactive",
                "sap_id": 55200853,
                "crm_id": 2792,
                "feb_da": 0
              },
              {
                "sl_no": 91,
                "emp_name": "Shivam Dubey",
                "curr_status": "Inactive",
                "sap_id": 55200860,
                "crm_id": 2801,
                "feb_da": 0
              },
              {
                "sl_no": 92,
                "emp_name": "Mritam Dey Sarkar",
                "curr_status": "Active",
                "sap_id": "Off Role",
                "crm_id": 2808,
                "feb_da": 2055
              },
              {
                "sl_no": 93,
                "emp_name": "Sarbesh Kumar Samantaray",
                "curr_status": "Active",
                "sap_id": 55200866,
                "crm_id": 2809,
                "feb_da": 1060
              },
              {
                "sl_no": 94,
                "emp_name": "Sourava Adhikari",
                "curr_status": "Active",
                "sap_id": 55200865,
                "crm_id": 2810,
                "feb_da": 3645
              },
              {
                "sl_no": 95,
                "emp_name": "S. SINDHU",
                "curr_status": "Inactive",
                "sap_id": "Dist Payroll",
                "crm_id": 2818,
                "feb_da": 0
              },
              {
                "sl_no": 96,
                "emp_name": "Sheikh Abdul",
                "curr_status": "Inactive",
                "sap_id": 55200884,
                "crm_id": 2831,
                "feb_da": 0
              },
              {
                "sl_no": 97,
                "emp_name": "KAPIL DEHURI",
                "curr_status": "Active",
                "sap_id": "Off Role",
                "crm_id": 2837,
                "feb_da": 3840
              },
              {
                "sl_no": 98,
                "emp_name": "PRADIP BORO",
                "curr_status": "Inactive",
                "sap_id": "Off Role",
                "crm_id": 2863,
                "feb_da": 0
              },
              {
                "sl_no": 99,
                "emp_name": "KESHAB KUMAR SONAR",
                "curr_status": "Inactive",
                "sap_id": "Off Role",
                "crm_id": 2864,
                "feb_da": 0
              },
              {
                "sl_no": 100,
                "emp_name": "Bablu Kumar Chaurasia",
                "curr_status": "Active",
                "sap_id": 55200915,
                "crm_id": 2866,
                "feb_da": 3528
              },
              {
                "sl_no": 101,
                "emp_name": "Rohit Kumar",
                "curr_status": "Inactive",
                "sap_id": 55200914,
                "crm_id": 2867,
                "feb_da": 0
              },
              {
                "sl_no": 102,
                "emp_name": "Roshan Bharti",
                "curr_status": "Inactive",
                "sap_id": 55200913,
                "crm_id": 2868,
                "feb_da": 0
              },
              {
                "sl_no": 103,
                "emp_name": "Binay Kumar",
                "curr_status": "Inactive",
                "sap_id": 55200911,
                "crm_id": 2869,
                "feb_da": 0
              },
              {
                "sl_no": 104,
                "emp_name": "Mohit Kumar Sahoo",
                "curr_status": "Inactive",
                "sap_id": 55200926,
                "crm_id": 2883,
                "feb_da": 0
              },
              {
                "sl_no": 105,
                "emp_name": "SUSHIL JOSHI",
                "curr_status": "Active",
                "sap_id": "Off Role",
                "crm_id": 2887,
                "feb_da": 4132
              },
              {
                "sl_no": 106,
                "emp_name": "DIGANTA BORA",
                "curr_status": "Inactive",
                "sap_id": "Off Role",
                "crm_id": 2894,
                "feb_da": 0
              },
              {
                "sl_no": 107,
                "emp_name": "BOLORAM KARMAKAR",
                "curr_status": "Active",
                "sap_id": "Off Role",
                "crm_id": 2895,
                "feb_da": 3315
              },
              {
                "sl_no": 108,
                "emp_name": "Vikash Kumar",
                "curr_status": "Inactive",
                "sap_id": 55200939,
                "crm_id": 2896,
                "feb_da": 0
              },
              {
                "sl_no": 109,
                "emp_name": "JWELL DEY",
                "curr_status": "Active",
                "sap_id": "Off Role",
                "crm_id": 2900,
                "feb_da": 5160
              },
              {
                "sl_no": 110,
                "emp_name": "Ajay Kumar Pandey",
                "curr_status": "Inactive",
                "sap_id": 55200947,
                "crm_id": 2901,
                "feb_da": 0
              },
              {
                "sl_no": 111,
                "emp_name": "Alok Kumar Soni",
                "curr_status": "Inactive",
                "sap_id": 55200949,
                "crm_id": 2902,
                "feb_da": 0
              },
              {
                "sl_no": 112,
                "emp_name": "Harender Yadav",
                "curr_status": "Inactive",
                "sap_id": 55200948,
                "crm_id": 2903,
                "feb_da": 0
              },
              {
                "sl_no": 113,
                "emp_name": "Kamlesh Mandal",
                "curr_status": "Active",
                "sap_id": "Off Role",
                "crm_id": 2906,
                "feb_da": 1815
              },
              {
                "sl_no": 114,
                "emp_name": "Prem Shankar Bharti",
                "curr_status": "Inactive",
                "sap_id": 55200955,
                "crm_id": 2907,
                "feb_da": 0
              },
              {
                "sl_no": 115,
                "emp_name": "Prashant Kumar",
                "curr_status": "Inactive",
                "sap_id": 55200954,
                "crm_id": 2909,
                "feb_da": 0
              },
              {
                "sl_no": 116,
                "emp_name": "Shankar Kumar",
                "curr_status": "Inactive",
                "sap_id": 55200953,
                "crm_id": 2910,
                "feb_da": 0
              },
              {
                "sl_no": 117,
                "emp_name": "Md Nasir",
                "curr_status": "Active",
                "sap_id": 55200959,
                "crm_id": 2915,
                "feb_da": 4688
              },
              {
                "sl_no": 118,
                "emp_name": "MANUJ KANDALI",
                "curr_status": "Active",
                "sap_id": "Off Role",
                "crm_id": 2920,
                "feb_da": 3578
              },
              {
                "sl_no": 119,
                "emp_name": "SADDAM HUSSAIN",
                "curr_status": "Inactive",
                "sap_id": "Off Role",
                "crm_id": 2921,
                "feb_da": 0
              },
              {
                "sl_no": 120,
                "emp_name": "Chandan Chandra Barman",
                "curr_status": "Inactive",
                "sap_id": "Off Role",
                "crm_id": 2922,
                "feb_da": 0
              },
              {
                "sl_no": 121,
                "emp_name": "Subrat Kumar Swain",
                "curr_status": "Active",
                "sap_id": 55200965,
                "crm_id": 2923,
                "feb_da": 3758
              },
              {
                "sl_no": 122,
                "emp_name": "VICTOR KAR",
                "curr_status": "Active",
                "sap_id": 55200983,
                "crm_id": 2925,
                "feb_da": 0
              },
              {
                "sl_no": 123,
                "emp_name": "Anand Kumar Mandal",
                "curr_status": "Active",
                "sap_id": 55200974,
                "crm_id": 2926,
                "feb_da": 2160
              },
              {
                "sl_no": 124,
                "emp_name": "Durgesh Kumar Jha",
                "curr_status": "Inactive",
                "sap_id": 55200976,
                "crm_id": 2927,
                "feb_da": 1162
              },
              {
                "sl_no": 125,
                "emp_name": "Amit Kumar",
                "curr_status": "Inactive",
                "sap_id": 55200981,
                "crm_id": 2928,
                "feb_da": 0
              },
              {
                "sl_no": 126,
                "emp_name": "Rakesh Kumar Singh",
                "curr_status": "Active",
                "sap_id": 55200975,
                "crm_id": 2929,
                "feb_da": 660
              },
              {
                "sl_no": 127,
                "emp_name": "MANJIT SARKAR",
                "curr_status": "Inactive",
                "sap_id": 55200982,
                "crm_id": 2930,
                "feb_da": 0
              },
              {
                "sl_no": 128,
                "emp_name": "Najimul Hoque",
                "curr_status": "Inactive",
                "sap_id": 55200980,
                "crm_id": 2931,
                "feb_da": 0
              },
              {
                "sl_no": 129,
                "emp_name": "Sushil Kumar Gaur",
                "curr_status": "Inactive",
                "sap_id": 55200986,
                "crm_id": 2933,
                "feb_da": 0
              },
              {
                "sl_no": 130,
                "emp_name": "Chandan Das",
                "curr_status": "Inactive",
                "sap_id": "Off Role",
                "crm_id": 2936,
                "feb_da": 0
              },
              {
                "sl_no": 131,
                "emp_name": "Kripanjoy Das",
                "curr_status": "Inactive",
                "sap_id": "Off Role",
                "crm_id": 2937,
                "feb_da": 0
              },
              {
                "sl_no": 132,
                "emp_name": "Madhurjya Saikia",
                "curr_status": "Inactive",
                "sap_id": "Off Role",
                "crm_id": 2939,
                "feb_da": 0
              },
              {
                "sl_no": 133,
                "emp_name": "Suraj Kumar Jha",
                "curr_status": "Active",
                "sap_id": 55200996,
                "crm_id": 2945,
                "feb_da": 2715
              },
              {
                "sl_no": 134,
                "emp_name": "Kundan Kumar",
                "curr_status": "Active",
                "sap_id": 55200995,
                "crm_id": 2946,
                "feb_da": 4365
              },
              {
                "sl_no": 135,
                "emp_name": "Arun Kumar",
                "curr_status": "Inactive",
                "sap_id": 55200998,
                "crm_id": 2947,
                "feb_da": 0
              },
              {
                "sl_no": 136,
                "emp_name": "Manish Kumar",
                "curr_status": "Active",
                "sap_id": 55201001,
                "crm_id": 2949,
                "feb_da": 3758
              },
              {
                "sl_no": 137,
                "emp_name": "Suraj Kumar",
                "curr_status": "Inactive",
                "sap_id": 55200994,
                "crm_id": 2951,
                "feb_da": 0
              },
              {
                "sl_no": 138,
                "emp_name": "Rohan Ahmed",
                "curr_status": "Inactive",
                "sap_id": 55201000,
                "crm_id": 2953,
                "feb_da": 188
              },
              {
                "sl_no": 139,
                "emp_name": "Biswajeet Pradhan",
                "curr_status": "Inactive",
                "sap_id": 55201006,
                "crm_id": 2954,
                "feb_da": 0
              },
              {
                "sl_no": 140,
                "emp_name": "Soumya Ranjan Dash",
                "curr_status": "Active",
                "sap_id": 55201005,
                "crm_id": 2955,
                "feb_da": 4462
              },
              {
                "sl_no": 141,
                "emp_name": "Jagannath Behera",
                "curr_status": "Inactive",
                "sap_id": 55201007,
                "crm_id": 2956,
                "feb_da": 0
              },
              {
                "sl_no": 142,
                "emp_name": "Muruli Mipun",
                "curr_status": "Inactive",
                "sap_id": 55201008,
                "crm_id": 2960,
                "feb_da": 0
              },
              {
                "sl_no": 143,
                "emp_name": "Abani Kumar Puti",
                "curr_status": "Inactive",
                "sap_id": 55201011,
                "crm_id": 2971,
                "feb_da": 0
              },
              {
                "sl_no": 144,
                "emp_name": "Situn Kumar Gouda",
                "curr_status": "Inactive",
                "sap_id": 55201009,
                "crm_id": 2972,
                "feb_da": 0
              },
              {
                "sl_no": 145,
                "emp_name": "Swagata Panda",
                "curr_status": "Inactive",
                "sap_id": 55201010,
                "crm_id": 2973,
                "feb_da": 0
              },
              {
                "sl_no": 146,
                "emp_name": "Nishikanta Sethi",
                "curr_status": "Inactive",
                "sap_id": 55201013,
                "crm_id": 2974,
                "feb_da": 0
              },
              {
                "sl_no": 147,
                "emp_name": "Bhaktahari Sahoo",
                "curr_status": "Inactive",
                "sap_id": 55201020,
                "crm_id": 2981,
                "feb_da": 0
              },
              {
                "sl_no": 148,
                "emp_name": "Sandip Kumar Sahoo",
                "curr_status": "Inactive",
                "sap_id": 55201019,
                "crm_id": 2982,
                "feb_da": 0
              },
              {
                "sl_no": 149,
                "emp_name": "Hasirat Hojai",
                "curr_status": "Inactive",
                "sap_id": "Off Role",
                "crm_id": 2983,
                "feb_da": 0
              },
              {
                "sl_no": 150,
                "emp_name": "KAUSIK NATH",
                "curr_status": "Active",
                "sap_id": "Off Role",
                "crm_id": 2984,
                "feb_da": 2932
              },
              {
                "sl_no": 151,
                "emp_name": "Dipanjan Deb",
                "curr_status": "Inactive",
                "sap_id": "Off Role",
                "crm_id": 2985,
                "feb_da": 0
              },
              {
                "sl_no": 152,
                "emp_name": "Shani Chaudhary",
                "curr_status": "Active",
                "sap_id": 55201021,
                "crm_id": 2994,
                "feb_da": 1915
              },
              {
                "sl_no": 153,
                "emp_name": "Saurabha Prajapati",
                "curr_status": "Active",
                "sap_id": 55201025,
                "crm_id": 2995,
                "feb_da": 795
              },
              {
                "sl_no": 154,
                "emp_name": "Prashant Srivastava",
                "curr_status": "Inactive",
                "sap_id": 55201024,
                "crm_id": 2996,
                "feb_da": 0
              },
              {
                "sl_no": 155,
                "emp_name": "Shyam Kumar",
                "curr_status": "Active",
                "sap_id": 55201039,
                "crm_id": 3005,
                "feb_da": 1680
              },
              {
                "sl_no": 156,
                "emp_name": "Ankit Kumar Pandey",
                "curr_status": "Inactive",
                "sap_id": 55201040,
                "crm_id": 3006,
                "feb_da": 0
              },
              {
                "sl_no": 157,
                "emp_name": "Krishna Kant Shukla",
                "curr_status": "Inactive",
                "sap_id": 55201044,
                "crm_id": 3007,
                "feb_da": 0
              },
              {
                "sl_no": 158,
                "emp_name": "Rabindra Gouda",
                "curr_status": "Active",
                "sap_id": 55201041,
                "crm_id": 3013,
                "feb_da": 1732
              },
              {
                "sl_no": 159,
                "emp_name": "Rahul Kumar",
                "curr_status": "Inactive",
                "sap_id": 55201050,
                "crm_id": 3014,
                "feb_da": 0
              },
              {
                "sl_no": 160,
                "emp_name": "VIVEK RANJAN",
                "curr_status": "Inactive",
                "sap_id": 223,
                "crm_id": 3018,
                "feb_da": 0
              },
              {
                "sl_no": 161,
                "emp_name": "CHHITISH SARWESH",
                "curr_status": "Active",
                "sap_id": 224,
                "crm_id": 3019,
                "feb_da": 1568
              },
              {
                "sl_no": 162,
                "emp_name": "Abhimanyu Kumar",
                "curr_status": "Inactive",
                "sap_id": 55201047,
                "crm_id": 3021,
                "feb_da": 0
              },
              {
                "sl_no": 163,
                "emp_name": "Amit Mishra",
                "curr_status": "Active",
                "sap_id": 55201061,
                "crm_id": 3025,
                "feb_da": 2078
              },
              {
                "sl_no": 164,
                "emp_name": "Tara Singh",
                "curr_status": "Inactive",
                "sap_id": 55201065,
                "crm_id": 3026,
                "feb_da": 0
              },
              {
                "sl_no": 165,
                "emp_name": "Satish Srivastava",
                "curr_status": "Active",
                "sap_id": 55201062,
                "crm_id": 3028,
                "feb_da": 1958
              },
              {
                "sl_no": 166,
                "emp_name": "Dheeraj Kumar",
                "curr_status": "Inactive",
                "sap_id": 55201057,
                "crm_id": 3030,
                "feb_da": 0
              },
              {
                "sl_no": 167,
                "emp_name": "Rakesh Kumar Srivastava",
                "curr_status": "Active",
                "sap_id": 55201063,
                "crm_id": 3034,
                "feb_da": 2638
              },
              {
                "sl_no": 168,
                "emp_name": "BABLU GUPTA",
                "curr_status": "Inactive",
                "sap_id": 55201069,
                "crm_id": 3035,
                "feb_da": 0
              },
              {
                "sl_no": 169,
                "emp_name": "Gourav Sharma",
                "curr_status": "Inactive",
                "sap_id": 55201073,
                "crm_id": 3036,
                "feb_da": 0
              },
              {
                "sl_no": 170,
                "emp_name": "Mahendra Kumar Sharma",
                "curr_status": "Inactive",
                "sap_id": 55201059,
                "crm_id": 3039,
                "feb_da": 0
              },
              {
                "sl_no": 171,
                "emp_name": "Ayush Agrahari",
                "curr_status": "Inactive",
                "sap_id": 55201075,
                "crm_id": 3041,
                "feb_da": 0
              },
              {
                "sl_no": 172,
                "emp_name": "Vimal Thakur",
                "curr_status": "Inactive",
                "sap_id": 55201074,
                "crm_id": 3043,
                "feb_da": 0
              },
              {
                "sl_no": 173,
                "emp_name": "Shashi Prakash Tiwari",
                "curr_status": "Inactive",
                "sap_id": 55200798,
                "crm_id": 3053,
                "feb_da": 0
              },
              {
                "sl_no": 174,
                "emp_name": "Mayurjit Das",
                "curr_status": "Inactive",
                "sap_id": 55201078,
                "crm_id": 3056,
                "feb_da": 0
              },
              {
                "sl_no": 175,
                "emp_name": "Marjiyaf Ashikin",
                "curr_status": "Active",
                "sap_id": "Off Role",
                "crm_id": 3057,
                "feb_da": 1838
              },
              {
                "sl_no": 176,
                "emp_name": "Partha Teron",
                "curr_status": "Active",
                "sap_id": "Off Role",
                "crm_id": 3058,
                "feb_da": 900
              },
              {
                "sl_no": 177,
                "emp_name": "Faizan Khan",
                "curr_status": "Active",
                "sap_id": 55201091,
                "crm_id": 3060,
                "feb_da": 2648
              },
              {
                "sl_no": 178,
                "emp_name": "Sudhir Kumar",
                "curr_status": "Inactive",
                "sap_id": 55201087,
                "crm_id": 3064,
                "feb_da": 0
              },
              {
                "sl_no": 179,
                "emp_name": "Ravi Kumar",
                "curr_status": "Inactive",
                "sap_id": 55201088,
                "crm_id": 3065,
                "feb_da": 0
              },
              {
                "sl_no": 180,
                "emp_name": "Risabh Pandey",
                "curr_status": "Active",
                "sap_id": 55201080,
                "crm_id": 3066,
                "feb_da": 2032
              },
              {
                "sl_no": 181,
                "emp_name": "Sunil Agrahari",
                "curr_status": "Inactive",
                "sap_id": 55201082,
                "crm_id": 3067,
                "feb_da": 0
              },
              {
                "sl_no": 182,
                "emp_name": "Vinay Singh",
                "curr_status": "Active",
                "sap_id": 55201083,
                "crm_id": 3068,
                "feb_da": 2932
              },
              {
                "sl_no": 183,
                "emp_name": "Kirti Kumar",
                "curr_status": "Inactive",
                "sap_id": 55201086,
                "crm_id": 3070,
                "feb_da": 0
              },
              {
                "sl_no": 184,
                "emp_name": "Tapan Ghosh",
                "curr_status": "Active",
                "sap_id": "Off Role",
                "crm_id": 3072,
                "feb_da": 3060
              },
              {
                "sl_no": 185,
                "emp_name": "Saiyad Mizanur Rahman Khan",
                "curr_status": "Inactive",
                "sap_id": "Off Role",
                "crm_id": 3073,
                "feb_da": 0
              },
              {
                "sl_no": 186,
                "emp_name": "Prosenjit Nag",
                "curr_status": "Active",
                "sap_id": "Off Role",
                "crm_id": 3074,
                "feb_da": 375
              },
              {
                "sl_no": 187,
                "emp_name": "Vikas Kumar",
                "curr_status": "Inactive",
                "sap_id": 55201116,
                "crm_id": 3077,
                "feb_da": 1388
              },
              {
                "sl_no": 188,
                "emp_name": "Pravin Kumar Pandey",
                "curr_status": "Active",
                "sap_id": 55201096,
                "crm_id": 3078,
                "feb_da": 1612
              },
              {
                "sl_no": 189,
                "emp_name": "Subodh Kumar",
                "curr_status": "Inactive",
                "sap_id": 55201097,
                "crm_id": 3079,
                "feb_da": 0
              },
              {
                "sl_no": 190,
                "emp_name": "Jitendra Kumar",
                "curr_status": "Inactive",
                "sap_id": 55201098,
                "crm_id": 3081,
                "feb_da": 0
              },
              {
                "sl_no": 191,
                "emp_name": "Niraj Kumar",
                "curr_status": "Active",
                "sap_id": 55201100,
                "crm_id": 3082,
                "feb_da": 2715
              },
              {
                "sl_no": 192,
                "emp_name": "Rajeev Kumar Raj",
                "curr_status": "Inactive",
                "sap_id": 55201067,
                "crm_id": 3083,
                "feb_da": 0
              },
              {
                "sl_no": 193,
                "emp_name": "Aman Agrawal",
                "curr_status": "Inactive",
                "sap_id": 55201101,
                "crm_id": 3084,
                "feb_da": 0
              },
              {
                "sl_no": 194,
                "emp_name": "Rahul Mishra",
                "curr_status": "Inactive",
                "sap_id": 55201123,
                "crm_id": 3087,
                "feb_da": 0
              },
              {
                "sl_no": 195,
                "emp_name": "Wasim Hassan",
                "curr_status": "Active",
                "sap_id": 55201125,
                "crm_id": 3094,
                "feb_da": 1740
              },
              {
                "sl_no": 196,
                "emp_name": "Mahabali",
                "curr_status": "Inactive",
                "sap_id": 55201104,
                "crm_id": 3095,
                "feb_da": 0
              },
              {
                "sl_no": 197,
                "emp_name": "Rahul Yadav",
                "curr_status": "Inactive",
                "sap_id": 55201105,
                "crm_id": 3096,
                "feb_da": 0
              },
              {
                "sl_no": 198,
                "emp_name": "Furkan Khan",
                "curr_status": "Inactive",
                "sap_id": 55201112,
                "crm_id": 3097,
                "feb_da": 0
              },
              {
                "sl_no": 199,
                "emp_name": "Ankit Sarswat",
                "curr_status": "Active",
                "sap_id": 55201118,
                "crm_id": 3098,
                "feb_da": 1860
              },
              {
                "sl_no": 200,
                "emp_name": "Himanshu Gupta",
                "curr_status": "Inactive",
                "sap_id": 55201117,
                "crm_id": 3099,
                "feb_da": 0
              },
              {
                "sl_no": 201,
                "emp_name": "Abdul Sattar",
                "curr_status": "Inactive",
                "sap_id": 55201124,
                "crm_id": 3100,
                "feb_da": 0
              },
              {
                "sl_no": 202,
                "emp_name": "Bajruddin",
                "curr_status": "Inactive",
                "sap_id": 55201126,
                "crm_id": 3101,
                "feb_da": 0
              },
              {
                "sl_no": 203,
                "emp_name": "Vaishnav Kumar",
                "curr_status": "Inactive",
                "sap_id": 55201110,
                "crm_id": 3103,
                "feb_da": 0
              },
              {
                "sl_no": 204,
                "emp_name": "Yankit Goswami",
                "curr_status": "Inactive",
                "sap_id": 55201114,
                "crm_id": 3104,
                "feb_da": 0
              },
              {
                "sl_no": 205,
                "emp_name": "Mahesh Chandra",
                "curr_status": "Inactive",
                "sap_id": 55201109,
                "crm_id": 3107,
                "feb_da": 0
              },
              {
                "sl_no": 206,
                "emp_name": "Kulbeer Singh",
                "curr_status": "Active",
                "sap_id": 55201113,
                "crm_id": 3108,
                "feb_da": 2250
              },
              {
                "sl_no": 207,
                "emp_name": "Azhar Iqbal Talukdar",
                "curr_status": "Inactive",
                "sap_id": "Off Role",
                "crm_id": 3109,
                "feb_da": 0
              },
              {
                "sl_no": 208,
                "emp_name": "Dhiraj Nath",
                "curr_status": "Inactive",
                "sap_id": 55201128,
                "crm_id": 3111,
                "feb_da": 0
              },
              {
                "sl_no": 209,
                "emp_name": "Rakesh Kumar Ranjan",
                "curr_status": "Inactive",
                "sap_id": 55201094,
                "crm_id": 3113,
                "feb_da": 0
              },
              {
                "sl_no": 210,
                "emp_name": "Harinarayan Pothal",
                "curr_status": "Active",
                "sap_id": 55201046,
                "crm_id": 3114,
                "feb_da": 1410
              },
              {
                "sl_no": 211,
                "emp_name": "Sandeep Kumar",
                "curr_status": "Active",
                "sap_id": 55201131,
                "crm_id": 3115,
                "feb_da": 3592
              },
              {
                "sl_no": 212,
                "emp_name": "Ankur Arya",
                "curr_status": "Active",
                "sap_id": 55201130,
                "crm_id": 3116,
                "feb_da": 3908
              },
              {
                "sl_no": 213,
                "emp_name": "Kalpujjal Sarmah",
                "curr_status": "Inactive",
                "sap_id": "Off Role",
                "crm_id": 3118,
                "feb_da": 0
              },
              {
                "sl_no": 214,
                "emp_name": "Mirfaidul_Hoque",
                "curr_status": "Active",
                "sap_id": 55201134,
                "crm_id": 3119,
                "feb_da": 3975
              },
              {
                "sl_no": 215,
                "emp_name": "Amit Singh",
                "curr_status": "Inactive",
                "sap_id": 55201102,
                "crm_id": 3138,
                "feb_da": 0
              },
              {
                "sl_no": 216,
                "emp_name": "Kumar Sonu Vishwakarma",
                "curr_status": "Inactive",
                "sap_id": 55201133,
                "crm_id": 3139,
                "feb_da": 0
              },
              {
                "sl_no": 217,
                "emp_name": "Prakash Ranjan Sahu",
                "curr_status": "Active",
                "sap_id": 55201142,
                "crm_id": 3142,
                "feb_da": 1868
              },
              {
                "sl_no": 218,
                "emp_name": "Tasnur Islam",
                "curr_status": "Inactive",
                "sap_id": "Off Role",
                "crm_id": 3143,
                "feb_da": 0
              },
              {
                "sl_no": 219,
                "emp_name": "Pritam Mandal",
                "curr_status": "Inactive",
                "sap_id": "Off Role",
                "crm_id": 3144,
                "feb_da": 0
              },
              {
                "sl_no": 220,
                "emp_name": "NARESH KUMAR",
                "curr_status": "Inactive",
                "sap_id": "Off Role",
                "crm_id": 3145,
                "feb_da": 0
              },
              {
                "sl_no": 221,
                "emp_name": "Amit Ranjan Verma",
                "curr_status": "Active",
                "sap_id": "Off Role",
                "crm_id": 3146,
                "feb_da": 2198
              },
              {
                "sl_no": 222,
                "emp_name": "Dinesh Kumar",
                "curr_status": "Inactive",
                "sap_id": 55201135,
                "crm_id": 3154,
                "feb_da": 0
              },
              {
                "sl_no": 223,
                "emp_name": "Birendra Kumar",
                "curr_status": "Active",
                "sap_id": 55201137,
                "crm_id": 3155,
                "feb_da": 1485
              },
              {
                "sl_no": 224,
                "emp_name": "Susen Dey",
                "curr_status": "Active",
                "sap_id": "Off Role",
                "crm_id": 3162,
                "feb_da": 1998
              },
              {
                "sl_no": 225,
                "emp_name": "Jahangir Sheikh",
                "curr_status": "Active",
                "sap_id": 55201153,
                "crm_id": 3163,
                "feb_da": 6540
              },
              {
                "sl_no": 226,
                "emp_name": "Jitendra Yadav",
                "curr_status": "Inactive",
                "sap_id": 55201154,
                "crm_id": 3164,
                "feb_da": 0
              },
              {
                "sl_no": 227,
                "emp_name": "Aditya Kumar",
                "curr_status": "Inactive",
                "sap_id": 55201160,
                "crm_id": 3171,
                "feb_da": 0
              },
              {
                "sl_no": 228,
                "emp_name": "Ayan Saifi",
                "curr_status": "Active",
                "sap_id": 55201166,
                "crm_id": 3172,
                "feb_da": 1770
              },
              {
                "sl_no": 229,
                "emp_name": "Shrawan Kumar Saini",
                "curr_status": "Active",
                "sap_id": 55201164,
                "crm_id": 3173,
                "feb_da": 2445
              },
              {
                "sl_no": 230,
                "emp_name": "Niten Prakash",
                "curr_status": "Inactive",
                "sap_id": 55201168,
                "crm_id": 3175,
                "feb_da": 0
              },
              {
                "sl_no": 231,
                "emp_name": "Krishna Kharka",
                "curr_status": "Inactive",
                "sap_id": "Off Role",
                "crm_id": 3176,
                "feb_da": 1065
              },
              {
                "sl_no": 232,
                "emp_name": "Manash Pratim Bordoloi",
                "curr_status": "Inactive",
                "sap_id": "Off Role",
                "crm_id": 3183,
                "feb_da": 0
              },
              {
                "sl_no": 233,
                "emp_name": "Amit Upadhayay",
                "curr_status": "Inactive",
                "sap_id": 55201171,
                "crm_id": 3184,
                "feb_da": 0
              },
              {
                "sl_no": 234,
                "emp_name": "Rabindra Manik",
                "curr_status": "Active",
                "sap_id": 55201174,
                "crm_id": 3188,
                "feb_da": 4935
              },
              {
                "sl_no": 235,
                "emp_name": "Amit kumar Sahoo",
                "curr_status": "Active",
                "sap_id": 55201178,
                "crm_id": 3195,
                "feb_da": 3945
              },
              {
                "sl_no": 236,
                "emp_name": "Prasenjit Ghosh",
                "curr_status": "Active",
                "sap_id": "Off Role",
                "crm_id": 3196,
                "feb_da": 3398
              },
              {
                "sl_no": 237,
                "emp_name": "Chandan Kumar",
                "curr_status": "Active",
                "sap_id": 55201183,
                "crm_id": 3197,
                "feb_da": 592
              },
              {
                "sl_no": 238,
                "emp_name": "Prakash_Pradhan",
                "curr_status": "Active",
                "sap_id": 55201184,
                "crm_id": 3198,
                "feb_da": 855
              },
              {
                "sl_no": 239,
                "emp_name": "Amrit Dubey",
                "curr_status": "Active",
                "sap_id": 55201179,
                "crm_id": 3202,
                "feb_da": 2488
              },
              {
                "sl_no": 240,
                "emp_name": "Rajeev Ranjan Singh",
                "curr_status": "Inactive",
                "sap_id": 55201192,
                "crm_id": 3207,
                "feb_da": 1575
              },
              {
                "sl_no": 241,
                "emp_name": "Sudipto Ronjon Borbora",
                "curr_status": "Inactive",
                "sap_id": "Off Role",
                "crm_id": 3214,
                "feb_da": 0
              },
              {
                "sl_no": 242,
                "emp_name": "Golam Rahman",
                "curr_status": "Active",
                "sap_id": "Off Role",
                "crm_id": 3215,
                "feb_da": 2115
              },
              {
                "sl_no": 243,
                "emp_name": "Omprakash Jha",
                "curr_status": "Active",
                "sap_id": 55201201,
                "crm_id": 3216,
                "feb_da": 1118
              },
              {
                "sl_no": 244,
                "emp_name": "Omprakash Kumar",
                "curr_status": "Inactive",
                "sap_id": 55201199,
                "crm_id": 3217,
                "feb_da": 0
              },
              {
                "sl_no": 245,
                "emp_name": "Gaurav Kumar Singh",
                "curr_status": "Inactive",
                "sap_id": 55201198,
                "crm_id": 3218,
                "feb_da": 0
              },
              {
                "sl_no": 246,
                "emp_name": "Nirmal Kanti Debnath",
                "curr_status": "Inactive",
                "sap_id": "Off Role",
                "crm_id": 3222,
                "feb_da": 0
              },
              {
                "sl_no": 247,
                "emp_name": "Adarsh Naiyar",
                "curr_status": "Active",
                "sap_id": 55201212,
                "crm_id": 3226,
                "feb_da": 1850
              },
              {
                "sl_no": 248,
                "emp_name": "SANGAM NAYAK",
                "curr_status": "Inactive",
                "sap_id": "Off Role",
                "crm_id": 3229,
                "feb_da": 0
              },
              {
                "sl_no": 249,
                "emp_name": "Randhir Sharma",
                "curr_status": "Active",
                "sap_id": "Off Role",
                "crm_id": 3230,
                "feb_da": 750
              },
              {
                "sl_no": 250,
                "emp_name": "Abhishek Paswan",
                "curr_status": "Inactive",
                "sap_id": 55201217,
                "crm_id": 3233,
                "feb_da": 0
              },
              {
                "sl_no": 251,
                "emp_name": "Pradeep Kumar Behera",
                "curr_status": "Active",
                "sap_id": 55201220,
                "crm_id": 3236,
                "feb_da": 3878
              },
              {
                "sl_no": 252,
                "emp_name": "Chandan Giri",
                "curr_status": "Active",
                "sap_id": 55201219,
                "crm_id": 3237,
                "feb_da": 2122
              },
              {
                "sl_no": 253,
                "emp_name": "Akash Kumar Jena",
                "curr_status": "Active",
                "sap_id": 55201233,
                "crm_id": 3243,
                "feb_da": 2978
              },
              {
                "sl_no": 254,
                "emp_name": "Pankaj Koch",
                "curr_status": "Active",
                "sap_id": "Off Role",
                "crm_id": 3247,
                "feb_da": 2498
              },
              {
                "sl_no": 255,
                "emp_name": "Abhijit_Chakraborty",
                "curr_status": "Active",
                "sap_id": "Off Role",
                "crm_id": 3249,
                "feb_da": 2730
              },
              {
                "sl_no": 256,
                "emp_name": "Ranajyoti Bora",
                "curr_status": "Inactive",
                "sap_id": "Off Role",
                "crm_id": 3260,
                "feb_da": 0
              },
              {
                "sl_no": 257,
                "emp_name": "Nitul Talukdar",
                "curr_status": "Inactive",
                "sap_id": "Off Role",
                "crm_id": 3261,
                "feb_da": 0
              },
              {
                "sl_no": 258,
                "emp_name": "Arijeet Bhowmick",
                "curr_status": "Active",
                "sap_id": "Off Role",
                "crm_id": 3272,
                "feb_da": 3915
              },
              {
                "sl_no": 259,
                "emp_name": "Hirak Jyoti Ray",
                "curr_status": "Active",
                "sap_id": 55201252,
                "crm_id": 3274,
                "feb_da": 3510
              },
              {
                "sl_no": 260,
                "emp_name": "Sourabh kumar",
                "curr_status": "Inactive",
                "sap_id": "Off Role",
                "crm_id": 3275,
                "feb_da": 0
              },
              {
                "sl_no": 261,
                "emp_name": "Hemant Kumar Mishra",
                "curr_status": "Active",
                "sap_id": 55201249,
                "crm_id": 3279,
                "feb_da": 3025
              },
              {
                "sl_no": 262,
                "emp_name": "Kumar Abhishek",
                "curr_status": "Active",
                "sap_id": 55201254,
                "crm_id": 3283,
                "feb_da": 495
              },
              {
                "sl_no": 263,
                "emp_name": "Gaurav Kumar",
                "curr_status": "Inactive",
                "sap_id": 55201259,
                "crm_id": 3287,
                "feb_da": 488
              },
              {
                "sl_no": 264,
                "emp_name": "Reetwam Pathak",
                "curr_status": "Active",
                "sap_id": 55201262,
                "crm_id": 3289,
                "feb_da": 960
              },
              {
                "sl_no": 265,
                "emp_name": "Shakti Singh",
                "curr_status": "Inactive",
                "sap_id": 55201271,
                "crm_id": 3297,
                "feb_da": 0
              },
              {
                "sl_no": 266,
                "emp_name": "Bikash Bezbaruah",
                "curr_status": "Inactive",
                "sap_id": "Off Role",
                "crm_id": 3298,
                "feb_da": 75
              },
              {
                "sl_no": 267,
                "emp_name": "Ranjit Mandal",
                "curr_status": "Active",
                "sap_id": "Off Role",
                "crm_id": 3299,
                "feb_da": 1522
              },
              {
                "sl_no": 268,
                "emp_name": "Ronit Behera",
                "curr_status": "Active",
                "sap_id": 55201275,
                "crm_id": 3304,
                "feb_da": 1808
              },
              {
                "sl_no": 269,
                "emp_name": "Trinkul Lochan Das",
                "curr_status": "Active",
                "sap_id": 55201280,
                "crm_id": 3316,
                "feb_da": 1252
              },
              {
                "sl_no": 270,
                "emp_name": "Vishwamitra Kumar",
                "curr_status": "Active",
                "sap_id": 55201288,
                "crm_id": 3336,
                "feb_da": 0
              },
              {
                "sl_no": 271,
                "emp_name": "Anup Kumar Mandal",
                "curr_status": "Inactive",
                "sap_id": 55201289,
                "crm_id": 3337,
                "feb_da": 0
              },
              {
                "sl_no": 272,
                "emp_name": "Alok Kumar Pandey",
                "curr_status": "Active",
                "sap_id": 55201291,
                "crm_id": 3338,
                "feb_da": 75
              },
              {
                "sl_no": 273,
                "emp_name": "Shiv Prasad",
                "curr_status": "Inactive",
                "sap_id": 55201292,
                "crm_id": 3339,
                "feb_da": 0
              },
              {
                "sl_no": 274,
                "emp_name": "Rounak Kumar",
                "curr_status": "Active",
                "sap_id": 55201293,
                "crm_id": 3340,
                "feb_da": 0
              },
              {
                "sl_no": 275,
                "emp_name": "Aman Raj",
                "curr_status": "Active",
                "sap_id": 55201295,
                "crm_id": 3341,
                "feb_da": 0
              },
              {
                "sl_no": 276,
                "emp_name": "Saurabh Kumar",
                "curr_status": "Active",
                "sap_id": 55201299,
                "crm_id": 3342,
                "feb_da": 0
              },
              {
                "sl_no": 277,
                "emp_name": "Tridip Chakraborty",
                "curr_status": "Active",
                "sap_id": "Off Role",
                "crm_id": 3343,
                "feb_da": 2828
              },
              {
                "sl_no": 278,
                "emp_name": "Roshan kumar",
                "curr_status": "Active",
                "sap_id": 55201302,
                "crm_id": 3349,
                "feb_da": 210
              },
              {
                "sl_no": 279,
                "emp_name": "Harekrishna Choudhuri",
                "curr_status": "Active",
                "sap_id": "Off Role",
                "crm_id": 3350,
                "feb_da": 1058
              },
              {
                "sl_no": 280,
                "emp_name": "Sumit",
                "curr_status": "Active",
                "sap_id": 55201309,
                "crm_id": 3359,
                "feb_da": 0
              },
              {
                "sl_no": 281,
                "emp_name": "Priyash Upadhaya",
                "curr_status": "Active",
                "sap_id": "Off Role",
                "crm_id": 3363,
                "feb_da": 465
              },
              {
                "sl_no": 282,
                "emp_name": "Rohan Raj",
                "curr_status": "Active",
                "sap_id": 55201320,
                "crm_id": 3365,
                "feb_da": 0
              },
              {
                "sl_no": 283,
                "emp_name": "Razzak Ahmed",
                "curr_status": "Active",
                "sap_id": "Off Role",
                "crm_id": 3373,
                "feb_da": 0
              },
              {
                "sl_no": 284,
                "emp_name": "Amar Raj",
                "curr_status": "Active",
                "sap_id": 55201321,
                "crm_id": 3374,
                "feb_da": 0
              },
              {
                "sl_no": 285,
                "emp_name": "Mangesh Kumar",
                "curr_status": "Active",
                "sap_id": 55201326,
                "crm_id": 3379,
                "feb_da": 0
              },
              {
                "sl_no": 286,
                "emp_name": "Vinit_Mishra",
                "curr_status": "Active",
                "sap_id": 55201328,
                "crm_id": 3382,
                "feb_da": 0
              },
              {
                "sl_no": 287,
                "emp_name": "Kunjanayan Das",
                "curr_status": "Active",
                "sap_id": "Off Role",
                "crm_id": 3385,
                "feb_da": 0
              },
              {
                "sl_no": 288,
                "emp_name": "Mridul Kumar Roy",
                "curr_status": "Active",
                "sap_id": "Off Role",
                "crm_id": 3386,
                "feb_da": 0
              },
              {
                "sl_no": 289,
                "emp_name": "Gautam Kumar",
                "curr_status": "Active",
                "sap_id": 55201334,
                "crm_id": 3392,
                "feb_da": 0
              },
              {
                "sl_no": 290,
                "emp_name": "Dileep Tomar",
                "curr_status": "Active",
                "sap_id": 55201340,
                "crm_id": 3395,
                "feb_da": 0
              },
              {
                "sl_no": 9,
                "emp_name": "Asutosh Kumar",
                "curr_status": "Inactive",
                "sap_id": 10300184,
                "crm_id": 404,
                "feb_da": 0
              },
              {
                "sl_no": 10,
                "emp_name": "Manish Kumar",
                "curr_status": "Inactive",
                "sap_id": 10300100,
                "crm_id": 439,
                "feb_da": 0
              },
              {
                "sl_no": 11,
                "emp_name": "Subodh Kumar",
                "curr_status": "Active",
                "sap_id": 10300101,
                "crm_id": 440,
                "feb_da": 4175
              },
              {
                "sl_no": 13,
                "emp_name": "PRADEEP KUMAR",
                "curr_status": "Active",
                "sap_id": 10300112,
                "crm_id": 455,
                "feb_da": 4850
              },
              {
                "sl_no": 18,
                "emp_name": "HIMANSHU KUMAR",
                "curr_status": "Inactive",
                "sap_id": 10300124,
                "crm_id": 851,
                "feb_da": 0
              },
              {
                "sl_no": 20,
                "emp_name": "SANTOSH KUMAR",
                "curr_status": "Inactive",
                "sap_id": 10300150,
                "crm_id": 891,
                "feb_da": 0
              },
              {
                "sl_no": 21,
                "emp_name": "TUNNA KUMAR SINGH",
                "curr_status": "Active",
                "sap_id": 10300163,
                "crm_id": 903,
                "feb_da": 3180
              },
              {
                "sl_no": 22,
                "emp_name": "VIKASH KUMAR SINGH",
                "curr_status": "Active",
                "sap_id": 55200353,
                "crm_id": 980,
                "feb_da": 4500
              },
              {
                "sl_no": 27,
                "emp_name": "DINESH KUMAR ROY",
                "curr_status": "Active",
                "sap_id": 10300254,
                "crm_id": 1156,
                "feb_da": 1110
              },
              {
                "sl_no": 33,
                "emp_name": "OM PRAKASH KUMAR SHAH",
                "curr_status": "Active",
                "sap_id": 55200304,
                "crm_id": 1266,
                "feb_da": 2588
              },
              {
                "sl_no": 35,
                "emp_name": "ABHISHEK KUMAR",
                "curr_status": "Inactive",
                "sap_id": 10300329,
                "crm_id": 1371,
                "feb_da": 0
              },
              {
                "sl_no": 37,
                "emp_name": "PAWAN KUMAR",
                "curr_status": "Active",
                "sap_id": 55200137,
                "crm_id": 1468,
                "feb_da": 4850
              },
              {
                "sl_no": 43,
                "emp_name": "Kunal Anand",
                "curr_status": "Inactive",
                "sap_id": 55200499,
                "crm_id": 1862,
                "feb_da": 0
              },
              {
                "sl_no": 48,
                "emp_name": "Pushpam Kumar",
                "curr_status": "Active",
                "sap_id": 55200571,
                "crm_id": 2091,
                "feb_da": 885
              },
              {
                "sl_no": 49,
                "emp_name": "Ravindar Singh",
                "curr_status": "Active",
                "sap_id": 55200967,
                "crm_id": 2094,
                "feb_da": 2662
              },
              {
                "sl_no": 54,
                "emp_name": "Santosh Kumar Chaudhary",
                "curr_status": "Inactive",
                "sap_id": 55200419,
                "crm_id": 2135,
                "feb_da": 0
              },
              {
                "sl_no": 55,
                "emp_name": "Kundan Kumar (Vaishali)",
                "curr_status": "Active",
                "sap_id": 55200442,
                "crm_id": 2165,
                "feb_da": 0
              },
              {
                "sl_no": 57,
                "emp_name": "Chanchal Kumar",
                "curr_status": "Active",
                "sap_id": 55201167,
                "crm_id": 2183,
                "feb_da": 2902
              },
              {
                "sl_no": 66,
                "emp_name": "NAWNIHAL KUMAR SHUKLA",
                "curr_status": "Active",
                "sap_id": 55200506,
                "crm_id": 2290,
                "feb_da": 3512
              },
              {
                "sl_no": 68,
                "emp_name": "SAGAR SINHA",
                "curr_status": "Inactive",
                "sap_id": 55200507,
                "crm_id": 2298,
                "feb_da": 0
              },
              {
                "sl_no": 69,
                "emp_name": "MANISH RAJ",
                "curr_status": "Inactive",
                "sap_id": 55200522,
                "crm_id": 2315,
                "feb_da": 0
              },
              {
                "sl_no": 71,
                "emp_name": "MANISH KUMAR (KATIHAR)",
                "curr_status": "Active",
                "sap_id": 55200534,
                "crm_id": 2326,
                "feb_da": 2648
              },
              {
                "sl_no": 72,
                "emp_name": "HARSH RANJAN",
                "curr_status": "Inactive",
                "sap_id": 55200555,
                "crm_id": 2343,
                "feb_da": 0
              },
              {
                "sl_no": 76,
                "emp_name": "VISHAL KUMAR",
                "curr_status": "Inactive",
                "sap_id": 55200579,
                "crm_id": 2368,
                "feb_da": 0
              },
              {
                "sl_no": 81,
                "emp_name": "KUNDAN KUMAR (KISHANGANJ)",
                "curr_status": "Inactive",
                "sap_id": 55200609,
                "crm_id": 2403,
                "feb_da": 0
              },
              {
                "sl_no": 83,
                "emp_name": "SACHIN KUMAR (ARWAL)",
                "curr_status": "Active",
                "sap_id": 55200634,
                "crm_id": 2452,
                "feb_da": 0
              },
              {
                "sl_no": 89,
                "emp_name": "Sanjay Kumar",
                "curr_status": "Inactive",
                "sap_id": 55200653,
                "crm_id": 2486,
                "feb_da": 0
              },
              {
                "sl_no": 91,
                "emp_name": "Rajiv Misra",
                "curr_status": "Inactive",
                "sap_id": 55200663,
                "crm_id": 2498,
                "feb_da": 0
              },
              {
                "sl_no": 95,
                "emp_name": "Mukesh Kumar Jha",
                "curr_status": "Active",
                "sap_id": 55200675,
                "crm_id": 2517,
                "feb_da": 1550
              },
              {
                "sl_no": 98,
                "emp_name": "Mukund Ranjan Ojha",
                "curr_status": "Inactive",
                "sap_id": 55200681,
                "crm_id": 2522,
                "feb_da": 0
              },
              {
                "sl_no": 110,
                "emp_name": "AJIT KUMAR SINHA",
                "curr_status": "Inactive",
                "sap_id": 55200710,
                "crm_id": 2563,
                "feb_da": 0
              },
              {
                "sl_no": 124,
                "emp_name": "PANKAJ KUMAR",
                "curr_status": "Inactive",
                "sap_id": 55200746,
                "crm_id": 2630,
                "feb_da": 0
              },
              {
                "sl_no": 127,
                "emp_name": "SUDHAKAR UPADHAYA",
                "curr_status": "Inactive",
                "sap_id": 55200754,
                "crm_id": 2643,
                "feb_da": 0
              },
              {
                "sl_no": 131,
                "emp_name": "RAHUL KUMAR SHARMA",
                "curr_status": "Active",
                "sap_id": 55200767,
                "crm_id": 2651,
                "feb_da": 3120
              },
              {
                "sl_no": 143,
                "emp_name": "VIKESH KUMAR",
                "curr_status": "Inactive",
                "sap_id": 55200783,
                "crm_id": 2679,
                "feb_da": 0
              },
              {
                "sl_no": 153,
                "emp_name": "MD FAZLE IMAM",
                "curr_status": "Inactive",
                "sap_id": 55200809,
                "crm_id": 2714,
                "feb_da": 0
              },
              {
                "sl_no": 154,
                "emp_name": "OM PRAKASH",
                "curr_status": "Active",
                "sap_id": 55200814,
                "crm_id": 2715,
                "feb_da": 6100
              },
              {
                "sl_no": 162,
                "emp_name": "MANISH KUMAR",
                "curr_status": "Inactive",
                "sap_id": 55200828,
                "crm_id": 2754,
                "feb_da": 0
              },
              {
                "sl_no": 163,
                "emp_name": "Piyush Kumar",
                "curr_status": "Active",
                "sap_id": 55200825,
                "crm_id": 2755,
                "feb_da": 3248
              },
              {
                "sl_no": 168,
                "emp_name": "Sumit singh",
                "curr_status": "Inactive",
                "sap_id": 55200843,
                "crm_id": 2778,
                "feb_da": 0
              },
              {
                "sl_no": 171,
                "emp_name": "Rajesh Kumar Sinha",
                "curr_status": "Inactive",
                "sap_id": 55200849,
                "crm_id": 2794,
                "feb_da": 0
              },
              {
                "sl_no": 172,
                "emp_name": "Gautam Kumar",
                "curr_status": "Inactive",
                "sap_id": 55200850,
                "crm_id": 2795,
                "feb_da": 0
              },
              {
                "sl_no": 179,
                "emp_name": "Amrendra Kumar Singh",
                "curr_status": "Inactive",
                "sap_id": 55200845,
                "crm_id": 2816,
                "feb_da": 0
              },
              {
                "sl_no": 184,
                "emp_name": "Manoj Kumar Sinha",
                "curr_status": "Inactive",
                "sap_id": 55200869,
                "crm_id": 2823,
                "feb_da": 0
              },
              {
                "sl_no": 185,
                "emp_name": "Sharat Kiran",
                "curr_status": "Active",
                "sap_id": 55200880,
                "crm_id": 2826,
                "feb_da": 9750
              },
              {
                "sl_no": 186,
                "emp_name": "Vivek Kumar",
                "curr_status": "Active",
                "sap_id": 55200879,
                "crm_id": 2827,
                "feb_da": 1170
              },
              {
                "sl_no": 187,
                "emp_name": "Sanjeev Tiwari",
                "curr_status": "Inactive",
                "sap_id": 55200876,
                "crm_id": 2828,
                "feb_da": 0
              },
              {
                "sl_no": 188,
                "emp_name": "Vikash Kumar",
                "curr_status": "Inactive",
                "sap_id": 55200875,
                "crm_id": 2829,
                "feb_da": 0
              },
              {
                "sl_no": 189,
                "emp_name": "Rakesh Kumar Sinha",
                "curr_status": "Active",
                "sap_id": 55200885,
                "crm_id": 2834,
                "feb_da": 2225
              },
              {
                "sl_no": 190,
                "emp_name": "Ajay Kumar Mishra",
                "curr_status": "Inactive",
                "sap_id": 55200886,
                "crm_id": 2835,
                "feb_da": 0
              },
              {
                "sl_no": 191,
                "emp_name": "Deepak Kumar",
                "curr_status": "Inactive",
                "sap_id": 55200893,
                "crm_id": 2843,
                "feb_da": 0
              },
              {
                "sl_no": 199,
                "emp_name": "Deepak Yadav",
                "curr_status": "Active",
                "sap_id": 55200910,
                "crm_id": 2858,
                "feb_da": 4925
              },
              {
                "sl_no": 212,
                "emp_name": "Haresh Kumar",
                "curr_status": "Active",
                "sap_id": 55200945,
                "crm_id": 2897,
                "feb_da": 1672
              },
              {
                "sl_no": 216,
                "emp_name": "Ashish Kumar",
                "curr_status": "Inactive",
                "sap_id": 55200956,
                "crm_id": 2908,
                "feb_da": 0
              },
              {
                "sl_no": 230,
                "emp_name": "Naquee Mursal",
                "curr_status": "Active",
                "sap_id": 55200997,
                "crm_id": 2948,
                "feb_da": 3442
              },
              {
                "sl_no": 231,
                "emp_name": "Pawan Kumar Poddar",
                "curr_status": "Active",
                "sap_id": 55200987,
                "crm_id": 2950,
                "feb_da": 0
              },
              {
                "sl_no": 236,
                "emp_name": "Satyam",
                "curr_status": "Active",
                "sap_id": 55200977,
                "crm_id": 2980,
                "feb_da": 3300
              },
              {
                "sl_no": 252,
                "emp_name": "Md. Aftab Ahmad",
                "curr_status": "Inactive",
                "sap_id": 55201055,
                "crm_id": 3027,
                "feb_da": 0
              },
              {
                "sl_no": 267,
                "emp_name": "Jitendra Kumar",
                "curr_status": "Active",
                "sap_id": 55201099,
                "crm_id": 3080,
                "feb_da": 3375
              },
              {
                "sl_no": 281,
                "emp_name": "Deepak_Kumar_Singh",
                "curr_status": "Active",
                "sap_id": 55201141,
                "crm_id": 3141,
                "feb_da": 1545
              },
              {
                "sl_no": 292,
                "emp_name": "Jai Shankar Kumar",
                "curr_status": "Active",
                "sap_id": 55201170,
                "crm_id": 3181,
                "feb_da": 0
              },
              {
                "sl_no": 301,
                "emp_name": "Santosh Kumar Saw",
                "curr_status": "Active",
                "sap_id": 55201181,
                "crm_id": 3212,
                "feb_da": 2468
              },
              {
                "sl_no": 303,
                "emp_name": "Raushan Kumar",
                "curr_status": "Inactive",
                "sap_id": 55201200,
                "crm_id": 3219,
                "feb_da": 0
              },
              {
                "sl_no": 308,
                "emp_name": "Kunal Anand",
                "curr_status": "Active",
                "sap_id": 55201215,
                "crm_id": 3232,
                "feb_da": 3800
              },
              {
                "sl_no": 312,
                "emp_name": "Sanjeev Kumar Verma",
                "curr_status": "Active",
                "sap_id": 55201227,
                "crm_id": 3248,
                "feb_da": 8175
              },
              {
                "sl_no": 315,
                "emp_name": "Akash",
                "curr_status": "Active",
                "sap_id": 55201242,
                "crm_id": 3268,
                "feb_da": 1050
              },
              {
                "sl_no": 326,
                "emp_name": "Ashwini Kumar Pandey",
                "curr_status": "Active",
                "sap_id": 55201283,
                "crm_id": 3320,
                "feb_da": 2525
              },
              {
                "sl_no": 327,
                "emp_name": "Karan Kumar",
                "curr_status": "Active",
                "sap_id": 55201284,
                "crm_id": 3321,
                "feb_da": 1950
              },
              {
                "sl_no": 328,
                "emp_name": "Rajiv Kumar Jha",
                "curr_status": "Active",
                "sap_id": 55201282,
                "crm_id": 3322,
                "feb_da": 7400
              },
              {
                "sl_no": 334,
                "emp_name": "Sujeet Kumar Chaudhary",
                "curr_status": "Active",
                "sap_id": 55201303,
                "crm_id": 3348,
                "feb_da": 150
              },
              {
                "sl_no": 344,
                "emp_name": "Mohammad Mistarul",
                "curr_status": "Active",
                "sap_id": 55201290,
                "crm_id": 3390,
                "feb_da": 0
              }
            ];
            
            for(let i=0; i<feb_da.length; i++){
            
            
                let sec_emps = [903,1156,1266,1466,1585,1890,1920,2091,2094,2109,2183,2184,2319,2326,2378,2596,2651,2755,2759,2827,2866,2897,2915,2926,2927,2929,2945,2946,2948,2949,2950,2980,2998,3019,3078,3082,3141,3155,3197,3212,3216,3218,3219,3226,3268,3283];
            
                  for(let j=0; j<sec_emps.length; j++){

                    if(feb_da[i]["crm_id"]==sec_emps[j]){

                      target_emps.push(sec_emps[j]);
                    }

                  }
              }

            
      
            res.json(target_emps);
      
          } catch (e) {
            res.status(500).json({ error: e.message });
          }
        }
      );

    

module.exports = authRouter;