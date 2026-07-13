extends CharacterBody2D

enum State { RUNNING, JUMPING, DUCKING }

const GRAVITY := 2000.0
const JUMP_VELOCITY := -800.0
const FIXED_X := 200.0
const GROUND_Y := 585.0
const RUN_HEIGHT := 80.0
const DUCK_HEIGHT := 40.0
const WIDTH := 40.0

var state: State = State.RUNNING

@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var visual: Sprite2D = $Sprite2D


func _ready() -> void:
	global_position.x = FIXED_X
	_update_shape(RUN_HEIGHT)


func _physics_process(delta: float) -> void:
	velocity.x = 0.0

	if state == State.JUMPING:
		velocity.y += GRAVITY * delta
	else:
		velocity.y = 0.0

	move_and_slide()

	if state == State.JUMPING and global_position.y >= GROUND_Y - RUN_HEIGHT / 2.0:
		state = State.RUNNING
		_update_shape(RUN_HEIGHT)

	if state != State.JUMPING:
		if Input.is_action_just_pressed("ui_up"):
			state = State.JUMPING
			velocity.y = JUMP_VELOCITY
			_update_shape(RUN_HEIGHT)
		elif Input.is_action_pressed("ui_down"):
			if state != State.DUCKING:
				state = State.DUCKING
				_update_shape(DUCK_HEIGHT)
		elif state == State.DUCKING:
			state = State.RUNNING
			_update_shape(RUN_HEIGHT)


func _update_shape(height: float) -> void:
	var shape := collision_shape.shape as RectangleShape2D
	shape.size = Vector2(WIDTH, height)
	global_position.y = GROUND_Y - height / 2.0
	var texture_height := visual.texture.get_height()
	visual.scale = Vector2(RUN_HEIGHT / texture_height, height / texture_height)
