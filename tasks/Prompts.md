# Prompts.md

Bu dosya, Dodge Runner'ın geliştirilmesinde AI Agent'a (Claude Code) verilen yönlendirmelerin yöntemini ve öğrenilen dersleri kaydeder. Amaç, kullanılan her komutu tek tek listelemek değil; **hangi yönlendirme biçiminin işe yaradığını** belgelemektir.

## Kalıcı Bağlam

Projeye özgü kurallar her seferinde tekrar yazılmaz; repo kökündeki `CLAUDE.md` dosyasında tutulur ve Agent tarafından otomatik okunur. Bu dosya şunları içerir:

- Proje özeti ve teknoloji yığını
- Okunması zorunlu doküman listesi
- Kritik oyun mantığı kuralları (karakter sabit x'te durur, çarpışma `Area2D` ile yapılır, zorluk kademeli artar)
- Çalışma kuralları (faz sırasını bozma, kapsam dışına çıkma, açık soruları varsayımla kapatma)

Bu yaklaşımın faydası, aynı talimatın her oturumda tekrarlanmasına gerek kalmamasıdır. Kural değiştiğinde tek bir dosya güncellenir.

## Yönlendirme Kalıpları

### Faz bazlı ilerleme

Temel kalıp şudur:

> "Tasks.md'deki Faz N maddelerini sırayla uygula. Her maddeyi tamamladığında ilgili kutucuğu işaretle. Faz N bitmeden Faz N+1'e geçme."

Bu kalıbın işe yaramasının nedeni, kapsamı önceden yazılı bir listeye sabitlemesidir. Agent'ın "yararlı olur" diye ekstra özellik eklemesi böylece engellenir.

### Belirsizlikte sorma zorunluluğu

> "Emin olmadığın bir teknik karar varsa bana sormadan varsayım yapma, sor."

Bu cümle özellikle mimari kararlarda (proje ayarları, motor sürümü, klasör yapısı) etkili olmuştur. Aksi hâlde Agent makul ama istenmeyen bir varsayımla ilerleyip sonradan geri alınması gereken iş üretebilir.

### Hata bildiriminde davranışı tarif etme

En verimli hata bildirimleri, çözümü değil **gözlemi** tarif edenlerdir:

> "Oyun hızlandığında alt ve üst engel birbirine çok yakın çıkıyor ve o aradan sıyrılmak mümkün olmuyor."

Bu tarif, Agent'ı sayısal doğrulamaya yöneltir (zıplama süresi ile engel arası mesafenin hıza göre karşılaştırılması) ve kök nedene ulaştırır. Buna karşılık "engellerin arasını aç" gibi bir çözüm talimatı, belirtiyi bastırır ama aynı sorunun başka hızlarda tekrarlamasını engellemez.

### Ekran görüntüsü ile bildirim

Görsel sorunlarda (karakterin havada durması, sprite'ın yanlış kare göstermesi) ekran görüntüsü paylaşmak, metinle tarif etmekten belirgin şekilde hızlı sonuç vermiştir.

## Öğrenilen Dersler

### Doküman üslubu açıkça belirtilmelidir

Agent, istenmediği hâlde dokümanlara ilerleme durumu ("şu an Faz 5 tamamlandı") yazma eğilimindedir. Bu tür metinler her fazda güncellenmek zorunda kalır ve kısa sürede yanlış bilgiye dönüşür. Uygulanan kural:

> "Dinamik terimler üretme; statik ve sonradan tekrar tekrar güncellenmeye ihtiyaç duymayacak öz metinler üret."

Güncel durum tek bir yerde — görev listesindeki kutucuklarda — tutulur, başka dosyada tekrarlanmaz.

### Detay seviyesi istenerek ayarlanmalıdır

Agent, kısa tutulması gereken dokümanları (örneğin bir PRD) gereksiz yere genişletebilir. Mevcut dosyaları örnek göstermek ("diğer PRD dosyaları gibi olsun") en pratik düzeltmedir.

### Görsel varlıklar doğrulanmalıdır

Küçük pixel-art sprite'ların hangi karesinin hangi pozu gösterdiği, dosya adından anlaşılmaz. Bir kez yanlış varsayılmış (duruş karesi olarak yanlış indeks seçilmiş) ve ancak sprite'lar büyütülerek görüntülendiğinde düzeltilebilmiştir. Ders: varlıkla ilgili varsayımlar, varlığa bakılarak doğrulanmalıdır.

### Planı önce onaylatmak geri alma maliyetini düşürür

Büyük değişikliklerde (yeni sürüme geçiş, dal açma, klasör yapısı değişikliği) Agent'tan önce plan istemek, uygulanmış ama istenmeyen değişiklikleri geri alma zahmetini ortadan kaldırmıştır.

### Kök neden aranmalı, belirti bastırılmamalıdır

Birkaç hatada ilk çözüm belirtiyi giderdi ama sorunu bitirmedi:

- Güç yükseltmelerinin engel içinde çıkması — ilk düzeltme yalnızca **mevcut** engelleri kontrol ediyordu; sonradan doğan engeller aynı soruna yol açmaya devam etti. Kalıcı çözüm için korumanın iki yönlü olması gerekti.
- Kaçılamaz engel kombinasyonu — mesafeyi büyütmek düşük hızda yeterliydi, ama sorun mesafenin **sabit piksel** olmasıydı. Boşluk süreye bağlanınca her hızda çözüldü.

Ders: bir düzeltme sonrası "bu hangi koşullarda yine olur?" sorusu sorulmalıdır.

## Örnek Yönlendirmeler

Aşağıdakiler, proje boyunca kullanılan tipik yönlendirmelerdir:

**Faz başlatma:**
> "CLAUDE.md, docs/PRD.md, docs/Architecture.md ve tasks/Tasks.md dosyalarını oku. Tasks.md'deki Faz 0 maddelerini sırayla uygula. Her maddeyi tamamladığında ilgili kutucuğu işaretle."

**Kapsam sınırlama:**
> "Plan iyi fakat şu değişiklikle uygula: sadece var olan tek arka plan görselini kullanacağız, o görsel yan yana sonsuza kadar akacak. Çok basit ve kısa."

**Hata bildirimi:**
> "Ölüp tekrar oynaya basınca şu hatayı veriyor ve oyun kapanıyor." *(ekran görüntüsüyle)*

**Doküman bakımı:**
> "Başka bütün dosyalarda ne kadar güncel olmayan metin varsa hepsini güncelle."

**Denge ayarı:**
> "Zaman yavaşlatma sadece dış dünya için geçerli olacak. Yürüyüş animasyonu yavaşlayacak fakat zıplama aynı hızda kalacak; zaten bu buff'ın faydası engelleri kolay aşmamız için hızlı zıplayabilmek."
