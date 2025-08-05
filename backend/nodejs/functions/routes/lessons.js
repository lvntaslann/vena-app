const express = require("express");
const admin = require("firebase-admin");
const db = admin.firestore();
const verifyTokenAndGetUserId = require("../utils/verifyToken");

const router = express.Router();

// ders ekleme
router.post("/add-lessons", async (req, res) => {
  const userId = await verifyTokenAndGetUserId(req, res);
  if (!userId) return;

  const {
    lesson,
    lessonsSubject,
    examDate,
    difficulty,
    completionStatus,
  } = req.body;

  if (!lesson || !examDate || !difficulty) {
    return res.status(400).json({
      error: "Eksik bilgi var: lesson, examDate veya difficulty",
    });
  }

  try {
    const userDoc = await db.collection("Users").doc(userId).get();
    if (!userDoc.exists) {
      await db.collection("Users").doc(userId).set({
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
      });
    }
    const lessonRef = await db
        .collection("lessons")
        .doc(userId)
        .collection("userLessons")
        .add({
          lesson,
          lessonsSubject,
          examDate: new Date(examDate),
          difficulty,
          completionStatus,
          createdAt: admin.firestore.FieldValue.serverTimestamp(),
        });
    await lessonRef.update({id: lessonRef.id});
    res.status(201).json({
      message: "Ders eklendi",
      lessonId: lessonRef.id,
    });
  } catch (err) {
    res.status(500).json({error: err.message});
  }
});

// dersleri listeleme
router.get("/get-lessons", async (req, res) => {
  const userId = await verifyTokenAndGetUserId(req, res);
  if (!userId) return;

  try {
    const snapshot = await db
        .collection("lessons")
        .doc(userId)
        .collection("userLessons")
        .orderBy("createdAt", "desc")
        .get();

    const lessons = snapshot.docs.map((doc) => ({
      id: doc.id,
      ...doc.data(),
      examDate:
        doc.data().examDate && doc.data().examDate.toDate ?
          doc.data().examDate.toDate() :
          null,
    }));

    res.status(200).json({lessons});
  } catch (err) {
    res.status(500).json({error: err.message});
  }
});

// ders silme
router.delete("/delete-lessons/:lessonId", async (req, res) => {
  const userId = await verifyTokenAndGetUserId(req, res);
  if (!userId) return;

  const {lessonId} = req.params;
  if (!lessonId) {
    return res.status(400).json({error: "Lesson ID gerekli"});
  }

  try {
    await db
        .collection("lessons")
        .doc(userId)
        .collection("userLessons")
        .doc(lessonId)
        .delete();

    res.status(200).json({message: "Ders silindi"});
  } catch (err) {
    res.status(500).json({error: err.message});
  }
});

// ders güncelleme
router.put("/update-lessons/:lessonId", async (req, res) => {
  const userId = await verifyTokenAndGetUserId(req, res);
  if (!userId) return;

  const {lessonId} = req.params;
  if (!lessonId) {
    return res.status(400).json({error: "Lesson ID gerekli"});
  }

  const allowedFields = [
    "lesson",
    "lessonsSubject",
    "examDate",
    "difficulty",
    "completionStatus",
  ];
  const updateData = {};

  allowedFields.forEach((field) => {
    if (
      req.body[field] !== undefined &&
      req.body[field] !== null &&
      req.body[field] !== ""
    ) {
      if (field === "examDate") {
        updateData[field] = new Date(req.body[field]);
      } else {
        updateData[field] = req.body[field];
      }
    }
  });

  if (Object.keys(updateData).length === 0) {
    return res.status(400).json({error: "Güncellenecek veri bulunamadı"});
  }

  updateData.updatedAt = admin.firestore.FieldValue.serverTimestamp();

  try {
    await db
        .collection("lessons")
        .doc(userId)
        .collection("userLessons")
        .doc(lessonId)
        .update(updateData);

    res.status(200).json({message: "Ders güncellendi"});
  } catch (err) {
    res.status(500).json({error: err.message});
  }
});

module.exports = router;
