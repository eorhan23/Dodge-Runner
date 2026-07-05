# UserStories.md

## Persona (Kısa)

**Adı:** Casual Oyuncu
**Profil:** Kısa molalarda telefonuna veya bilgisayarına bakıp hızlı bir şeyler oynamak isteyen, uzun öğrenme süreci istemeyen kullanıcı.
**Motivasyon:** Zaman öldürmek, refleks/skor rekabeti, "bir tur daha" hissi.

## Kullanıcı Hikayeleri

### US-1: Oyuna Hızlı Başlama
**Olarak** bir oyuncu,
**İstiyorum ki** oyunu açar açmaz nasıl oynanacağını hemen anlayayım,
**Böylece** öğrenmek için zaman kaybetmeyeyim.

**Kabul Kriterleri:**
- Oyun açıldığında kontrollerin ne olduğu (Yukarı Ok: zıpla, Aşağı Ok: eğil) açıkça görünür.
- İlk 5 saniye içinde oyuncu bir engelle karşılaşır (öğrenme eğrisi hızlı başlar).

### US-2: Zıplama ile Engelden Kaçma
**Olarak** bir oyuncu,
**İstiyorum ki** Yukarı Ok tuşuna bastığımda karakterim zıplasın,
**Böylece** zeminden yükselen engellerden kaçabileyim.

**Kabul Kriterleri:**
- Yukarı Ok tuşuna basıldığında karakter belirli bir yüksekliğe zıplar.
- Zıplama sırasında zeminden yükselen bir engelle çarpışma olmaz (doğru zamanlamada).
- Zıplama animasyonu/hareketi görsel olarak akıcıdır.

### US-3: Eğilme ile Engelden Kaçma
**Olarak** bir oyuncu,
**İstiyorum ki** Aşağı Ok tuşuna bastığımda karakterim eğilsin,
**Böylece** üstten gelen alçak engellerden kaçabileyim.

**Kabul Kriterleri:**
- Aşağı Ok tuşuna basıldığında karakterin çarpışma alanı (hitbox) küçülür/alçalır.
- Eğilme sırasında üstten gelen bir engelle çarpışma olmaz (doğru zamanlamada).

### US-4: Zorluk Artışı ile Meydan Okuma Hissi
**Olarak** bir oyuncu,
**İstiyorum ki** oyun ilerledikçe hızlansın ve zorlaşsın,
**Böylece** sürekli tetikte kalayım ve oyun sıkıcı olmasın.

**Kabul Kriterleri:**
- Oyun başladıktan belirli bir süre sonra engel hızı ve/veya sıklığı artar.
- Zorluk artışı ani değil, kademelidir.

### US-5: Çarpışma ve Oyun Sonu
**Olarak** bir oyuncu,
**İstiyorum ki** bir engele çarptığımda oyunun bittiğini ve skorumu göreyim,
**Böylece** performansımı değerlendirip tekrar deneyebileyim.

**Kabul Kriterleri:**
- Çarpışma anında oyun durur.
- Skor (hayatta kalınan süre veya geçilen engel sayısı) ekranda gösterilir.
- "Tekrar Oyna" seçeneği sunulur ve çalışır.

### US-6: Skor Takibi ile Motivasyon
**Olarak** bir oyuncu,
**İstiyorum ki** her oyunda skorumu görebileyim,
**Böylece** kendimi geliştirip geliştirmediğimi anlayabileyim.

**Kabul Kriterleri:**
- Oyun sırasında güncel skor ekranda görünür.
- Oyun bitiminde final skor net şekilde gösterilir.
