extends Label


func _process(_delta: float) -> void:
	text = "Skor: %d" % GameManager.score
