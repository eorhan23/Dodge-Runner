extends CharacterBody2D

enum State { RUNNING, JUMPING, DUCKING }

const GRAVITY := 2000.0
const JUMP_VELOCITY := -800.0
const FIXED_X := 200.0
const GROUND_Y := 585.0
const RUN_HEIGHT := 80.0
const DUCK_HEIGHT := 40.0
const WIDTH := 40.0
# Normal oyun hızındaki (speed_multiplier = 1.0) kare tempo; oyun hızlandıkça
# aynı çarpanla ölçeklenir, böylece koşu animasyonu zemin hızıyla uyumlu kalır.
const BASE_ANIM_FPS := 10.0

var state: State = State.RUNNING

@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var visual: Sprite2D = $Sprite2D

var _frames: Array = []
var _frame_index := 0
var _anim_timer := 0.0


func _ready() -> void:
	global_position.x = FIXED_X
	_frames = CharacterManager.get_frames()
	if not _frames.is_empty():
		visual.texture = _frames[CharacterManager.RUN_FRAMES[0]]
	_update_shape(RUN_HEIGHT)


func _process(delta: float) -> void:
	# Koşma ve eğilme sırasında adımlar akmaya devam eder; yalnızca havadayken
	# animasyon durur (bkz. _set_jump_frame).
	if state == State.JUMPING or _frames.size() < 3:
		return

	# Oyun hızlandıkça adımlar da hızlanır (zemin kayma hızıyla aynı çarpan).
	var fps := BASE_ANIM_FPS * GameManager.effective_speed_multiplier()
	_anim_timer += delta
	var frame_duration := 1.0 / fps
	if _anim_timer >= frame_duration:
		_anim_timer -= frame_duration
		var run_frames: Array = CharacterManager.RUN_FRAMES
		_frame_index = (_frame_index + 1) % run_frames.size()
		visual.texture = _frames[run_frames[_frame_index]]


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
		if Input.is_action_just_pressed("jump"):
			state = State.JUMPING
			velocity.y = JUMP_VELOCITY
			AudioManager.play_jump()
			_set_jump_frame()
			_update_shape(RUN_HEIGHT)
		elif Input.is_action_pressed("duck"):
			if state != State.DUCKING:
				state = State.DUCKING
				_update_shape(DUCK_HEIGHT)
		elif state == State.DUCKING:
			state = State.RUNNING
			_update_shape(RUN_HEIGHT)


func _set_jump_frame() -> void:
	# Havadayken animasyon durur ve bir ayağı önde olan adım karesi sabit kalır;
	# bu, zıplama pozu olarak duruş karesinden daha doğal görünür.
	if _frames.size() <= CharacterManager.JUMP_FRAME:
		return
	_anim_timer = 0.0
	visual.texture = _frames[CharacterManager.JUMP_FRAME]


func _update_shape(height: float) -> void:
	var shape := collision_shape.shape as RectangleShape2D
	shape.size = Vector2(WIDTH, height)
	global_position.y = GROUND_Y - height / 2.0
	var texture_height := visual.texture.get_height()
	visual.scale = Vector2(RUN_HEIGHT / texture_height, height / texture_height)
