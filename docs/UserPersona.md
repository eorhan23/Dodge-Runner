# UserPersona.md

Bu dosya, [Problem.md](Problem.md)'deki "hedef kullanıcı" özetini detaylandırır. Kullanıcı hikayeleri ve kabul kriterleri için bkz. [UserStories.md](UserStories.md).

## Birincil Persona — "Mola Oyuncusu"

**Profil:** 18-35 yaş arası, bilgisayar başında çalışan (öğrenci veya ofis çalışanı) bir kullanıcı. Gün içinde bilgisayarını uzun süre kullanıyor ve kısa aralar veriyor.

**Bağlam:** Oyunu ders/iş arasındaki 5-10 dakikalık molalarda açıyor. Klavyesi zaten elinin altında; oyun için ayrı bir donanım veya hesap açma zahmetine girmek istemiyor.

**İhtiyaçlar:**

- Açılır açılmaz oynanabilen, kurulum ve öğrenme yükü olmayan bir oyun.
- Tek elle, iki tuşla yönetilebilen basit kontrol.
- Bir tur bittiğinde hemen yeniden başlayabilme.
- Kendi gelişimini görebilme (en yüksek skor, geçmiş turlar).

**Engeller / Sinir Bozucular:**

- Hesap açma, giriş yapma veya internet bağlantısı zorunluluğu.
- Reklam ve tur arası bekleme ekranları.
- Kaçınılması imkânsız engeller — oyuncunun hatası olmadan ölmek, tekrar oynama isteğini kırar.
- Uzun süren giriş animasyonları ve menü akışları.

**Başarı Ölçütü:** Kullanıcı, oyunu açtıktan sonra 10 saniye içinde oynuyor olmalı ve bir tur bittiğinde tek tuşla yeni tura başlayabilmeli.

## İkincil Persona — "Rekor Kovalayan Oyuncu"

**Profil:** Aynı yaş grubunda, ancak oyunu bir kez keşfettikten sonra tekrar tekrar açıp kendi rekorunu geçmeye çalışan kullanıcı.

**Farklılaşan İhtiyaçlar:**

- Zorluk seviyesi seçebilme — oyun kolaylaştığında kendini daha çok zorlayabilme.
- Detaylı istatistik: en yüksek skor, oynanan tur sayısı, ortalama hayatta kalma süresi, son turların skorları.
- Kontrolleri kendi alışkanlığına göre değiştirebilme.
- Görsel çeşitlilik (karakter seçimi) ve tur içinde stratejik kararlar (hangi güç yükseltmesini toplamalı).

**Engeller / Sinir Bozucular:**

- İlerlemenin kaydedilmemesi; oyunu kapatınca istatistiklerin sıfırlanması.
- Rastgeleliğin beceriyi gölgelemesi — aynı beceriyle çok farklı skorlar çıkması.

**Başarı Ölçütü:** Kullanıcı, oyunu kapatıp tekrar açtığında istatistiklerini ve tercihlerini olduğu gibi bulmalı.

## Persona Dışı Kalanlar

Aşağıdaki kullanıcı grupları bilinçli olarak hedeflenmemiştir; bu, kapsamı dar ve net tutmak içindir:

- **Rekabetçi/çevrimiçi oyuncular** — küresel skor tablosu, arkadaş listesi veya çok oyunculu mod yoktur. Proje tamamen çevrimdışı çalışır.
- **Mobil ve dokunmatik kullanıcılar** — kontrol şeması klavyeye dayanır; hedef platform masaüstüdür.
- **Uzun oturumlu oyun arayanlar** — hikâye, seviye ilerlemesi veya kayıtlı oyun (save/continue) yoktur; her tur bağımsızdır.
