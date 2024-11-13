// Kelas User untuk menyimpan informasi pengguna (User)
class User {
  String name;  // Nama pengguna
  int age;  // Umur pengguna
  List<Product> products;  // Daftar produk yang dimiliki oleh pengguna
  Role? role;  // Peran pengguna, bisa Admin atau Customer

  // Konstruktor untuk menginisialisasi nama, umur, dan peran pengguna
  User(this.name, this.age, this.role) : products = [];  // Inisialisasi daftar produk kosong
}

// Kelas Product untuk menyimpan informasi produk
class Product {
  String productName;  // Nama produk
  double price;  // Harga produk
  bool inStock;  // Status ketersediaan produk (tersedia atau habis)

  // Konstruktor untuk menginisialisasi produk dengan nama, harga, dan stok
  Product(this.productName, this.price, this.inStock);

  // Override operator == untuk membandingkan objek Product berdasarkan atributnya
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;  // Jika objek sama persis
    return other is Product &&
        other.productName == productName &&  // Periksa apakah nama produk sama
        other.price == price &&  // Periksa apakah harga sama
        other.inStock == inStock;  // Periksa apakah stok sama
  }

  // Override hashCode untuk menghasilkan nilai hash berdasarkan atribut produk
  @override
  int get hashCode => productName.hashCode ^ price.hashCode ^ inStock.hashCode;
}

// Enum untuk mendefinisikan dua peran pengguna: Admin dan Customer
enum Role { Admin, Customer }

// Kelas AdminUser yang merupakan turunan dari User
class AdminUser extends User {
  // Konstruktor AdminUser, mewarisi konstruktor User
  AdminUser(String name, int age) : super(name, age, Role.Admin);

  // Method untuk menambahkan produk ke daftar produk admin
  void tambahProduk(Product product) {
    if (product.inStock) {
      products.add(product);  // Menambahkan produk jika tersedia di stok
      print("\n===== INFO LAPORAN TAMBAH PRODUK =====");
      print('${product.productName} berhasil ditambahkan ke daftar produk.');
    } else {
      // Jika produk tidak tersedia di stok
      print(
          '${product.productName} tidak tersedia dalam stok dan tidak dapat ditambahkan.');
    }
  }

  // Method untuk menghapus produk dari daftar produk admin
  void hapusProduk(Product product) {
    products.remove(product);  // Menghapus produk dari daftar produk
    print("\n===== INFO LAPORAN HAPUS PRODUK =====");
    print('${product.productName} berhasil dihapus dari daftar produk.');
  }
}

// Kelas CustomerUser yang merupakan turunan dari User
class CustomerUser extends User {
  // Konstruktor CustomerUser, mewarisi konstruktor User
  CustomerUser(String name, int age) : super(name, age, Role.Customer);

  // Method untuk melihat daftar produk yang tersedia
  void lihatProduk() {
    print('\nDaftar Produk Tersedia:');
    for (var product in products) {
      // Menampilkan nama, harga, dan status stok produk
      print('${product.productName} - Rp${product.price} - ${product.inStock ? "Tersedia" : "Habis"}');
    }
  }
}

// Fungsi untuk mengambil detail produk secara asinkron
Future<void> fetchProductDetails() async {
  print('Mengambil detail produk...');
  await Future.delayed(Duration(seconds: 2));  // Simulasi delay 2 detik
  print('Detail produk berhasil diambil.');
}

void main() async {  // Menambahkan async di main untuk menjalankan operasi asinkron
  // Membuat instance AdminUser dan CustomerUser
  AdminUser admin = AdminUser('Alice', 30);
  CustomerUser customer = CustomerUser('Bob', 25);

  // Membuat beberapa produk
  Product product1 = Product('Laptop', 15000000.0, true);
  Product product2 = Product('Handphone1', 8000000.0, false);  // Produk habis
  Product product3 = Product('Handphone2', 8000000.0, true);

  /* Menggunakan try-catch untuk menangani kemungkinan error saat manipulasi produk*/
  try {
    // Admin menambahkan dan menghapus produk
    admin.tambahProduk(product1);
    admin.hapusProduk(product2);  // Menghapus produk yang tidak tersedia
    admin.tambahProduk(product3);
  } on Exception catch (e) {
    print('Kesalahan: $e');  // Menangkap dan menampilkan error jika ada
  }

  // Customer melihat produk yang tersedia
  customer.lihatProduk();

  // Pengambilan data produk secara asinkron
  await fetchProductDetails();  // Pastikan menunggu hasil pengambilan data

  // Menggunakan Map untuk menyimpan produk berdasarkan nama produk
  Map<String, Product> productMap = {
    product1.productName: product1,
    product2.productName: product2,
    product3.productName: product3,
  };

  // Menampilkan produk dari Map
  productMap.forEach((key, value) {
    print('${key} - Harga: Rp${value.price} - Stok: ${value.inStock ? "Tersedia" : "Habis"}');
  });

  // Menggunakan Set untuk menyimpan produk unik tanpa duplikasi
  Set<Product> productSet = {product1, product2, product3};
  print('\nDaftar Produk dari Set:');
  productSet.forEach((product) {
    // Menampilkan produk dari Set
    print('${product.productName} - Harga: Rp${product.price} - Stok: ${product.inStock ? "Tersedia" : "Habis"}');
  });
}

