extends Node

const SAVE_PATH := "user://stats.cfg"
const RECENT_SCORES_LIMIT := 5

# GameManager.Difficulty sırasına karşılık gelen dosya bölüm adları
# (EASY=0, NORMAL=1, HARD=2). Autoload yükleme sırasına bağımlı olmamak için
# GameManager'a doğrudan referans verilmez.
const SECTION_NAMES := ["easy", "normal", "hard"]

var _config := ConfigFile.new()


func _ready() -> void:
	# Dosya yoksa (ilk çalıştırma) hata değil; boş ayarlarla devam edilir.
	_config.load(SAVE_PATH)


func record_game(difficulty: int, score: int, survival_time: float) -> void:
	var section: String = SECTION_NAMES[difficulty]

	var high_score: int = _config.get_value(section, "high_score", 0)
	if score > high_score:
		_config.set_value(section, "high_score", score)

	var games_played: int = _config.get_value(section, "games_played", 0)
	_config.set_value(section, "games_played", games_played + 1)

	var total_time: float = _config.get_value(section, "total_time", 0.0)
	_config.set_value(section, "total_time", total_time + survival_time)

	# En yeni skor başta; liste sabit uzunlukta tutulur.
	var recent: Array = _config.get_value(section, "recent_scores", [])
	recent.push_front(score)
	if recent.size() > RECENT_SCORES_LIMIT:
		recent.resize(RECENT_SCORES_LIMIT)
	_config.set_value(section, "recent_scores", recent)

	_config.save(SAVE_PATH)


func get_stats(difficulty: int) -> Dictionary:
	var section: String = SECTION_NAMES[difficulty]
	var games_played: int = _config.get_value(section, "games_played", 0)
	var total_time: float = _config.get_value(section, "total_time", 0.0)

	# Ortalama, tüm süreleri saklamak yerine toplam/sayı üzerinden hesaplanır.
	var average_time := 0.0
	if games_played > 0:
		average_time = total_time / games_played

	return {
		"high_score": _config.get_value(section, "high_score", 0),
		"games_played": games_played,
		"average_time": average_time,
		"recent_scores": _config.get_value(section, "recent_scores", []),
	}
