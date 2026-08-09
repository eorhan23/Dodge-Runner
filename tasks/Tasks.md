# Görev Listesi — Dodge Runner

Bu liste `PRD.md` ve `Architecture.md` dokümanlarına dayanır. Her madde Claude Code tarafından uygulanacak şekilde atomik ve somut adımlar içerir. Bir görev tamamlandığında kutuyu `- [x]` olarak işaretle. Fazlar sıralı bağımlılık taşır (bir sonraki faz öncekine dayanır), ancak her faz içindeki bağımsız maddeler paralel yürütülebilir.

## Faz 0 — Proje Kurulumu

- [x] `src/` klasörü altında yeni bir Godot 4 projesi oluştur (`project.godot` burada oluşacak).
- [x] Proje ayarlarında pencere boyutu ve adı (Dodge Runner) tanımla.
- [x] `scenes/`, `scripts/`, `assets/sprites/` alt klasörlerini oluştur.
- [x] Repo köküne `.gitignore` ekle (`.godot/`, `.import/`, `export.cfg` hariç tutulsun).
- [x] Boş bir `Main.tscn` sahnesi oluştur ve ana sahne olarak ayarla.

## Faz 1 — Karakter Mekaniği

- [x] `Player.tscn` sahnesini oluştur: `CharacterBody2D` kök node + `CollisionShape2D` + basit görsel (ColorRect veya Sprite2D placeholder).
- [x] `Player.gd` scriptini yaz: Yukarı Ok tuşuna basınca zıplama hareketi.
- [x] `Player.gd`'ye eğilme mantığını ekle: Aşağı Ok tuşuna basınca çarpışma şekli küçülür/alçalır.
- [x] Karakterin sabit x-konumunda kalmasını, yalnızca y ekseninde hareket etmesini sağla.
- [x] Zıplama ve eğilme arasında geçiş durumlarını (Running / Jumping / Ducking) basit bir state (durum) değişkeniyle yönet.

## Faz 2 — Engel Sistemi

- [x] `Obstacle.tscn` sahnesini oluştur: `Area2D` kök node + `CollisionShape2D` + basit görsel.
- [x] `Obstacle.gd` scriptini yaz: `_process(delta)` içinde sabit hızla sola hareket.
- [x] En az 3-4 farklı engel varyasyonu tanımla (yükseklik/konum farkıyla): üstten gelen alçak engel, zeminden yükselen engel, çift engel kombinasyonu, farklı hızda engel.
- [x] `SpawnManager.gd` scriptini yaz: bir `Timer` node'u ile periyodik olarak rastgele bir engel tipini örnekleyip (instantiate) sahneye ekle.
- [x] Ekran dışına çıkan engelleri bellekten temizle (`queue_free()`).

## Faz 3 — Zorluk Artışı ve Skor Sistemi

- [x] `GameManager.gd` scriptini yaz (autoload/singleton olarak proje ayarlarına ekle).
- [x] Oyun başladığından beri geçen süreyi takip eden bir sayaç ekle.
- [x] Belirli aralıklarla (örn. her 10 saniyede bir) engel hızını ve/veya spawn sıklığını kademeli olarak artır.
- [x] Skor hesaplama mantığını belirle ve uygula (hayatta kalınan süre veya geçilen engel sayısı — bkz. Architecture.md §8 açık soru).
- [x] Skoru oyun sırasında ekranda göster (basit bir Label node ile).

## Faz 4 — Çarpışma ve Oyun Sonu

- [x] `Obstacle` ile `Player` arasındaki `Area2D` çarpışma sinyalini (`body_entered`) bağla.
- [x] Çarpışma anında `GameManager.game_over()` fonksiyonunu tetikle: oyunu durdur, tüm hareketi dondur.
- [x] `GameOver.tscn` sahnesini oluştur: final skor gösterimi + "Tekrar Oyna" butonu.
- [x] "Tekrar Oyna" butonuna basınca oyunun temiz bir başlangıç durumuna sıfırlanmasını sağla (skor, hız, engel listesi sıfırlanır).

