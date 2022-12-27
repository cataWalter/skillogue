const functions = require("firebase-functions");
const admin = require("firebase-admin");
const serviceAdmin = require("./serviceAccountKey.json");

admin.initializeApp({
	credential: admin.credential.cert(serviceAdmin)
});

exports.sendPushNotify = functions.https.onRequest((request, response) => {
	const token = request.body.token;
	const title = request.body.title;
	const message = request.body.message;

	functions.logger.info(title + "/" + token + "/" + message, 
		{structuredData: true});

	const payload = {
		token: token,
		notification: {
			title: title,
			body: message,
		},
		data: {
			click_action: "FLUTTER_NOTIFICATION_CLICK",
		},
	};

	admin.messaging().send(payload).then((response)=> {
		functions.logger.info("Successfully sent message");
		return {success:true};
	}).catch((error) => {
		functions.error(error);
		return {error:error.code};
	});

	response.send("OK");
});