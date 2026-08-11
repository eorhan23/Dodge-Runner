# Dodge Runner

Yandan bakışlı (side-scroller), sonsuz koşu tarzında bir 2D arcade oyunu. Oyuncu sabit bir konumdan ilerlerken üstten ve alttan gelen engellerden zıplayarak veya eğilerek kaçar.

## Proje Amacı

Kısa sürede öğrenilebilen ama ustalaşması zor, klavye kontrollü bir refleks oyunu geliştirmek. Detaylar için [docs/PRD.md](docs/PRD.md) dosyasına bakınız.

## Özellikler

- Zıplama ve eğilme mekaniği, farklı engel varyantları
- Üç zorluk seviyesi ve zamanla kademeli artan hız
- Altı karakter seçeneği, koşma animasyonlu
- Üç tür × üç kademe güç yükseltmesi: kalkan, zaman yavaşlatma, skor çarpanı
- Ses efektleri, arka plan müziği ve ayarlanabilir ses seviyeleri
- Zorluk bazında yerel istatistikler ve değiştirilebilir tuş atamaları

Tamamen çevrimdışı çalışır; sunucu, hesap veya internet bağlantısı gerektirmez.

## Teknoloji

- **Oyun Motoru:** Godot 4
- **Dil:** GDScript
- **Platform:** Masaüstü (Windows/Linux/macOS)
- **Kontrol:** Klavye (Yukarı Ok / Boşluk: zıpla, Aşağı Ok: eğil — ayarlardan değiştirilebilir)

## Doküman Yapısı

| Dosya | İçerik |
|---|---|
| [docs/Problem.md](docs/Problem.md) | Çözülmeye çalışılan problem ve motivasyon |
| [docs/UserPersona.md](docs/UserPersona.md) | Hedef kullanıcı profilleri |
| [docs/UserStories.md](docs/UserStories.md) | Kullanıcı hikayeleri ve kabul kriterleri |
| [docs/PRD.md](docs/PRD.md) | Ürün sürümleri, kapsam, MVP sınırları |
| [docs/Architecture.md](docs/Architecture.md) | Teknik mimari, klasör/sahne yapısı, oyun döngüsü |
| [docs/Modules.md](docs/Modules.md) | Modül tasarımı ve sorumluluk dağılımı |
| [docs/Database.md](docs/Database.md) | Veri modeli ve kalıcılık şeması |
| [docs/API.md](docs/API.md) | Dahili modül arayüzleri |
| [docs/Roadmap.md](docs/Roadmap.md) | Sürüm yol haritası |
| [tasks/Tasks.md](tasks/Tasks.md) | Faz bazlı görev listesi ve ilerleme takibi |
| [tasks/Sprint.md](tasks/Sprint.md) | Fazların sprint düzeyinde özeti |
| [tasks/DefinitionOfDone.md](tasks/DefinitionOfDone.md) | "Bitti" sayılma ölçütleri |
| [tasks/Prompts.md](tasks/Prompts.md) | AI Agent yönlendirme yöntemi |
| [demo/Demo.md](demo/Demo.md) | Çalıştırma ve demo senaryosu |
| [RELEASE_NOTES.md](RELEASE_NOTES.md) | Sürüm notları |

## Kurulum

Ek bağımlılık, paket kurulumu veya internet bağlantısı gerekmez — yalnızca oyun motoru yeterlidir.

1. [Godot 4.7](https://godotengine.org/download) indirin. Kurulum gerektirmez; indirilen dosya doğrudan çalıştırılır. (Proje **Godot 4.7** ile geliştirildi; daha yeni 4.x sürümleri de çalışır.)
2. Godot Proje Yöneticisi'nde **Import** ile `src/project.godot` dosyasını seçin ve projeyi açın.
3. **F5** ile projeyi çalıştırın; oyun ana menüyle açılır.

Oynanış kaydı ve ekran görüntüleri için bkz. [demo/](demo/).

## Lisans

*(Belirtilmedi)*
