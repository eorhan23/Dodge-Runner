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
- [x] Demo için kısa bir oynanış kaydı/ekran görüntüsü al, `demo/` klasörüne ekle.

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

- [x] Kalkan: sayılı dokunulmazlık (1/2/3) uygula; çarpışmada hakkı azalt, hak bitince veya süre dolunca kalkanı kaldır.
- [x] Zaman: oyun akışını kademeye göre yavaşlat (engeller, arka plan ve zorluk artışı birlikte).
- [x] Skor çarpanı: kademeye göre (2x/3x/4x) skor kazanımını çarp.
- [x] `GameManager` ve `Obstacle` ile entegrasyon: çarpışma artık kalkan durumunu kontrol etmeli.

> Not: Hareket eden her şey `GameManager.effective_speed_multiplier()` kullanır — zaman buff'ı tek noktadan uygulanır. Skor, çarpan zamanla değiştiği için artık `elapsed_time`'dan türetilmez, kare kare biriktirilir.

## Faz 14 — Buff Üretimi ve Denge

- [x] `SpawnManager`'a buff üretimi ekle (engellerle çakışmayacak konumlarda).
- [x] Nadirlik dağılımını uygula: türler arası eşit, her tür içinde güçlü kademe daha nadir.
- [x] Ekranda aktif buff göstergesi (kalan süre / kalan dokunulmazlık).
- [x] Playtest ile buff süreleri, çıkma sıklığı ve etki güçlerini dengele.

> Not: Buff üretimi engel ritmine karışmasın diye ayrı bir `Timer` kullanır (7-12 sn aralık). Kademe ağırlıkları `SpawnManager.TIER_WEIGHTS` (45/33/22). Zaman yavaşlatma yalnızca dış dünyayı etkiler; zıplama fiziği ve skor kazanımı gerçek zamanda kalır.
>
> Denge ayarları: etki süresi türden bağımsız, yalnızca kademeye bağlıdır (`BuffManager.TIER_DURATIONS` — 7 / 10 / 13 sn). Yavaşlatma oranları 0.80 / 0.70 / 0.60'tır; daha düşük değerler, zıplama gerçek zamanda kaldığı için havada kalma süresini engellere göre orantısız kısaltıp oyunu zorlaştırıyordu. Buff ile engel arasındaki mesafe iki yönlü korunur: buff üretilirken mevcut engellere bakılır, engel üretilirken de yakında buff varsa üretim `BUFF_RETRY_DELAY` kadar ertelenir.

## Faz 15 — Son Cilalama ve Proje Kapanışı

Projenin son fazı. Tüm sürümler (MVP, v1, v2) tamamlandıktan sonra yapılır.

### Doküman Tamamlama

Staj programının standart MDD klasör yapısında yer alıp projede henüz bulunmayan dosyalar:

- [x] `docs/UserPersona.md` — hedef kullanıcı profili.
- [x] `docs/Modules.md` — modül/bileşen tasarımı ve sorumluluk dağılımı.
- [x] `docs/Roadmap.md` — sürüm yol haritası (MVP → v1 → v2).
- [x] `docs/Database.md` — veri modeli; bu projede veritabanı yerine yerel dosya kalıcılığı kullanıldığı için kapsam gerekçesi ve `ConfigFile` şeması.
- [x] `docs/API.md` — endpoint planı; çevrimdışı proje olduğu için kapsam gerekçesi ve dahili modüller arası arayüzler.
- [x] `tasks/Sprint.md` — fazların sprint planı olarak özeti.
- [x] `tasks/DefinitionOfDone.md` — bir görevin "bitti" sayılma ölçütleri.
- [x] `tasks/Prompts.md` — geliştirme sürecinde AI Agent'a verilen yönlendirmeler.
- [x] `demo/Demo.md` — demo senaryosu ve çalıştırma talimatları.
- [x] `RELEASE_NOTES.md` — sürüm notları.

### Test, Düzeltme ve Kapanış

