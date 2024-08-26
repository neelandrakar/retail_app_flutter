const express = require('express');
const loyaltyRouter = express.Router();
const cloudinary = require('../utils/coudinary');
const upload = require('../middleware/multer');
const GiftCategory = require('../models/gift_category');
const Merchant = require('../models/merchant');
const Coupon = require('../models/coupons');
const auth = require('../middleware/auth');
const CouponCode = require('../models/coupon_code');

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
      
        const { merchant_name, merchant_type, merchant_logo } = req.body;

        const user_id = req.user;
        let merchants = await Merchant.find();
        const merchant_id = merchants.length + 1;

        let merchant = Merchant({
            merchant_id: merchant_id,
            merchant_type: merchant_type,
            merchant_name: merchant_name,
            merchant_logo: merchant_logo,
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
        let gift_category_data = [];

        for(let i=0; i<gift_categories.length; i++){

            const gift_category_id = gift_categories[i].gift_category_id;
            let merchants = [];

            let all_merchants = await Merchant.find({
                merchant_type: gift_category_id,
                d_status: false
            });

            for(let j=0; j<all_merchants.length; j++){

                let coupons = [];

                let all_coupons = await Coupon.find({
                    d_status: false,
                    merchant_id: all_merchants[j].merchant_id
                });

                for(let k=0; k<all_coupons.length; k++){

                    coupons.push(all_coupons[k]);
                }

                merchants.push({
                    '_id': all_merchants[j]._id,
                    'merchant_id': all_merchants[j].merchant_id,
                    'merchant_name': all_merchants[j].merchant_name,
                    'merchant_logo': all_merchants[j].merchant_logo,
                    'merchant_type': all_merchants[j].merchant_type,
                    'd_status': all_merchants[i].d_status,
                    'coupons': coupons
                });
            }

            gift_category_data.push({

                '_id': gift_categories[i]._id,
                'gift_category_id': gift_categories[i].gift_category_id,
                'gift_category_name': gift_categories[i].gift_category_name,
                'gift_category_logo': gift_categories[i].gift_category_logo,
                'd_status': gift_categories[i].d_status,
                'merchants': merchants
            }); 
        }

        res.status(200).json({
            success: true,
            message: gift_category_data  //`Gift category added successfully`
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
        const allCoupons = req.body;
        const userId = req.user;
      
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
      
        if (allCoupons.length > 0) {

          for (let i = 0; i < allCoupons.length; i++) {

            const couponCode = await generateUniqueCode();
            let coupon_code_schema = await CouponCode.find();
            const coupon_code_id = coupon_code_schema.length + 1;

            const newCouponCode = new CouponCode({
              coupon_code_id: coupon_code_id,
              coupon_code: couponCode,
              merchant_id: allCoupons[i].merchant_id,
              coupon_value: allCoupons[i].coupon_value,
              coupon_id: allCoupons[i].coupon_id,
              expiry_date: allCoupons[i].expiry_date,
              post_user: userId
            });
      
            await newCouponCode.save();
          }
      
          res.status(200).json({
            success: true,
            message: `${allCoupons.length} coupons are allocated`
          });
        } else {
          res.status(200).json({
            success: true,
            message: `No coupon found!`
          });
        }
      } catch (err) {
        res.status(500).json({
          success: false,
          message: err
        });
      }
    });

module.exports = loyaltyRouter;