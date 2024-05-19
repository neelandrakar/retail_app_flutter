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
const VisitHistory = require('../models/visit_history');
const AccountConversion = require('../models/account_conversion');
const AccountConversionInitial = require('../models/account_conversion_initial');
const AccountTarget = require('../models/account_target');
const DealerLiftingMaster = require('../models/dealer_lifting_master');
const Calender = require('../models/calender');
// import * as myFunctions from '../common_functions'

employeeRouter.post('/v1/api/create-menu', auth, async(req,res) => {

    try{

        const {menu_title, menu_subtitle, menu_image, menu_type, menu_color,menu_division, order, nav_path} = req.body;

        let newMenu = Menu({
            menu_title,
            menu_subtitle,
            menu_image,
            menu_type,
            menu_color,
            menu_division,
            order,
            nav_path
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
        });

        console.log(myMenuAccess[0].accessable_menus.length);
        console.log(allMenus.length);


        for(let i=0; i<allMenus.length; i++){

            for(let j=0; j<myMenuAccess[0].accessable_menus.length; j++){

                if(allMenus[i]._id==myMenuAccess[0].accessable_menus[j]){

                    myMenus.push(allMenus[i]);
                    break;
                }
            }
        }

        console.log(myMenus.length);

        
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
        let follow_up_persons = [emp_id]

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
            'issues': visit_questions_issues,
            'follow_up_persons': follow_up_persons
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


employeeRouter.post('/v1/api/submit-visit-remarks', auth, async(req,res) => {

    try{
        const { account_obj_id, check_in_time, check_out_time, visit_call, selfie_image,
             purpose_of_visit, gift_handed_over, submitted_counter_potential, submitted_sub_dealer_count,
             submitted_business_survey, discussion_details, action_plan_details, issue_details,
             follow_up_person, rating 
            } = req.body;
        const emp_id = req.user;
        let initial_status = 'NA';
        let new_status = 'NA';

        let visited_account = await AccountMaster.findById(account_obj_id);
        let employee = await Employee.findById(emp_id);
        initial_status = visited_account.account_status;

        function removeTime(date) {
            var newDate =  new Date(date);  
            return new Date(
                newDate.getFullYear(),
                newDate.getMonth(),
                newDate.getDate()
            );
        }
        
        let visit_history = await VisitHistory.find();
        let dh_id = visit_history.length+1;        

        let newVisit = new VisitHistory({
            dh_id: dh_id,
            account_id: visited_account.account_id,
            account_status: visited_account.account_status,
            emp_id: emp_id,
            date: removeTime(check_in_time),
            check_in_time: check_in_time,
            check_out_time: check_out_time,
            visit_call: visit_call,
            selfie_image: selfie_image,
            purpose_of_visit: purpose_of_visit,
            gift_handed_over: gift_handed_over,
            submitted_business_survey: submitted_business_survey,
            submitted_counter_potential: submitted_counter_potential,
            submitted_sub_dealer_count: submitted_sub_dealer_count,
            discussion_details: discussion_details,
            action_plan_details: action_plan_details,
            issue_details: issue_details,
            follow_up_person: follow_up_person,
            rating: rating
        });

        if(visited_account.account_status=='Survey'){
            
            visited_account.account_status='Prospective';
            visited_account = await visited_account.save();
            
            new_status = visited_account.account_status;

            let new_acc_conv = await AccountConversion({
                account_id: visited_account.account_id,
                from: initial_status,
                to: new_status,
                post_user: emp_id
            });

            new_acc_conv = await new_acc_conv.save();
        }

        let newJsonLog = new JsonLog({
            post_user: emp_id,
            api_name: '/v1/api/submit-visit-remarks',
            request: JSON.stringify(req.body),
            response: JSON.stringify(newVisit)
          });
          
          newJsonLog = await newJsonLog.save();

          newVisit = await newVisit.save();
  

        res.status(200).json(newVisit);

    }catch (e) {
        res.status(500).json({ error: e.message });
      }

});

employeeRouter.post('/v1/api/auto-inital-status-entry', auth, async(req,res) => {

    try{

        const emp_id = req.user;
        let taggedAccounts = [];

        taggedAccounts = await AccountMaster.find({
            d_status: 0,
        });

        function getMonth(date) {
            var newDate =  new Date(date);  
            return new Date(
                newDate.getFullYear(),
                newDate.getMonth(),
                1
            );
        }

        let curr_month = getMonth(Date.now());

        let account_conversion_initial = await AccountConversionInitial.find({
            month: curr_month,
        });

        for(let i=0; i<taggedAccounts.length; i++){
            let insertData = true;
        
            for(let j=0; j<account_conversion_initial.length; j++){

                if(taggedAccounts[i].account_id == account_conversion_initial[j].account_id){
                    insertData = false;
                }
            }

            if(insertData){
            let newAccountConvInitial = await AccountConversionInitial({
                account_id : taggedAccounts[i].account_id,
                post_user : req.user,
                month: curr_month,
                account_status: taggedAccounts[i].account_status
            });
                newAccountConvInitial = await newAccountConvInitial.save();
        }
    }
       
        res.json(account_conversion_initial);

    }catch (e) {
        res.status(500).json({ error: e.message });
      }

});

employeeRouter.post('/v1/api/set-dealer-target', auth, async(req,res) => {

    try{

        const { account_id, primary_target, secondary_target } = req.body;

        const emp_id = req.user;
        let primary_target_taken = false;
        let secondary_target_taken = false;
        let new_target;

        if(primary_target>0){
            primary_target_taken = true;
        }
        if(secondary_target>0){
            secondary_target_taken = true;
        }


        function getMonth(date) {
            var newDate =  new Date(date);  
            return new Date(
                newDate.getFullYear(),
                newDate.getMonth(),
                1
            );
        }
        let curr_month = getMonth(Date.now());

        let dealer = await AccountMaster.find({
            account_id: account_id
        });

        let target_tbl = await AccountTarget.find({
            month: curr_month
        });

        if(target_tbl.length>0){

        } else {
                new_target = AccountTarget({
                account_id : account_id,
                month: curr_month,
                primary_target: primary_target,
                primary_target_taken: primary_target_taken,
                secondary_target: secondary_target,
                secondary_target_taken: secondary_target_taken,
                post_user: emp_id,
                updated_on: Date.now()
            });

            new_target = await new_target.save();
        }
        
        res.json(new_target);

    }catch (e) {
        res.status(500).json({ error: e.message });
      }

});

employeeRouter.post('/v1/api/get-target-vs-achievement', auth, async(req,res) => {

    try{

        const { account_type_id } = req.body;

        const emp_id = req.user;

        let employee = await Employee.findById(emp_id);
        let emp_districts = employee.district_id;
        let emp_profile = employee.profile_id;
        let taggedAccounts = [];
        let taggedDLPPT = [];
        let target_data = [];
        let secondary_target_percentage = 80;  //Secondary target % is fixed to be 80% of Primary Target
        let active_dealer_count = 0;
        let inactive_dealer_count = 0;
        let prospective_dealer_count = 0;
        let min_target_for_active = 0;
        let min_target_for_inactive = 0;
        let min_target_for_prospective = 0;

        if(emp_profile==3){
            min_target_for_active = 10, //Min treshhold for active accounts
            min_target_for_inactive = 5; //Min treshhold for inactive accounts
            min_target_for_prospective = 5; //Min treshhold for prospective accounts
        }



        taggedAccounts = await AccountMaster.find({
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

        if(account_type_id==1){

                taggedDLPPT = await AccountMaster.find({
                $or: [
                    {AGM_RSM: emp_id},
                    {ASM: emp_id},
                    {SO: emp_id},
                    {ME: emp_id},
                ],
                all_districts : { $in: emp_districts },
                account_type_id: 7 ,
                working_as_dealer: 1,
                d_status: 0,
                account_status: { $nin: ['Rejected']}
            });
        }


        //Merging both dealer & distributor working as dealer data
        taggedAccounts = taggedAccounts.concat(taggedDLPPT);

        for(let i=0;i < taggedAccounts.length; i++){
            if(taggedAccounts[i].account_status=='Active SSIL'){
                active_dealer_count++;
            } else if(taggedAccounts[i].account_status=='Inactive'){
                inactive_dealer_count++;
            } else if(taggedAccounts[i].account_status=='Prospective' || taggedAccounts[i].account_status=='Survey'){
                prospective_dealer_count++;
            }
        }

        if(min_target_for_active>active_dealer_count){
            min_target_for_active = active_dealer_count;

        } 
        if(min_target_for_inactive>inactive_dealer_count){
            min_target_for_inactive = inactive_dealer_count;
            
        }
        if(min_target_for_prospective>prospective_dealer_count) {
            min_target_for_prospective = prospective_dealer_count;
        }



        function getMonth(date) {
            var newDate =  new Date(date);  
            return new Date(
                newDate.getFullYear(),
                newDate.getMonth(),
                1
            );
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

        for(let i=0; i<taggedAccounts.length; i++){

            let initial_status = await AccountConversionInitial.find({
                account_id: taggedAccounts[i].account_id,
                month: getMonth(Date.now())
            });

            let dealer_target = await AccountTarget.find({
                account_id: taggedAccounts[i].account_id,
                month: getMonth(Date.now())
            });

            if(dealer_target.length>0){

            if(dealer_target[0].primary_target_taken==true){

                target_data.push({
                    'id': dealer_target[0]._id,
                    'account_id': taggedAccounts[i].account_id,
                    'dealer_name': taggedAccounts[i].account_name,
                    'account_status': taggedAccounts[i].account_status,
                    'initial_status': initial_status.length>0 ? initial_status[0].account_status : 'NA',
                    'primary_target': dealer_target[0].primary_target,
                    'cm_achievement': 20,
                    'lm_achievement': 40,
                    'district_names': await getDistrictNames(taggedAccounts[i].all_districts),
                    'district_ids': taggedAccounts[i].all_districts
                });
            }
            }
        }

        const finalRes = {
            'secondary_target_percentage': secondary_target_percentage,
            'target_data': target_data,
            'min_target_for_active': min_target_for_active,
            'min_target_for_inactive': min_target_for_inactive,
            'min_target_for_prospective': min_target_for_prospective
        }

        
        res.json(finalRes);

    }catch (e) {
        res.status(500).json({ error: e.message });
      }

});


//Get employee's eligible slab

employeeRouter.post('/v1/api/get-emp-slab', auth, async(req,res) =>{

    const { slab_type } = req.body;

    try{
        const emp_id = req.user;

        const emp = await Employee.findById(emp_id);
        const emp_profile = emp.profile_id;
        const myDate = new Date();
        let start_date, end_date;
        let total_sale = 0;
        const currentDate = new Date();

        function getPoints(profile_id, lifting_qty){

            let emp_points = 0;

            if(profile_id==2){
                emp_points = 200 * lifting_qty;
            }
            else if(profile_id==3){
                emp_points = 150 * lifting_qty;
            }
            return emp_points;
        }

        if(currentDate.getMonth()>=3){
            start_date = new Date(currentDate.getFullYear()-1, 3, 1, 0, 0, 0);
            end_date = new Date(currentDate.getFullYear(), 2, 31, 23, 59, 59);
        } else {
            start_date = new Date(currentDate.getFullYear(), 3, 1, 0, 0, 0);
            end_date = new Date(currentDate.getFullYear()+1, 2, 31, 23, 59, 59);
        }
        
        // const calendar = await Calender.find({
        //     d_status:0,
        //     date:{
        //      $gte: start_date,
        //      $lte: end_date
        //  }
        //  });

        const result = await DealerLiftingMaster.aggregate([
            {
              $match: {
                d_status: 0,
                tagged_emps: { $in: [emp_id] },
                date:{$gte:new Date(start_date),$lt:new Date(end_date)}

              },
            },
            {
              $group: {
                '_id': "$invoice_no",
                total_quantity: { $sum: "$quantity" },
                date: { $first: "$date"} 
              },
            },
          ]);
          
          console.log(result);

         //To get monthly sale
         if(slab_type==1){

         let months = [
            { "month": 4, "year": 2023 },
            { "month": 5, "year": 2023 },
            { "month": 6, "year": 2023 },
            { "month": 7, "year": 2023 },
            { "month": 8, "year": 2023 },
            { "month": 9, "year": 2023 },
            { "month": 10, "year": 2023 },
            { "month": 11, "year": 2023 },
            { "month": 12, "year": 2023 },
            { "month": 1, "year": 2024 },
            { "month": 2, "year": 2024 },
            { "month": 3, "year": 2024 }
        ]

        let monthly_sale = [];

        function formatDate(input) {
            const [month, year] = input.split(' '); // Split by ', ' instead of ' '
            const date = new Date(`${month}/1/${year}`);
            return date.toLocaleString('default', { month: 'short', year: 'numeric' });
        }

        
        
        for(let i=0; i<months.length; i++){ 

            let total_sale = 0;
            let emp_sale = await DealerLiftingMaster.find({
                d_status: 0,
                tagged_emps: { $in: [ emp_id ]  },
                $expr: {
                    $and: [
                    { $eq: [{ $month: '$date' }, months[i]['month']] },
                    { $eq: [{ $year: '$date' }, months[i]['year']] }
                    ]
                },
                });
            const month_no = months[i]['month'];
            const year_no = months[i]['year'];

            let month_year = month_no + " " + year_no;
            if(emp_sale.length>0){
                for (let j = 0; j < emp_sale.length; j++) {
                    total_sale += emp_sale[j].quantity;
                }
            }

            console.log(formatDate(month_year));    

             
            monthly_sale.push({
                'month': formatDate(month_year),
                'total_sale': total_sale,
                'earned_points': getPoints(emp_profile, total_sale)
            });                
        }
         

        res.status(200).json({ 
            
            'total_sale': total_sale,
            'details': monthly_sale
    
            }
        );

      //To get invoice wise sale  
    } else if(slab_type==2){

        res.json(result);
    }

    }catch(e){
        res.status(500).json({ error: e.message });
    }
} );





module.exports = employeeRouter;