# 🎸 FFmpeg Matrix Audio Visualizer

Sebuah skrip otomatisasi berbasis **FFmpeg** untuk mengubah file audio (MP3) menjadi video visualizer estetik dengan nuansa *Matrix Green*. Skrip ini mendukung pemrosesan massal dari file lokal maupun daftar URL.

## ✨ Fitur Utama
- **Batch Processing**: Render otomatis seluruh folder MP3 atau daftar URL dalam satu klik.
- **Smart Background**: 
  - Menggunakan gambar spesifik jika nama file cocok (`lagu1.mp3` -> `lagu1.jpg`).
  - Menggunakan `images.webp` sebagai fallback global.
  - Latar belakang hitam solid otomatis jika tidak ada gambar tersedia.
- **Visualizer Dinamis**: Waveform audio berwarna hijau Matrix yang responsif.
- **Auto-Title**: Judul video diambil otomatis dari nama file atau ujung URL.
- **Streaming Support**: Mendukung render langsung dari *direct link* audio tanpa download manual.

## 🛠️ Persyaratan
1. **FFmpeg**: Pastikan FFmpeg terinstall dan terdaftar di *System Path* Anda.
2. **Windows OS**: Skrip menggunakan format `.bat` untuk Command Prompt.

## 🚀 Cara Penggunaan

### 1. Render File Lokal (MP3 + Gambar)
1. Letakkan semua file `.mp3` di folder utama.
2. (Opsional) Tambahkan gambar `.jpg`, `.png`, atau `.webp`.
3. Jalankan `auto_render.bat`.
4. Hasil render akan muncul di folder `output/`.

### 2. Render dari URL (list.txt)
1. Buat file bernama `list.txt`.
2. Masukkan URL langsung file MP3 (satu per baris).
3. Jalankan `render_url.bat`.

## 📁 Struktur Folder
```text
.
├── output/              # Hasil render video (.mp4)
├── images.webp          # Gambar latar belakang default
├── auto_render.bat      # Skrip untuk file lokal
├── render_url.bat       # Skrip untuk daftar URL
├── list.txt             # Daftar link audio
└── [Daftar MP3 Kamu]

## 🛠️ Troubleshooting

| Masalah | Solusi |
| :--- | :--- |
| **'ffmpeg' is not recognized** | Pastikan FFmpeg sudah terinstal dan path folder `bin` miliknya sudah didaftarkan di Environment Variables Windows. |
| **Protocol not found (URL)** | Pastikan Anda menggunakan versi FFmpeg terbaru (v4.0+) yang dikompilasi dengan dukungan SSL/HTTPS. |
| **Teks Berantakan** | Jika judul file terlalu panjang, kurangi ukuran `fontsize` di dalam skrip `.bat` atau perpendek nama file MP3. |
| **Gambar Tidak Muncul** | Pastikan nama file gambar sama persis dengan nama file MP3 (termasuk huruf kapital/kecil). |
| **Render Berhenti Tengah Jalan** | Biasanya terjadi pada render URL karena koneksi internet yang tidak stabil (timeout). Coba jalankan ulang skrip. |

## 📜 License

Proyek ini dilisensikan di bawah **MIT License**.

**Ringkasan MIT License:**
- ✅ **Boleh** digunakan untuk keperluan komersial.
- ✅ **Boleh** dimodifikasi dan didistribusikan ulang.
- ✅ **Boleh** digunakan secara pribadi.
- ⚠️ **Wajib** mencantumkan hak cipta dan izin asli dalam setiap salinan perangkat lunak.
- ❌ **Tidak ada jaminan**: Penulis tidak bertanggung jawab atas masalah yang timbul dari penggunaan perangkat lunak ini.

---