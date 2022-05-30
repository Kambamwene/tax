const functions = require("firebase-functions");

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
exports.sendPushNotification=functions.https.onRequest((request,response)=>{
    if(request.method=="GET"){
        functions.logger.info("GET request")
    }
    functions.logger.info(request.query.token)
    response.send("Shopping hub Cloud Functions by Fasthub")
})