import 'package:flutter/material.dart';
import '../../features/lesson/data/model/lessons.dart';

Future<Lesson?> showAddLessonBottomSheet(
  BuildContext context, {
  Lesson? existingLesson,
}) {
  final nameController =
      TextEditingController(text: existingLesson?.name ?? '');
  final topicController = TextEditingController();
  final List<String> topics = List.from(existingLesson?.lessonsSubject ?? []);
  String selectedDifficulty = existingLesson?.difficulty ?? "Orta";
  DateTime? selectedDate = existingLesson?.examDate;

  final List<String> difficultyLevels = ["Kolay", "Orta", "Zor"];

  return showModalBottomSheet<Lesson>(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Padding(
            padding: EdgeInsets.fromLTRB(
              20,
              24,
              20,
              MediaQuery.of(context).viewInsets.bottom + 24,
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      existingLesson == null
                          ? "Yeni Ders Ekle"
                          : "Dersi Güncelle",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Ders adı
                  _buildLessonsNameTextfield(nameController),
                  const SizedBox(height: 20),
                  // Konular başlığı
                  const Text(
                    "Konular",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  _buildAddSubjectArea(topicController, setState, topics),
                  const SizedBox(height: 10),
                  if (topics.isNotEmpty)
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: topics
                          .map((t) => Chip(
                                label: Text(t),
                                onDeleted: () {
                                  setState(() => topics.remove(t));
                                },
                              ))
                          .toList(),
                    ),
                  const SizedBox(height: 20),
                  const Text(
                    "Zorluk Seviyesi",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: difficultyLevels.map((level) {
                      final isSelected = selectedDifficulty == level;
                      return ChoiceChip(
                        label: Text(level),
                        selected: isSelected,
                        onSelected: (_) =>
                            setState(() => selectedDifficulty = level),
                        selectedColor: level == "Kolay"
                            ? Colors.green.shade200
                            : level == "Orta"
                                ? Colors.orange.shade200
                                : Colors.red.shade200,
                        backgroundColor: Colors.grey.shade200,
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Sınav Tarihi",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade100,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: selectedDate ??
                                DateTime.now().add(const Duration(days: 1)),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2100),
                          );
                          if (picked != null) {
                            setState(() => selectedDate = picked);
                          }
                        },
                        icon: const Icon(Icons.calendar_today, size: 16),
                        label: Text(
                          selectedDate == null
                              ? "Tarih Seç"
                              : "${selectedDate!.day}.${selectedDate!.month}.${selectedDate!.year}",
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  _buildSaveAndUpdateButton(nameController, selectedDate,
                      topics, existingLesson, selectedDifficulty, context),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

TextField _buildLessonsNameTextfield(TextEditingController nameController) {
  return TextField(
    controller: nameController,
    decoration: InputDecoration(
      labelText: "Ders Adı",
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
    ),
  );
}

Row _buildAddSubjectArea(TextEditingController topicController,
    StateSetter setState, List<String> topics) {
  return Row(
    children: [
      Expanded(
        child: TextField(
          controller: topicController,
          decoration: InputDecoration(
            labelText: "Konu ekle",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          ),
        ),
      ),
      const SizedBox(width: 8),
      IconButton(
        icon: const Icon(Icons.add_circle, color: Colors.blue),
        onPressed: () {
          if (topicController.text.trim().isNotEmpty) {
            setState(() {
              topics.add(topicController.text.trim());
              topicController.clear();
            });
          }
        },
      ),
    ],
  );
}

SizedBox _buildSaveAndUpdateButton(
    TextEditingController nameController,
    DateTime? selectedDate,
    List<String> topics,
    Lesson? existingLesson,
    String selectedDifficulty,
    BuildContext context) {
  return SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      onPressed: () {
        if (nameController.text.trim().isNotEmpty &&
            selectedDate != null &&
            topics.isNotEmpty) {
          final lesson = Lesson(
            id: existingLesson?.id,
            name: nameController.text.trim(),
            difficulty: selectedDifficulty,
            examDate: selectedDate,
            lessonsSubject: topics,
            completionStatus: existingLesson?.completionStatus ?? false,
          );
          Navigator.pop(context, lesson);
        }
      },
      child: Text(
        existingLesson == null ? "Kaydet" : "Güncelle",
        style: const TextStyle(fontSize: 16),
      ),
    ),
  );
}
