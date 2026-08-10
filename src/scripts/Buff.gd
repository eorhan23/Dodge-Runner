extends Area2D

# Buff türü ve kademesi (0-2); SpawnManager tarafından üretimde atanır.
@export var buff_type: int = BuffManager.Type.SHIELD
@export var tier: int = 0

const RADIUS := 26.0
const ICON_SIZE := 34.0
const DESPAWN_X := -100.0
# Engellerle aynı ekran hızında akar ki oyuncu için tutarlı hissettirsin.
const SPEED_FACTOR := 1.0

@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var circle: Node2D = $Circle
@onready var icon: Sprite2D = $Icon
@onready var label: Label = $Label


func _ready() -> void:
	# Engel üretimi, buff'ların dibine engel koymamak için bu grubu tarar.
	add_to_group("buff")
	_apply_visual()
	body_entered.connect(_on_body_entered)


func _process(delta: float) -> void:
	position.x -= current_speed() * delta
	if position.x < DESPAWN_X:
		queue_free()


func current_speed() -> float:
	return SpawnManager.BASE_SPEED * SPEED_FACTOR * GameManager.effective_speed_multiplier()


func _apply_visual() -> void:
	var shape := collision_shape.shape as CircleShape2D
	shape.radius = RADIUS

	# Daire koddan çizilir; rengi kademeyi gösterir.
	circle.color = BuffManager.TIER_COLORS[tier]
	circle.radius = RADIUS

	# Kalkan ve zaman için ikon, skor çarpanı için yazı kullanılır.
	if buff_type == BuffManager.Type.SCORE:
		icon.visible = false
		label.visible = true
		var multiplier: int = BuffManager.DEFINITIONS[BuffManager.Type.SCORE]["multiplier"][tier]
		label.text = "%dx" % multiplier
	else:
		label.visible = false
		icon.visible = true
		icon.texture = BuffManager.SHIELD_ICON if buff_type == BuffManager.Type.SHIELD else BuffManager.TIME_ICON
		var scale_factor := ICON_SIZE / icon.texture.get_height()
		icon.scale = Vector2(scale_factor, scale_factor)


func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return
	BuffManager.activate(buff_type, tier)
	AudioManager.play_get_buff()
	queue_free()
