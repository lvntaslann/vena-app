import 'package:flutter/material.dart';
import '../../themes/app_colors.dart';

class PlanSettingsDialog extends StatefulWidget {
  final TimeOfDay initialStartTime;
  final TimeOfDay initialEndTime;
  final int initialBreakMinutes;

  const PlanSettingsDialog({
    Key? key,
    required this.initialStartTime,
    required this.initialEndTime,
    required this.initialBreakMinutes,
  }) : super(key: key);

  @override
  _PlanSettingsDialogState createState() => _PlanSettingsDialogState();
}

class _PlanSettingsDialogState extends State<PlanSettingsDialog> {
  late TimeOfDay startTime;
  late TimeOfDay endTime;
  late TextEditingController breakController;

  @override
  void initState() {
    super.initState();
    startTime = widget.initialStartTime;
    endTime = widget.initialEndTime;
    breakController =
        TextEditingController(text: widget.initialBreakMinutes.toString());
  }

  Future<void> pickStartTime() async {
    final picked =
        await showTimePicker(context: context, initialTime: startTime);
    if (picked != null) {
      setState(() {
        startTime = picked;
      });
    }
  }

  Future<void> pickEndTime() async {
    final picked = await showTimePicker(context: context, initialTime: endTime);
    if (picked != null) {
      setState(() {
        endTime = picked;
      });
    }
  }

  @override
  void dispose() {
    breakController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 16,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
             const Icon(
                Icons.schedule_rounded,
                size: 48,
                color: AppColors.showDialogIconColor,
              ),
              const SizedBox(height: 16),
             const Text(
                "Çalışma Takvimi Ayarları",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.showDialogTitleColor,
                ),
              ),
              const SizedBox(height: 12),

              // Başlangıç Saati
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text(
                  "Başlangıç Saati",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                trailing: TextButton(
                  onPressed: pickStartTime,
                  child: Text(
                    startTime.format(context),
                    style:const TextStyle(
                      color: AppColors.showDialogButtonColor,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              // Bitiş Saati
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text(
                  "Bitiş Saati",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                trailing: TextButton(
                  onPressed: pickEndTime,
                  child: Text(
                    endTime.format(context),
                    style:const TextStyle(
                      color: AppColors.showDialogButtonColor,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              // Mola Süresi
              TextField(
                controller: breakController,
                keyboardType: TextInputType.number,
                decoration:const InputDecoration(
                  labelText: "Mola Süresi (dakika)",
                  labelStyle:
                      TextStyle(color: AppColors.showDialogTextColor),
                  enabledBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: AppColors.showDialogButtonColor),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: AppColors.showDialogButtonColor),
                  ),
                ),
                style: const TextStyle(color: AppColors.showDialogTextColor),
              ),

              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(null),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                            color:
                                AppColors.showDialogButtonColor.withOpacity(0.5)),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child:const Text(
                        "İptal",
                        style: TextStyle(
                          color: AppColors.showDialogButtonColor,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        final breakMinutes = int.tryParse(breakController.text) ?? 30;
                        Navigator.of(context).pop({
                          'startTime': startTime,
                          'endTime': endTime,
                          'breakMinutes': breakMinutes,
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: AppColors.showDialogButtonColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          "Onayla",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.showDialogButtonTextColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
