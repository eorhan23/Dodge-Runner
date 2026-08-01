extends Label


func _ready() -> void:
	text = SettingsManager.get_controls_hint()
	get_tree().create_timer(4.0).timeout.connect(func() -> void: visible = false)
