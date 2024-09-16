const express = require('express');
const loyaltyRouter = express.Router();
const GiftCategory = require('../models/gift_category');
const Merchant = require('../models/merchant');
const Coupon = require('../models/coupons');
const auth = require('../middleware/auth');
const CouponCode = require('../models/coupon_code');
const Employee = require('../models/employee');
const DealerLiftingMaster = require('../models/dealer_lifting_master');

//Add a gift category
loyaltyRouter.post('/v1/api/add-gift-category', auth, async(req, res) =>{
    try {
      
        const { gift_category_name, gift_category_logo } = req.body;

        const user_id = req.user;
        let gift_categories = await GiftCategory.find();
        const gift_category_id = gift_categories.length+1;
        console.log(gift_categories.length);

        let gift_category = GiftCategory({
            gift_category_id: gift_category_id,
            gift_category_name: gift_category_name,
            gift_category_logo: gift_category_logo,
            post_user: user_id
        });

        gift_category = await gift_category.save(); 


        res.status(200).json({
            success: true,
            message: gift_category  //`Gift category added successfully`
        });

    } catch (err) {
        res.status(500).json({
          success: false,
          message: err
        });
      }
  });

  //Add a merchant
  loyaltyRouter.post('/v1/api/add-merchant', auth, async(req, res) =>{
    try {
      
        const { merchant_name, merchant_type, merchant_logo, merchant_cover_img, about_us } = req.body;

        const user_id = req.user;
        let merchants = await Merchant.find();
        const merchant_id = merchants.length + 1;

        let merchant = Merchant({
            merchant_id: merchant_id,
            merchant_type: merchant_type,
            merchant_name: merchant_name,
            merchant_logo: merchant_logo,
            about_us: about_us,
            merchant_cover_img: merchant_cover_img,
            post_user: user_id

        });

        merchant = await merchant.save(); 

        res.status(200).json({
            success: true,
            message: merchant  //`Gift category added successfully`
        });

    } catch (err) {
        res.status(500).json({
          success: false,
          message: err
        });
      }
  });



    //Show merchants
loyaltyRouter.post('/v1/api/create-coupon-master', auth, async(req, res) =>{
    try {

        const all_coupons = req.body;
        const user_id = req.user;

        for(let i=0; i<all_coupons.length; i++){

            let coupon_schema = await Coupon.find(); 

            const coupon_id = coupon_schema.length + 1;

            let new_coupon = Coupon({
                'coupon_id': coupon_id,
                'merchant_id': all_coupons[i].merchant_id,
                'coupon_value': all_coupons[i].coupon_value,
                'post_user': user_id
            });

            await new_coupon.save();
        }

        res.status(200).json({
            success: true,
            message: `${all_coupons.length} coupons are allocated`   
        });

    } catch (err) {
        res.status(500).json({
            success: false,
            message: err
        });
        }
    });

//Show merchants
loyaltyRouter.post('/v1/api/show-merchants', auth, async(req, res) =>{
    try {
        
        // const { gift_category_name, gift_category_logo } = req.body;

        const user_id = req.user;
        let gift_categories = await GiftCategory.find({
            d_status: false
        });
        let gift_category_data_with_all = [];
        let gift_category_data = [];
        let merchants_for_all = [];

        for(let i=0; i<gift_categories.length; i++){

            const gift_category_id = gift_categories[i].gift_category_id;
            let merchants = [];

            let all_merchants = await Merchant.find({
                merchant_type: gift_category_id,
                d_status: false
            });

            console.log(1);

            for(let j=0; j<all_merchants.length; j++){

                let coupons = [];

                let all_coupons = await Coupon.find({
                    d_status: false,
                    merchant_id: all_merchants[j].merchant_id
                });

                console.log(`2 ${all_merchants[j].merchant_name}`)


                if(all_coupons.length>0){

                for(let k=0; k<all_coupons.length; k++){

                    coupons.push(all_coupons[k]);
                }}

                console.log(`3 ${all_merchants[j].merchant_name}`)

                merchants.push({
                    '_id': all_merchants[j]._id,
                    'merchant_id': all_merchants[j].merchant_id,
                    'merchant_name': all_merchants[j].merchant_name,
                    'gift_category_name': gift_categories[i].gift_category_name,
                    'merchant_logo': all_merchants[j].merchant_logo,
                    'merchant_cover_img': all_merchants[j].merchant_cover_img,
                    'merchant_type': all_merchants[j].merchant_type,
                    'about_us': all_merchants[j].about_us,
                    'rewards_screen_text': all_merchants[j].rewards_screen_text,
                    'd_status': all_merchants[j].d_status,
                    'coupons': coupons
                });

                console.log(`4 ${all_merchants[j].merchant_name}`)


                merchants_for_all.push({
                  '_id': all_merchants[j]._id,
                  'merchant_id': all_merchants[j].merchant_id,
                  'gift_category_name': gift_categories[i].gift_category_name,
                  'merchant_name': all_merchants[j].merchant_name,
                  'merchant_logo': all_merchants[j].merchant_logo,
                  'merchant_cover_img': all_merchants[j].merchant_cover_img,
                  'about_us': all_merchants[j].about_us,
                  'rewards_screen_text': all_merchants[j].rewards_screen_text,
                  'merchant_type': all_merchants[j].merchant_type,
                  'd_status': all_merchants[j].d_status,
                  'coupons': coupons
              });

              console.log(5);
            }

            gift_category_data.push({

                '_id': gift_categories[i]._id,
                'gift_category_id': gift_categories[i].gift_category_id,
                'gift_category_name': gift_categories[i].gift_category_name,
                'gift_category_logo': gift_categories[i].gift_category_logo,
                'merchant_cover_img': gift_categories[i].merchant_cover_img,
                'd_status': gift_categories[i].d_status,
                'merchants': merchants
            });
        }

        gift_category_data_with_all = [{
          '_id': '_id',
          'gift_category_id': 1,
          'gift_category_name': 'All',
          'gift_category_logo': 'All logo',
          'd_status': false,
          'merchants': merchants_for_all
        }, ...gift_category_data];



        res.status(200).json({
            success: true,
            message: gift_category_data_with_all 
        });

    } catch (err) {
        res.status(500).json({
            success: false,
            message: err
        });
        }
    });


