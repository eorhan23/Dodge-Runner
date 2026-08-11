# Modules.md

Bu dosya, Dodge Runner'ın modül (bileşen) tasarımını ve sorumluluk dağılımını açıklar. Klasör yapısı ve sahne mimarisi için bkz. [Architecture.md](Architecture.md).

## 1. Modül Katmanları

Proje üç katmana ayrılır:

| Katman | Ne yapar | Yaşam süresi |
|---|---|---|
| **Yöneticiler (Autoload)** | Oyun durumu, kalıcı veri, ses, üretim | Uygulama boyunca yaşar; sahne değişiminden etkilenmez |
| **Oyun Nesneleri** | Oyuncu, engel, güç yükseltmesi | Sahne içinde doğar ve ölür |
| **Arayüz / Sunum** | Menüler, etiketler, görsel efektler | Bağlı olduğu sahne kadar yaşar |

Bu ayrımın nedeni: oyun durumu (skor, zorluk, istatistik) sahne değişiminde kaybolmamalı, ama oyun nesneleri her turda temiz bir başlangıçtan doğmalıdır.

## 2. Yönetici Modülleri (Autoload)

Yükleme sırası `project.godot`'ta tanımlıdır ve **anlamlıdır**: `AudioManager`, `SettingsManager`'dan önce gelir; çünkü `SettingsManager` açılışta kayıtlı ses seviyelerini uygularken ses yollarının hazır olmasına ihtiyaç duyar.

### GameManager

Oyunun merkezî durum makinesidir.

- **Sorumluluk:** Skor birikimi, geçen süre, zorluk seviyesi ve kademeli zorluk artışı, tur başlatma/bitirme.
- **Dışa açtığı arayüz:** `start_game()`, `game_over()`, `reset()`, `set_difficulty()`, `effective_speed_multiplier()`.
- **Kritik nokta:** `effective_speed_multiplier()` tek bir doğruluk kaynağıdır — ekranda hareket eden her şey (engeller, güç yükseltmeleri, arka plan, koşu animasyonu) hızını buradan alır. Zaman yavaşlatma efekti bu tek noktada uygulanır.

### SpawnManager

Engel ve güç yükseltmesi üretiminden sorumludur.

- **Sorumluluk:** İki bağımsız `Timer` ile üretim zamanlaması, engel varyantı seçimi, konum hesabı, nadirlik dağılımı.
- **Kritik nokta:** Engeller arası boşluk piksel değil **zaman** cinsinden hesaplanır (`current_pair_gap()`, `MIN_GAP_SECONDS`). Zıplama süresi oyun hızından bağımsız sabit olduğu için, sabit piksel mesafesi yüksek hızlarda kaçılması imkânsız durumlar üretirdi.

### BuffManager

Aktif güç yükseltmelerinin tek kayıt yeridir.

- **Sorumluluk:** Tür/kademe tanımları (`DEFINITIONS`, `TIER_DURATIONS`, `TIER_COLORS`), aktif efektlerin kalan süresi, kalkan hakları.
- **Dışa açtığı arayüz:** `activate()`, `get_time_slow_factor()`, `get_score_multiplier()`, `consume_shield_charge()`, `reset()`.
- **Kritik nokta:** Etki değerleri kod içine dağıtılmaz, hepsi burada tanımlıdır. Denge ayarı yapılacağı zaman tek dosya değişir.

### StatsManager

Yerel istatistik kalıcılığı.

- **Sorumluluk:** `user://stats.cfg` okuma/yazma, zorluk bazında en yüksek skor, tur sayısı, toplam süre ve son 5 skor.
- **Dışa açtığı arayüz:** `record_game()`, `get_stats()`, `clear_all()`.

### SettingsManager

Tuş atamaları ve ses seviyelerinin kalıcılığı.

- **Sorumluluk:** `user://settings.cfg` içindeki `input` ve `audio` bölümleri, `InputMap`'in çalışma zamanında yeniden kurulması.
- **Kritik nokta:** Godot'un `InputMap` olay dizisi boşluk kabul etmez (bir olay silinince sonrakiler kayar). Bu yüzden yuva indeksleri ayrı bir sözlükte tutulur ve `InputMap` her değişiklikte baştan kurulur.

