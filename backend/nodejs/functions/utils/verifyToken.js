const admin = require("firebase-admin");

async function verifyTokenAndGetUserId(req, res) {
  const authHeader = req.headers.authorization;
  if (!authHeader || !authHeader.startsWith("Bearer ")) {
    res.status(401).json({error: "Yetkilendirme tokeni eksik"});
    return null;
  }

  const idToken = authHeader.split("Bearer ")[1];

  try {
    const decodedToken = await admin.auth().verifyIdToken(idToken);
    return decodedToken.uid;
  } catch (error) {
    res.status(401).json({error: "Token doğrulama başarısız"});
    return null;
  }
}

module.exports = verifyTokenAndGetUserId;
