# API.md

## Kapsam Notu

**Bu projede HTTP API veya endpoint bulunmamaktadır.**

Dodge Runner çevrimdışı çalışan bir masaüstü oyunudur: sunucu, istemci-sunucu iletişimi, kimlik doğrulama veya ağ isteği yoktur. Dolayısıyla REST/GraphQL endpoint tanımı, istek-yanıt şeması veya durum kodu tablosu bu proje için anlamsızdır.

Bu karar [Architecture.md](Architecture.md) §7'de "kapsam dışı bırakılan teknik kararlar" arasında kayıtlıdır.

Ancak "API" kavramının asıl karşılığı — **bir modülün dışarıya sunduğu sözleşme** — bu projede de vardır. Bu dosya, autoload yöneticilerinin diğer modüllere sunduğu çağrılabilir arayüzleri belgeler. Modüllerin sorumluluk dağılımı için bkz. [Modules.md](Modules.md).

## Ağ ve Güvenlik Notları

Kimlik doğrulama, yetkilendirme, oturum yönetimi ve taşıma güvenliği (TLS) bu projede uygulanmaz — çünkü uygulanacak bir ağ yüzeyi yoktur. Güvenlik açısından ilgili tek nokta şudur:

- Oyun yalnızca kendi `user://` klasörüne yazar; sistemin başka bir yerine dokunmaz.
- Saklanan veri kişisel veri içermez (skor, tuş ataması, ses seviyesi, karakter seçimi).
- Kayıt dosyaları düz metindir ve kullanıcı tarafından değiştirilebilir. Bu bilinçli bir tercihtir: tek kullanıcılı yerel bir oyunda skorun "korunması" gereken bir çıkar yoktur. Çevrimiçi bir skor tablosu eklenseydi, istemciden gelen skora güvenilemeyeceği için sunucu tarafı doğrulama gerekirdi.

## Dahili Modül Arayüzleri

Aşağıdaki yöneticiler autoload'dır; proje genelinde adlarıyla doğrudan çağrılırlar.

### GameManager

Oyun akışının ve skorun kontrolü.

| Çağrı | Parametre | Döndürür | Açıklama |
|---|---|---|---|
| `start_game()` | — | — | Yeni tur başlatır; skoru, hızı ve üretim durumunu sıfırlar |
| `game_over()` | — | — | Turu bitirir, istatistiği kaydeder, oyunu duraklatır, bitiş ekranını açar |
| `reset()` | — | — | Sayaçları seçili zorluğun başlangıç değerlerine döndürür |
| `set_difficulty(difficulty)` | `Difficulty` | — | Zorluğu değiştirir ve durumu sıfırlar |
| `effective_speed_multiplier()` | — | `float` | Hareket eden her şeyin kullanması gereken hız çarpanı |

Okunabilir durum alanları: `score`, `elapsed_time`, `difficulty`, `speed_multiplier`, `is_running`, `is_game_over`.

**Sözleşme notu:** `game_over()` birden fazla kez çağrılabilir (aynı karede iki engele çarpma); ikinci ve sonraki çağrılar yok sayılır.

### BuffManager

Aktif güç yükseltmelerinin sorgulanması.

| Çağrı | Parametre | Döndürür | Açıklama |
|---|---|---|---|
| `activate(type, tier)` | `int, int` | — | Bir güç yükseltmesini etkinleştirir; aynı türden aktif olan varsa yerini alır |
| `is_active(type)` | `int` | `bool` | Tür şu anda aktif mi |
| `get_time_slow_factor()` | — | `float` | Oyun akışının çarpılacağı oran; aktif değilse `1.0` |
| `get_score_multiplier()` | — | `int` | Skor çarpanı; aktif değilse `1` |
| `get_shield_charges()` | — | `int` | Kalan dokunulmazlık hakkı; aktif değilse `0` |
| `consume_shield_charge()` | — | `bool` | Bir hak harcar; `true` = oyuncu korundu, `false` = kalkan yok |
| `get_tier(type)` | `int` | `int` | Aktif kademe; aktif değilse `-1` |
| `get_remaining(type)` | `int` | `float` | Kalan süre (saniye); aktif değilse `0.0` |
| `reset()` | — | — | Tüm aktif etkileri temizler |

