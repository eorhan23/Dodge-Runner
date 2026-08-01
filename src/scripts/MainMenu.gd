extends Control

@onready var easy_button: Button = $DifficultyButtons/EasyButton
@onready var normal_button: Button = $DifficultyButtons/NormalButton
@onready var hard_button: Button = $DifficultyButtons/HardButton
@onready var start_button: Button = $StartButton
@onready var high_score_label: Label = $StatsPanel/HighScoreLabel
@onready var games_played_label: Label = $StatsPanel/GamesPlayedLabel
@onready var average_time_label: Label = $StatsPanel/AverageTimeLabel
@onready var recent_scores_label: Label = $StatsPanel/RecentScoresLabel


func _ready() -> void:
	easy_button.pressed.connect(_on_difficulty_selected.bind(GameManager.Difficulty.EASY))
	normal_button.pressed.connect(_on_difficulty_selected.bind(GameManager.Difficulty.NORMAL))
	hard_button.pressed.connect(_on_difficulty_selected.bind(GameManager.Difficulty.HARD))
	start_button.pressed.connect(_on_start_pressed)
	_sync_selection()


func _on_difficulty_selected(new_difficulty: GameManager.Difficulty) -> void:
	AudioManager.play_ui_click()
	GameManager.set_difficulty(new_difficulty)
	_sync_selection()


func _sync_selection() -> void:
	easy_button.button_pressed = GameManager.difficulty == GameManager.Difficulty.EASY
	normal_button.button_pressed = GameManager.difficulty == GameManager.Difficulty.NORMAL
	hard_button.button_pressed = GameManager.difficulty == GameManager.Difficulty.HARD
	_refresh_stats()


func _refresh_stats() -> void:
	# Panel her zaman seçili zorluğun verisini gösterir.
	var stats := StatsManager.get_stats(GameManager.difficulty)

	if stats["games_played"] == 0:
		high_score_label.text = "En Yüksek Skor: —"
		games_played_label.text = "Oynanan Oyun: —"
		average_time_label.text = "Ortalama Süre: —"
		recent_scores_label.text = "Son 5 Skor: —"
		return

	high_score_label.text = "En Yüksek Skor: %d" % stats["high_score"]
	games_played_label.text = "Oynanan Oyun: %d" % stats["games_played"]
	average_time_label.text = "Ortalama Süre: %.1f sn" % stats["average_time"]

	var recent: Array = stats["recent_scores"]
	var parts := PackedStringArray()
	for entry in recent:
		parts.append(str(entry))
	recent_scores_label.text = "Son 5 Skor: %s" % ", ".join(parts)


func _on_start_pressed() -> void:
	AudioManager.play_ui_start()
	get_tree().change_scene_to_file("res://scenes/Main.tscn")
