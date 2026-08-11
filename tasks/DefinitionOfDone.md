# DefinitionOfDone.md

Bu dosya, Dodge Runner'da bir işin "bitti" sayılması için karşılanması gereken ölçütleri tanımlar. Amaç, "çalışıyor gibi görünüyor" ile "gerçekten tamam" arasındaki farkı net tutmaktır.

## Görev Düzeyinde

[Tasks.md](Tasks.md)'deki bir maddenin `- [x]` olarak işaretlenebilmesi için:

1. **Çalışıyor.** Özellik Godot Editor'da çalıştırılarak elle denenmiş ve beklendiği gibi davranmıştır.
2. **Hata üretmiyor.** Godot çıktı panelinde yeni hata veya uyarı yoktur.
3. **Kapsam içindedir.** Yapılan iş, ilgili sürümün PRD'sinde tanımlı olanla sınırlıdır; yolda akla gelen ekstra özellikler eklenmemiştir.
4. **Faz sırası korunmuştur.** Bir sonraki fazın işi, önceki faz tamamlanmadan yapılmamıştır.
5. **Sayısal değerler tek yerdedir.** Yeni bir denge değeri (hız, süre, olasılık) koda dağıtılmamış, ilgili modülün sabitler bölümüne konmuştur.
6. **Neden'i yazılmıştır.** Sezgiye aykırı bir çözüm varsa, kodda o kararın nedenini açıklayan bir yorum bulunur — ne yaptığı değil, neden öyle yapıldığı.
7. **Görev listesi güncellenmiştir.** Kutucuk işaretlenmiş; karar veya bilgi değeri taşıyan bir ayrıntı varsa fazın altına not olarak eklenmiştir.

## Faz Düzeyinde

Bir fazın tamamlanmış sayılması için, yukarıdakilere ek olarak:

1. **Fazın tüm maddeleri işaretlidir.** İşaretlenemeyen bir madde varsa, nedeni açıkça belirtilmiştir.
2. **Regresyon yoktur.** Önceki fazların özellikleri hâlâ çalışmaktadır — özellikle oyun döngüsü, çarpışma ve sahne geçişleri.
3. **Etkilenen dokümanlar güncellenmiştir.** Faz; klasör yapısını, modül sorumluluklarını veya oyun kurallarını değiştirdiyse ilgili doküman da güncellenmiştir.
4. **Commit atılmıştır.** Faz, açıklayıcı bir commit mesajıyla kayıt altına alınmıştır.

## Sürüm Düzeyinde

Bir sürümün (MVP / v1 / v2) tamamlanmış sayılması için:

1. **PRD kapsamı karşılanmıştır.** İlgili PRD'deki her özellik uygulanmış veya kapsam dışı bırakıldığı gerekçesiyle kayda geçirilmiştir.
2. **Uçtan uca test edilmiştir.** Menü akışları, her zorluk seviyesi, oyun döngüsü ve oyun sonu ekranı sırayla denenmiştir.
3. **Kalıcılık doğrulanmıştır** (v1 ve sonrası). Oyun kapatılıp yeniden açıldığında ayarlar ve istatistikler korunmaktadır.
4. **Sürüm etiketlenmiştir.** Git etiketi atılmış, bir sonraki sürümün dalı bu noktadan açılmıştır.

## Oyun Mekaniği İçin Ek Ölçütler

Oyun kurallarını etkileyen işlerde, "çalışıyor" yetmez:

1. **Kaçılamaz durum üretmiyor.** Hiçbir engel kombinasyonu, oyuncunun doğru oynadığı hâlde ölmesine yol açmamalıdır. Bu, özellikle yüksek hızlarda kontrol edilmelidir — düşük hızda güvenli görünen bir mesafe, hız arttıkça kaçınılmaz hâle gelebilir.
2. **Zamanlama piksele değil süreye bağlıdır.** Oyuncunun tepki verebilmesi için gereken boşluklar, hızdan bağımsız olarak sabit bir süreye karşılık gelmelidir.
3. **Zorluk artışı kademelidir.** Ani sıçrama yoktur ve bir üst sınır tanımlıdır.
4. **Geri bildirim vardır.** Oyuncunun durumunu değiştiren her olayın görsel veya işitsel bir karşılığı olmalıdır.

## Doküman İçin Ölçütler

1. **Metin statiktir.** Doküman, ilerleme durumu gibi sık değişen bilgileri tekrarlamaz; güncel durum tek bir yerde (görev listesi) tutulur.
2. **Çelişki yoktur.** Aynı bilgi birden fazla dosyada geçiyorsa, hepsi aynı şeyi söyler.
3. **Kapsam dışı kararlar gerekçelidir.** Bir şeyin neden yapılmadığı, ne yapıldığı kadar açıktır.
