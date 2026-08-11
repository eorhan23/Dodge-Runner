# Roadmap.md

Bu dosya, Dodge Runner'ın sürüm yol haritasını ve her sürümün kapsamını özetler. Faz bazlı görev listesi için bkz. [../tasks/Tasks.md](../tasks/Tasks.md).

## Sürüm Stratejisi

Proje üç sürüme bölünmüştür. Her sürüm kendi PRD dosyasına ve kendi git dalına sahiptir; tamamlandığında bir etiketle işaretlenir. Bu sayede her sürüm bağımsız olarak çalıştırılabilir ve karşılaştırılabilir durumda kalır.

| Sürüm | PRD | Dal | Etiket |
|---|---|---|---|
| MVP | [PRD.md](PRD.md) | `main` | `mvp` |
| v1 | [PRD_v1.md](PRD_v1.md) | `prd-v1` | `v1` |
| v2 | [PRD_v2.md](PRD_v2.md) | `prd-v2` | `v2` |

Sürümler birikimlidir: v1, MVP'nin üzerine kurulur; v2, v1'in üzerine. Bir sonraki sürümün dalı, bir öncekinin tamamlandığı noktadan açılır.

## MVP — Oynanabilir Çekirdek

**Hedef:** Oyunun temel döngüsünün uçtan uca çalışması. Bir kullanıcı oyunu açıp oynayabilmeli, ölebilmeli ve tekrar başlayabilmelidir.

**Kapsam:**

- Sabit x-konumunda koşan, zıplayan ve eğilen karakter
- Sağdan sola akan engeller, farklı varyantlar
- Kademeli zorluk artışı ve süre bazlı skor
- Çarpışma tespiti ve oyun sonu ekranı
- Pixel-art görseller ve kontrol talimatı

**Kapsam dışı:** Menü, ses, kalıcı veri, özelleştirme.

## v1 — Kullanıcı Deneyimi Katmanı

**Hedef:** Oyunu tek seferlik bir demodan, tekrar açılmaya değer bir uygulamaya dönüştürmek. Bu sürümün ortak teması **kalıcılık ve kontrol**: kullanıcının tercihleri ve ilerlemesi hatırlanır.

**Kapsam:**

- Ana menü ve üç zorluk seviyesi (Kolay / Normal / Zor)
- Ses efektleri, döngülü arka plan müziği, ayarlanabilir ses seviyeleri
- Sonsuz kayan arka plan
- Yerel istatistikler: en yüksek skor, tur sayısı, ortalama süre, son 5 skor — zorluk bazında
- Değiştirilebilir tuş atamaları ve ayarlar ekranı

## v2 — Çeşitlilik ve Derinlik

**Hedef:** Tekrar oynanabilirliği artırmak. v1 "oyunu senin hâline getirir", v2 "her turu birbirinden farklı kılar".

**Kapsam:**

- 6 karakter seçeneği, her biri 3 kareli koşma animasyonuyla
- Güç yükseltmeleri: 3 tür × 3 kademe
  - Kalkan — sayılı dokunulmazlık
  - Zaman — oyun akışını yavaşlatma
  - Skor çarpanı
- Kademe bazlı nadirlik dağılımı ve renk kodlaması
- Ekranda aktif etki göstergesi ve kalkan görsel efekti

## Kapanış Fazı

Son faz bir özellik sürümü değildir; projeyi teslim edilebilir hâle getirir:

- Tüm dokümanların gözden geçirilmesi ve tutarlılık düzeltmeleri
- Uçtan uca test: her zorluk, karakter, güç yükseltmesi kademesi, menü akışı ve kalıcılık senaryosu
- Test sırasında çıkan hataların düzeltilmesi ve son denge ayarı
- Demo kaydı

## Kapsam Dışı Bırakılanlar

Aşağıdaki fikirler bilinçli olarak kapsam dışıdır. Gerekçe, projenin çevrimdışı ve tek kullanıcılı kalması ve staj süresi içinde tamamlanabilir bir kapsam korunmasıdır:

- Çevrimiçi skor tablosu, hesap sistemi, çok oyunculu mod
- Seviye/bölüm ilerlemesi, hikâye modu, kayıtlı oyun
- Mobil veya dokunmatik kontrol desteği
- Mağaza, para birimi veya oyun içi satın alma
