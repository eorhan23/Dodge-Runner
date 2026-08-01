extends Control

@onready var easy_button: Button = $DifficultyButtons/EasyButton
@onready var normal_button: Button = $DifficultyButtons/NormalButton
@onready var hard_button: Button = $DifficultyButtons/HardButton
@onready var start_button: Button = $StartButton


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


func _on_start_pressed() -> void:
	AudioManager.play_ui_start()
	get_tree().change_scene_to_file("res://scenes/Main.tscn")
