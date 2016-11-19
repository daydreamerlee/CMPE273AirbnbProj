/**
 * Created by Rentala on 15-11-2016.
 */
var express = require('express');
var router = express.Router();
var mq_client = require('../rpc/client');

router.get('/tripDetails',function (req,res) {

    var json_responses;
    var msg_payload;
    var user_id = req.param("user_id");
    var host_id = req.param("host_id");


    if(user_id!=null){
        msg_payload = {"user_id":user_id,"host_id":null};

        mq_client.make_request('trip_details_queue',msg_payload,function (err,results) {
            console.log(results);
           if(err){
               throw err;
           }
           else {
               if(results.statusCode == 200){
                   console.log("inside 200");
                   json_responses = {"status_code":results.statusCode,"userTrips":results.userTrips};
               }
               else {
                   json_responses = {"status_code":results.statusCode,"msg":results.errMsg};
               }
               res.send(json_responses);
               res.end();
           }
        });
    }
    else{
        msg_payload = {"user_id":null,"host_id":host_id};

        mq_client.make_request('trip_details_queue',msg_payload,function (err,results) {
            console.log(results);
            if(err){
                throw err;
            }
            else {
                if(results.statusCode == 200){
                    console.log("inside 200");
                    json_responses = {"status_code":results.statusCode,"hostTrips":results.hostTrips};
                }
                else {
                    json_responses = {"status_code":results.statusCode,"msg":results.errMsg};
                }
                res.send(json_responses);
                res.end();
            }
        });
    }
});



router.post('/delete',function (req,res) {
    var json_responses;

    var trip_id = req.param("trip_id");

    var msg_payload = {"trip_id":trip_id};

    mq_client.make_request('delete_trip_queue',msg_payload,function (err,results) {
        if(err){
            throw err;
        }
        else {
            if(results.statusCode == 200)
            {
                json_responses = {"status_code":200};
            }
            else {
                json_responses = {"status_code":401};
            }
            res.send(json_responses);
            res.end();
        }
    });
});

router.post('/createTrip', function(req, res){
  var property_id = req.body.property_id;
  var host_id = req.body.host_id;
  var user_id = req.body.user_id/*req.session.user._id*/;
  var city_nm = req.body.city_nm;
  var state = req.body.state;
  var start_date = req.body.start_date;
  var end_date = req.body.end_date;
  var price = req.body.price;
  var guest = req.body.guest;
  var country = req.body.country;
  var payment_details = {
    "mode" : req.body.mode,
    "card_number" : req.body.card_number,
    "cvv" : req.body.cvv,
    "expiry_date" : req.body.expiry_date
  };
  var msg_payload = {
    "property_id" : property_id,
    "host_id" : host_id,
    "user_id" : user_id,
    "city_nm" : city_nm,
    "state" : state,
    "start_date" : start_date,
    "end_date" : end_date,
    "price" : price,
    "guest" : guest,
    "country" : country,
    "payment_details" : payment_details
  };
  console.log(msg_payload);
  mq_client.make_request('createTrip_queue', msg_payload, function (err,results) {
        if(err){
            throw err;
        }
        else {
            if(results.statusCode == 200)
            {
                res.send({"status_code":200});
            }
            else {
                res.send({"status_code":401});
            }
        }
    });
});

router.post('/updateTrip',function (req,res) {
    var json_responses;

    var trip_id = req.param("trip_id");
    var status = req.param("status");

    var msg_payload = {"trip_id":trip_id, "status": status};

    mq_client.make_request('update_trip_queue',msg_payload,function (err,results) {
        if(err){
            throw err;
        }
        else {
            if(results.statusCode == 200)
            {
              console.log("success");
                json_responses = {"status_code":200};
            }
            else {
                json_responses = {"status_code":400};
            }
            res.send(json_responses);
            res.end();
        }
    });
});


router.post('/review/:propertyId', function (req, res, next)  {

    var storage = multer.diskStorage({
        destination: function (req, file, cb) {
            cb(null, '../AirbnbClient/public/uploads');
        },
        filename: function (req, file, cb) {
            var datetimestamp = Date.now();
            imagePath = getID() + '.'
                + file.originalname.split('.')[file.originalname.split('.').length -1];
            cb(null, imagePath);
        }
    });
    var upload = multer({ storage: storage}).array('file');
    var json_responses;
    upload(req,res,function(err) {
        if (err) {
            res.json({error_code: 1, err_desc: err});
            return;
        }
        var msg_payload = buildPayLoad(req);


        mq_client.make_request('create_trip_review_queue', msg_payload, function(err,results){
            if(err){
                json_responses = {
                    "failed" : "failed"
                };
            } else {
                json_responses = {
                    "reviews" : results.insertedIds[0]
                };
            }
            res.statusCode = results.code;
            res.send(json_responses);
        });
    });

});

function buildPayLoad(req) {
    var msg_payload = {};
    msg_payload.property_id = req.param("propertyId");
    msg_payload.review = {
        rating: req.body.rating,
        comment: req.body.comment,
        images: req.files,
        time: new Date().toDateString(),
        user_id: 1, //stub get from session
        user_name: "Trump",  //stub
        trip_id: 1 //stub get from session
    }
    return msg_payload;
}



module.exports = router;