- [x] Tüm dokümanları (`README.md`, `CLAUDE.md`, `docs/*.md`) baştan sona gözden geçir; güncelliğini yitirmiş, çelişkili veya eksik kalmış bütün metinleri düzelt.
- [x] Ölü nokta hatasını düzelt: yüksek hızlarda çift engelin arası ve ardışık engel aralığı, kaçışı fiziksel olarak imkânsız kılacak kadar daralıyordu.
- [x] Ayarlar ekranına tüm kalıcı veriyi silen "Oyunu Sıfırla" seçeneği ekle (onay adımıyla).
- [x] Paylaşılan `settings.cfg` yazma çakışmasını düzelt: karakter seçimi ile ses/tuş ayarları birbirinin kaydını siliyordu.
- [x] Oyunu Godot Editor'da uçtan uca elle test et: her zorluk, her karakter, her buff türü/kademesi, menü akışları, ayarlar ve kalıcılık (kapat-aç).
- [x] Test sırasında çıkan diğer hataları düzelt.
- [x] Genel oynanabilirlik dengesini son kez gözden geçir (zorluk eğrisi, buff sıklığı).
- [x] Demo için oynanış kaydı/ekran görüntüsü al, `demo/screenshots/` klasörüne ekle (MVP Faz 5'ten devreden madde).

> Not: Ölü nokta düzeltmesinin ilkesi, engeller arası boşluğu piksel yerine **zaman** cinsinden sabitlemektir. Zıplama süresi (`2 * |JUMP_VELOCITY| / GRAVITY` = 0.8 sn) oyun hızından bağımsız olduğu için, sabit piksel mesafesi hız arttıkça giderek kısalan bir süreye denk gelir ve bir noktada kaçış imkânsızlaşır.
>
> Gereken boşluk **önceki engelin türüne** bağlıdır: zemin engelinden sonra oyuncu 0.8 sn havada kalır ve eğilemez (`GAP_AFTER_GROUND_SECONDS` = 0.88 sn), tavan engelinden sonra ise eğilme bırakılır bırakılmaz zıplayabilir (`GAP_AFTER_TOP_SECONDS` = 0.38 sn). İkisine de aynı süreyi dayatmak oyunu gereksiz yere seyrekleştirir.
>
> Boşluk hem süre hem piksel cinsinden ölçülür ve **büyük olanı** geçerlidir (`MIN_VISUAL_GAP_PIXELS`). Yalnız zaman ölçütü kullanıldığında, oyun yavaşken süre olarak yeterli olan bir boşluk piksel olarak dar kalıyor ve engeller ekranda dip dibe görünüyordu; oyuncu ikisini tek küme gibi algılayıp tepki veremiyordu. Zaman ölçütü hızlı oyunu, piksel ölçütü yavaş oyunu korur.
>
> Koruma üç parçalıdır ve üçü de gereklidir:
> 1. `current_pair_gap()` — çift engelin iki parçası arasındaki mesafeyi hızla orantılı üretir.
> 2. `_start_timer(variant)` — bir sonraki üretimin alt sınırını grubun **son** engeline göre hesaplar. Çiftin ikinci parçası üretim noktasının sağına konduğu için bu gecikme hesaba katılmazsa sonraki engel onun dibine düşer. (Bu adım ilk denemede atlandığı için düzeltme sorunu çözmek yerine ağırlaştırmıştı.)
> 3. `_are_points_clear()` — üretim anında konum kontrolü, son savunma hattı. Eşiği zamanlayıcıyla birebir aynı tutmak sınırdaki her durumu reddedip oyunu seyrekleştirdiği için `CLEARANCE_TOLERANCE` payı bırakılır.
>
> Tempo (`MIN_SPAWN_INTERVAL` / `MAX_SPAWN_INTERVAL`) adaletten ayrıdır: garanti alt sınırlarda olduğu için üretim aralığı denge amacıyla serbestçe ayarlanabilir.
>
> Doğrulama: oyun headless çalıştırılıp engellerin oyuncu hizasına varış aralıkları ölçüldü (zorluk başına 150 sn), erken ve geç oyun ayrı raporlandı. Kaçılamaz kombinasyon sayısı kolay/normal/zor için düzeltme öncesi 54/78/125 (en dar aralık 0.22 sn), düzeltme sonrası **0/0/0**. Son yoğunluk erken oyunda 0.67 / 0.73 / 0.90, geç oyunda 1.08 / 1.13 / 1.18 engel/sn.
>
> Denge ayarı yapılacaksa iki grup sabit ayrılmıştır: **tempo** (`MIN_SPAWN_INTERVAL` / `MAX_SPAWN_INTERVAL`) serbestçe değiştirilebilir, **adalet** (`GAP_AFTER_*`, `MIN_VISUAL_GAP_PIXELS`) fiziksel sınırlara dayanır ve düşürülürse kaçılamaz durumlar geri döner.
>
> Not: `settings.cfg` dosyasını `SettingsManager` ve `CharacterManager` ayrı `ConfigFile` nesneleriyle paylaşır. Bu yüzden her yazma işleminden önce dosya diskten yeniden okunur; aksi halde bir modülün bellekteki eski kopyası diğerinin kaydını geri alır. Bu hata, sıfırlama özelliği eklenirken yazılan doğrulama testiyle ortaya çıkmıştır.
