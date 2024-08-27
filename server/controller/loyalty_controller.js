const express = require('express');

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
  
  module.exports = generateUniqueCode;