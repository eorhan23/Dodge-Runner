# CLAUDE.md

Bu dosya, bu repoda çalışırken Claude Code'a (claude.ai/code) rehberlik eder.

## Proje Özeti

**Dodge Runner** — yandan bakışlı (side-scroller), sonsuz koşu tarzında bir **Godot 4 masaüstü arcade oyunu**. Oyuncu sabit bir x-konumunda koşar, üstten ve alttan gelen engellerden zıplayarak veya eğilerek kaçar. Backend, sunucu veya veritabanı yoktur — tamamen yerel/çevrimdışı çalışır.

> **Durum:** Proje şu anda yalnızca planlama/doküman aşamasındadır. `src/` altında henüz Godot projesi oluşturulmamıştır (bkz. `tasks/Tasks.md` Faz 0). Bu depoda kod üretmeden önce mutlaka `tasks/Tasks.md`'deki faz sırasını takip et.

## Önce Oku

Kod yazmadan önce şu dosyaları oku — bu CLAUDE.md onların özetidir, tam gerçek kaynak değildir:

- **`docs/PRD.md`** — MVP kapsamı: hangi özellikler var, hangileri yok.
- **`docs/Architecture.md`** — teknik mimari: klasör yapısı, sahne (node) yapısı, oyun döngüsü mantığı, zorluk artışı kuralları.
- **`docs/Problem.md`** — çözülmeye çalışılan problem ve motivasyon.
- **`docs/UserStories.md`** — kullanıcı hikayeleri ve kabul kriterleri.
- **`tasks/Tasks.md`** — fazlara bölünmüş, atomik görev listesi. Fazlar sıralı bağımlılık taşır (Faz N, Faz N-1'e dayanır); bir faz içindeki bağımsız maddeler paralel yapılabilir. Bir görevi tamamlayınca ilgili kutuyu `- [x]` olarak işaretle.

## Teknoloji Yığını

| Katman | Teknoloji |
|---|---|
| Motor | Godot 4.x |
| Dil | GDScript |
| Platform | Masaüstü (Windows/Linux/macOS) |
| Kontrol | Klavye (Yukarı Ok: zıpla, Aşağı Ok: eğil) |
| Veri Kalıcılığı | Yok (MVP kapsamında) |

## Klasör Yapısı (Planlanan — `Architecture.md` §3)

```
dodge-runner/
├── docs/                     # Dokümantasyon
├── tasks/                    # Görev takibi
├── src/                      # Godot projesi kökü (project.godot burada)
│   ├── project.godot
│   ├── scenes/
│   │   ├── Main.tscn
│   │   ├── Player.tscn
│   │   ├── Obstacle.tscn
│   │   └── GameOver.tscn
│   ├── scripts/
│   │   ├── Player.gd
│   │   ├── Obstacle.gd
│   │   ├── GameManager.gd      # autoload/singleton
│   │   └── SpawnManager.gd
│   └── assets/sprites/
└── demo/
```

**Kural:** Godot'un otomatik oluşturduğu `.godot/`, `.import/` gibi klasör/dosyalar `.gitignore` ile hariç tutulur, asla commit edilmez.

## Kritik Oyun Mantığı Kuralları

- **Karakter hareketi:** Karakter sabit x-konumunda kalır; dünya (engeller) sağdan sola hareket eder. Karakteri hareket ettirme.
- **Çarpışma tespiti:** `RigidBody2D` fizik motoru değil, `Area2D` sinyal tabanlı yaklaşım kullanılır (bkz. `Architecture.md` §7).
- **Zorluk artışı:** Kademeli olmalı, ani sıçramalar olmamalı. Üst sınır konularak oyunun oynanamaz hale gelmesi engellenir (bkz. `Architecture.md` §6).
- **Durum yönetimi:** Karakterin `Running` / `Jumping` / `Ducking` durumları arasında geçiş net olmalı, her durumun kendi çarpışma şekli vardır.

## Geliştirme Komutları

Proje henüz `src/` altında oluşturulmadı. Godot projesi kurulduktan sonra geliştirme ve test doğrudan Godot Editor üzerinden yapılır; bu proje için harici bir CLI build/test komutu zorunlu değildir.

Faz 0 tamamlanana kadar `src/` altında herhangi bir `.gd` veya `.tscn` dosyası oluşturulmamalıdır — önce `tasks/Tasks.md` Faz 0 maddelerini uygula.

## Çalışma Kuralları

- **Faz sırasını bozma.** `tasks/Tasks.md`'deki fazlar birbirine bağımlıdır; bir sonraki fazın kodunu öncekini tamamlamadan yazma.
- **Kapsam dışına çıkma.** MVP dışı özellikler (`tasks/Tasks.md` sonundaki "Backlog — MVP Dışı" bölümü: mobil kontrol, çoklu seviye, ses/müzik, online skor tablosu, karakter özelleştirme, power-up'lar) açıkça istenmedikçe uygulanmaz.
- **Açık sorular** (`Architecture.md` §8) kod ile örtük olarak cevaplanmaz; belirsizlik varsa kullanıcıya sor.
- Bir görev tamamlandığında `tasks/Tasks.md` içindeki ilgili `- [ ]` kutusunu `- [x]` olarak işaretle.
- Placeholder görseller (basit geometrik şekiller) MVP için yeterlidir; gerçek sprite/asset üretimi bilinçli olarak Faz 5'e ertelenmiştir.
