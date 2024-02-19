const express = require('express');
const Employee = require('../models/employee');
const Calender = require('../models/calender');
const AttendanceTbl = require('../models/attendance_tbl');
const auth = require('../middleware/auth');
const attendanceRouter = express.Router();

attendanceRouter.post('/v1/api/create-calender',  async (req,res) => {

    try{

        const startDate = new Date('2023-01-01');
        const endDate = new Date('2025-12-31');

        let currentDate = startDate;
        // currentDate.setDate(currentDate.getDate()+1);

        // res.json(currentDate.toISOString().split('T')[0]);


        while (currentDate <=endDate) {

            const ISTDate = currentDate.toLocaleString();
            console.log(ISTDate);
            let calender = new Calender({
                date: ISTDate
            });

            calender = await calender.save();
            currentDate.setDate(currentDate.getDate()+1);
          }

          res.json('Calender is created');

    }catch (e) {
        res.status(500).json({ error: e.message });
      }
});

attendanceRouter.get('/v1/api/get-attendance',  auth ,async (req,res) => {

    try{

        const userId = req.user;
        let emp = await Employee.findById(userId);



        const getTime = new Date();
        const currentDate = getTime.getDate();
        let get_attendance = [];
        let startDate = new Date();
        let endDate = new Date();
        const currentMonth = getTime.getMonth();
        const currentYear = getTime.getFullYear();
        let hasLoggedInToday = false;
        let startKM = 0.0;
        let endKM = 0.0;
        let totalVisitCount = 0;
        let vehicle = 0; //1=> bike, 2=> car, 3=> others
        let startOdometer = '';
        let endOdometer = '';

        function convertToIST(date) {
        // Difference between UTC and IST in minutes
        const differenceInMinutes = 330;

        // Convert the difference to milliseconds
        const differenceInMilliseconds = differenceInMinutes * 60 * 1000;

        // Get the current date
        const currentDate = new Date(date);

        // Get the local time
        const localTime = currentDate.getTime();

        // Calculate the IST date
        const istDate = new Date(localTime + differenceInMilliseconds);

        // Return the IST date
        return istDate;
      }

        function convertToPlainDate(dateStr) {
          // Convert the date string to a Date object
          let date = new Date(dateStr);
        
          // Get the date part of the Date object and set the time part to 00:00:00.000
          date.setHours(0, 0, 0, 0);
        
          // Convert the modified Date object back to a date string
        
          return date;
        }

        function removeTime(date) {
          var newDate =  new Date(date);  
          return new Date(
              newDate.getFullYear(),
              newDate.getMonth(),
              newDate.getDate()
          );
      }

        function formatDate(date, shortYear=false) {
            var d = new Date(date),
                month = '' + (d.getMonth() + 1),
                day = '' + d.getDate(),
                year = shortYear ? String(d.getFullYear()).slice(2) : d.getFullYear();
        
            if (month.length < 2) 
                month = '0' + month;
            if (day.length < 2) 
                day = '0' + day;
        
            return [shortYear ? day : year, month, shortYear ? year : day].join('-');
        }

        function getDiffernece(endDate, startDate){

          let diff = Math.abs(endDate - startDate) / 60000;

          return parseInt(diff);
        }

        if(currentDate>=1 && currentDate<=25){

            startDate = new Date(currentYear,currentMonth-1, 26);
            endDate = new Date(currentYear,currentMonth,25);
            console.log(1);
           
        } else if(currentDate>=26 && currentDate<=31){

            startDate = formatDate(new Date(currentYear,currentMonth, 26));
            endDate = formatDate(new Date(currentYear,currentMonth+1,25));
            console.log(endDate + ' $$ '+ startDate);

        }

        if(formatDate(emp.joining_date)>startDate){
          startDate = formatDate(emp.joining_date+1);
        }


        console.log('start: '+formatDate(startDate));
        console.log('end: '+formatDate(endDate));
        console.log('curdate: '+ getTime);

        
        

        const calender = await Calender.find({
           d_status:0,
           date:{
            $gte:formatDate(startDate),
            $lte:formatDate(getTime)
        }
        });

        const attendance_tbl = await AttendanceTbl.find({
            emp_id:userId
         });

        let logged_in = false;

        for(let i=0; i< calender.length; i++){

            let calDate = calender[i].date;
            let hasLoggedIn = false;
            let getLoginTime = null;
            let getLogoutTime = null;
            let field_time = 0;
            let checkin_deviation = 0;
            let checkout_deviation = 0;




            var calFormattedDate = new Date(calDate.getTime() - (calDate.getTimezoneOffset() * 60000 ))
                    .toISOString()
                    .split("T")[0];

            var todayFormattedDate = new Date(getTime.getTime() - (calDate.getTimezoneOffset() * 60000 ))
            .toISOString()
            .split("T")[0];

            let isToday = todayFormattedDate == calFormattedDate;


            let mainLoginTime = new Date(`${calFormattedDate}T04:00:00.000+00:00`);
            let mainLogoutTime = new Date(`${calFormattedDate}T13:00:00.000+00:00`);



            if(attendance_tbl.length>0){
            

            for(let j=0; j < attendance_tbl.length; j++){

                let attendanceDate = attendance_tbl[j].date;
                let attIndex = attendance_tbl[j];
                


                formattedAttendanceDate = new Date(attendanceDate.getTime() - (attendanceDate.getTimezoneOffset() * 60000 ))
                .toISOString()
                .split("T")[0];



                if(formatDate(getTime)===formattedAttendanceDate){
                    hasLoggedInToday = true;
                }

                // console.log('cal: '+ calFormattedDate);
                // console.log('att: '+ formattedAttendanceDate);


                if(calFormattedDate===formattedAttendanceDate){

                    hasLoggedIn = true;


                    getLoginTime = attIndex.loginTime;
                    getLogoutTime = attIndex.logoutTime;
                    startKM = attIndex.startKM;
                    startOdometer = attIndex.startOdometer;
                    endKM = attIndex.endKM;
                    endOdometer = attIndex.endOdometer;
                    vehicle = attIndex.vehicle;

                    console.log(calFormattedDate+ ": " + getLoginTime);
                    console.log(calFormattedDate+ ": " + getLogoutTime);


                    if(getLogoutTime!=null){
                      field_time = getDiffernece(getLogoutTime,getLoginTime);
                    } else{
                      field_time = 0;
                    }
                    if(getLoginTime!=null && getLoginTime>mainLoginTime){
                      checkin_deviation = getDiffernece(getLoginTime,mainLoginTime);

                    }

                    if(getLogoutTime!=null && getLogoutTime<mainLogoutTime){
                      checkout_deviation = getDiffernece(mainLogoutTime, getLogoutTime);
                    } else if(getLogoutTime=null){
                      checkout_deviation = 10;
                    }
                }
            }

            if(hasLoggedIn){

                get_attendance.push({
                    'date': removeTime(calDate),
                    'login_status': 1,
                    'login_time': getLoginTime,
                    'logout_time': getLogoutTime,
                    'checkin_deviation': checkin_deviation,
                    'checkout_deviation': checkout_deviation,
                    'field_time': field_time,
                    'checkin_time': getLoginTime,
                    'checkout_time': getLogoutTime,
                    'startKM': startKM,
                    'startOdometer': startOdometer,
                    'endKM': endKM,
                    'endOdometer': endOdometer,
                    'vehicle': vehicle
                });
            } else{

                get_attendance.push({
                    'date': removeTime(calDate),
                    'login_status': isToday ? 0 : 2,
                    'login_time': getLoginTime,
                    'logout_time': getLogoutTime,
                    'field_time': field_time,
                    'checkin_deviation': checkin_deviation,
                    'checkout_deviation': checkout_deviation,
                    'field_time': field_time,
                    'checkin_time': getLoginTime,
                    'checkout_time': getLogoutTime,
                    'startKM': startKM,
                    'startOdometer': startOdometer,
                    'endKM': endKM,
                    'endOdometer': endOdometer,
                    'vehicle': vehicle                
                  });
            }
        }
        
        else{
            get_attendance.push({
              'date': removeTime(calDate),
              'login_status': isToday ? 0 : 2,
              'login_time': getLoginTime,
              'logout_time': getLogoutTime,
              'field_time': field_time,
              'checkin_deviation': checkin_deviation,
              'checkout_deviation': checkout_deviation,
              'field_time': field_time,
              'checkin_time': getLoginTime,
              'checkout_time': getLogoutTime,
              'startKM': startKM,
              'startOdometer': startOdometer,
              'endKM': endKM,
              'endOdometer': endOdometer,
              'vehicle': vehicle
            });
        }
        }



        const full_attendance_data = ({
            'cycle_start_date': formatDate(startDate, true),
            'cycle_end_date': formatDate(endDate, true),
            'current_date': getTime,
            'hasLoggedInToday': hasLoggedInToday,
            get_attendance
        });

        res.json(full_attendance_data);

    }catch (e) {
        res.status(500).json({ error: e.message });
      }
});

