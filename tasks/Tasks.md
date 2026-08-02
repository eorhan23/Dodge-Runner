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

## Backlog — V2 (Şimdilik Uygulanmayacak)

Bu maddeler `PRD_v2.md`'de yer alır, kullanıcı açıkça istemedikçe uygulanmaz:

- Karakter özelleştirme
- Güç-yükseltmeler (power-up'lar)
