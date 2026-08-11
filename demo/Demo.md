# Demo.md

Bu dosya, Dodge Runner'ın nasıl çalıştırılacağını ve sunum sırasında izlenecek demo senaryosunu anlatır.

## Çalıştırma

**Gereksinim:** Godot 4.x (masaüstü sürümü). Ek bağımlılık, kurulum adımı veya internet bağlantısı gerekmez.

1. Godot Editor'ı aç.
2. **Import** ile `src/project.godot` dosyasını seç.
3. Projeyi çalıştır (**F5**).

Oyun `MainMenu.tscn` sahnesiyle açılır.

## Kontroller

| Tuş | İşlev |
|---|---|
| Yukarı Ok veya Boşluk | Zıpla |
| Aşağı Ok | Eğil |

Tuş atamaları Ayarlar ekranından değiştirilebilir.

## Demo Senaryosu

Aşağıdaki sıra, projenin üç sürümünde eklenen özellikleri sırayla gösterecek şekilde düzenlenmiştir.

### 1. Ana Menü (v1)

- Zorluk seçeneklerini göster: **Kolay / Normal / Zor**.
- Sağdaki istatistik panelini göster. Zorluk değiştirildiğinde panelin de değiştiğine dikkat çek — istatistikler seviye bazında ayrı tutulur.
- Karakter seçim kutucuklarını göster (v2): 6 karakter.

### 2. Temel Oyun Döngüsü (MVP)

- **Normal** zorlukta bir tur başlat.
- Zıplama ve eğilme mekaniğini göster: alt engeller zıplanarak, üst engeller eğilerek geçilir.
- Karakterin sabit x-konumunda kaldığını, dünyanın hareket ettiğini belirt.
- Skorun süreyle arttığını göster.
- Oyun ilerledikçe hızın kademeli arttığını göster.

### 3. Ses ve Görsel Katman (v1)

- Zıplama, çarpışma ve arka plan müziğini duyur.
- Arka planın kesintisiz kaydığını ve hızının oyun hızıyla eşleştiğini göster.

### 4. Güç Yükseltmeleri (v2)

Bir turda mümkünse üç türü de göster:

- **Kalkan** — toplandığında karakterin etrafında halka belirir; engele çarpıldığında oyuncu ölmez, engel yok olur ve bir hak eksilir.
- **Zaman** — dış dünya yavaşlar, ancak zıplama gerçek hızda kalır. Bu bilinçli bir tasarım kararıdır: buff'ın faydası, engelleri daha rahat aşabilmektir.
- **Skor çarpanı** — skor kazanımı hızlanır.

Daire renginin **kademeyi** gösterdiğini vurgula: yeşil (1) < mavi (2) < kırmızı (3). Türü ise ikon veya çarpan yazısı belirtir. Sol üstteki gösterge, aktif etkiyi kendi kademe renginde listeler.

### 5. Oyun Sonu ve Kalıcılık

- Bir engele çarparak turu bitir; final skorunu göster.
- "Tekrar Oyna" ile temiz bir başlangıç yapıldığını göster.
- Ana menüye dön; istatistiklerin güncellendiğini göster.
- **Oyunu kapatıp yeniden aç** — istatistiklerin, karakter seçiminin ve ayarların korunduğunu göster. Bu, v1'in ana katkısıdır.

### 6. Ayarlar

- Bir tuş atamasını değiştir ve oyun içinde çalıştığını göster.
- Ses kaydıraçlarını göster.
- **"Oyunu Sıfırla"** seçeneğini göster — tüm kalıcı veriyi siler, onay adımı vardır.

## Sunum Notları

Sorulması muhtemel sorular ve kısa cevapları:

**"Neden fizik motoru (RigidBody2D) kullanılmadı?"**
Çarpışma `Area2D` sinyalleriyle yapılır. Bu yaklaşım daha öngörülebilirdir; engellerin fiziksel olarak itilmesi veya birbirine çarpması gibi istenmeyen davranışlar oluşmaz.

**"Zorluk nereye kadar artıyor?"**
Her seviyenin tanımlı bir hız üst sınırı ve üretim aralığı alt sınırı vardır. Sınırlar olmadan oyun bir noktada oynanamaz hâle gelirdi.

**"Kaçılamaz engel çıkıyor mu?"**
Hayır, ve bu ölçülerek doğrulanmıştır. Engeller arası boşluk hem zaman hem piksel cinsinden ölçülüp büyük olanı uygulanır: zıplama süresi (0.8 sn) oyun hızından bağımsız sabit olduğu için sabit bir piksel mesafesi yüksek hızlarda kaçışı imkânsız kılar, buna karşılık yalnız zaman ölçütü de yavaş oyunda engelleri ekranda dip dibe gösterir. Ayrıca gereken boşluk önceki engelin türüne göre değişir — zemin engelinden sonra oyuncu havada olduğu için eğilemez, tavan engelinden sonra ise hemen zıplayabilir.

**"Zorluk nasıl doğrulandı?"**
Oyun oyuncusuz olarak headless çalıştırılıp engellerin oyuncu hizasına varış aralıkları ölçüldü (zorluk başına 150 sn). Zıplama fiziğinin izin verdiği sınırın altına düşen aralık sayısı üç zorlukta da sıfırdır.

**"Veriler nerede saklanıyor?"**
Veritabanı yoktur. Godot'un `ConfigFile` sınıfıyla, kullanıcı klasöründeki iki düz metin dosyasında tutulur. Ayrıntı için bkz. [../docs/Database.md](../docs/Database.md).

## Demo Materyalleri

`screenshots/` klasöründe bulunur:

| Dosya | İçerik |
|---|---|
| `gameplay.mp4` | Oynanış kaydı |
| `1.png` – `4.png` | Ekran görüntüleri |