attendanceRouter.post('/v1/api/get-attendance_v1', auth, async (req, res) => {
    try {
      const userId = req.user;
      const getTime = new Date();
      const currentDate = getTime.getDate();
      let get_attendance = [];
      let startDate = new Date();
      let endDate = new Date();
      const currentMonth = getTime.getMonth();
      const currentYear = getTime.getFullYear();
      let hasLoggedInToday = false;
  
      function formatDate(date) {
        var d = new Date(date),
          month = '' + (d.getMonth() + 1),
          day = '' + d.getDate(),
          year = d.getFullYear();
  
        if (month.length < 2) month = '0' + month;
        if (day.length < 2) day = '0' + day;
  
        return [year, month, day].join('-');
      }
  
      if (currentDate >= 1 && currentDate <= 25) {
        startDate = new Date(currentYear, currentMonth - 1, 26);
        endDate = new Date(currentYear, currentMonth, 25 + 1);
      } else if (currentDate >= 26 && currentDate <= 31) {
        startDate = formatDate(new Date(currentYear, currentMonth, 26));
        endDate = formatDate(new Date(currentYear, currentMonth + 1, 25 + 1));
      }
  
      const calendar = await Calender.find({
        d_status: 0,
        date: {
          $gte: formatDate(startDate),
          $lte: formatDate(getTime),
        },
      });
  
      const attendance_tbl = await AttendanceTbl.find({
        emp_id: userId,
      });
  
      for (let i = 0; i < calendar.length; i++) {
        let calDate = calendar[i].date;
  
        var calFormattedDate = new Date(calDate.getTime() - calDate.getTimezoneOffset() * 60000)
          .toISOString()
          .split('T')[0];
  
        let attendanceDate = attendance_tbl.find(
          (attendance) =>
            new Date(attendance.date.getTime() - attendance.date.getTimezoneOffset() * 60000)
              .toISOString()
              .split('T')[0] === calFormattedDate
        );
  
        if (attendanceDate) {
          hasLoggedInToday = true;
          get_attendance.push({
            date: calFormattedDate,
            logged_in: true,

          });
        } else {
          get_attendance.push({
            date: calFormattedDate,
            logged_in: false,

          });
        }
      }
  
      const full_attendance_data = {
        cycle_start_date: formatDate(startDate),
        cycle_end_date: formatDate(endDate - 1),
        current_date: formatDate(new Date()),
        hasLoggedInToday: hasLoggedInToday,
        get_attendance,
      };
  
      res.json(full_attendance_data);
    } catch (e) {
      res.status(500).json({ error: e.message });
    }
  });
  

