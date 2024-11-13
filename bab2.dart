// Enum FaseProyek untuk mendefinisikan fase proyek
enum FaseProyek { perencanaan, pengembangan, evaluasi }

// Kelas Karyawan yang menjadi superclass bagi berbagai jenis karyawan
class Karyawan {
  String nama;
  int umur;
  String peran;
  bool aktif = true;
  int produktivitas = 50;

  Karyawan(this.nama, {required this.umur, required this.peran});

  // Method untuk menandai karyawan resign
  void resign() {
    aktif = false;
  }

  // Metode untuk menampilkan karyawan sedang bekerja
  void bekerja() {
    print('$nama sedang bekerja sebagai $peran');
  }
}

// KaryawanTetap adalah turunan dari Karyawan dengan peran tetap
class KaryawanTetap extends Karyawan {
  KaryawanTetap(String nama, {required int umur, required String peran})
      : super(nama, umur: umur, peran: peran);
}

// KaryawanKontrak adalah turunan dari Karyawan dengan peran kontrak
class KaryawanKontrak extends Karyawan {
  KaryawanKontrak(String nama, {required int umur, required String peran})
      : super(nama, umur: umur, peran: peran);
}

// Manajer adalah subclass dari Karyawan dengan aturan khusus pada produktivitas
class Manajer extends Karyawan {
  Manajer(String nama, {required int umur})
      : super(nama, umur: umur, peran: "Manajer");

  // Override untuk memastikan produktivitas manajer tidak lebih dari 85
  @override
  void bekerja() {
    if (produktivitas > 85) {
      print('Produktivitas Manajer tidak boleh lebih dari 85!');
    } else {
      print(
          '$nama sedang bekerja sebagai Manajer dengan produktivitas $produktivitas');
    }
  }
}

// Mixin Kinerja untuk menambah dan mengupdate produktivitas karyawan
mixin Kinerja on Karyawan {
  DateTime waktuTerakhirUpdate = DateTime.now();

  // Metode untuk mengupdate produktivitas, hanya bisa dilakukan setiap 30 hari
  void updateProduktivitas(int nilai) {
    DateTime sekarang = DateTime.now();
    if (sekarang.difference(waktuTerakhirUpdate).inDays >= 30) {
      produktivitas = (nilai < 0)
          ? 0
          : (nilai > 100)
              ? 100
              : nilai;
      waktuTerakhirUpdate = sekarang;
      print('Produktivitas diperbarui menjadi $produktivitas');
    } else {
      print("Produktivitas hanya dapat diperbarui setiap 30 hari.");
    }
  }
}

// Kelas Perusahaan untuk mengelola karyawan aktif dan non-aktif
class Perusahaan {
  List<Karyawan> karyawanAktif = [];
  List<Karyawan> karyawanNonAktif = [];
  final int batasMaksimal = 20;

  // Menambah karyawan aktif jika jumlahnya belum mencapai batas
  void tambahKaryawan(Karyawan karyawan) {
    if (karyawanAktif.length < batasMaksimal) {
      karyawanAktif.add(karyawan);
      print('Karyawan ${karyawan.nama} berhasil ditambahkan.');
    } else {
      print('Batas maksimal karyawan aktif tercapai.');
    }
  }

  // Menghapus karyawan dan memindahkannya ke daftar non-aktif
  void resignKaryawan(Karyawan karyawan) {
    karyawanAktif.remove(karyawan);
    karyawanNonAktif.add(karyawan);
    print(
        'Karyawan ${karyawan.nama} telah resign dan dipindahkan ke daftar non-aktif.');
  }
}

// Kelas Produk untuk mendefinisikan produk yang dijual di perusahaan
class Produk {
  String namaProduk;
  double harga;
  String kategori;
  int jumlahTerjual = 0;

  Produk(this.namaProduk, this.harga, this.kategori) {
    // Validasi harga produk berdasarkan kategori
    if (kategori == "NetworkAutomation" && harga < 200000) {
      throw Exception("Harga NetworkAutomation harus minimal 200.000");
    } else if (kategori == "DataManagement" && harga >= 200000) {
      throw Exception("Harga DataManagement harus di bawah 200.000");
    }
  }

