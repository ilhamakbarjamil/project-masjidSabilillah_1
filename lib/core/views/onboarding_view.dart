import 'package:concentric_transition/concentric_transition.dart';
import 'package:flutter/material.dart';
import '../../features/announcements/views/announcement_list_view.dart';

// Model Data Halaman
class PageData {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color bgColor;
  final Color textColor;

  const PageData({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.bgColor,
    required this.textColor,
  });
}

// Daftar Halaman Onboarding
final pages = [
  // HALAMAN 1: Info Umum
  const PageData(
    icon: Icons.mosque_outlined,
    title: "Informasi Terkini\nMasjid Kita",
    subtitle: "Dapatkan info kajian, jadwal sholat, dan pengumuman penting langsung di genggaman.",
    bgColor: Color(0xFF33CC99), // Warna Primary App
    textColor: Colors.white,
  ),
  
  // HALAMAN 2: Fitur Ramadhan (FOKUS DI SINI)
  const PageData(
    icon: Icons.calendar_month_outlined, // Ikon yang sama dengan tombol di AppBar
    title: "Mode Spesial\nRamadhan",
    subtitle: "Cek jadwal Tarawih & Takjil. \n\n👉 Klik tombol Kalender di POJOK KANAN ATAS pada halaman utama.",
    bgColor: Color(0xFF0F2027), // Warna Tema Ramadhan
    textColor: Colors.amber,    // Warna Emas
  ),

  // HALAMAN 3: Selesai
  const PageData(
    icon: Icons.check_circle_outline,
    title: "Mari\nDimulai",
    subtitle: "Jadikan ibadah lebih teratur dan informasi lebih transparan.",
    bgColor: Colors.white,
    textColor: Color(0xFF33CC99),
  ),
];

class OnboardingView extends StatelessWidget {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: ConcentricPageView(
        colors: pages.map((p) => p.bgColor).toList(),
        radius: screenWidth * 0.1,
        // Animasi transisi
        curve: Curves.ease,
        duration: const Duration(seconds: 1),
        
        // Aksi Tombol Next
        nextButtonBuilder: (context) => Padding(
          padding: const EdgeInsets.only(left: 3),
          child: Icon(Icons.navigate_next, size: screenWidth * 0.08),
        ),
        
        // Agar tidak infinite scroll, kita batasi item count
        // Saat user swipe di halaman terakhir, kita pindah ke Home
        itemCount: pages.length,
        onFinish: () {
          // Navigasi ke Halaman Utama dan hapus Onboarding dari history
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const AnnouncementListView()),
          );
        },

        itemBuilder: (index) {
          final page = pages[index % pages.length];
          return SafeArea(child: _Page(page: page));
        },
      ),
    );
  }
}

class _Page extends StatelessWidget {
  final PageData page;

  const _Page({required this.page});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // IKON DALAM LINGKARAN
          Container(
            padding: const EdgeInsets.all(20.0),
            margin: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: page.textColor, // Warna background icon kontras
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                )
              ]
            ),
            child: Icon(
              page.icon, 
              size: screenHeight * 0.08, 
              color: page.bgColor, // Warna icon mengikuti warna background page
            ),
          ),
          
          const SizedBox(height: 20),

          // JUDUL
          Text(
            page.title,
            style: TextStyle(
              color: page.textColor,
              fontSize: screenHeight * 0.04,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 16),

          // SUBTITLE / PENJELASAN
          Text(
            page.subtitle,
            style: TextStyle(
              color: page.textColor.withOpacity(0.8),
              fontSize: 16,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          
          // Khusus Halaman Ramadhan, tambahkan visualisasi panah/petunjuk jika perlu
          if (page.title.contains("Ramadhan")) ...[
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(color: page.textColor, width: 1),
                borderRadius: BorderRadius.circular(8)
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.arrow_upward, size: 16, color: page.textColor),
                  const SizedBox(width: 8),
                  Text(
                    "Lihat Pojok Kanan Atas", 
                    style: TextStyle(color: page.textColor, fontSize: 12)
                  ),
                ],
              ),
            )
          ]
        ],
      ),
    );
  }
}