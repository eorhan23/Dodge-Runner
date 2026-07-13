extends Area2D

@export var width: float = 40.0
@export var height: float = 60.0
@export var bottom_y: float = 525.0
@export var speed: float = 300.0
@export var is_hanging: bool = false

const DESPAWN_X := -100.0

@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var visual: Sprite2D = $Sprite2D


func _ready() -> void:
	_apply_shape()
	body_entered.connect(_on_body_entered)


func _process(delta: float) -> void:
	position.x -= speed * delta
	if position.x < DESPAWN_X:
		queue_free()


func _apply_shape() -> void:
	var shape := collision_shape.shape as RectangleShape2D
	shape.size = Vector2(width, height)
	global_position.y = bottom_y - height / 2.0

	if is_hanging:
		var scale_x := height / visual.texture.get_height()
		var scale_y := bottom_y / visual.texture.get_height()
		visual.scale = Vector2(scale_x, scale_y)
		visual.flip_v = true
		visual.position.y = (height - bottom_y) / 2.0
	else:
		var scale_factor := height / visual.texture.get_height()
		visual.scale = Vector2(scale_factor, scale_factor)


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		GameManager.game_over()