attendanceRouter.post('/v1/api/submit-login-data',  auth ,async (req,res) => {

    try{

        const {login_location, login_latitude, login_longitude} = req.body;
        const userId = req.user;
        let today = new Date();

        // const attendance_tbl = await AttendanceTbl.find({
        //    d_status:0
        // });

        function convertToPlainDate(dateStr) {
          let date = new Date(dateStr);
        
          date.setHours(0, 0, 0);
          return date;
        }

        function removeTime(date) {
          return new Date(
            date.getFullYear(),
            date.getMonth(),
            date.getDate()
          );
        }

        let attendance_tbl = new AttendanceTbl({
            date: removeTime(today),
            emp_id: userId,
            updated_at: Date.now(),
            loginTime: Date.now(),
            login_location,
            login_latitude,
            login_longitude
          });

          var formattedDate = new Date(today.getTime() - (today.getTimezoneOffset() * 60000 ))
          .toISOString()
          .split("T")[0];

        attendance_tbl = await attendance_tbl.save();
        res.json({
            'date': formattedDate,
            'logged_in': true,
        });



    }catch (e) {
        res.status(500).json({ error: e.message });
      }
});

//Logout
attendanceRouter.post('/v1/api/submit-logout-data',  auth ,async (req,res) => {

  try{

      const {logout_location, logout_latitude, logout_longitude, endKM, endOdometer} = req.body;
      const userId = req.user;
      let today = new Date();
      let todaysDate = '';
      let currentTime = new Date();


      function convertToIST(d){


        todaysDate = new Date(d.getTime() - (d.getTimezoneOffset() * 60000 ))
        .toISOString()
        .split("T")[0];

        return todaysDate;
      }

      function convertToPlainDate(dateStr) {
        let date = new Date(dateStr);
      
        date.setHours(0, 0, 0,0);
        return date;
      }

      function removeTime(date) {
        return new Date(
          date.getFullYear(),
          date.getMonth(),
          date.getDate()
        );
      }

      console.log(removeTime(today));
      console.log(convertToPlainDate(today));


      const attendance_data = await AttendanceTbl.find({
         d_status:0,
         emp_id: userId,
         date: removeTime(today),
      });

      for(let i=0; i<attendance_data.length; i++){

        attendance_data[i].logoutTime = currentTime;
        attendance_data[i].logout_latitude = logout_latitude;
        attendance_data[i].logout_longitude = logout_longitude;
        attendance_data[i].logout_location = logout_location;
        attendance_data[i].endKM = endKM;
        attendance_data[i].endOdometer = endOdometer;

        attendance_data[i] = await attendance_data[i].save();

      }



      res.status(200).json(attendance_data);
      
  }catch (e) {
      res.status(500).json({ error: e.message });
    }
});

