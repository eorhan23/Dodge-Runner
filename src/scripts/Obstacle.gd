extends Area2D

@export var width: float = 40.0
@export var height: float = 60.0
@export var bottom_y: float = 550.0
@export var speed: float = 300.0

const DESPAWN_X := -100.0

@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var visual: ColorRect = $ColorRect


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
	visual.size = Vector2(width, height)
	visual.position = Vector2(-width / 2.0, -height / 2.0)


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		GameManager.game_over()