### CharacterManager

Karakter kataloğu ve seçim kalıcılığı.

- **Sorumluluk:** 6 karakterin sprite yolları, kare anlamları (`RUN_FRAMES`, `IDLE_FRAME`, `JUMP_FRAME`), seçili karakterin `settings.cfg`'deki `character` bölümünde saklanması.
- **Kritik nokta:** `settings.cfg` dosyasını `SettingsManager` ile paylaşır, ancak her biri **ayrı bir `ConfigFile` nesnesi** tutar. Bu yüzden bölüm silme işlemlerinden önce dosya diskten yeniden okunur; aksi halde biri diğerinin kaydını geri alır.

### AudioManager

Ses çalma ve ses yolu (bus) yönetimi.

- **Sorumluluk:** `AudioStreamPlayer` node'larının koddan üretilmesi, Music/SFX yollarının oluşturulması, efekt ve müzik çalma.
- **Kritik nokta:** Oyun sonunda sahne duraklatıldığı (`get_tree().paused`) için ses düğümleri `PROCESS_MODE_ALWAYS` ile çalışır; aksi halde ölüm sesi duyulmazdı.

## 3. Oyun Nesnesi Modülleri

### Player

- Girdiye göre `Running` / `Jumping` / `Ducking` durumları arasında geçiş yapar; her durumun kendi çarpışma şekli vardır.
- Sabit bir x-konumunda kalır — dünya hareket eder, karakter değil.
- Koşma animasyonu oyun hızıyla ölçeklenir; havadayken tek kareye sabitlenir.

### Obstacle

- `Area2D` tabanlıdır; `body_entered` sinyaliyle çarpışmayı bildirir.
- Çarpışma anında önce kalkan sorgulanır (`BuffManager.consume_shield_charge()`), kalkan yoksa oyun biter.
- Hızını kendi başına belirlemez; `SpawnManager.BASE_SPEED` ve `GameManager.effective_speed_multiplier()` çarpımını kullanır.

### Buff

- Engellerle aynı hızda akar, `Area2D` ile toplanır.
- Görseli koddan üretilir: kademe renginde daire + tür ikonu veya çarpan yazısı. Skor çarpanı için ayrı görsel varlık yoktur.

## 4. Arayüz ve Sunum Modülleri

| Modül | Sorumluluk |
|---|---|
| `MainMenu` | Zorluk seçimi, karakter seçimi, istatistik paneli, oyuna giriş |
| `Settings` | Tuş atama, ses kaydıraçları, varsayılana sıfırlama, tüm veriyi sıfırlama |
| `GameOver` | Final skoru ve "Tekrar Oyna" |
| `ScoreLabel` | Skoru `GameManager`'dan okuyup gösterir |
| `BuffIndicator` | Aktif güç yükseltmelerini kademe renginde listeler |
| `ShieldEffect` | Kalkan aktifken karakteri saran halkayı çizer |
| `ScrollingBackground` | Arka planı kesintisiz yatay kaydırır |
| `ControlsHint` | Tur başında kontrol talimatını gösterip gizler |
| `BuffCircle` | Güç yükseltmesinin arkasındaki renkli daireyi çizer |

## 5. Modüller Arası Bağımlılık Kuralları

- **Yöneticiler oyun nesnelerini tanımaz.** İletişim tek yönlüdür: nesneler yöneticileri çağırır, tersi olmaz. İstisna, `SpawnManager`'ın nesneleri üretmesidir.
- **Nesneler birbirini doğrudan tanımaz.** Birbirlerini bulmaları gerektiğinde node grupları kullanılır (`"player"`, `"obstacle"`, `"buff"`).
- **Arayüz modülleri yalnızca okur.** Ekrandaki etiketler yöneticilerden veri okur, oyun durumunu değiştirmez.
- **Sayısal denge değerleri tek yerde tanımlanır.** Zorluk değerleri `GameManager.DIFFICULTY_SETTINGS`, güç yükseltmesi değerleri `BuffManager.DEFINITIONS`, üretim değerleri `SpawnManager` sabitlerindedir.
