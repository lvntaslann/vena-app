# Vena

BTK Hackathon Yarışması için geliştirilen bu mobil uygulama, öğrencilerin sınav dönemlerinde hangi derse ne kadar süreyle çalışmaları gerektiğine karar vermekte zorlandıkları anlarda devreye girer. Uygulama; ders konuları, zorluk seviyeleri ve sınav tarihlerini dikkate alarak kişiye özel bir örnek çalışma planı oluşturur.

Plan hazırlanırken öğrencinin belirlediği başlama ve bitiş saatleri ile mola süreleri de göz önünde bulundurularak bireyselleştirilmiş bir çalışma programı sunulur.

Ayrıca, öğrenciler diledikleri zaman seçtikleri ders konularına yönelik kaynak önerileri alarak, zamanlarını daha verimli kullanabilir ve hedeflerine odaklı şekilde çalışabilirler.

<h3> Uygulama şeması</h2>
<img src="/excalidraw.png" alt="Uygulama Tasarımı" width="2000" style="display: block; margin: auto;" />

### 🎥 Uygulama Tanıtım Videosu
 [Google Drive Tanıtım Videosu](https://drive.google.com/file/d/1LybLexOQIYUymIdgPKy_LxH4FuYACw3p/view?usp=sharing)
---


<h3>📱 Uygulama Figma Görselleri</h2>
<img src="/figma.png" alt="Uygulama Tasarımı" width="850" style="display: block; margin: auto;" />



---

## 🛠️ Kullanılan Teknolojiler

| Katman                | Teknoloji              |
|----------------------|------------------------|
| Frontend             | Flutter                |
| UI/UX Tasarım        | Figma                  |
| State Management     | Bloc / Cubit           |
| Kimlik Doğrulama     | JWT, Firebase Auth     |
| Backend (API)        | Node.js (Express)      |
| AI Backend           | Flask + Python         |
| AI Agents            | Crew AI, Serper API, Gemini 2.5 Flash |
| Veritabanı (local)   | Shared Preferences     |
| Konteynerleme        | Docker                 |
---

## 🎯 Proje Amacı ve Kapsamı

- **CrewAI**, **Serper API** ve **Google Gemini** kullanılarak internette arama yapabilen AI ajanlarının oluşturulması.
- **Dockerfile** ve **docker-compose.yaml** ile Flask tabanlı AI sunucusunun container içinde ayağa kaldırılması.
- **Mobil arayüz üzerinde kullanıcı işlemleri:**
  - E-posta/şifre ve Google ile giriş/kayıt.
  - JWT token ile güvenli kimlik doğrulama.
- **Ders yönetimi:**
  - Sınav tarihi, konu başlıkları ve zorluk derecesi gibi bilgileri ekleme.
  - Dersleri silme ve güncelleme işlemleri.
- **Yapay zekâ destekli çalışma planı:**
  - Eklenen ders içeriklerine göre haftalık çalışma planının otomatik oluşturulması.
  - Haftalık toplam saat, seans sayısı ve AI güven skorunun sunulması.
- **Anasayfa özellikleri:**
  - Günlük planların gösterimi.
  - Tamamlanma durumuna göre ilerleme yüzdesinin görselleştirilmesi.
- **Backend canlıya alma:**
  - Firebase Cloud Functions kullanılarak Node.js backend'in deploy edilmesi.
  - Oluşturulan API’lere HTTP istekleri gönderilmesi.

---

## 📂 Proje Dosya Yapısı

```
/backend
└── nodejs
    └── functions
        ├── routes
        │   ├── auth.js
        │   ├── lessons.js
        │   └── studyPlan.js
        │
        ├── utils
        │   └── verifyToken.js
        │
        └── index.js
```

```
/ai-agents
├── planner
│   ├── agent.py
│   ├── planner_service.py
│   └── prompts.py
│
├── app.py
├── config.py
└── requirements.txt
```

```
/frontend
│
├── lib
│   ├── core
│   │   ├── constants
│   │   ├── utils
│   │   ├── themes
│   │   └── widgets
│   │
│   ├── features
│   │   ├── auth
│   │   │   ├── data
│   │   │   │   ├── model
│   │   │   │   │   └── user_model.dart
│   │   │   │   └── services
│   │   │   │       └── auth_services.dart
│   │   │   ├── logic
│   │   │   │   ├── auth_cubit.dart
│   │   │   │   └── auth_state.dart
│   │   │   └── presentation
│   │   │       ├── pages
│   │   │       │   ├── login_page.dart
│   │   │       │   └── signup_page.dart
│   │   │       └── widgets
│   │   │
│   │   ├── calendar
│   │   │   ├── data
│   │   │   │   ├── model
│   │   │   │   │   ├── study_meta.dart
│   │   │   │   │   ├── study_plan.dart
│   │   │   │   │   └── study_session.dart
│   │   │   │   └── services
│   │   │   │       └── calendar_services.dart
│   │   │   ├── logic
│   │   │   │   ├── calendar_cubit.dart
│   │   │   │   └── calendar_state.dart
│   │   │   └── presentation
│   │   │       ├── pages
│   │   │       │   └── calendar_page.dart
│   │   │       └── widgets
│   │   │
│   │   ├── lessons
│   │   │   ├── data
│   │   │   │   ├── model
│   │   │   │   │   └── lessons.dart
│   │   │   │   └── services
│   │   │   │       └── lesson_services.dart
│   │   │   ├── logic
│   │   │   │   ├── lesson_cubit.dart
│   │   │   │   └── lesson_state.dart
│   │   │   └── presentation
│   │   │       ├── pages
│   │   │       │   └── lessons_page.dart
│   │   │       └── widgets
│   │   │
│   │   ├── settings
│   │   │   └── presentation
│   │   │       ├── pages
│   │   │       │   └── settings_page.dart
│   │   │       └── widgets
│   │   │
│   │   ├── splash
│   │   │   └── presentation
│   │   │       └── pages
│   │   │           └── splash_screen.dart
│   │   │
│   │   └── home
│   │       └── presentation
│   │           ├── pages
│   │           │   └── home_page.dart
│   │           └── widgets
│   │

```

---







