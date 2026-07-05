# PRD.md — Ürün Gereksinimleri Dokümanı

## 1. Proje Adı

**Dodge Runner** *(çalışma adı — geliştirme sürecinde değişebilir)*

## 2. Problem

Kısa süreli, öğrenmesi kolay ama ustalaşması zor bir refleks/arcade oyununa ihtiyaç var. Detaylı problem tanımı için: [Problem.md](Problem.md)

## 3. Hedef Kullanıcı

Kısa molalarda hızlı, basit ama zorlayıcı bir oyun deneyimi arayan casual oyuncular. Detaylı kullanıcı hikayeleri için: [UserStories.md](UserStories.md)

## 4. Değer Önerisi

Tek bakışta anlaşılır kurallarla (zıpla / eğil), zamanla artan zorluk eğrisiyle yüksek tekrar oynanabilirlik sunan bir mini arcade oyunu.

## 5. Oyun Konsepti

Yandan bakışlı (2D side-scroller) bir sahnede karakter sabit bir x-konumunda durur; arka plan ve engeller sağdan sola doğru hareket eder (dünya kayar, karakter sabit kalır — klasik endless-runner tekniği). Oyuncu, üstten gelen alçak engellerden **eğilerek**, alttan/zeminden gelen engellerden **zıplayarak** kaçar.

## 6. MVP Kapsamı (Bu Sürümde Olacaklar)

- Karakter sabit x-konumunda, sürekli koşar görünümde
- **Yukarı Ok tuşu** → zıplama
- **Aşağı Ok tuşu** → eğilme
- 3-4 farklı engel tipi:
  1. Alçak, üstten gelen engel (eğilme gerektirir)
  2. Yerden yükselen engel (zıplama gerektirir)
  3. Çift engel / kombinasyon (zıplama + zamanlama gerektirir)
  4. Farklı hızda hareket eden engel
- Zamanla artan oyun hızı / zorluk seviyesi
- Çarpışma tespiti → çarpışınca oyun biter
- Skor sistemi (hayatta kalınan süre veya geçilen engel sayısına dayalı)
- Basit "Oyun Bitti / Tekrar Oyna" ekranı

## 7. MVP Kapsamı Dışı (Bilerek Bırakılanlar)

- Mobil / dokunmatik kontrol desteği
- Çoklu seviye (level) tasarımı
- Ses ve müzik (opsiyonel, zorunlu değil)
- Çevrimiçi skor tablosu (online leaderboard)
- Karakter özelleştirme / farklı karakter seçenekleri
- Güç-yükseltmeler (power-up'lar)

## 8. Teknik Yaklaşım (Yüksek Seviye — Detaylar Architecture.md'de)

- **Motor:** Godot 4
- **Dil:** GDScript
- **Platform:** Masaüstü
- **Kontrol:** Klavye

*(Not: Bu PRD, MDD stajının 1. hafta 5. gün çıktısı olarak hazırlanmıştır. Architecture.md, Roadmap.md ve Tasks.md gibi dosyalar, programın 3. ve 4. gün derslerinde işlenecek konulara göre ilerleyen haftalarda eklenecektir.)*

## 9. Başarı Kriteri (Definition of Done — Taslak)

MVP'nin tamamlandığı kabul edilir eğer:

- [ ] Oyun açılır ve karakter görünür şekilde koşar
- [ ] Karakter zıplayabilir ve eğilebilir
- [ ] En az 3 farklı engel tipi doğru şekilde çarpışma tespiti yapar
- [ ] Oyun hızı zamanla artar
- [ ] Çarpışma anında oyun sona erer ve skor gösterilir
- [ ] "Tekrar Oyna" seçeneği çalışır

## 10. Riskler ve Belirsizlikler

- Godot'ta çarpışma tespiti (`Area2D` / `CollisionShape2D`) ve zamanlama hassasiyeti ilk denemede tam oturmayabilir; test-düzelt döngüsü gerekebilir.
- Zorluk artış eğrisinin "adil" hissettirilmesi (çok kolay ya da çok zor olmaması) denge ayarı gerektirebilir.
- Görsel varlık (sprite) eksikliği MVP'de placeholder şekillerle (kare/dikdörtgen) çözülecek; bu bir risk değil, bilinçli bir kapsam kararıdır.
