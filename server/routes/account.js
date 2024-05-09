const express = require('express');
const accountRouter = express.Router();
const auth = require('../middleware/auth');
const AccountMaster = require('../models/account_master');
const Employee = require('../models/employee');
const State = require('../models/state_tbl');
const Cluster = require('../models/clusters');
const District = require('../models/districts');
const Block = require('../models/blocks');
const EngineerType = require('../models/engineer_type');
const AccountConversionInitial = require('../models/account_conversion_initial');
const authRouter = require('./auth');
const sapMaster = require('../models/sap_master');

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

            function getMonth(date) {
                var newDate =  new Date(date);  
                return new Date(
                    newDate.getFullYear(),
                    newDate.getMonth(),
                    1
                );
            }

            let newAccountConvInitial = await AccountConversionInitial({
                account_id : account_id,
                post_user : emp_id,
                month: getMonth(Date.now())
            });

            newAccountConvInitial = await newAccountConvInitial.save();
            
            res.json(account);


    }catch (e) {
        res.status(500).json({ error: e.message });
      }

});


accountRouter.post('/v1/api/create-distributor', auth, async(req,res) => {

    try{

        const {account_name, password, contact_person_name,
               mobno, zone_id, state_id, cluster_id, all_districts, block_id,
               street, area, police_station, city, pincode, work_for, account_type_id,
               potential, nod, working_as_dealer, main_district
            } = req.body;

        const emp_id = req.user;
        let AGM_RSM = '';
        let ASM = '';
        let SO = '';
        let ME = '';

        let fullAccountMaster = await AccountMaster.find();
        let account_id = fullAccountMaster.length+1;

        

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
            p_account_id : account_id,
            password,
            contact_person_name,
            mobno,
            zone_id,
            state_id,
            cluster_id,
            main_district: main_district,
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
            working_as_dealer,
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

accountRouter.post('/v1/api/create-engineer', auth, async(req,res) => {

    try{

        const {account_name, p_account_id, password, contact_person_name,
               mobno, zone_id, state_id, cluster_id, district_id, block_id,
               street, area, police_station, city, pincode, work_for, account_type_id,
               engineer_type, card_no
         } = req.body;

        const emp_id = req.user;
        let AGM_RSM = '';
        let ASM = '';
        let SO = '';
        let ME = '';
        let all_districts = [];

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
            p_account_id : p_account_id,
            password,
            contact_person_name,
            mobno,
            card_no,
            engineer_type,
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
            created_by: emp_id
        });
    
            account = await account.save();
            
            res.json(account);


    }catch (e) {
        res.status(500).json({ error: e.message });
      }

});

accountRouter.post('/v1/api/account-location-update', auth, async (req,res) => {

    try{

        const { account_obj_id, new_lat, new_lon, location_image, address_type} = req.body;

        console.log(req.body);

        const emp_id = req.user;
        let account = await AccountMaster.findById(account_obj_id);

        //Get tagged emp
        async function getTaggedEmp(get_emp_id){

            if(get_emp_id!=''){

            let employee = await Employee.find({
                _id: get_emp_id,
                active: 1
            });

            return employee ? employee[0].emp_name : 'NA';

            } else{

                return 'NA';
            }
        }

        //Fetch district name array
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

        //Get single district's name
        async function getSingleDistrictName(get_district_id){

            console.log('hello');

            let district = await District.find({
                district_id: get_district_id
            });

            console.log(district);


            return district.length>0 ? district[0].district_title : 'NA';
        }

        //Fetch state name
        async function getStateName(get_state_id){

            let state = await State.find({
                state_id: get_state_id
            });

            return state ? state[0].state_name : 'NA';
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

        async function getCreationDate(creation_date){
            var today = new Date();

            // console.log('c :'+creation_date.getDate() + '    today: '+ today.getDate());
            var diffDays = today.getDate() - creation_date.getDate(); 

            return diffDays ? diffDays : 0
        }

        async function getDistributorName(get_p_dealer_id){

            let account = await AccountMaster.find({
                account_id: get_p_dealer_id
            });

            return account.length>0 ? account[0].account_name : 'NA';
        }

        async function getEngineerType(get_engineer_type_id){

            let engineer_type = await EngineerType.find({
                engineer_type_id: get_engineer_type_id
            });

            return engineer_type.length>0 ? engineer_type[0].engineer_title : 'NA';
        }

        async function getInfluencerParentDealer(get_parent_dealer_id){

            if(get_parent_dealer_id>0){
            let parent_dealer = await AccountMaster.find({
                account_id: get_parent_dealer_id
            });

            return parent_dealer.length>0 ? parent_dealer[0].account_name : 'NA';
        } else{
            return 'NA';
        }
        }

        if(address_type==1){
        
            if(account.latitude=='0.0' && account.longitude=='0.0'){

                account.latitude = new_lat;
                account.longitude = new_lon;
                account.home_location_img = location_image;

                account = await account.save();
                const updatedRes = {
                    ...account.toObject(),
                    'state_name': await getStateName(account.state_id),
                    'cluster_name': await getClusterName(account.cluster_id),
                    'district_names': await getDistrictNames(account.all_districts),
                    'main_district_name': await getSingleDistrictName(account.main_district),
                    'block_name': await getBlockName(account.block_id),
                    'last_billing_quantity': 0,
                    'last_billing_date': null,
                    'cy_primary_sale': 0,
                    'ly_primary_sale': 0,
                    'cy_sec_sale': 0,
                    'total_outstanding': 0,
                    'below_thirty': 0,
                    'thirtyOne_to_fourtyFive': 0,
                    'fourtySix_to_sixty': 0,
                    'sixtyOne_to_ninety': 0,
                    'ninetyOne_to_above': 0,
                    'security_deposite': 1000000,
                    'created_before': await getCreationDate(account.created_on),
                    'tagged_rsm': await getTaggedEmp(account.AGM_RSM),
                    'tagged_asm': await getTaggedEmp(account.ASM),
                    'tagged_so': await getTaggedEmp(account.SO),
                    'tagged_me': await getTaggedEmp(account.ME),
                    'created_by_name': await getTaggedEmp(account.created_by)
                }
    
                res.json(updatedRes);            
          } else {
            
                console.log('Already Plotted');
                res.json('Already Plotted');
            }
    } else if(address_type==2){

        if(account.office_latitude=='0.0' && account.office_longitude=='0.0'){

            account.office_latitude = new_lat;
            account.office_longitude = new_lon;
            account.office_location_img = location_image;

            account = await account.save();
            const updatedRes = {
                ...account.toObject(),
                'state_name': await getStateName(account.state_id),
                'cluster_name': await getClusterName(account.cluster_id),
                'district_names': await getDistrictNames(account.all_districts),
                'main_district_name': await getSingleDistrictName(account.main_district),
                'block_name': await getBlockName(account.block_id),
                'last_billing_quantity': 0,
                'last_billing_date': null,
                'cy_primary_sale': 0,
                'ly_primary_sale': 0,
                'cy_sec_sale': 0,
                'total_outstanding': 0,
                'below_thirty': 0,
                'thirtyOne_to_fourtyFive': 0,
                'fourtySix_to_sixty': 0,
                'sixtyOne_to_ninety': 0,
                'ninetyOne_to_above': 0,
                'security_deposite': 1000000,
                'created_before': await getCreationDate(account.created_on),
                'tagged_rsm': await getTaggedEmp(account.AGM_RSM),
                'tagged_asm': await getTaggedEmp(account.ASM),
                'tagged_so': await getTaggedEmp(account.SO),
                'tagged_me': await getTaggedEmp(account.ME),
                'created_by_name': await getTaggedEmp(account.created_by)
            }

            res.json(updatedRes);
        
      } else {
        
            console.log('Already Plotted');
            res.json('Already Plotted');
        }
    } else {

        res.status(404).json({error: '404 Not Found'});
    }

    }catch (e) {
        res.status(500).json({ error: e.message });
    }
});

//Set SAP ID

accountRouter.post('/v1/api/set-sap-id', auth, async (req,res) => {

    try{

        const { sapid, dealer_id } = req.body;

        const emp_id = req.user;

        let account = await AccountMaster.find({
            account_id: dealer_id
        });

        let sap_id_exists = await sapMaster.find({
            sapid: sapid
        });

        if(sap_id_exists.length>0){
            res.status(403).json({msg: 'SAP Id already exists'});
        } else {
            // console.log(`length: ${sap_id_exists.length}`);

            let dealer_id_exists = await sapMaster.find({
                dealer_id: dealer_id
            });

            if(dealer_id_exists.length>0){

                for(let i=0; i<dealer_id_exists.length; i++){
                    dealer_id_exists[i].is_active = false;
                    await dealer_id_exists[i].save();
                }
            }

            let new_sap_trn = sapMaster({
                sapid,
                dealer_id: account[0].account_id,
                post_user: req.user
            });

            account[0].sapid = sapid;

            new_sap_trn = await new_sap_trn.save();
            await account[0].save();

            res.json(new_sap_trn);


        }


    }catch (e) {
        res.status(500).json({ error: e.message });
    }

});


authRouter.post('/v1/api/add-dispatch-data', auth, async (req,res) => {
    try{


        res.json(req.body);

    } catch(e){
        res.status(500).json({ error: e.message });
    }
});


module.exports = accountRouter;