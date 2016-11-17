//super simple rpc server example

var amqp = require('amqp'),
	util = require('util'),
	//mongoURL = "mongodb://rentala:team5password@ds155097.mlab.com:55097/airbnb",
	// uncomment above and comment below line to make it work on mLab
	mongoURL = "mongodb://localhost:27017/airbnb",
	mongo = require("./db/mongo"),
    mysql = require("./db/mysql"),
	cnn = amqp.createConnection({host:'127.0.0.1'});

var auth = require('./services/authentication');
var profile = require('./services/profile');
var property = require('./services/property');
var admin = require('./services/admin');
var mongoConn;
var connection;

mysql.getPool(10);

mongo.connect(mongoURL, function(db){
	mongoConn = db;
	connection = { mongoConn: mongoConn};
	console.log('Connected to mongo at: ' + mongoURL);
});


cnn.on('ready', function(){
	console.log("listening on all queues");

	cnn.queue('login_queue', function(q){
		subscriber(q, auth.login );
	});
	// registration queue
	cnn.queue('register_queue', function(q){
		subscriber(q, auth.register );
	});
	
	cnn.queue('update_profile_queue', function(q){
		subscriber(q, profile.updateProfile );
	});
	cnn.queue('userinfo_queue', function(q){
		subscriber(q, profile.userInfo );
	});
	cnn.queue('list_property_queue', function(q){
		subscriber(q, property.listProperty );
	});
	cnn.queue('search_property_queue', function(q){
		subscriber(q, property.searchProperty );
	});
	cnn.queue('approve_host_queue', function(q){
		subscriber(q, admin.approveHost );
	});
	cnn.queue('pending_hosts_for_approval_queue', function(q){
		subscriber(q, admin.pendingHostsForApproval );
	});
	cnn.queue('delete_user_queue', function(q){
		subscriber(q, profile.deleteUser );
	});
});

var subscriber = function(q, module){
	q.subscribe(function(message, headers, deliveryInfo, m){
		util.log(util.format( deliveryInfo.routingKey, message));
		util.log("Message: "+JSON.stringify(message));
		util.log("DeliveryInfo: "+JSON.stringify(deliveryInfo));
		module.handle_request(connection, message, function(err,res){
			cnn.publish(m.replyTo, res, {
				contentType:'application/json',
				contentEncoding:'utf-8',
				correlationId:m.correlationId
			});
		});
	});
}

