# Database.md

## Kapsam Notu

**Bu projede veritabanı kullanılmamaktadır.**

Dodge Runner tamamen yerel ve çevrimdışı çalışan, tek kullanıcılı bir masaüstü oyunudur. Sunucu, kullanıcı hesabı veya paylaşılan veri yoktur; saklanan tek şey, oyunu çalıştıran kişinin kendi tercihleri ve istatistikleridir. Bu veri hacmi ve erişim deseni için bir veritabanı motoru (SQLite dahil) gereksiz bir bağımlılık olurdu.

Bunun yerine Godot'un yerleşik **`ConfigFile`** sınıfı kullanılır: INI biçiminde, düz metin, bağımlılıksız.

Bu karar [Architecture.md](Architecture.md) §7'de de "kapsam dışı bırakılan teknik kararlar" arasında kayıtlıdır.

## Veri Saklama Yeri

Dosyalar Godot'un `user://` sanal yolunda tutulur. İşletim sistemine göre fiziksel karşılığı:

| Platform | Yol |
|---|---|
| Windows | `%APPDATA%\Godot\app_userdata\Dodge Runner\` |
| Linux | `~/.local/share/godot/app_userdata/Dodge Runner/` |
| macOS | `~/Library/Application Support/Godot/app_userdata/Dodge Runner/` |

İki dosya vardır: `stats.cfg` ve `settings.cfg`.

## Veri Modeli

### `stats.cfg` — Oyun İstatistikleri

Yöneten modül: `StatsManager.gd`

Her zorluk seviyesi ayrı bir bölümdür (`easy`, `normal`, `hard`). Böylece seviyeler birbirinin rekorunu bozmaz.

| Alan | Tip | Açıklama |
|---|---|---|
| `high_score` | int | O zorluktaki en yüksek skor |
| `games_played` | int | Oynanan toplam tur sayısı |
| `total_time` | float | Toplam hayatta kalma süresi (saniye) |
| `recent_scores` | Array[int] | Son 5 turun skoru, en yenisi başta |

**Tasarım notu:** Ortalama hayatta kalma süresi ayrı bir alan olarak saklanmaz; `total_time / games_played` ile hesaplanır. Böylece her turun süresini ayrı ayrı saklamak gerekmez ve dosya sabit boyutta kalır.

Örnek içerik:

```ini
[normal]
high_score=1840
games_played=27
total_time=496.3
recent_scores=[1840, 720, 1150, 430, 980]
```

### `settings.cfg` — Kullanıcı Tercihleri

Üç bölüm içerir ve **iki farklı modül tarafından paylaşılır**: `input` ve `audio` bölümlerini `SettingsManager.gd`, `character` bölümünü `CharacterManager.gd` yönetir.

**`[input]`** — Tuş atamaları

| Alan | Tip | Açıklama |
|---|---|---|
| `jump_0` | int | Zıplama, 1. yuva (varsayılan: Yukarı Ok) |
| `jump_1` | int | Zıplama, 2. yuva (varsayılan: Boşluk) |
| `duck_0` | int | Eğilme (varsayılan: Aşağı Ok) |

Değerler Godot keycode'larıdır. İki özel değer vardır: alanın **hiç bulunmaması** "varsayılan geçerli" anlamına gelir, `-1` ise "yuva bilerek boşaltılmış" demektir. Bu ayrım olmadan, boşaltılan bir yuva her açılışta varsayılana geri dönerdi.

**`[audio]`** — Ses seviyeleri

| Alan | Tip | Açıklama |
|---|---|---|
| `music` | float | Müzik seviyesi, 0-100 |
| `sfx` | float | Efekt seviyesi, 0-100 |

Yüzde olarak saklanır, çalma anında `linear_to_db()` ile desibele çevrilir.

**`[character]`** — Karakter seçimi

| Alan | Tip | Açıklama |
|---|---|---|
| `selected` | int | `CharacterManager.CHARACTERS` dizisindeki indeks (0-5) |

Örnek içerik:

```ini
[input]
jump_0=4194320
jump_1=32
duck_0=4194322

[audio]
music=70.0
sfx=100.0

[character]
selected=3
```

## Bütünlük ve Hata Toleransı

Bu veri kritik değildir; bozulması durumunda oyun çalışmaya devam etmelidir. Uygulanan korumalar:

- **Dosya yoksa hata verilmez.** İlk çalıştırmada `ConfigFile.load()` başarısız olur ve boş ayarlarla devam edilir; her okuma bir varsayılan değer taşır.
- **Geçersiz değerler düzeltilir.** Örneğin kayıtlı karakter indeksi liste sınırları dışındaysa 0'a düşülür.
- **Paylaşılan dosyada yazma çakışması önlenir.** `settings.cfg` iki modül (`SettingsManager` ve `CharacterManager`) tarafından **ayrı `ConfigFile` nesneleriyle** kullanılır. Her modül kendi kopyasını bellekte tuttuğu için, biri kaydettiğinde diğerinin kopyası eskir. Bu yüzden **her yazma işleminden önce dosya diskten yeniden okunur**; aksi halde bir modülün eski kopyası diğerinin yeni kaydını sessizce geri alır (örneğin ses seviyesi değiştirildiğinde karakter seçiminin eski değerine dönmesi).

## Verinin Sıfırlanması

Kullanıcı, Ayarlar ekranındaki **"Oyunu Sıfırla"** seçeneğiyle tüm kalıcı veriyi silebilir (onay adımı vardır). Bu işlem `stats.cfg` içeriğini boşaltır ve `settings.cfg`'deki üç bölümü de kaldırır; sonuç, oyunun ilk kurulum hâlidir.

Alternatif olarak yukarıdaki klasördeki iki dosya elle silinebilir.
