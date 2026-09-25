# tv_series (Ditonton)

Repository ini merupakan starter project submission kelas Flutter Expert Dicoding Indonesia.

---

## Fitur TV Series

Selain katalog film, aplikasi menampilkan katalog TV series yang dibangun dengan clean
architecture yang sama (layer `domain`, `data`, dan `presentation`).

| Fitur | Halaman | Route |
| ----------- | ----------- | ----------- |
| Daftar on the air, popular, dan top rated | `HomeTVPage` | `/home-tv` |
| Daftar popular | `PopularTVsPage` | `/popular-tv` |
| Daftar top rated | `TopRatedTVsPage` | `/top-rated-tv` |
| Detail series (poster, judul, rating, sinopsis, season, rekomendasi) | `TVDetailPage` | `/detail-tv` |
| Daftar episode pada sebuah season | `SeasonDetailPage` | `/detail-tv-season` |
| Pencarian judul melalui API TMDB | `SearchTVPage` | `/search-tv` |
| Watchlist yang disimpan pada SQLite | `WatchlistTVsPage` | `/watchlist-tv` |

Watchlist TV series disimpan pada tabel `watchlist_tv` di database `ditonton.db`, terpisah
dari watchlist film. Database dinaikkan ke versi 2 dan tabel baru dibuat lewat `onUpgrade`,
sehingga watchlist film yang sudah tersimpan tidak hilang.

## Menjalankan Testing

Unit test dan widget test dijalankan pada host:
```
flutter test
```

Integration test berada pada folder `integration_test/` dan membutuhkan perangkat atau
emulator yang aktif:
```
flutter test integration_test/app_test.dart
```
Integration test mengganti dua ujung aplikasi (HTTP client dan database watchlist) dengan
test double, sehingga alurnya berjalan tanpa jaringan dan hasilnya tidak berubah-ubah.

Apabila Anda mengubah kelas yang di-*mock*, jalankan ulang *code generator* berikut:
```
dart run build_runner build --delete-conflicting-outputs
```

## Tips Submission Awal

Pastikan untuk memeriksa kembali seluruh hasil testing pada submissionmu sebelum dikirimkan. Karena kriteria pada submission ini akan diperiksa setelah seluruh berkas testing berhasil dijalankan.


## Tips Submission Akhir

Jika kamu menerapkan modular pada project, Anda dapat memanfaatkan berkas `test.sh` pada repository ini. Berkas tersebut dapat mempermudah proses testing melalui *terminal* atau *command prompt*. Sebelumnya menjalankan berkas tersebut, ikuti beberapa langkah berikut:
1. Install terlebih dahulu aplikasi sesuai dengan Operating System (OS) yang Anda gunakan.
    - Bagi pengguna **Linux**, jalankan perintah berikut pada terminal.
        ```
        sudo apt-get update -qq -y
        sudo apt-get install lcov -y
        ```
    
    - Bagi pengguna **Mac**, jalankan perintah berikut pada terminal.
        ```
        brew install lcov
        ```
    - Bagi pengguna **Windows**, ikuti langkah berikut.
        - Install [Chocolatey](https://chocolatey.org/install) pada komputermu.
        - Setelah berhasil, install [lcov](https://community.chocolatey.org/packages/lcov) dengan menjalankan perintah berikut.
            ```
            choco install lcov
            ```
        - Kemudian cek **Environtment Variabel** pada kolom **System variabels** terdapat variabel GENTHTML dan LCOV_HOME. Jika tidak tersedia, Anda bisa menambahkan variabel baru dengan nilai seperti berikut.
            | Variable | Value|
            | ----------- | ----------- |
            | GENTHTML | C:\ProgramData\chocolatey\lib\lcov\tools\bin\genhtml |
            | LCOV_HOME | C:\ProgramData\chocolatey\lib\lcov\tools |
        
2. Untuk mempermudah proses verifikasi testing, jalankan perintah berikut.
    ```
    git init
    ```
3. Kemudian jalankan berkas `test.sh` dengan perintah berikut pada *terminal* atau *powershell*.
    ```
    test.sh
    ```
    atau
    ```
    ./test.sh
    ```
    Proses ini akan men-*generate* berkas `lcov.info` dan folder `coverage` terkait dengan laporan coverage.
4. Tunggu proses testing selesai hingga muncul web terkait laporan coverage.

