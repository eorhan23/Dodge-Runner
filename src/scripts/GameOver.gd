extends Control

@onready var final_score_label: Label = $FinalScoreLabel
@onready var restart_button: Button = $RestartButton
@onready var main_menu_button: Button = $MainMenuButton


func _ready() -> void:
	final_score_label.text = "Skor: %d" % GameManager.score
	restart_button.pressed.connect(_on_restart_pressed)
	main_menu_button.pressed.connect(_on_main_menu_pressed)


func _on_restart_pressed() -> void:
	# Sahne yeniden yüklenince Main.gd._ready() GameManager.start_game()'i çağırır.
	get_tree().paused = false
	get_tree().reload_current_scene()


func _on_main_menu_pressed() -> void:
	GameManager.reset()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")
