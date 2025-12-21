/// List of Indonesian cities for prayer time API
class IndonesianCities {
  static const List<String> cities = [
    // Jawa
    'Jakarta',
    'Surabaya',
    'Bandung',
    'Semarang',
    'Yogyakarta',
    'Solo',
    'Cirebon',
    'Bogor',
    'Bekasi',
    'Depok',
    'Tangerang',
    'Serang',
    'Purwokerto',
    'Cilacap',
    'Kebumen',
    'Pekalongan',
    'Kudus',
    'Jepara',
    'Salatiga',
    'Klaten',
    'Sukoharjo',
    'Wonogiri',
    'Karanganyar',
    'Blora',
    'Rembang',
    'Gresik',
    'Sidoarjo',
    'Lamongan',
    'Tuban',
    'Bojonegoro',
    'Jombang',
    'Nganjuk',
    'Kediri',
    'Tulungagung',
    'Trenggalek',
    'Malang',
    'Pasuruan',
    'Probolinggo',
    'Banyuwangi',
    'Bondowoso',
    'Situbondo',
    'Lumajang',
    
    // Sumatera
    'Aceh',
    'Banda Aceh',
    'Medan',
    'Deli Serdang',
    'Tebing Tinggi',
    'Pematangsiantar',
    'Asahan',
    'Tapanuli',
    'Langkat',
    'Penang',
    'Pekanbaru',
    'Jambi',
    'Palembang',
    'Bengkulu',
    'Lampung',
    'Bandar Lampung',
    'Padang',
    'Bukittinggi',
    'Payakumbuh',
    
    // Kalimantan
    'Pontianak',
    'Singkawang',
    'Sambas',
    'Banjarmasin',
    'Barito',
    'Sampit',
    'Pangkalan Bun',
    'Samarinda',
    'Balikpapan',
    'Bontang',
    'Palangka Raya',
    'Muara Teweh',
    'Tarakan',
    'Tanjung Selor',
    'Nunukan',
    
    // Sulawesi
    'Makassar',
    'Manado',
    'Bitung',
    'Palu',
    'Kendari',
    'Bau-Bau',
    'Gorontalo',
    'Mamuju',
    'Toli-Toli',
    'Luwuk',
    'Buol',
    'Kolonedale',
    'Manokwari',
    
    // Nusa Tenggara
    'Mataram',
    'Lombok',
    'Kupang',
    'Dili',
    'Labuhanbajo',
    'Ruteng',
    
    // Maluku
    'Ambon',
    'Ternate',
    'Tidore',
    'Manado',
    'Banda Neira',
    
    // Papua
    'Jayapura',
    'Manokwari',
    'Sorong',
    'Merauke',
    
    // Bali & NTT
    'Denpasar',
    'Ubud',
    'Sanur',
    'Kuta',
  ];

  /// Get city label with proper casing
  static String getCityLabel(String city) {
    return city;
  }

  /// Get default city
  static String getDefaultCity() {
    return 'Surabaya';
  }

  /// Check if city is valid
  static bool isValidCity(String city) {
    return cities.contains(city);
  }
}
