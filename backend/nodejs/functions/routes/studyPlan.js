const express = require("express");
const router = express.Router();
const admin = require("firebase-admin");
const db = admin.firestore();

// plan kaydetme
router.post("/", async (req, res) => {
  try {
    const {userId, plans, meta} = req.body;

    const userRef = db.collection("study-plan").doc(userId);
    await userRef.set({
      weeklyTotalHours: meta.weeklyTotalHours,
      aiConfidence: meta.aiConfidence,
    });

    const batch = db.batch();
    plans.forEach((plan) => {
      const planRef = userRef.collection("plans").doc(plan.date);

      batch.set(planRef, {
        day: plan.day,
        dailyTotalHours: plan.dailyTotalHours,
        plan: plan.sessions.map((s) => ({
          id: s.id,
          startingTime: s.startingTime,
          endTime: s.endTime,
          lessons: s.lessons,
          lessonsSubject: s.lessonsSubject,
          lessonsDuration: s.lessonsDuration,
          completed: false,
        })),
      });
    });

    await batch.commit();
    res.status(200).json({message: "Plans + meta saved successfully"});
  } catch (err) {
    console.error("POST / hata:", err);
    res.status(500).json({error: err.message});
  }
});

// tüm planları getir
router.get("/:userId", async (req, res) => {
  try {
    const {userId} = req.params;
    const userRef = db.collection("study-plan").doc(userId);
    const userDoc = await userRef.get();
    const meta = userDoc.exists ? userDoc.data() : null;
    const snapshot = await userRef.collection("plans").get();
    const plans = snapshot.docs.map((doc) => ({
      date: doc.id,
      ...doc.data(),
    }));

    res.json({
      meta: meta || {
        weeklyTotalHours: 0.0,
        aiConfidence: 0.0,
      },
      plans: plans,
    });
  } catch (err) {
    console.error("GET /:userId hata:", err);
    res.status(500).json({error: err.message});
  }
});

// id ile plan getirme
router.get("/:userId/:planDate", async (req, res) => {
  try {
    const {userId, planDate} = req.params;
    const planRef = db
        .collection("study-plan")
        .doc(userId)
        .collection("plans")
        .doc(planDate);

    const doc = await planRef.get();
    if (!doc.exists) return res.status(404).json({error: "Plan not found"});
    res.json({date: planDate, ...doc.data()});
  } catch (err) {
    console.error("GET /:userId/:planDate hata:", err);
    res.status(500).json({error: err.message});
  }
});

// ders tamamlama durumu
router.put("/:userId/:planDate/session/:sessionId", async (req, res) => {
  try {
    const {userId, planDate, sessionId} = req.params;
    const {completed} = req.body;

    console.log("PUT /session toggle çağrıldı");
    console.log({userId, planDate, sessionId, completed});

    const planRef = db
        .collection("study-plan")
        .doc(userId)
        .collection("plans")
        .doc(planDate);

    const planDoc = await planRef.get();
    if (!planDoc.exists) {
      console.log("Plan bulunamadı");
      return res.status(404).json({error: "Plan not found"});
    }

    const planData = planDoc.data();
    if (!planData || !planData.plan) {
      console.log("Plan içinde session yok");
      return res.status(404).json({error: "Sessions not found in plan"});
    }
    const updatedSessions = planData.plan.map((session) => {
      if (session.id === sessionId) {
        console.log(`Session bulundu, completed güncelleniyor: ${completed}`);
        return {...session, completed: completed};
      }
      return session;
    });
    await planRef.set({plan: updatedSessions}, {merge: true});

    res.status(200).json({message: "Session completion status updated"});
  } catch (err) {
    console.error("PUT /session toggle hata:", err);
    res.status(500).json({error: err.message});
  }
});

module.exports = router;
