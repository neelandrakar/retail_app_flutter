const express = require('express');
const employeeRouter = express.Router();
const Employee = require('../models/employee');
const Menu = require('../models/menu');
const State = require('../models/state_tbl');
const Cluster = require('../models/clusters');
const District = require('../models/districts');
const Block = require('../models/blocks');
const auth = require('../middleware/auth');
const MenuAccess = require('../models/menu_access');
const AccountMaster = require('../models/account_master');
const EngineerType = require('../models/engineer_type');
const Zone = require('../models/zone');
const QuestionMaster = require('../models/question_master');
const JsonLog = require('../models/json_log');

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

employeeRouter.post('/v1/api/add-engineer-type', auth, async(req,res) => {

    try{

        const {engineer_title} = req.body;

        let newType = EngineerType({
            engineer_title,
            engineer_type_id: 1,
            is_active: 1
        });

        newType = await newType.save();
        
        res.json(newType);

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

employeeRouter.post('/v1/api/add-state', auth, async(req,res) => {

    try{

        const {state_id, zone_id, state_name, state_color, state_group, working_status, sorting_order, state_language, short_name, is_for_paint} = req.body;

        let newState = State({
            state_id,
            zone_id,
            state_name,
            state_color,
            state_group,
            working_status,
            sorting_order,
            state_language,
            is_for_paint,
            short_name
        });

        newState = await newState.save();
        
        res.json(newState);

    }catch (e) {
        res.status(500).json({ error: e.message });
      }

});

employeeRouter.post('/v1/api/add-zone', auth, async(req,res) => {

    try{

        const {zone_name} = req.body;

        let fullZone = await Zone.find();

        let zone_id = fullZone.length+1;


        let newZone = Zone({
            zone_id,
            zone_name
        });

        newZone = await newZone.save();
        
        res.json(newZone);

    }catch (e) {
        res.status(500).json({ error: e.message });
      }

});

employeeRouter.post('/v1/api/add-cluster', auth, async(req,res) => {

    try{

        const {cluster_id, cluster_name, zone_id, state_id, cluster_color, d_status, priority} = req.body;

        let newCluster = Cluster({
            cluster_id,
            cluster_name,
            zone_id,
            state_id,
            cluster_color,
            d_status,
            priority
        });

        newCluster = await newCluster.save();
        
        res.json(newCluster);

    }catch (e) {
        res.status(500).json({ error: e.message });
      }

});

employeeRouter.post('/v1/api/add-district', auth, async(req,res) => {

    try{

        const {district_id, district_title, zone_id, state_id, district_color, d_status, cluster_id} = req.body;

        let newDistrict = District({
            district_id,
            district_title,
            zone_id,
            state_id,
            district_color,
            d_status,
            cluster_id
        });

        newDistrict = await newDistrict.save();
        
        res.json(newDistrict);

    }catch (e) {
        res.status(500).json({ error: e.message });
      }

});

employeeRouter.post('/v1/api/add-block', auth, async(req,res) => {

    try{

        const {block_id, block_name, zone_id,district_id, state_id, d_status, cluster_id} = req.body;

        let newBlock = Block({
            block_id,
            block_name,
            zone_id,
            state_id,
            d_status,
            cluster_id,
            district_id
        });

        newBlock = await newBlock.save();
        
        res.json(newBlock);

    }catch (e) {
        res.status(500).json({ error: e.message });
      }

});

employeeRouter.post('/v1/api/fetch-tagged-accounts', auth, async(req,res) => {

    try{

        const { account_type_id } = req.body;

        const emp_id = req.user;
        let employee = await Employee.findById(emp_id);
        let emp_districts = employee.district_id;

        let taggedAccounts = await AccountMaster.find({
            $or: [
                {AGM_RSM: emp_id},
                {ASM: emp_id},
                {SO: emp_id},
                {ME: emp_id},
            ],
            all_districts : { $in: emp_districts },
            account_type_id: account_type_id,
            d_status: 0,
            account_status: { $nin: ['Rejected']}
        });

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

        if(account_type_id==1 || account_type_id==7){

        const dealerWithData = await Promise.all(taggedAccounts.map(async oneAccount => ({
            ...oneAccount.toObject(),
            'distributor_name': await getDistributorName(oneAccount.p_account_id),
            'state_name': await getStateName(oneAccount.state_id),
            'cluster_name': await getClusterName(oneAccount.cluster_id),
            'district_names': await getDistrictNames(oneAccount.all_districts),
            'main_district_name': await getSingleDistrictName(oneAccount.main_district),
            'block_name': await getBlockName(oneAccount.block_id),
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
            'created_before': await getCreationDate(oneAccount.created_on),
            'tagged_rsm': await getTaggedEmp(oneAccount.AGM_RSM),
            'tagged_asm': await getTaggedEmp(oneAccount.ASM),
            'tagged_so': await getTaggedEmp(oneAccount.SO),
            'tagged_me': await getTaggedEmp(oneAccount.ME),
            'created_by_name': await getTaggedEmp(oneAccount.created_by)

        })));
        
        
        res.json(dealerWithData);

    } else if(account_type_id==6){

            const engineerWithData = await Promise.all(taggedAccounts.map(async oneAccount => ({
                ...oneAccount.toObject(),
                'parent_dealer': await getInfluencerParentDealer(oneAccount.p_account_id),
                'engineer_type_name': await getEngineerType(oneAccount.engineer_type),
                'state_name': await getStateName(oneAccount.state_id),
                'cluster_name': await getClusterName(oneAccount.cluster_id),
                'district_names': await getDistrictNames(oneAccount.all_districts),
                'block_name': await getBlockName(oneAccount.block_id),
                'kyc_approval': 0,
                'created_before': await getCreationDate(oneAccount.created_on),
                'tagged_rsm': await getTaggedEmp(oneAccount.AGM_RSM),
                'tagged_asm': await getTaggedEmp(oneAccount.ASM),
                'tagged_so': await getTaggedEmp(oneAccount.SO),
                'tagged_me': await getTaggedEmp(oneAccount.ME),
                'created_by_name': await getTaggedEmp(oneAccount.created_by)
    
            })));
            
            
            res.json(engineerWithData);    
        
    }

    }catch (e) {
        res.status(500).json({ error: e.message });
      }

});

employeeRouter.get('/v1/api/update-emp-data', auth, async(req,res) => {

    try{

        const emp_id = req.user;

        let emp = await Employee.findById(emp_id);

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

        const updatedRes = {
            ...emp.toObject(),
            'state_names': await getStateNames(emp.state_id),
            'district_names': await getDistrictNames(emp.district_id),
            'zone_name': await getZoneData(emp.state_id, 1),
            'zone_id': await getZoneData(emp.state_id, 2)

        }

        
        res.json(updatedRes);

    }catch (e) {
        res.status(500).json({ error: e.message });
      }

});

employeeRouter.post('/v1/api/fetch-blocks', auth, async(req,res) => {

    try{

        const {district_id} = req.body;

        console.log(req.body);

        let blockList = await Block.find({
            district_id: district_id
        });
        
        res.json(blockList);

    }catch (e) {
        res.status(500).json({ error: e.message });
      }

});

employeeRouter.post('/v1/api/fetch-districts', auth, async(req,res) => {

    try{

        const {district_id} = req.body;

        // console.log(req.body);

        let blockList = await Block.find({
            district_id: district_id
        });
        
        res.json(blockList);

    }catch (e) {
        res.status(500).json({ error: e.message });
      }

});

employeeRouter.post('/v1/api/add-visit-question', auth, async(req,res) => {

    try{

        const {question_parent_id, question_parent_name, question, account_type_id, account_status, is_mandatory} = req.body;

        let question_master = await QuestionMaster.find();
        let question_id = question_master.length+1;

        let new_question = QuestionMaster({
            question_id,
            question_parent_id,
            question_parent_name,
            question,
            account_type_id,
            account_status,
            is_mandatory
        });

        new_question = await new_question.save();
    
        res.json(new_question);

    }catch (e) {
        res.status(500).json({ error: e.message });
      }

});

employeeRouter.post('/v1/api/fetch-visit-questions', auth, async(req,res) => {

    try{

        const { account_obj_id } = req.body;
        const emp_id = req.user;

        let account = await AccountMaster.findById(account_obj_id);
        let account_type_id = account.account_type_id;
        let account_status = account.account_status;
        let account_status_array = [account_status,'All']
        let show_business_survey = false;
        let show_dealer_counter_potential = false;
        let show_sub_dealer_count = false;
        let show_gift_hand_over = false;
        let purpose_of_visit = ['Gift Hand Over', 'Visit'];

        if(account.account_type_id==1 || account.account_type_id==7){
            show_business_survey = true;
            show_dealer_counter_potential = true;
            show_sub_dealer_count = true;
            show_gift_hand_over = true;
        }

        let visit_questions_discussions = await QuestionMaster.find({

            account_type_id: account_type_id,
            account_status: {$in: account_status_array},
            question_parent_id: 1,
            d_status: 0
        });

        let visit_questions_action_plan = await QuestionMaster.find({
            account_type_id: account_type_id,
            account_status: {$in: account_status_array},
            question_parent_id: 2,
            d_status: 0
        });

        let visit_questions_issues = await QuestionMaster.find({
            account_type_id: account_type_id,
            account_status: {$in: account_status_array},
            question_parent_id: 3,
            d_status: 0
        });

        const finalRes = {
            'show_business_survey': show_business_survey,
            'show_dealer_counter_potential': show_dealer_counter_potential,
            'show_sub_dealer_count': show_sub_dealer_count,
            'show_gift_hand_over': show_gift_hand_over,
            'purpose_of_visit': purpose_of_visit,
            'discussions': visit_questions_discussions,
            'action_plan': visit_questions_action_plan,
            'issues': visit_questions_issues
        };

        let newJsonLog = new JsonLog({
            post_user: emp_id,
            api_name: '/v1/api/fetch-visit-questions',
            request: JSON.stringify(req.body),
            response: JSON.stringify(finalRes)
          });
          
          newJsonLog = await newJsonLog.save();
        
        res.status(200).json(finalRes);

    }catch (e) {
        res.status(500).json({ error: e.message });
      }

});



module.exports = employeeRouter;