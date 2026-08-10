extends Node2D

# Kalkan aktifken karakterin çevresinde beliren koruma halkası. Ayrı bir görsel
# varlık yerine koddan çizilir; rengi kalkanın kademesini yansıtır.

const RADIUS := 46.0
# Halkanın nabız gibi hafifçe büyüyüp küçülmesi, korumanın canlı olduğunu belli eder.
const PULSE_SPEED := 4.0
const PULSE_AMOUNT := 0.06

var _pulse_time := 0.0


func _process(delta: float) -> void:
	var active := BuffManager.is_active(BuffManager.Type.SHIELD)
	visible = active
	if not active:
		return

	_pulse_time += delta * PULSE_SPEED
	queue_redraw()


func _draw() -> void:
	var tier := BuffManager.get_tier(BuffManager.Type.SHIELD)
	if tier < 0:
		return

	var color: Color = BuffManager.TIER_COLORS[tier]
	var radius := RADIUS * (1.0 + sin(_pulse_time) * PULSE_AMOUNT)

	# İçi hafif dolgu + belirgin kenar: karakteri gizlemeden çevresini sarar.
	draw_circle(Vector2.ZERO, radius, Color(color.r, color.g, color.b, 0.18))
	draw_arc(Vector2.ZERO, radius, 0.0, TAU, 48, color, 3.0, true)
