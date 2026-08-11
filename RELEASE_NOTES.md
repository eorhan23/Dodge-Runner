# Sürüm Notları

Dodge Runner'ın sürüm geçmişi. Sürüm kapsamlarının gerekçesi için bkz. [docs/Roadmap.md](docs/Roadmap.md).

---

## v2 — Çeşitlilik ve Derinlik

**Dal:** `prd-v2`

Bu sürümün amacı tekrar oynanabilirliği artırmaktır: her tur birbirinden farklı geçer.

### Yenilikler

**Karakter seçimi**

- 6 karakter seçeneği (mavi, yeşil, turuncu, mor, beyaz, sarı)
- Her karakterin 3 kareli koşma animasyonu; animasyon hızı oyun hızıyla birlikte artar
- Seçim kalıcıdır, oyun kapatılıp açıldığında korunur

**Güç yükseltmeleri**

Üç tür, her biri üç kademeli:

| Tür | Kademe 1 | Kademe 2 | Kademe 3 |
|---|---|---|---|
| Kalkan | 1 dokunulmazlık | 2 dokunulmazlık | 3 dokunulmazlık |
| Zaman | %20 yavaşlatma | %30 yavaşlatma | %40 yavaşlatma |
| Skor çarpanı | 2x | 3x | 4x |

- Etki süresi kademeye bağlıdır ve türden bağımsızdır: 7 / 10 / 13 saniye
- Daire rengi kademeyi gösterir (yeşil / mavi / kırmızı); tür ikondan veya çarpan yazısından anlaşılır
- Güçlü kademeler daha nadir çıkar
- Sol üstte aktif etkileri kademe renginde listeleyen gösterge
- Kalkan aktifken karakterin etrafında görsel halka

**Tasarım kararı:** Zaman yavaşlatma yalnızca dış dünyayı etkiler. Zıplama fiziği ve skor kazanımı gerçek zamanda kalır — böylece buff, engelleri aşmayı gerçekten kolaylaştırır.

### Düzeltmeler

- **Kaçılamaz engel kombinasyonu giderildi.** Engeller arası boşluk artık sabit bir piksel mesafesi değil; hem **zaman** hem **piksel** cinsinden ölçülüp büyük olanı uygulanır. Zaman ölçütü hızlı oyunu korur (zıplama süresi oyun hızından bağımsız sabit olduğu için, sabit piksel mesafesi yüksek hızlarda kaçışı imkânsız kılıyordu); piksel ölçütü yavaş oyunu korur (süre olarak yeterli bir boşluk, yavaşken ekranda dip dibe görünüp iki engeli tek küme gibi gösteriyordu).
- **Gereken boşluk önceki engelin türüne göre belirlenir.** Zemin engelinden sonra oyuncu 0.8 sn havada kalır ve eğilemez; tavan engelinden sonra ise eğilme bırakılır bırakılmaz zıplayabilir. İkisine aynı süreyi dayatmak oyunu gereksiz yere seyrekleştiriyordu.
- **Güç yükseltmeleri artık engel içinde veya dibinde çıkmıyor.** Koruma iki yönlüdür: hem yerleştirme sırasında mevcut engeller kontrol edilir, hem de yakında bir güç yükseltmesi varken engel üretimi kısa süre ertelenir.
- **Karakter seçimi ile ses/tuş ayarları birbirinin kaydını siliyordu.** Her iki modül de `settings.cfg` dosyasını ayrı birer kopya üzerinden kullandığı için, biri kaydettiğinde diğerinin bellekteki eski kopyası dosyayı geri alıyordu. Artık her yazma işleminden önce dosya diskten yeniden okunur.
- Engele çarpma anında ayrı bir ses efekti eklendi.
- Karakter eğilirken koşma animasyonu devam ediyor; havadayken tek kareye sabitleniyor.

### Yeni Özellik: Oyunu Sıfırla

Ayarlar ekranına, tüm kalıcı veriyi (istatistikler, tuş atamaları, ses seviyeleri, karakter seçimi) silen bir seçenek eklendi. İşlem geri alınamadığı için onay adımı vardır.

---

## v1 — Kullanıcı Deneyimi Katmanı

**Dal:** `prd-v1` · **Etiket:** `v1`

Bu sürümün amacı, oyunu tek seferlik bir demodan tekrar açılmaya değer bir uygulamaya dönüştürmektir. Ortak tema kalıcılık ve kontroldür.

### Yenilikler

**Ana menü ve zorluk seviyeleri**

- Kolay / Normal / Zor seçenekleri; her biri farklı başlangıç hızı, hız üst sınırı ve üretim aralığı kullanır
- Menüden oyuna ve oyundan menüye akış

**Ses ve müzik**

- Zıplama ve ölüm ses efektleri
- Arayüz sesleri (tıklama, oyun başlatma)
- Döngülü arka plan müziği — menüde sessiz, ölünce durur
- Müzik ve efektler için ayrı ses seviyesi ayarı

**Kayan arka plan**

- Tek arka plan görseli kesintisiz yatay akar; hızı oyunun zorluk çarpanıyla eşleşir

**Yerel istatistikler**

- En yüksek skor, oynanan tur sayısı, ortalama hayatta kalma süresi, son 5 turun skoru
- Her zorluk seviyesi için ayrı tutulur; menüde seçili seviyenin verileri gösterilir

**Kontrol çeşitliliği**

- Boşluk tuşuyla da zıplama
- Ayarlar ekranından tuş atamalarını değiştirme
- Varsayılana sıfırlama seçeneği

### Teknik Notlar

- Kalıcı veri Godot'un `ConfigFile` sınıfıyla saklanır: `user://stats.cfg` ve `user://settings.cfg`. Veritabanı kullanılmaz.
- Motorun `ui_*` aksiyonları değiştirilmez; oyun kendi `jump` / `duck` aksiyonlarını tanımlar.

---

## MVP — Oynanabilir Çekirdek

**Dal:** `main` · **Etiket:** `mvp`

İlk çalışan sürüm. Oyun döngüsünün uçtan uca kurulması hedeflenmiştir: oyna, öl, tekrar başla.

### Kapsam

- Sabit x-konumunda koşan karakter; zıplama ve eğilme mekaniği
- Sağdan sola akan engeller: zemin engeli, tavandan sarkan engel, çift engel, hızlı engel
- Kademeli zorluk artışı — her 10 saniyede hız artar ve üretim aralığı kısalır, tanımlı üst/alt sınırlarla
- Hayatta kalınan süreye dayalı skor (saniyede 10 puan)
- Çarpışma tespiti, oyun sonu ekranı ve yeniden başlatma
- Pixel-art görseller ve tur başında kontrol talimatı

### Teknik Kararlar

- Çarpışma fizik motoru yerine `Area2D` sinyalleriyle yapılır — daha öngörülebilir ve bu kapsam için yeterli
- Fiziksel bir zemin gövdesi yoktur; dikey konum mantıksal bir zemin sabitiyle yönetilir
- Karakter hareket etmez, dünya hareket eder
