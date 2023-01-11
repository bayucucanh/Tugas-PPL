# Prima Academy Mobile

Aplikasi Belajar Sepak Bola yang Benar hanya di Prima Academy
Dimulai dari video pembelajaran (e-Learning), Konsultasi dengan Pelatih, hingga Tes Kemampuan Sepak Bola dengan adaptasi Sport Science)

## Getting Started

Untuk memulai development, gunakan staging untuk melakukan percobaan.

## How To Test

Untuk menggunakan test jalankan perintah dibawah ini pada terminal

```
flutter run test
```

Untuk melakukan pengecekan coverage gunakan perintah dibawah ini :

```
flutter test --coverage

// Untuk men-generate html test apa saja yang belum dilakukan dan melihat keseluruhan report test

genhtml coverage/lcov.info -o coverage/html

// Untuk membuka halaman coverage

open coverage/html/index.html
```
