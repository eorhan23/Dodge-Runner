# Architecture.md

## 1. Genel Bakış

Dodge Runner, Godot 4 motoru ve GDScript ile geliştirilen, tek dosyalık bir masaüstü 2D arcade oyunudur. Backend, sunucu veya veritabanı yoktur — tüm oyun mantığı ve durumu yerel olarak, oyun oturumu içinde tutulur.

## 2. Teknoloji Yığını

| Katman | Teknoloji |
|---|---|
| Motor | Godot 4.x |
| Dil | GDScript |
| Platform | Masaüstü (Windows/Linux/macOS) |
| Kontrol | Klavye (varsayılan: Yukarı Ok / Boşluk: zıpla, Aşağı Ok: eğil — v1'de değiştirilebilir) |
| Veri Kalıcılığı | MVP'de yok; v1'de `ConfigFile` ile yerel kayıt (`user://stats.cfg` istatistikler, `user://settings.cfg` tuş atamaları ve ses seviyeleri) |

## 3. Klasör Yapısı

```
dodge-runner/
├── README.md
├── RELEASE_NOTES.md          # Sürüm notları
├── docs/                     # Dokümantasyon (bu dosyalar)
│   ├── Problem.md            # Problem tanımı ve motivasyon
│   ├── UserPersona.md        # Hedef kullanıcı profilleri
│   ├── UserStories.md        # Kullanıcı hikayeleri ve kabul kriterleri
│   ├── PRD.md / PRD_v1.md / PRD_v2.md   # Sürüm bazlı kapsam
│   ├── Architecture.md       # Bu dosya
│   ├── Modules.md            # Modül tasarımı ve sorumluluk dağılımı
│   ├── Database.md           # Veri modeli (ConfigFile şeması)
│   ├── API.md                # Dahili modül arayüzleri
│   └── Roadmap.md            # Sürüm yol haritası
├── tasks/                    # Görev takibi
│   ├── Tasks.md              # Fazlara bölünmüş görev listesi
│   ├── Sprint.md             # Fazların sprint düzeyinde özeti
│   ├── Prompts.md            # AI Agent yönlendirme yöntemi
│   └── DefinitionOfDone.md   # "Bitti" ölçütleri
├── src/                      # Godot projesi kökü (project.godot burada)
│   ├── project.godot
│   ├── scenes/
│   │   ├── MainMenu.tscn      # Zorluk seçimi + istatistikler (v1)
│   │   ├── Settings.tscn      # Tuş ataması ekranı (v1)
│   │   ├── Main.tscn          # Ana oyun sahnesi, oyun döngüsünü yönetir
│   │   ├── Player.tscn        # Karakter sahnesi (CharacterBody2D)
│   │   ├── Obstacle.tscn      # Tekil engel sahnesi (Area2D)
│   │   ├── Buff.tscn          # Toplanabilir güç yükseltmesi (Area2D, v2)
│   │   └── GameOver.tscn      # Oyun bitti / tekrar oyna ekranı
│   ├── scripts/
│   │   ├── Player.gd          # Zıplama/eğilme mantığı, girdi işleme
│   │   ├── Obstacle.gd        # Engel hareketi ve çarpışma sinyali
│   │   ├── GameManager.gd     # Skor, zorluk artışı, oyun durumu (autoload/singleton)
│   │   ├── SpawnManager.gd    # Engel üretim zamanlaması (Timer tabanlı, autoload/singleton)
│   │   ├── StatsManager.gd    # Yerel istatistik kaydı, ConfigFile (autoload/singleton, v1)
│   │   ├── AudioManager.gd    # Ses efektleri, müzik, ses yolları (autoload/singleton, v1)
│   │   ├── SettingsManager.gd # Tuş atamaları + ses seviyeleri, ConfigFile (autoload/singleton, v1)
│   │   ├── CharacterManager.gd # Seçili karakter, ConfigFile (autoload/singleton, v2)
│   │   ├── BuffManager.gd     # Aktif buff'lar ve süreleri (autoload/singleton, v2)
│   │   ├── Buff.gd            # Buff hareketi, görsel çizimi, toplanma (v2)
│   │   ├── BuffCircle.gd      # Buff arka planındaki renkli daireyi çizer (v2)
│   │   ├── BuffIndicator.gd   # Aktif buff'ları ve kalan süreleri gösterir (v2)
│   │   ├── ShieldEffect.gd    # Kalkan aktifken karakteri saran halkayı çizer (v2)
│   │   ├── Settings.gd        # Tuş atama ekranı mantığı (v1)
│   │   ├── MainMenu.gd        # Zorluk seçimi, oyunu başlatma (v1)
│   │   ├── Main.gd            # Oyun sahnesi açılınca turu başlatır
│   │   ├── GameOver.gd        # Final skor gösterimi, "Tekrar Oyna"
│   │   ├── ScrollingBackground.gd # Arka planı sonsuz yatay kaydırır (v1)
│   │   ├── ScoreLabel.gd      # Skor Label'ını GameManager'dan günceller
│   │   └── ControlsHint.gd    # Başlangıç kontrol talimatını birkaç saniye sonra gizler
│   └── assets/
│       ├── sprites/           # pixel-art sprite'lar
│       │   ├── player.png
│       │   ├── obstacle.png
│       │   ├── background.png
│       │   ├── characters/    # 6 karakter × 3 kare koşma animasyonu (v2)
│       │   │   ├── blue/ green/ orange/
│       │   │   └── purple/ white/ yellow/
│       │   └── buffs/         # protection_buff.png, time_buff.png (v2)
│       └── audio/             # ses varlıkları (v1)
│           ├── sfx/
│           │   ├── game/      # jump.mp3, death.mp3, hit.mp3, get_buff.mp3
│           │   └── ui/        # click.mp3, start.mp3
│           └── music/         # background_loop.mp3
└── demo/                      # Sunum/demo materyalleri
    ├── Demo.md                # Çalıştırma ve demo senaryosu
    └── screenshots/
```

Bu dosya listesinin hangi kısmının fiilen oluşturulduğu statik olarak burada tutulmaz — güncel durum için `tasks/Tasks.md`'deki işaretli kutucuklara bakılmalıdır.

## 4. Sahne (Node) Mimarisi

- **Main.tscn**: Kök sahne. `GameManager` ve `SpawnManager` autoload/singleton olarak proje ayarlarında tanımlanır, sahneye bağımlı değildir.
- **Player.tscn**: `CharacterBody2D` kök node, altında `CollisionShape2D` (durum değişince — koşma/eğilme — boyutu değişir) ve görsel temsil (`Sprite2D`). v2'den itibaren doku, `CharacterManager`'dan gelen seçili karakterin 3 karesiyle çalışma zamanında değiştirilir (koşarken animasyon, zıplama/eğilmede sabit kare). Projede fiziksel bir zemin/`Ground` çarpışma gövdesi yoktur; dikey konum script içindeki mantıksal bir zemin sabitiyle yönetilir — bu, §7'deki Area2D-sinyal-tabanlı çarpışma felsefesiyle tutarlıdır.
- **Obstacle.tscn**: `Area2D` kök node (fiziksel çarpma yerine sinyal tabanlı tespit tercih edilir — daha basit ve MVP'ye uygun), görsel temsil `Sprite2D` (`obstacle.png`; tavandan sarkan varyantta dikey çevrilip tavana kadar uzatılır), `body_entered` sinyali `Player`'ın `"player"` grubunda olup olmadığını kontrol edip `GameManager.game_over()`'ı tetikler.
- **Main.tscn**: yukarıdakilere ek olarak statik bir arka plan (`Sprite2D`, `background.png`), skor `Label`'ı (`ScoreLabel.gd`) ve başlangıç kontrol talimatı `Label`'ı (`ControlsHint.gd`) barındırır.

## 5. Oyun Döngüsü Mantığı

1. `SpawnManager`, bir `Timer` node'u ile periyodik olarak `Obstacle` sahnesini örnekler (instantiate) ve ekranın sağından sahneye ekler.
2. Her `Obstacle`, `_process(delta)` içinde sabit bir hızla sola hareket eder; hız değeri `GameManager`'daki global zorluk seviyesine bağlıdır.
3. `GameManager`, oyun başladığından beri geçen süreye göre periyodik olarak hız ve/veya spawn sıklığını artırır (kademeli zorluk eğrisi).
4. `Player`, girdiye (Yukarı Ok / Aşağı Ok) göre durum değiştirir: `Running`, `Jumping`, `Ducking`. Her durumun kendi çarpışma şekli (hitbox) vardır.
5. Çarpışma (`Obstacle` ile `Player` arasında `Area2D` sinyali) tetiklendiğinde `GameManager.game_over()` çağrılır, oyun durur, `GameOver.tscn` gösterilir.

## 6. Zorluk Artışı Kuralı

- Başlangıç hızı ve spawn aralığı sabit bir değerle başlar.
- Her 10 saniyede bir, hız %8 artırılır (üst sınır 2.2×) ve spawn aralığı %8 kısaltılır (alt sınır orijinalin 0.5×'i) — bkz. `GameManager.gd`.
- Üst/alt sınırlar sayesinde oyunun "oynanamaz" hale gelmesi engellenir. Bu değerler bir ilk ayar; gerçek oynanabilirlik hissi playtest ile doğrulanıp gerekirse ince ayar yapılacak (bkz. `Tasks.md` Faz 5).

### 6.1. Kaçılamaz Durum Yasağı

Zorluk artışının bir sınırı daha vardır: **hiçbir engel dizilimi, doğru oynayan bir oyuncunun ölmesine yol açmamalıdır.**

Bunu sağlayan kural, engeller arası boşluğun **piksel değil zaman** cinsinden tanımlanmasıdır. Gerekçesi şudur: zıplama süresi `2 * |JUMP_VELOCITY| / GRAVITY` ile sabittir ve oyun hızından etkilenmez (zaman buff'ı da bilerek zıplamayı yavaşlatmaz). Buna karşılık engeller hızlandıkça sabit bir piksel mesafesini giderek daha kısa sürede kat eder. Dolayısıyla sabit piksel mesafesi, yüksek hızlarda kaçınılmaz ölüm üretir.

Gereken boşluk sabit değildir; **önceki engelin türüne** bağlıdır. İkisine de aynı süreyi dayatmak oyunu gereksiz yere seyrekleştirir:

| Önceki engel | Oyuncunun durumu | Gereken boşluk |
|---|---|---|
| Zemin | Zıplar; 0.8 sn havada kalır ve bu süre boyunca **eğilemez** | `GAP_AFTER_GROUND_SECONDS` (0.88 sn) |
| Tavan | Eğilir; eğilme bırakılır bırakılmaz zıplayabilir | `GAP_AFTER_TOP_SECONDS` (0.38 sn) |

Bu süreler tek başına yetmez. Oyun yavaşken süre cinsinden yeterli olan bir boşluk **piksel** olarak dar kalır; iki engel ekranda dip dibe görünür ve oyuncu ikisini tek bir küme gibi algılayıp hangisine nasıl tepki vereceğini ayırt edemez. Bu yüzden her boşluk ayrıca `MIN_VISUAL_GAP_PIXELS` kadar asgari bir piksel mesafesi tutar — yani boşluk, süre ve piksel ölçütlerinin **büyük olanına** göre belirlenir. Zaman ölçütü hızlı oyunu, piksel ölçütü yavaş oyunu korur.

Uygulama `SpawnManager.gd` içinde üç parçalıdır:

1. **`current_pair_gap()`** — çift engelin iki parçası arasındaki mesafeyi hızla orantılı üretir. Oyuncu önce zıplayıp inmek sonra eğilmek zorunda olduğu için zemin engeli kuralı geçerlidir.
2. **`_start_timer(variant)`** — bir sonraki üretimin alt sınırını, üretilen grubun **son** engeline göre hesaplar. Çift engelin ikinci parçası üretim noktasının sağına konduğu için, alt sınır o parçanın gecikmesini de kapsar.
3. **`_are_points_clear()`** — üretim anında konum kontrolü; üretim noktalarının yakınında engel veya buff varsa üretim `SPACING_RETRY_DELAY` kadar ertelenir.

Üçüncü adım gereksiz görünebilir ama değildir: çift engelin ikinci parçası ve buff'lar üretim noktasının ötesine yerleştiği için, zamanlayıcı hesabı bu geometriyi tek başına garanti edemez. Buna karşılık konum kontrolü zamanlayıcıyla **birebir aynı** eşiği kullanmaz (`CLEARANCE_TOLERANCE`); eşit tutulduğunda sınırdaki her durum reddedilip üretim sürekli erteleniyor ve oyun belirgin şekilde seyrekleşiyordu.

Tempo (`MIN_SPAWN_INTERVAL` / `MAX_SPAWN_INTERVAL`) ile adalet birbirinden ayrıdır: yukarıdaki alt sınırlar garantiyi tek başına sağladığı için, üretim aralığı denge amacıyla serbestçe sıkılaştırılabilir.

## 6.1. Buff Sistemi (v2)

Üç tür × üç kademe = 9 buff. Türler arasında çıkma olasılığı eşittir; her türün kendi içinde güçlü kademe daha nadirdir (kademeler arası fark abartılı değildir).

| Tür | Kademe 1 | Kademe 2 | Kademe 3 |
|---|---|---|---|
| Kalkan | 1 dokunulmazlık | 2 dokunulmazlık | 3 dokunulmazlık |
| Zaman | %20 yavaşlatma | %30 yavaşlatma | %40 yavaşlatma |
| Skor Çarpanı | 2x | 3x | 4x |

- **Görsel:** Buff'lar `Obstacle` gibi sağdan sola hareket eder ve `Area2D` ile toplanır. Arka plandaki daire koddan çizilir; rengi **kademeyi** belirtir (kademe 1 = yeşil, 2 = mavi, 3 = kırmızı). Aynı renk kodu sol üstteki aktif buff göstergesinde ve kalkan halkasında da kullanılır. Tür, dairenin üzerindeki ikondan (`protection_buff.png` / `time_buff.png`) veya koddan yazılan çarpan metninden (2x/3x/4x) anlaşılır — skor çarpanı için ayrı bir görsel varlık yoktur.
- **Süre:** Etki süresi yalnızca kademeye bağlıdır ve türden bağımsızdır (7 / 10 / 13 sn). Süre dolunca etki kalkar. Kalkan ayrıca sayılı dokunulmazlık taşır — haklar tükenirse veya süre dolarsa (hangisi önce olursa) kalkan kalkar.
- **Konum:** Buff'ların engellerin içinde veya dibinde çıkmaması iki yönlü korunur: buff yerleştirilirken mevcut engellere bakılır, engel üretilirken de yakında buff varsa üretim kısa süre ertelenir. Tek yönlü kontrol yetersizdir, çünkü buff üretim noktasının sağına konur ve sonradan doğan bir engel onun yanına denk gelebilir.
- **Zaman buff'ının sınırı:** Yavaşlatma yalnızca dış dünyaya uygulanır; zıplama fiziği ve skor kazanımı gerçek zamanda kalır. Aksi hâlde havada kalma süresi engellere göre orantısız kısalır ve buff, faydası olması gereken durumda oyunu zorlaştırırdı.
- **Yönetim:** `BuffManager` (autoload) aktif buff'ları ve kalan sürelerini takip eder; etkiler `GameManager` (skor/zaman) ve `Obstacle` çarpışma yolu (kalkan) üzerinden uygulanır.

## 7. Kapsam Dışı Bırakılan Teknik Kararlar

- **Fizik motoru tabanlı çarpışma (RigidBody2D) kullanılmayacak** — Area2D sinyal tabanlı yaklaşım, MVP için yeterli ve daha öngörülebilir.
- **Veritabanı / online skor tablosu yok** — bu proje tamamen yerel/çevrimdışı çalışır, bu yüzden `Database.md` ve `API.md` dosyaları bu proje kapsamında oluşturulmamıştır. (v1'de istatistikler `ConfigFile` ile `user://stats.cfg`'ye yazılır; bu yerel bir dosyadır, çevrimdışı çalışma değişmez.)
- **Ses/müzik sistemi** MVP kapsamında değildi; v1'de eklendi (bkz. `AudioManager.gd`, ses efektleri + müzik + ayarlanabilir ses seviyeleri).

## 8. Açık Sorular

- ~~Zıplama fiziksel mi (yerçekimi + zıplama kuvveti) yoksa animasyon tabanlı (tween/sabit eğri) mi olacak?~~ **Karar verildi:** Fiziksel yaklaşım (yerçekimi + zıplama hızı) uygulandı, bkz. `Player.gd`.
- ~~Skor tam olarak neye göre hesaplanacak (geçen süre mi, geçilen engel sayısı mı, ikisinin kombinasyonu mu)?~~ **Karar verildi:** Skor, hayatta kalınan süreye dayanıyor (saniyede 10 puan), bkz. `GameManager.gd`.
