extends Control

@onready var final_score_label: Label = $FinalScoreLabel
@onready var restart_button: Button = $RestartButton


func _ready() -> void:
	final_score_label.text = "Skor: %d" % GameManager.score
	restart_button.pressed.connect(_on_restart_pressed)


func _on_restart_pressed() -> void:
	GameManager.reset()
	get_tree().paused = false
	get_tree().reload_current_scene()