**Sözleşme notu:** `consume_shield_charge()` yalnızca gerçekten bir hak harcadığında `true` döner. Çarpışma yolu bu dönüş değerine göre karar verir; ek bir kontrol yapmamalıdır.

### StatsManager

İstatistik kaydı ve okuma.

| Çağrı | Parametre | Döndürür | Açıklama |
|---|---|---|---|
| `record_game(difficulty, score, survival_time)` | `int, int, float` | — | Turu kaydeder ve diske yazar |
| `get_stats(difficulty)` | `int` | `Dictionary` | `high_score`, `games_played`, `average_time`, `recent_scores` |
| `clear_all()` | — | — | Tüm zorlukların istatistiklerini siler |

### SettingsManager

Tuş atamaları ve ses seviyeleri.

| Çağrı | Parametre | Döndürür | Açıklama |
|---|---|---|---|
| `get_keycode(action, slot)` | `String, int` | `int` | Yuvadaki keycode; boşsa `-1` |
| `get_binding_text(action, slot)` | `String, int` | `String` | Ekranda gösterilecek tuş adı; boşsa `—` |
| `set_binding(action, slot, keycode)` | `String, int, int` | — | Atamayı değiştirir, çakışmayı çözer, kaydeder |
| `get_controls_hint()` | — | `String` | Güncel atamalara göre kontrol ipucu metni |
| `get_music_volume()` / `get_sfx_volume()` | — | `float` | Kayıtlı seviye (0-100) |
| `set_music_volume(p)` / `set_sfx_volume(p)` | `float` | — | Seviyeyi uygular ve kaydeder |
| `reset_to_defaults()` | — | — | Tuş ve ses ayarlarını varsayılana döndürür |

**Sözleşme notu:** `set_binding()` çakışmayı kendi içinde çözer — atanan tuş başka bir yuvada kullanılıyorsa oradan kaldırılır. Çağıran tarafın önceden kontrol etmesi gerekmez.

### CharacterManager

Karakter kataloğu ve seçim.

| Çağrı | Parametre | Döndürür | Açıklama |
|---|---|---|---|
| `select(index)` | `int` | — | Karakteri seçer ve kaydeder; geçersiz indeks yok sayılır |
| `get_selected()` | — | `Dictionary` | Seçili karakterin `id`, `label`, `frames` bilgisi |
| `get_frames()` | — | `Array` | Seçili karakterin 3 karesi, yüklenmiş doku olarak |
| `get_preview_texture(index)` | `int` | `Texture2D` | Menü önizlemesi için duruş karesi |
| `reset_to_default()` | — | — | Seçimi ilk karaktere döndürür |

### AudioManager

Ses çalma.

| Çağrı | Açıklama |
|---|---|
| `play_jump()` / `play_death()` / `play_hit()` / `play_get_buff()` | Oyun içi efektler |
| `play_ui_click()` / `play_ui_start()` | Arayüz efektleri |
| `start_music()` / `stop_music()` | Arka plan müziği |
| `set_music_volume(p)` / `set_sfx_volume(p)` | Ses yolu seviyesi (0-100) |

### SpawnManager

Üretim kontrolü.

| Çağrı | Döndürür | Açıklama |
|---|---|---|
| `reset()` | — | Üretim zamanlayıcılarını ve engel referanslarını tur başlangıcına döndürür |
| `current_pair_gap()` | `float` | Çift engel arasında bırakılacak güncel piksel mesafesi |

## Node Grupları

Oyun nesneleri birbirini doğrudan tanımaz; grup üzerinden sorgulanır. Bu, gruplarla kurulan gayrı resmî bir arayüzdür:

| Grup | Kimler üye | Kim sorgular |
|---|---|---|
| `player` | Oyuncu | Engel ve güç yükseltmesi, çarpışan gövdenin oyuncu olup olmadığını doğrularken |
| `obstacle` | Tüm engeller | `SpawnManager`, güç yükseltmesini boş bir konuma yerleştirirken |
| `buff` | Tüm güç yükseltmeleri | `SpawnManager`, engeli güç yükseltmesinin dibine koymamak için |
