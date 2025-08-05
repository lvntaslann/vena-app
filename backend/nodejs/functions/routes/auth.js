require('dotenv').config();

const express = require("express");
const fetch = require("node-fetch");
const admin = require("firebase-admin");
const db = admin.firestore();
const router = express.Router();

const GOOGLE_CLIENT_ID = process.env.GOOGLE_CLIENT_ID;
const FIREBASE_API_KEY = process.env.FIREBASE_API_KEY;
const {OAuth2Client} = require("google-auth-library");
const client = new OAuth2Client(GOOGLE_CLIENT_ID);


router.post("/register", async (req, res) => {
  const {name, email, password} = req.body;

  if (!name || !email || !password) {
    return res
        .status(400)
        .json({error: "Ad/soyad, Email ve şifre gerekli."});
  }

  try {
    const userRecord = await admin.auth().createUser({
      email,
      password,
    });

    await db.collection("Users").doc(userRecord.uid).set({
      name: name,
      email: userRecord.email,
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
    });

    return res.status(201).json({
      message: "Kayıt başarılı",
      uid: userRecord.uid,
      name: name,
      email: userRecord.email,
    });
  } catch (error) {
    return res.status(400).json({error: error.message});
  }
});


router.post("/login", async (req, res) => {
  const {email, password} = req.body;

  if (!email || !password) {
    return res.status(400).json({error: "Email ve şifre gerekli."});
  }

  try {
    const response = await fetch(
        `https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=${FIREBASE_API_KEY}`,
        {
          method: "POST",
          headers: {"Content-Type": "application/json"},
          body: JSON.stringify({email, password, returnSecureToken: true}),
        },
    );

    const data = await response.json();

    if (!response.ok) {
      return res.status(401).json({error: data.error.message});
    }

    const userDoc = await db.collection("Users").doc(data.localId).get();
    let name = "";
    if (userDoc.exists) {
      name = userDoc.data().name || "";
    }

    return res.status(200).json({
      message: "Giriş başarılı",
      idToken: data.idToken,
      refreshToken: data.refreshToken,
      uid: data.localId,
      email: data.email,
      name: name,
    });
  } catch (error) {
    return res
        .status(500)
        .json({error: "Giriş başarısız", details: error.message});
  }
});


router.post("/google-login", async (req, res) => {
  const {idToken} = req.body;

  if (!idToken) {
    return res.status(400).json({error: "Google ID Token gerekli."});
  }
  try {
    const ticket = await client.verifyIdToken({
      idToken,
      audience: GOOGLE_CLIENT_ID,
    });

    const payload = ticket.getPayload();
    const uid = payload.sub;
    const email = payload.email;
    const name = payload.name || "Google Kullanıcısı";
    try {
      await admin.auth().getUser(uid);
    } catch (err) {
      await admin.auth().createUser({
        uid,
        email,
        emailVerified: true,
        displayName: name,
      });
    }
    const userDoc = await db.collection("Users").doc(uid).get();
    if (!userDoc.exists) {
      await db.collection("Users").doc(uid).set({
        name,
        email,
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
      });
    }
    const customToken = await admin.auth().createCustomToken(uid);
    const firebaseResponse = await fetch(
        `https://identitytoolkit.googleapis.com/v1/accounts:signInWithCustomToken?key=${FIREBASE_API_KEY}`,
        {
          method: "POST",
          headers: {"Content-Type": "application/json"},
          body: JSON.stringify({
            token: customToken,
            returnSecureToken: true,
          }),
        },
    );

    const firebaseData = await firebaseResponse.json();

    if (!firebaseResponse.ok) {
      return res.status(401).json({error: firebaseData.error.message});
    }
    return res.status(200).json({
      message: "Google ile giriş başarılı",
      idToken: firebaseData.idToken,
      refreshToken: firebaseData.refreshToken,
      uid: uid,
      email: firebaseData.email,
      name: name,
    });
  } catch (error) {
    console.error(error);
    return res.status(401).json({
      error: "Google token doğrulanamadı",
      details: error.message,
    });
  }
});

module.exports = router;
