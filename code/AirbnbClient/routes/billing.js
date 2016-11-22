var express = require('express');
var router = express.Router();
var mq_client = require('../rpc/client');
var tool = require("../utili/common");

router.get('/view',function (req,res) {

    var json_responses;

    var trip_id = req.param("trip_id");
    var msg_payload={"trip_id":trip_id};

    mq_client.make_request('get_bill_queue',msg_payload,function (err,results) {
        if(err){
            //Need to add tool to log error.
            tool.logError(err);
            json_responses = {"status_code":400};
        }
        else {
            if(results.statusCode==200){
                json_responses = {"status_code":results.statusCode, "bill_dtls":results.bill_dtls,"property_dtls":results.property_dtls};
            }
            else {
                json_responses = {"status_code":results.statusCode};
            }
        }
        res.send(json_responses);
        res.end();
    });
});

router.post('/deleteBill',function (req, res) {

    var json_responses;
    var bill_id = req.param("bill_id");
    var msg_payload = {"bill_id":bill_id};

    mq_client.make_request('delete_bill_queue',msg_payload,function (err,results) {
       if(err){
           //Need to add tool to log error.
           tool.logError(err);
           json_responses = {"status_code":400};
       }
       else
       {
           if(results.statusCode==200){
               json_responses={"status_code":200};
           }
           else {
               json_responses = {"status_code":results.statusCode};
           }
       }
        res.send(json_responses);
        res.end();
    });
});

module.exports = router;