  // Terapkan diskon jika produk memenuhi syarat
  void terapkanDiskon() {
    if (kategori == "NetworkAutomation" && jumlahTerjual > 50) {
      double hargaDiskon = harga * 0.15;
      harga = hargaDiskon >= 200000 ? hargaDiskon : 200000;
      print("Harga setelah diskon: $harga");
    }
  }
}

// Kelas Proyek untuk mengelola fase dan anggota proyek
class Proyek {
  String namaProyek;
  FaseProyek fase = FaseProyek.perencanaan;
  List<Karyawan> anggotaTim = [];
  DateTime tanggalMulai = DateTime.now();

  Proyek(this.namaProyek);

  // Menambah anggota tim pada proyek
  void tambahAnggotaTim(Karyawan karyawan) {
    if (anggotaTim.length < 20) {
      anggotaTim.add(karyawan);
      print('Anggota tim ${karyawan.nama} berhasil ditambahkan ke proyek.');
    } else {
      print('Tidak dapat menambah lebih dari 20 anggota tim.');
    }
  }

  // Melanjutkan fase proyek berdasarkan kriteria yang ada
  void lanjutKeFaseBerikutnya() {
    if (fase == FaseProyek.perencanaan && anggotaTim.length >= 5) {
      fase = FaseProyek.pengembangan;
      print('Proyek $namaProyek memasuki fase Pengembangan.');
    } else if (fase == FaseProyek.pengembangan &&
        DateTime.now().difference(tanggalMulai).inDays > 45) {
      fase = FaseProyek.evaluasi;
      print('Proyek $namaProyek memasuki fase Evaluasi.');
    }
  }
}

void main() {
  // Produk
  var produk1 = Produk("Sistem Manajemen Data", 150000, "DataManagement");
  var produk2 = Produk("Sistem Otomasi Jaringan", 250000, "NetworkAutomation");

  // Menampilkan detail produk sebelum diskon
  print("Nama Produk: ${produk1.namaProduk}, Harga: ${produk1.harga}");
  print("Nama Produk: ${produk2.namaProduk}, Harga: ${produk2.harga}");

  // Terapkan diskon jika memenuhi syarat
  produk2.jumlahTerjual = 60; // Misal produk2 sudah terjual lebih dari 50 unit
  produk2.terapkanDiskon();

  // Membuat beberapa karyawan
  var karyawan1 = KaryawanTetap("Farida Rustam", umur: 19, peran: "Pengembang");
  var karyawan2 = KaryawanKontrak("Agat", umur: 21, peran: "InsinyurJaringan");
  var karyawan3 = Manajer("Iring", umur: 20);

  // Menampilkan info karyawan
  print(
      "Karyawan 1: ${karyawan1.nama}, Umur: ${karyawan1.umur}, Peran: ${karyawan1.peran}");
  print(
      "Karyawan 2: ${karyawan2.nama}, Umur: ${karyawan2.umur}, Peran: ${karyawan2.peran}");
  print(
      "Karyawan 3: ${karyawan3.nama}, Umur: ${karyawan3.umur}, Peran: ${karyawan3.peran}");

  // Membuat perusahaan dan menambahkan karyawan
  var perusahaan = Perusahaan();
  perusahaan.tambahKaryawan(karyawan1);
  perusahaan.tambahKaryawan(karyawan2);
  perusahaan.tambahKaryawan(karyawan3);

  // Menampilkan jumlah karyawan aktif di perusahaan
  print("Jumlah karyawan aktif: ${perusahaan.karyawanAktif.length}");

  // Membuat proyek baru
  var proyek = Proyek("Proyek Transformasi Digital");
  proyek.tambahAnggotaTim(karyawan1);
  proyek.tambahAnggotaTim(karyawan2);
  proyek.tambahAnggotaTim(karyawan3);

  // Lanjutkan fase proyek jika memenuhi syarat
  proyek.lanjutKeFaseBerikutnya();
}
