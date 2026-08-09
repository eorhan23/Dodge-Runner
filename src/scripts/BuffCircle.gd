extends Node2D

# Buff'ın arka planındaki renkli daire; ayrı bir görsel varlık yerine koddan çizilir.
@export var color: Color = Color.WHITE:
	set(value):
		color = value
		queue_redraw()

@export var radius: float = 26.0:
	set(value):
		radius = value
		queue_redraw()


func _draw() -> void:
	draw_circle(Vector2.ZERO, radius, color)
	# İnce koyu kenarlık, açık arka planlarda dairenin sınırını belirginleştirir.
	draw_arc(Vector2.ZERO, radius, 0.0, TAU, 48, Color(0, 0, 0, 0.6), 3.0, true)
