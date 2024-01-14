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

employeeRouter.get('/v1/api/fetch-tagged-accounts', auth, async(req,res) => {

    try{

        const emp_id = req.user;
        let employee = await Employee.findById(emp_id);

        let emp_districts = employee.district_id;

        let taggedAccounts = await AccountMaster.find({
            ASM: emp_id,
            all_districts : { $in: emp_districts },
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

            console.log('c :'+creation_date.getDate() + '    today: '+ today.getDate());
            var diffDays = today.getDate() - creation_date.getDate(); 

            return diffDays ? diffDays : 0
        }

        const resWithData = await Promise.all(taggedAccounts.map(async oneAccount => ({
            ...oneAccount.toObject(),
            'state_name': await getStateName(oneAccount.state_id),
            'cluster_name': await getClusterName(oneAccount.cluster_id),
            'district_names': await getDistrictNames(oneAccount.all_districts),
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
        
        
        res.json(resWithData);

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

        const updatedRes = {
            ...emp.toObject(),
            'state_names': await getStateNames(emp.state_id),
            'district_names': await getDistrictNames(emp.district_id)
        }

        
        res.json(updatedRes);

    }catch (e) {
        res.status(500).json({ error: e.message });
      }

});




module.exports = employeeRouter;