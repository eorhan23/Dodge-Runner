# Sprint.md

Bu dosya, [Tasks.md](Tasks.md)'deki fazların sprint düzeyinde gruplanmış hâlidir. Görevlerin tek tek durumu Tasks.md'de tutulur; burada sprint hedefleri, kapsamı ve bağımlılıkları özetlenir.

## Sprint Yapısı

Proje üç sprintten oluşur ve her sprint bir sürüme karşılık gelir. Sprint sınırları PRD sınırlarıyla aynıdır; böylece her sprint sonunda çalışan ve teslim edilebilir bir sürüm ortaya çıkar.

Fazlar sprint içindeki iş paketleridir. Fazlar arasında **sıralı bağımlılık** vardır: bir faz, kendinden öncekinin çıktısına dayanır. Bir faz içindeki bağımsız maddeler paralel yürütülebilir.

## Sprint 1 — MVP: Oynanabilir Çekirdek

**Sprint hedefi:** Oyun döngüsünün uçtan uca çalışması — oyna, öl, tekrar başla.

| Faz | İş paketi | Çıktı |
|---|---|---|
| Faz 0 | Proje kurulumu | Godot projesi, klasör yapısı, boş ana sahne |
| Faz 1 | Karakter mekaniği | Zıplayan, eğilen, sabit x'te duran karakter |
| Faz 2 | Engel sistemi | Akan engeller, varyantlar, üretim zamanlaması |
| Faz 3 | Zorluk ve skor | Kademeli zorluk artışı, süre bazlı skor |
| Faz 4 | Çarpışma ve oyun sonu | Çarpışma tespiti, bitiş ekranı, yeniden başlatma |
| Faz 5 | Cilalama | Gerçek sprite'lar, denge ayarı, kontrol talimatı |

**Bağımlılık:** Faz 4, çarpışma için Faz 1 ve 2'nin tamamlanmasını gerektirir. Faz 3'ün skor gösterimi Faz 2'nin oyun döngüsüne dayanır.

**Sprint sonu ölçütü:** Oyun açılır, oynanır, ölünce yeniden başlatılabilir.

## Sprint 2 — v1: Kullanıcı Deneyimi Katmanı

**Sprint hedefi:** Kullanıcının tercihleri ve ilerlemesi hatırlansın; oyun tek seferlik bir demo olmaktan çıksın.

| Faz | İş paketi | Çıktı |
|---|---|---|
| Faz 6 | Ana menü ve zorluk seçimi | Menü sahnesi, üç zorluk seviyesi |
| Faz 7 | Ses ve müzik | Efektler, döngülü müzik, ses seviyesi ayarı |
| Faz 8 | Kayan arka plan | Kesintisiz yatay akış |
| Faz 9 | Yerel istatistikler | `stats.cfg`, menüde istatistik paneli |
| Faz 10 | Kontrol çeşitliliği | Ayarlar ekranı, değiştirilebilir tuş atamaları |

**Bağımlılık:** Faz 9 ve 10, ayarlarını göstermek için Faz 6'nın menü sahnesine ihtiyaç duyar. Faz 7'nin ses seviyesi kaydıraçları, Faz 10'un ayarlar ekranıyla aynı sahneyi paylaşır.

**Sprint sonu ölçütü:** Oyun kapatılıp açıldığında istatistikler, tuş atamaları ve ses seviyeleri korunur.

## Sprint 3 — v2: Çeşitlilik ve Derinlik

**Sprint hedefi:** Her turu birbirinden farklı kılmak; tekrar oynanabilirliği artırmak.

| Faz | İş paketi | Çıktı |
|---|---|---|
| Faz 11 | Karakter seçimi ve animasyon | 6 karakter, koşma animasyonu, seçim kalıcılığı |
| Faz 12 | Güç yükseltmesi altyapısı | Toplanabilir nesne, görsel üretimi, aktif etki takibi |
| Faz 13 | Güç yükseltmesi etkileri | Kalkan, zaman yavaşlatma, skor çarpanı |
| Faz 14 | Üretim ve denge | Üretim zamanlaması, nadirlik dağılımı, ekran göstergesi |
| Faz 15 | Son cilalama ve kapanış | Doküman tamamlama, uçtan uca test, hata düzeltme, demo |

**Bağımlılık:** Bu sprintte bağımlılık en belirgindir — altyapı (12) olmadan etkiler (13), etkiler olmadan denge (14) yapılamaz. Faz 15 tüm sürümlerin tamamlanmasını bekler.

**Sprint sonu ölçütü:** Tüm güç yükseltmesi türleri ve kademeleri çalışır, denge oynanabilir, dokümanlar tutarlıdır.

## Sprint Dışı Süreklilik

Aşağıdaki işler bir sprinte ait değildir; her sprint boyunca sürer:

- **Doküman güncelliği** — bir faz klasör yapısını veya oyun kuralını değiştirdiğinde ilgili doküman aynı fazda güncellenir.
- **Hata düzeltme** — test sırasında çıkan hatalar, bir sonraki faza bırakılmadan çözülür.
- **Denge ayarı** — oynanabilirlik hissi, ilgili özellik eklendiği anda değerlendirilir; son kontrol kapanış fazındadır.
