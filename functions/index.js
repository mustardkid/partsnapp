const functions = require("firebase-functions");
const admin = require("firebase-admin");
const csv = require("csv-parser");
const fs = require("fs");

admin.initializeApp();
const db = admin.firestore();

exports.importPartsCatalog = functions.https.onRequest((req, res) => {
  const results = [];

  fs.createReadStream("parts_catalog_template.csv")
    .pipe(csv())
    .on("data", (data) => results.push(data))
    .on("end", async () => {
      const batch = db.batch();

      results.forEach((part) => {
        const docRef = db.collection("parts_catalog").doc(part.id);
        batch.set(docRef, {
          sku: part.sku,
          part_name: part.part_name,
          brand: part.brand,
          vehicle_type: part.vehicle_type,
          category: part.category,
          price: parseFloat(part.price),
          image_url: part.image_url,
          affiliate_link: part.affiliate_link,
          updated_at: part.updated_at,
        });
      });

      await batch.commit();
      res.send("Parts catalog imported successfully.");
    });
});
