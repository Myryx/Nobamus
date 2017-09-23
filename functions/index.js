var functions = require('firebase-functions');

const admin = require('firebase-admin');
admin.initializeApp(functions.config().firebase);

exports.closestUsers = functions.https.onRequest((req, res) => {
	return admin.database().ref('users').once('value', (snapshot) => {
        const users = snapshot.val();
        var distances = {}
        const x1 = req.query.latitude;
        const y1 = req.query.longitude;
        for (var userId in users) {
        	if( users[userId].hasOwnProperty('latitude') && 
        	   	users[userId].hasOwnProperty('longitude') &&
        	   	users[userId].hasOwnProperty('track')  &&
        	   	users[userId].hasOwnProperty('isOnline')) {
        		if (users[userId]["isOnline"] == true) {
		    		var x2 = users[userId]["latitude"]
		        	var y2 = users[userId]["longitude"]
		        	var distance = Math.sqrt(Math.pow((x2 - x1), 2) + Math.pow((y2 - y1), 2))
		        	distances[userId] = distance	
        		}
			}
        }
        var result = Object.keys(distances).sort(function(a, b) {
            return distances[a] - distances[b];
        })
        res.send(result);
     });
});