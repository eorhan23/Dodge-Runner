# Görev Listesi — Dodge Runner

Bu liste `PRD.md` ve `Architecture.md` dokümanlarına dayanır. Her madde Claude Code tarafından uygulanacak şekilde atomik ve somut adımlar içerir. Bir görev tamamlandığında kutuyu `- [x]` olarak işaretle. Fazlar sıralı bağımlılık taşır (bir sonraki faz öncekine dayanır), ancak her faz içindeki bağımsız maddeler paralel yürütülebilir.

## Faz 0 — Proje Kurulumu

- [x] `src/` klasörü altında yeni bir Godot 4 projesi oluştur (`project.godot` burada oluşacak).
- [x] Proje ayarlarında pencere boyutu ve adı (Dodge Runner) tanımla.
- [x] `scenes/`, `scripts/`, `assets/sprites/` alt klasörlerini oluştur.
- [x] Repo köküne `.gitignore` ekle (`.godot/`, `.import/`, `export.cfg` hariç tutulsun).
- [x] Boş bir `Main.tscn` sahnesi oluştur ve ana sahne olarak ayarla.

## Faz 1 — Karakter Mekaniği

- [ ] `Player.tscn` sahnesini oluştur: `CharacterBody2D` kök node + `CollisionShape2D` + basit görsel (ColorRect veya Sprite2D placeholder).
- [ ] `Player.gd` scriptini yaz: Yukarı Ok tuşuna basınca zıplama hareketi.
- [ ] `Player.gd`'ye eğilme mantığını ekle: Aşağı Ok tuşuna basınca çarpışma şekli küçülür/alçalır.
- [ ] Karakterin sabit x-konumunda kalmasını, yalnızca y ekseninde hareket etmesini sağla.
- [ ] Zıplama ve eğilme arasında geçiş durumlarını (Running / Jumping / Ducking) basit bir state (durum) değişkeniyle yönet.

## Faz 2 — Engel Sistemi

- [ ] `Obstacle.tscn` sahnesini oluştur: `Area2D` kök node + `CollisionShape2D` + basit görsel.
- [ ] `Obstacle.gd` scriptini yaz: `_process(delta)` içinde sabit hızla sola hareket.
- [ ] En az 3-4 farklı engel varyasyonu tanımla (yükseklik/konum farkıyla): üstten gelen alçak engel, zeminden yükselen engel, çift engel kombinasyonu, farklı hızda engel.
- [ ] `SpawnManager.gd` scriptini yaz: bir `Timer` node'u ile periyodik olarak rastgele bir engel tipini örnekleyip (instantiate) sahneye ekle.
- [ ] Ekran dışına çıkan engelleri bellekten temizle (`queue_free()`).

## Faz 3 — Zorluk Artışı ve Skor Sistemi

- [ ] `GameManager.gd` scriptini yaz (autoload/singleton olarak proje ayarlarına ekle).
- [ ] Oyun başladığından beri geçen süreyi takip eden bir sayaç ekle.
- [ ] Belirli aralıklarla (örn. her 10 saniyede bir) engel hızını ve/veya spawn sıklığını kademeli olarak artır.
- [ ] Skor hesaplama mantığını belirle ve uygula (hayatta kalınan süre veya geçilen engel sayısı — bkz. Architecture.md §8 açık soru).
- [ ] Skoru oyun sırasında ekranda göster (basit bir Label node ile).

## Faz 4 — Çarpışma ve Oyun Sonu

- [ ] `Obstacle` ile `Player` arasındaki `Area2D` çarpışma sinyalini (`body_entered`) bağla.
- [ ] Çarpışma anında `GameManager.game_over()` fonksiyonunu tetikle: oyunu durdur, tüm hareketi dondur.
- [ ] `GameOver.tscn` sahnesini oluştur: final skor gösterimi + "Tekrar Oyna" butonu.
- [ ] "Tekrar Oyna" butonuna basınca oyunun temiz bir başlangıç durumuna sıfırlanmasını sağla (skor, hız, engel listesi sıfırlanır).

## Faz 5 — Cilalama ve Demo Hazırlığı

- [ ] Placeholder görselleri (varsa) daha uygun sprite'larla değiştir.
- [ ] Zorluk eğrisini oynanabilirlik açısından test edip ince ayar yap.
- [ ] Kontrollerin ekranda kısa bir talimat olarak gösterilmesini sağla (oyun başında).
- [ ] Demo için kısa bir oynanış kaydı/ekran görüntüsü al, `demo/` klasörüne ekle.

## Backlog — MVP Dışı (Şimdilik Uygulanmayacak)

Bu maddeler `PRD.md` §7'de MVP kapsamı dışında bırakılmıştır. Kullanıcı açıkça istemedikçe uygulanmaz:

- Mobil / dokunmatik kontrol desteği
- Çoklu seviye (level) tasarımı
- Ses ve müzik sistemi
- Çevrimiçi skor tablosu (online leaderboard)
- Karakter özelleştirme
- Güç-yükseltmeler (power-up'lar)
