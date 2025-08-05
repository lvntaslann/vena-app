import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vena/themes/app_colors.dart';

class ResourceDialog extends StatelessWidget {
  final Map<String, dynamic> resources;

  const ResourceDialog({super.key, required this.resources});

  Color _getLinkColor(String url) {
    if (url.contains("youtube")) return Colors.redAccent;
    if (url.endsWith(".pdf")) return Colors.deepOrange;
    return Colors.blueAccent;
  }

  IconData _getLinkIcon(String url) {
    if (url.contains("youtube")) return Icons.play_circle_fill;
    if (url.endsWith(".pdf")) return Icons.picture_as_pdf;
    return Icons.link;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      insetPadding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(0),
        constraints: const BoxConstraints(maxHeight: 600, minWidth: 320),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            //başlık kaynaklar
            _buildTitleText(),

            // İçerik Listesi
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: resources.length,
                itemBuilder: (context, lessonIndex) {
                  final lessonName = resources.keys.elementAt(lessonIndex);
                  final subjects =
                      resources[lessonName] as Map<String, dynamic>;

                  return Card(
                    color: AppColors.pageBackgroundColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Ders adı
                          _buildLessonsName(lessonName),
                          const SizedBox(height: 10),

                          // Konu ve linkleri listeleme
                          ...subjects.entries.map((subjectEntry) {
                            final subjectName = subjectEntry.key;
                            final links = subjectEntry.value as List<dynamic>;

                            return _buildListingSubjectsAndLinks(
                                subjectName, links, context);
                          }).toList(),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Kapat Butonu
            _buildCancelButton(context)
          ],
        ),
      ),
    );
  }

  Container _buildTitleText() {
    return Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF4A90E2), Color(0xFF6C63FF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: const Text(
              "📚 Kaynaklar",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          );
  }

  Row _buildLessonsName(String lessonName) {
    return Row(
      children: [
        const Icon(Icons.book, color: Color(0xFF4A90E2)),
        const SizedBox(width: 8),
        Text(
          lessonName,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: Color(0xFF4A90E2),
          ),
        ),
      ],
    );
  }

  Container _buildListingSubjectsAndLinks(
      String subjectName, List<dynamic> links, BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.miniContainerColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 12),
        iconColor: Colors.deepPurple,
        collapsedIconColor: Colors.grey.shade600,
        title: Text(
          subjectName,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
        children: links.map((linkData) {
          final url = linkData['url'];
          final desc = linkData['description'];

          return ListTile(
            leading: Icon(
              _getLinkIcon(url),
              color: _getLinkColor(url),
            ),
            title: Text(
              desc,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: Text(
              url,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            onTap: () async {
              final uri = Uri.parse(url);
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Bu bağlantı açılamıyor: $url"),
                  ),
                );
              }
            },
          );
        }).toList(),
      ),
    );
  }

  Container _buildCancelButton(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 16, bottom: 12),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.buttonBackgroundColor,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 3,
        ),
        onPressed: () => Navigator.of(context).pop(),
        label: const Text(
          "Kapat",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
