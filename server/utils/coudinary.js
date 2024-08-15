const cloudinary = require('cloudinary').v2;
const global_variables = require('../global_variables');


cloudinary.config({
  cloud_name: global_variables.CLOUDINARY_CLOUD_NAME,
  api_key: global_variables.CLOUDINARY_API_KEY,
  api_secret: global_variables.CLOUDINARY_API_SECRET
});

module.exports = cloudinary;