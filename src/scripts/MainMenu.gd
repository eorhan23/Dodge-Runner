extends Control

@onready var easy_button: Button = $DifficultyButtons/EasyButton
@onready var normal_button: Button = $DifficultyButtons/NormalButton
@onready var hard_button: Button = $DifficultyButtons/HardButton
@onready var start_button: Button = $StartButton
@onready var settings_button: Button = $SettingsButton
@onready var controls_label: Label = $ControlsLabel
@onready var high_score_label: Label = $StatsPanel/HighScoreLabel
@onready var games_played_label: Label = $StatsPanel/GamesPlayedLabel
@onready var average_time_label: Label = $StatsPanel/AverageTimeLabel
@onready var recent_scores_label: Label = $StatsPanel/RecentScoresLabel
@onready var character_buttons: HBoxContainer = $CharacterButtons

var _character_buttons: Array = []


func _ready() -> void:
	_build_character_buttons()
	easy_button.pressed.connect(_on_difficulty_selected.bind(GameManager.Difficulty.EASY))
	normal_button.pressed.connect(_on_difficulty_selected.bind(GameManager.Difficulty.NORMAL))
	hard_button.pressed.connect(_on_difficulty_selected.bind(GameManager.Difficulty.HARD))
	start_button.pressed.connect(_on_start_pressed)
	settings_button.pressed.connect(_on_settings_pressed)
	controls_label.text = SettingsManager.get_controls_hint()
	_sync_selection()


func _build_character_buttons() -> void:
	var group := ButtonGroup.new()
	for index in CharacterManager.CHARACTERS.size():
		var button := Button.new()
		button.custom_minimum_size = Vector2(80, 70)
		button.toggle_mode = true
		button.button_group = group
		button.icon = CharacterManager.get_preview_texture(index)
		# 16x20 piksel sprite'lar buton içinde küçük kalır; genişleterek büyütüyoruz.
		button.expand_icon = true
		button.tooltip_text = CharacterManager.CHARACTERS[index]["label"]
		button.pressed.connect(_on_character_selected.bind(index))
		character_buttons.add_child(button)
		_character_buttons.append(button)


func _on_character_selected(index: int) -> void:
	AudioManager.play_ui_click()
	CharacterManager.select(index)
	_sync_character_selection()


func _sync_character_selection() -> void:
	for index in _character_buttons.size():
		_character_buttons[index].button_pressed = index == CharacterManager.selected_index


func _on_difficulty_selected(new_difficulty: GameManager.Difficulty) -> void:
	AudioManager.play_ui_click()
	GameManager.set_difficulty(new_difficulty)
	_sync_selection()


func _sync_selection() -> void:
	easy_button.button_pressed = GameManager.difficulty == GameManager.Difficulty.EASY
	normal_button.button_pressed = GameManager.difficulty == GameManager.Difficulty.NORMAL
	hard_button.button_pressed = GameManager.difficulty == GameManager.Difficulty.HARD
	_sync_character_selection()
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


func _on_settings_pressed() -> void:
	AudioManager.play_ui_click()
	get_tree().change_scene_to_file("res://scenes/Settings.tscn")
