console.log('Trying to connect');

const express = require('express');
const mongoose = require('mongoose');
const authRouter = require('./routes/auth');
const attendanceRouter = require('./routes/employee_attendance');
const employeeRouter = require('./routes/employee');
const menuAccessRouter = require('./routes/menu_access');
const accountRouter = require('./routes/account');
const global_variables = require('./global_variables');
const DB = global_variables.MONGODB_URL;
const PORT = 3000;
const app = express();

//middleware
app.use(express.json());
app.use(attendanceRouter);
app.use(authRouter);
app.use(employeeRouter);
app.use(menuAccessRouter);
app.use(accountRouter);


mongoose.connect(DB)
.then(()=>{
    console.log('Connected Successfully');
})
.catch((e)=>{
    console.log(`Error while connecting. Error: ${e}`);
});


app.listen(PORT,'0.0.0.0',function(){
    console.log(`Connected at ${PORT}`);
});