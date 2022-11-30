const fs = require('fs');
const geojsonStream = require('geojson-stream');
var admin = require("firebase-admin");

var serviceAccount = require("./serviceAccountKey.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: "https://forestmap-5d284.firebaseio.com"
});

const result = [];

fs.createReadStream('test.geojson')
  .pipe(geojsonStream.parse((data) => {
    if (data.geometry !== undefined || data.geometry !== null) {
      if (data.geometry.coordinates !== undefined || data.geometry.coordinates !== null) {
        if (Array.isArray(data.geometry.coordinates)) {
          const coordinates = data.geometry.coordinates;
          coordinates.forEach((coord) => {
            const dto = {
              id: data.properties.id || null,
              area: data.properties.area || null,
              type: data.properties.class || null,
              specie: data.properties.specie || null,
              det_date: data.properties.det_date || null,      
              image_date: data.properties.image_date || null,
              points: coord[0].map((points) => new admin.firestore.GeoPoint(points[0], points[1])),
            };

            result.push(dto);
          });
        }
      }
    }
  }))
  .on('end', async () => {
    try {
      const db = admin.firestore();
      const ref = await db.collection('geolocationData').add({
        name: 'test',
        updated_at: admin.firestore.Timestamp.now(),
      });

      const collectionPromises = [];

      result.forEach(async (item) => {
        collectionPromises.push(new Promise((resolve, reject) => {
          try {
            ref.collection('data').add(item).then(resp => resolve(resp));
          } catch (error) {
            reject(error);
          }
        }))
      });

      console.warn("====================//========================");
      console.warn("====================//========================");
      console.info("STARTED TO UPLOAD DATA");

      await Promise.all(collectionPromises);

      console.warn("====================//========================");
      console.warn("====================//========================");
      console.info("SUCCESS");
    } catch(error) {
      console.error("ERROR: " + error.message);
    }
  })