## Faz 5 — Cilalama ve Demo Hazırlığı

- [x] Placeholder görselleri (varsa) daha uygun sprite'larla değiştir.
- [x] Zorluk eğrisini oynanabilirlik açısından test edip ince ayar yap.
- [x] Kontrollerin ekranda kısa bir talimat olarak gösterilmesini sağla (oyun başında).
- [ ] Demo için kısa bir oynanış kaydı/ekran görüntüsü al, `demo/` klasörüne ekle.

## Faz 6 — Ana Menü ve Zorluk Seçimi

- [x] `MainMenu.tscn` sahnesini oluştur: Kolay / Normal / Zor zorluk seçenekleri + "Başla" butonu.
- [x] `run/main_scene`'i `MainMenu.tscn` olarak ayarla; "Başla" ile `Main.tscn`'e geçiş yap.
- [x] Seçilen zorluğun `GameManager`'ın başlangıç hız/zorluk çarpanlarını ve üst sınırlarını nasıl etkileyeceğini tanımla ve uygula.

## Faz 7 — Ses ve Müzik

- [x] `src/assets/audio/sfx/` ve `src/assets/audio/music/` altındaki ses dosyalarını çalan `AudioManager.gd` autoload'ını oluştur (`AudioStreamPlayer` node'ları koddan üretilir).
- [x] Zıplama anında ses efekti çal.
- [x] Çarpışma/oyun sonu anında ses efekti çal.
- [x] Döngülü bir arka plan müziği ekle (oyun sahnesinde; menüde sessiz, ölünce durur).
- [x] Arayüz sesleri: zorluk seçiminde tık sesi, oyunu başlatan butonlarda (Başla / Tekrar Oyna) başlangıç sesi.
- [x] Müzik ve efektler için ayrı ses seviyesi ayarı (Ayarlar ekranında kaydıraç, `ConfigFile` ile kalıcı).

## Faz 8 — Kayan Arka Plan

- [x] Statik `Background` (`Sprite2D`) sonsuz yatay akış yapacak şekilde güncellendi (`ScrollingBackground.gd`).
- [x] Mevcut tek arka plan görseli yan yana kesintisiz tekrarlanarak kayar; hız, oyunun zorluk çarpanıyla ölçeklenir.

> Not: Çok katmanlı paralaks yerine, kullanıcı isteğiyle mevcut tek görselin sonsuz kaydırılması tercih edildi (daha sade, ek görsel varlık gerektirmiyor).

## Faz 9 — Yerel İstatistikler

- [x] `StatsManager.gd` scriptini yaz (autoload olarak ekle), `ConfigFile` ile `user://stats.cfg`'ye okuma/yazma yap.
- [x] Takip edilecek veriler: en yüksek skor, toplam oynanan oyun sayısı, ortalama hayatta kalma süresi, son 5 oyunun skor geçmişi.
- [x] `GameManager.game_over()` tetiklendiğinde bu turun verisini `StatsManager`'a bildir ve kaydet.
- [x] İstatistikleri `MainMenu.tscn`'de göster (sağ panelde, seçili zorluğa göre).

> Not: İstatistikler her zorluk seviyesi için ayrı tutulur; menüde seçili zorluğun verileri gösterilir.

## Faz 10 — Kontrol Çeşitliliği

- [x] `Player.gd`'ye Boşluk tuşuyla da zıplama girdisi ekle (`jump` aksiyonunun ikinci varsayılan tuşu).
- [x] Tuş atamalarının değiştirilebilmesi için bir Ayarlar ekranı oluştur (`Settings.tscn`, InputMap çalışma zamanında güncellenir).
- [x] Özelleştirilmiş tuş atamalarını `ConfigFile` ile kalıcı hale getir (`user://settings.cfg`).

