# 📚 NusaBookstore

Aplikasi toko buku digital berbasis Flutter yang menerapkan **State Management menggunakan Provider**. Dibangun sebagai tugas PPM Sesi 3 dengan menampilkan katalog buku nusantara, keranjang belanja interaktif, dan dukungan Light/Dark Mode.

---

## ✨ Fitur Utama

| Fitur | Deskripsi |
|-------|-----------|
| 📖 Katalog Buku | Menampilkan 6 buku pilihan dengan informasi lengkap |
| 🛒 Keranjang Belanja | Tambah, kurangi, dan hapus buku dari keranjang |
| 🔢 Badge Keranjang | Ikon keranjang di AppBar dengan jumlah item real-time |
| 💰 Total Harga | Kalkulasi otomatis total harga dalam format Rupiah |
| 🌙 Dark/Light Mode | Toggle tema yang berlaku di seluruh aplikasi |
| ✅ Checkout | Konfirmasi pembayaran dengan SnackBar notifikasi |
| 📱 Responsive | Tampilan yang nyaman di berbagai ukuran layar |

---

## 🏗️ Struktur Folder

```
lib/
├── models/
│   └── book.dart           # Model Book dengan data sample
├── providers/
│   ├── cart_provider.dart  # State management keranjang belanja
│   └── theme_provider.dart # State management tema aplikasi
├── screens/
│   ├── catalog_screen.dart # Halaman katalog buku
│   └── cart_screen.dart    # Halaman keranjang belanja
└── main.dart               # Entry point + MultiProvider setup
```

---

## 🧩 Konsep/Widget yang Digunakan

- `MaterialApp` — Root aplikasi dengan konfigurasi tema
- `Scaffold` — Layout dasar setiap halaman
- `AppBar` — Navigasi dengan badge keranjang dan toggle tema
- `Card` — Tampilan setiap buku di katalog dan keranjang
- `ListView` — Daftar buku scrollable
- `Row` & `Column` — Layout horizontal dan vertikal
- `Consumer<T>` — Rebuild widget saat state berubah
- `context.watch<T>()` — Membaca state dan subscribe perubahan
- `context.read<T>()` — Melakukan aksi tanpa rebuild
- `ChangeNotifier` — Base class CartProvider dan ThemeProvider
- `MultiProvider` — Mendaftarkan banyak provider di root

---

## 📦 Provider

### CartProvider
```dart
class CartProvider extends ChangeNotifier {
  void addItem(Book book)     // Tambah buku / increment jumlah
  void removeItem(String id)  // Kurangi jumlah / hapus buku
  void clearCart()            // Kosongkan keranjang
  int get totalItems          // Total jumlah buku
  double get totalPrice       // Total harga semua buku
}
```

### ThemeProvider
```dart
class ThemeProvider extends ChangeNotifier {
  void toggleTheme()          // Ganti Light ↔ Dark Mode
  ThemeMode get themeMode     // Mode tema aktif
  bool get isDarkMode         // Status mode gelap
}
```

---

## 🎥 Video Demo Aplikasi

> 📹 **Demonstrasi Interaktif NusaBookstore:**  
> Menampilkan implementasi State Management Provider (`CartProvider` & `ThemeProvider`), katalog buku, search & filter, penambahan item keranjang realtime, dan alur checkout.

<video src="https://github.com/eman-spec/tugas-PPM-sesi-3/raw/main/demo.mp4" controls width="100%" poster="https://raw.githubusercontent.com/eman-spec/tugas-PPM-sesi-3/main/web/icons/Icon-512.png">
  Browser Anda tidak mendukung tag video. Silakan tonton melalui link di bawah.
</video>

### 🎬 [▶️ Klik di sini untuk Memutar / Download Video Demo (`demo.mp4`)](https://github.com/eman-spec/tugas-PPM-sesi-3/raw/main/demo.mp4)

---

## 🚀 Cara Menjalankan

1. **Clone repository:**
   ```bash
   git clone https://github.com/eman-spec/tugas-PPM-sesi-3.git
   cd nusa_bookstore
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Jalankan aplikasi:**
   ```bash
   flutter run
   ```

---

## 📋 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.1.2      # State Management
  intl: ^0.19.0         # Format Rupiah
```

---

## 👨‍💻 Informasi

**Mata Kuliah:** Pemrograman Perangkat Mobile (PPM)  
**Sesi:** 3 — State Management dengan Provider  
**Framework:** Flutter  
**Bahasa:** Dart  
