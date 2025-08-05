const functions = require("firebase-functions");
const admin = require("firebase-admin");
const serviceAccount = require("./serviceAccountKey.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

const express = require("express");
const cors = require("cors");
const app = express();

const authRoutes = require("./routes/auth");
const lessonsRoutes = require("./routes/lessons");
const studyPlanRoutes = require("./routes/studyPlan");


app.use(cors({origin: true}));
app.use(express.json());

// Yetkilendirme işlemleri
app.use("/auth", authRoutes);

// Derslerle ilgili API'ler
app.use("/lessons", lessonsRoutes);

app.use("/study-plan", studyPlanRoutes);
// Basit test endpoint
app.get("/test", (req, res) => {
  res.send("API çalışıyor");
});

exports.api = functions.https.onRequest(app);
