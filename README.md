lib/
├── 🧱 core/                     # Folder untuk kode inti yang dipakai bersama
│   ├── constants/
│   │   └── app_colors.dart      # 🎨 Daftar warna aplikasi (Primary, Background, dll)
│   ├── services/
│   │   └── supabase_service.dart # 🔌 Jembatan koneksi ke Database Supabase
│   └── views/
│       └── onboarding_view.dart  # 📱 Tampilan Pengenalan Awal (Slide Geser)
│
├── 🚀 features/                 # Folder Fitur (Setiap fitur punya folder sendiri)
│   │
│   ├── 📢 announcements/        # FITUR 1: Pengumuman Masjid (CRUD Utama)
│   │   ├── controllers/         # 🧠 LOGIKA: Mengatur state (Loading, Error, Data List)
│   │   │   └── announcement_controller.dart
│   │   ├── models/              # 📝 BLUEPRINT: Bentuk data dari Database ke Aplikasi
│   │   │   └── announcement_model.dart
│   │   ├── repositories/        # 🤝 KOMUNIKASI: Fungsi Insert, Update, Delete ke Supabase
│   │   │   └── announcement_repository.dart
│   │   └── views/               # 👁️ TAMPILAN (UI) PENGUMUMAN
│   │       ├── announcement_list_view.dart   # Halaman Utama (List Kartu)
│   │       ├── announcement_detail_view.dart # Halaman Detail per Item
│   │       └── announcement_form_view.dart   # Halaman Form (Input/Edit)
│   │
│   └── 🌙 ramadhan/             # FITUR 2: Agenda Ramadhan (Database Terpisah)
│       ├── models/              # 📝 Blueprint data jadwal Ramadhan
│       │   └── ramadhan_model.dart
│       ├── repositories/        # 🤝 Fungsi CRUD khusus tabel Ramadhan
│       │   └── ramadhan_repository.dart
│       └── views/               # 👁️ TAMPILAN (UI) RAMADHAN
│           └── ramadhan_view.dart            # Halaman List & Form Jadwal Ramadhan
│
├── 🏁 main.dart                 # Pintu masuk aplikasi (Inisialisasi Awal)
└── ⚙️ .env                       # File rahasia (URL & Key Supabase) - JANGAN DI-UPLOAD KE GITHUB