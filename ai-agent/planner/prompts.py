from config import Config

class PlannerPrompts:
    PLANNER_TASK_DESCRIPTION = (
            "Bugün tarih: {todayDate}, gün: {todayDay}.\n"
            "Kullanıcının sınav takvimi şu şekilde: {examCalendar}. "
            "Her ders için isim, sınav tarihi, zorluk (kolay, orta, zor) ve konu başlıkları verilmiştir.\n\n"
            "Her konu için tamamlanma_durumu (%0-%100) bilgisi vardır. "
            "Bu bilgiyi kullanarak 1 haftalık çalışma planı oluştur veya güncelle: "
            "Planlama bugünden başlayacak ve hafta Pazar günü sona erecek şekilde ayarlanacak.\n"
            "- %100 tamamlanan konuları plana tekrar koyma, sadece kısa tekrar blokları ekle.\n"
            "- %50-99 arası tamamlanan konuları pekiştirme amaçlı kısa bloklarla ekle.\n"
            "- %0-49 arası tamamlanmayan konulara daha fazla zaman ayır.\n"
            "- Zorluk seviyesi zor olan derslere daha uzun süre, kolay olanlara daha kısa süre ayır.\n"
            "- Konuları pedagojik sıraya göre sırala: önce temel/zor konular, sonra kolay/tekrar konuları.\n"
            "- Çalışma saatleri {startingTime} - {endTime} arası olmalı.\n"
            "- Dersler arasında {breakTimeMinutes} dakika mola olsun.\n\n"
            " **Planın sonunda, oluşturduğun planın ne kadar verimli ve dengeli olduğuna dair 0.1 ile 0.9 arasında bir güven puanı (ai_confidence) belirt.**\n"
            "Bu değeri mutlaka ver. Bu alan boş veya sıfır olamaz. Rastgele değil, plana göre makul bir sayı seç.. KESİNLİKLE VER\n\n"
            "Çıktıyı **sadece geçerli JSON formatında ver**.\n"
            "Kesinlikle 'json', '```', 'Thought:' veya açıklama ekleme.\n"
            "Örnek format:\n"
            "{{\n"
            '  "Pazartesi": [\n'
            '    {{"lessons": "Matematik", "lessonsSubject": "Limit", "lessonsDuration": 2.0, "startingTime": "09:00", "endTime": "11:00"}},\n'
            "    ...\n"
            "  ],\n"
            '  "Salı": [...],\n'
            '  ...\n'
            '  "aiConfidence": 0.91\n'
            "}}"
        )
    
    RESOURCE_SUGGESTION_DESCRIPTION = (
        "Kullanıcının sınav takvimi şu şekilde: {examCalendar}.\n"
        "Her ders ve konu için sadece linkleri listele. **Her link için bir de kısa açıklama (description) ver.**\n"
        "Gerektiğinde Serper tool'u kullanarak web araması yap.\n"
        "Format:\n"
        "{{\n"
        '  "Matematik": {{\n'
        '    "Türev": [\n'
        '      {{"url": "https://youtube.com/...", "description": "Türev temelleri için başlangıç videosu"}},\n'
        '      {{"url": "https://example.com", "description": "Türev ileri seviye sorular"}},\n'
        '    ],\n'
        '    "İntegral": [\n'
        '      {{"url": "https://youtube.com/...", "description": "İntegral kavramları anlatım"}},\n'
        '      {{"url": "https://example.com", "description": "İntegral soru çözüm seti"}},\n'
        '    ]\n'
        '  }},\n'
        '  "Fizik": {{\n'
        '    "Hareket": [\n'
        '      {{"url": "https://youtube.com/...", "description": "Hareket formülleri anlatımı"}},\n'
        '      {{"url": "https://example.com", "description": "Hareket ileri seviye test"}},\n'
        '    ]\n'
        '  }}\n'
        "}}\n"
        "ÇIKTIDA TEK BİR KARAKTER BİLE EKLEME.\n"
        "SADECE JSON VER. YORUM, BAŞLIK, 'işte kaynaklar:' GİBİ ŞEYLER EKLEME.\n"
    )


    BACKSTORY = Config.PLANNER_BACKSTORY
    BACKSTORY2 = Config.PLANNER_BACKSTORY_2
    TASK_DESCRIPTION = PLANNER_TASK_DESCRIPTION