//Allocation of coupon codes        
loyaltyRouter.post('/v1/api/allocate-coupon-codes', auth, async(req, res) =>{
    try {
        const userId = req.user;
        let coupon_id = 1;
      
        async function generateUniqueCode() {
          let code = '';
          for (let i = 0; i < 16; i++) {
            const charType = Math.random() < 0.5 ? 'letter' : 'number';
            if (charType === 'letter') {
              code += String.fromCharCode(Math.floor(Math.random() * 26) + 65); // Uppercase letter
            } else {
              code += Math.floor(Math.random() * 10); // Number
            }
          }
      
          const existingCode = await CouponCode.findOne({ d_status: false, coupon_code: code });
          if (existingCode) {
            return generateUniqueCode(); // Recursively generate a new code if it already exists
          }
      
          return code;
        }

        while(coupon_id<=80){
      

          let j = 1; // Initialize j
          while(j<=10){

            const couponCode = await generateUniqueCode();
            let coupon_code_schema = await CouponCode.find();
            const coupon_code_id = coupon_code_schema.length + 1;
            console.log(`coupon id: ${coupon_id}`);

            const coupon_master = await Coupon.find({
              coupon_id: coupon_id,
              d_status: false
            });


            const coupon_value = coupon_master[0].coupon_value;
            const merchant_id = coupon_master[0].merchant_id;
            const expiry_date = new Date('2024-12-31');

            const newCouponCode = new CouponCode({
              coupon_code_id: coupon_code_id,
              coupon_code: couponCode,
              merchant_id: merchant_id,
              coupon_value: coupon_value,
              coupon_id: coupon_id,
              expiry_date: expiry_date,
              post_user: userId
            });
      
              await newCouponCode.save();
          j++;
        }
        console.log(`coupon_id=${coupon_id} are allocated`);
        coupon_id++;
      }
      
          res.status(200).json({
            success: true,
            message: `${10} coupons are allocated`
          });
        
      } catch (err) {
        res.status(500).json({
          success: false,
          message: err
        });
      }
    });

    //Get merchant details
    loyaltyRouter.post('/v1/api/get-merchant-details', auth, async(req, res) =>{
      try {
  
          const { merchant_id } = req.body;
          const user_id = req.user;
  
          let merchant = await Merchant.find({
            merchant_id: merchant_id
          });
  
          res.status(200).json({
              success: true,
              message: merchant   
          });
  
      } catch (err) {
          res.status(500).json({
              success: false,
              message: err
          });
          }
      });


    loyaltyRouter.post('/v1/api/redeem-a-coupon', auth, async(req, res) =>{

      try{

        const { coupon_id } = req.body;
        let success_msg = "NA";
        let allocated_coupon;
        const emp_id = req.user;
        const post_time = Date.now();
        const currentDate = new Date();
        let start_date, end_date;
        let total_sale = 0;
        let total_points = 0;
        let total_redeemed = 0;
        let total_pending = 0;
        const emp = await Employee.findById(emp_id);
        const emp_profile = emp.profile_id;
        let points_slab = 0;

        if(emp_profile==2){
          points_slab = 200;
        }
        else if(emp_profile==3){
            points_slab = 150;
        } else if(emp_profile==5 || emp_profile==28){
            points_slab = 100;
        }

        //Fetching start date and end date
        if(currentDate.getMonth()>=3){
          start_date = new Date(currentDate.getFullYear()-1, 3, 1, 0, 0, 0);
          end_date = new Date(currentDate.getFullYear(), 2, 31, 23, 59, 59);
        } else {
            start_date = new Date(currentDate.getFullYear()-2, 3, 1, 0, 0, 0);
            end_date = new Date(currentDate.getFullYear()-1, 2, 31, 23, 59, 59);
        }

        //Fetching lifting details
        const result = await DealerLiftingMaster.aggregate([
          {
            $match: {
              d_status: 0,
              tagged_emps: { $in: [emp_id] },
              date: { $gte: new Date(start_date), $lt: new Date(end_date) }
            }
          },
          {
            $group: {
              '_id': "$invoice_no",
              'total_quantity': { $sum: "$quantity" },
              'date': { $first: "$date" },
              'sapid': {$first : "$sapid"}
            }
          },
          {
            $addFields: {
              'earned_points': {
                  $let: {
                      vars: { pointsSlab: points_slab },
                      in: { $multiply: ["$$pointsSlab", "$total_quantity"] }
                    }
              },
              'point_type': 1
          }
          }
        ]);

        for(let i=0; i < result.length; i++){

          total_sale += result[i]['total_quantity'];
          total_points += result[i]['earned_points'];
        }

        //Fetching current points
        total_pending = total_points - total_redeemed;

        const coupon = await Coupon.findById(coupon_id);
        const coupon_value = coupon.coupon_value;
        console.log(coupon_value);

        if(total_pending<coupon_value){
          console.log("Proceed");
        } else {
          console.log("Block");
        }

        const merchant_id = coupon.merchant_id;
        const merchant = await Merchant.find({
          merchant_id: merchant_id
        });

        let all_coupon_codes = await CouponCode.find({
          coupon_id: coupon.coupon_id,
          allocated_to: ""
        });

        for(let i=0; i<all_coupon_codes.length; i++){

          if(all_coupon_codes[i].allocated_to==""){

            allocated_coupon = all_coupon_codes[i];
            allocated_coupon.allocated_to = emp_id;
            allocated_coupon.allocation_date = post_time;
            // await allocated_coupon.save();
            break;

          }
        }

        // console.log('all_coupon_codes');

        const merchant_name = merchant[0].merchant_name;

        success_msg = `You've successfully redeemed a ${merchant_name}'s coupon worth ₹${coupon_value}!!!`

        res.status(200).json({
          success: true,
          message: success_msg
        });

      }catch(err){
        res.status(500).json({
          success: false,
          message: err
        });
      }
    });

    loyaltyRouter.post('/v1/api/get-redeemed-vouchers', auth, async(req, res) =>{

      try{

        const emp_id = req.user;
        const currentDate = new Date();
        // console.log(currentDate);

        let redeemed_vouchers = await CouponCode.find({
          allocated_to: emp_id,
          d_status: false
        });
        
        let final_res = [];

        function formatISODate(timestamp, key) {
          const date = new Date(timestamp);
          const year = date.getFullYear();
          const month = date.toLocaleString('default', { month: 'short' });
          const day = date.getDate();
          let hours = date.getHours();
          const minutes = date.getMinutes();
          const ampm = hours >= 12 ? 'PM' : 'AM';
          hours = hours % 12 || 12; // Convert to 12-hour format
        
          function getOrdinal(day) {
            if (day > 10 && day < 20) return 'th';
            switch (day % 10) {
              case 1: return 'st';
              case 2: return 'nd';
              case 3: return 'rd';
              default: return 'th';
            }
          }
        
          return key ==1 ? `${month} ${day}${getOrdinal(day)}, ${year} • ${hours.toString().padStart(2, '0')}:${minutes.toString().padStart(2, '0')} ${ampm}`
          : `${month} ${day}${getOrdinal(day)}, ${year}`;

        }
         

        for(let i=0; i<redeemed_vouchers.length; i++){

          let merchant_name = "NA";
          let is_expired = false;

          let merchant = await Merchant.find({
            merchant_id: redeemed_vouchers[i].merchant_id
          });

          is_expired = redeemed_vouchers[i].expiry_date>currentDate ? false : true; 

          merchant_name = merchant[0].merchant_name;

          final_res.push({
            "header_text": "Click to get coupon!!!",
            "merchant_name": merchant_name,
            "coupon_value": redeemed_vouchers[i].coupon_value,
            "expiry_date": formatISODate(redeemed_vouchers[i].expiry_date, 0),
            "redeemed_on": formatISODate(redeemed_vouchers[i].allocation_date, 1),
            "is_expired": is_expired
          });

        }

        res.status(200).json({
          success: true,
          message: final_res
        });

      }catch(err){
        res.status(500).json({
          success: false,
          message: err
        });
      }
    });


module.exports = loyaltyRouter;