//Logout
attendanceRouter.post('/v1/api/submit-login-odometer-data',  auth ,async (req,res) => {

  try{

      const { vehicle, startOdometer, startKM } = req.body;
      const userId = req.user;
      let today = new Date();
      let todaysDate = '';
      let currentTime = new Date();


      function convertToIST(d){


        todaysDate = new Date(d.getTime() - (d.getTimezoneOffset() * 60000 ))
        .toISOString()
        .split("T")[0];

        return todaysDate;
      }

      function convertToPlainDate(dateStr) {
        let date = new Date(dateStr);
      
        date.setHours(0, 0, 0,0);
        return date;
      }

      function removeTime(date) {
        return new Date(
          date.getFullYear(),
          date.getMonth(),
          date.getDate()
        );
      }

      const attendance_data = await AttendanceTbl.find({
        d_status:0,
        emp_id: userId,
        date: removeTime(today),
     });

     for(let i=0; i<attendance_data.length; i++){

       attendance_data[i].startKM = startKM;
       attendance_data[i].startOdometer = startOdometer;
       attendance_data[i].vehicle = vehicle;

       attendance_data[i] = await attendance_data[i].save();

     }

      res.status(200).json(attendance_data);
      
  }catch (e) {
      res.status(500).json({ error: e.message });
    }
});


module.exports = attendanceRouter;