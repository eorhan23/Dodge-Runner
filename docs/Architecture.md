# Architecture.md

## 1. Genel Bakış

Dodge Runner, Godot 4 motoru ve GDScript ile geliştirilen, tek dosyalık bir masaüstü 2D arcade oyunudur. Backend, sunucu veya veritabanı yoktur — tüm oyun mantığı ve durumu yerel olarak, oyun oturumu içinde tutulur.

## 2. Teknoloji Yığını

| Katman | Teknoloji |
|---|---|
| Motor | Godot 4.x |
| Dil | GDScript |
| Platform | Masaüstü (Windows/Linux/macOS) |
| Kontrol | Klavye (Yukarı Ok: zıpla, Aşağı Ok: eğil) |
| Veri Kalıcılığı | Yok (MVP kapsamında skor kaydı diske yazılmaz) |

## 3. Klasör Yapısı (Planlanan)

```
dodge-runner/
├── docs/                     # Dokümantasyon (bu dosyalar)
├── tasks/                    # Görev takibi
├── src/                      # Godot projesi kökü (project.godot burada)
│   ├── project.godot
│   ├── scenes/
│   │   ├── Main.tscn          # Ana oyun sahnesi, oyun döngüsünü yönetir
│   │   ├── Player.tscn        # Karakter sahnesi (CharacterBody2D)
│   │   ├── Obstacle.tscn      # Tekil engel sahnesi (Area2D)
│   │   └── GameOver.tscn      # Oyun bitti / tekrar oyna ekranı
│   ├── scripts/
│   │   ├── Player.gd          # Zıplama/eğilme mantığı, girdi işleme
│   │   ├── Obstacle.gd        # Engel hareketi ve çarpışma sinyali
│   │   ├── GameManager.gd     # Skor, zorluk artışı, oyun durumu (autoload/singleton)
│   │   └── SpawnManager.gd    # Engel üretim zamanlaması (Timer tabanlı)
│   └── assets/
│       └── sprites/           # MVP'de placeholder geometrik şekiller kullanılabilir
└── demo/                      # Sunum/demo materyalleri
```

## 4. Sahne (Node) Mimarisi

- **Main.tscn**: Kök sahne. `GameManager` ve `SpawnManager` autoload/singleton olarak proje ayarlarında tanımlanır, sahneye bağımlı değildir.
- **Player.tscn**: `CharacterBody2D` kök node, altında `CollisionShape2D` (durum değişince — koşma/eğilme — boyutu değişir) ve görsel temsil (basit `ColorRect` veya `Sprite2D`).
- **Obstacle.tscn**: `Area2D` kök node (fiziksel çarpma yerine sinyal tabanlı tespit tercih edilir — daha basit ve MVP'ye uygun), `body_entered` sinyali `GameManager`'a bağlanır.

## 5. Oyun Döngüsü Mantığı

1. `SpawnManager`, bir `Timer` node'u ile periyodik olarak `Obstacle` sahnesini örnekler (instantiate) ve ekranın sağından sahneye ekler.
2. Her `Obstacle`, `_process(delta)` içinde sabit bir hızla sola hareket eder; hız değeri `GameManager`'daki global zorluk seviyesine bağlıdır.
3. `GameManager`, oyun başladığından beri geçen süreye göre periyodik olarak hız ve/veya spawn sıklığını artırır (kademeli zorluk eğrisi).
4. `Player`, girdiye (Yukarı Ok / Aşağı Ok) göre durum değiştirir: `Running`, `Jumping`, `Ducking`. Her durumun kendi çarpışma şekli (hitbox) vardır.
5. Çarpışma (`Obstacle` ile `Player` arasında `Area2D` sinyali) tetiklendiğinde `GameManager.game_over()` çağrılır, oyun durur, `GameOver.tscn` gösterilir.

## 6. Zorluk Artışı Kuralı (Taslak — geliştirme sırasında ayarlanabilir)

- Başlangıç hızı ve spawn aralığı sabit bir değerle başlar.
- Her N saniyede bir (örn. 10 saniye), hız belirli bir yüzde artırılır (örn. %5-10) ve spawn aralığı kısaltılır.
- Üst sınır konularak (hız/spawn sıklığı belirli bir noktadan sonra sabitlenir) oyunun "oynanamaz" hale gelmesi engellenir.

## 7. Kapsam Dışı Bırakılan Teknik Kararlar

- **Fizik motoru tabanlı çarpışma (RigidBody2D) kullanılmayacak** — Area2D sinyal tabanlı yaklaşım, MVP için yeterli ve daha öngörülebilir.
- **Veritabanı / online skor tablosu yok** — bu proje tamamen yerel/çevrimdışı çalışır, bu yüzden `Database.md` ve `API.md` dosyaları bu proje kapsamında oluşturulmamıştır.
- **Ses/müzik sistemi MVP'de yok** — ilerleyen fazlarda opsiyonel olarak eklenebilir.

## 8. Açık Sorular

- Zıplama fiziksel mi (yerçekimi + zıplama kuvveti) yoksa animasyon tabanlı (tween/sabit eğri) mi olacak? — İlk prototipte fiziksel yaklaşım denenip test edilecek.
- Skor tam olarak neye göre hesaplanacak (geçen süre mi, geçilen engel sayısı mı, ikisinin kombinasyonu mu)? — Geliştirme sırasında netleştirilecek, `Tasks.md` Faz 3'te ele alınacak.
