# Dodge Runner

Yandan bakışlı (side-scroller), sonsuz koşu tarzında bir 2D arcade oyunu. Oyuncu sabit bir konumdan ilerlerken üstten ve alttan gelen engellerden zıplayarak veya eğilerek kaçar.

## Durum

🏗️ Bu proje aktif olarak geliştiriliyor. Temel oynanış döngüsü uçtan uca çalışıyor: zıplama/eğilme, engeller, zamanla artan zorluk, skor, çarpışma ve "Tekrar Oyna" ekranı. Cilalama ve son rötuşlar sürüyor.

## Proje Amacı

Kısa sürede öğrenilebilen ama ustalaşması zor, klavye kontrollü bir refleks oyunu geliştirmek. Detaylar için [docs/PRD.md](docs/PRD.md) dosyasına bakınız.

## Teknoloji

- **Oyun Motoru:** Godot 4
- **Dil:** GDScript
- **Platform:** Masaüstü (Windows/Linux/macOS)
- **Kontrol:** Klavye (Yukarı Ok: zıpla, Aşağı Ok: eğil)

## Doküman Yapısı

| Dosya | İçerik |
|---|---|
| `docs/Problem.md` | Çözülmeye çalışılan problem ve motivasyon |
| `docs/PRD.md` | Ürün sürümleri, kapsam, MVP sınırları |
| `docs/UserStories.md` | Kullanıcı hikayeleri ve kabul kriterleri |
| `docs/Architecture.md` | Teknik mimari, klasör/sahne yapısı, oyun döngüsü |
| `tasks/Tasks.md` | Faz bazlı görev listesi ve ilerleme takibi |

## Kurulum

1. [Godot 4.7](https://godotengine.org/download) (veya üzeri bir 4.x sürümü) indirip kurun.
2. Godot Proje Yöneticisi'nde "Import" ile `src/project.godot` dosyasını seçin ve projeyi açın.
3. Editörde F5 (veya F6) ile `Main.tscn` sahnesini çalıştırın.

## Lisans

*(Belirtilmedi)*