> Not: `ui_up`/`ui_down` yerine kendi `jump`/`duck` aksiyonları tanımlandı — motorun UI aksiyonlarını değiştirmemek için. "Zıpla" iki atanabilir yuvaya sahiptir (varsayılan: Yukarı Ok, Boşluk); ikisi de değiştirilebilir. Ayarlar ekranında "Varsayılana Sıfırla" seçeneği vardır.

## Faz 11 — Karakter Seçimi ve Animasyon

- [x] `CharacterManager.gd` scriptini yaz (autoload): seçili karakteri `ConfigFile` ile kalıcı tut (`user://settings.cfg`).
- [x] Ana menüye karakter seçim bölgesi ekle (6 karakter: mavi, yeşil, turuncu, mor, beyaz, sarı).
- [x] `Player.gd`'ye 3 kareli koşma animasyonu ekle; seçili karakterin sprite'ları kullanılır.
- [x] Zıplama ve eğilme durumlarında animasyon yerine sabit kare göster.

## Faz 12 — Buff Altyapısı

- [x] `Buff.tscn` / `Buff.gd` oluştur: engeller gibi sağdan sola hareket eden, `Area2D` ile toplanabilen nesne.
- [x] Buff görselini koddan çiz: kademe rengine göre daire (mavi/yeşil/turuncu) + üstünde ikon (kalkan/saat) veya çarpan yazısı (2x/3x/4x).
- [x] `BuffManager.gd` scriptini yaz (autoload): aktif buff'ları ve kalan sürelerini takip et, süresi bitenleri kaldır.
- [x] Buff toplanınca `get_buff.mp3` çal.
- [x] Ekran dışına çıkan toplanmamış buff'ları temizle (`queue_free()`).

> Not: Buff türleri/kademeleri ve etki değerleri `BuffManager.DEFINITIONS` içinde tek yerde tanımlıdır. Daire, ayrı bir görsel varlık yerine `BuffCircle.gd` ile koddan çizilir.

## Faz 13 — Buff Etkileri

- [ ] Kalkan: sayılı dokunulmazlık (1/2/3) uygula; çarpışmada hakkı azalt, hak bitince veya süre dolunca kalkanı kaldır.
- [ ] Zaman: oyun akışını kademeye göre yavaşlat (engeller, arka plan ve zorluk artışı birlikte).
- [ ] Skor çarpanı: kademeye göre (2x/3x/4x) skor kazanımını çarp.
- [ ] `GameManager` ve `Obstacle` ile entegrasyon: çarpışma artık kalkan durumunu kontrol etmeli.

## Faz 14 — Buff Üretimi ve Denge

- [ ] `SpawnManager`'a buff üretimi ekle (engellerle çakışmayacak konumlarda).
- [ ] Nadirlik dağılımını uygula: türler arası eşit, her tür içinde güçlü kademe daha nadir.
- [ ] Ekranda aktif buff göstergesi (kalan süre / kalan dokunulmazlık).
- [ ] Playtest ile buff süreleri, çıkma sıklığı ve etki güçlerini dengele.

## Faz 15 — Son Cilalama ve Proje Kapanışı

Projenin son fazı. Tüm sürümler (MVP, v1, v2) tamamlandıktan sonra yapılır.

- [ ] Tüm dokümanları (`README.md`, `CLAUDE.md`, `docs/*.md`) baştan sona gözden geçir; güncelliğini yitirmiş, çelişkili veya eksik kalmış bütün metinleri düzelt.
- [ ] Oyunu uçtan uca test et: her zorluk, her karakter, her buff türü/kademesi, menü akışları, ayarlar ve kalıcılık (kapat-aç).
- [ ] Test sırasında çıkan hataları düzelt.
- [ ] Genel oynanabilirlik dengesini son kez gözden geçir (zorluk eğrisi, buff sıklığı).
- [ ] Demo için oynanış kaydı/ekran görüntüsü al, `demo/` klasörüne ekle (MVP Faz 5'ten devreden madde).
