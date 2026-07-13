extends Node

const OBSTACLE_SCENE := preload("res://scenes/Obstacle.tscn")

const SPAWN_X := 1330.0
const PLAYER_X := 200.0
const GROUND_Y := 585.0
const TOP_BOTTOM_Y := 525.0
const BASE_SPEED := 300.0
const FAST_SPEED := 480.0
const MIN_SPAWN_INTERVAL := 1.2
const MAX_SPAWN_INTERVAL := 2.2

var timer: Timer

var _last_ground_obstacle: Node = null
var _last_top_obstacle: Node = null


func _ready() -> void:
	timer = Timer.new()
	timer.one_shot = true
	timer.timeout.connect(_on_timer_timeout)
	add_child(timer)
	_start_timer()


func _start_timer() -> void:
	var interval := randf_range(MIN_SPAWN_INTERVAL, MAX_SPAWN_INTERVAL)
	timer.start(interval * GameManager.spawn_interval_multiplier)


func _on_timer_timeout() -> void:
	_spawn_random_obstacle()
	_start_timer()


func _spawn_random_obstacle() -> void:
	var base_speed := BASE_SPEED * GameManager.speed_multiplier
	var fast_speed := FAST_SPEED * GameManager.speed_multiplier
	match randi() % 4:
		0:
			_spawn_ground(base_speed, SPAWN_X)
		1:
			_spawn_top(base_speed, SPAWN_X)
		2:
			_spawn_ground(base_speed, SPAWN_X)
			_spawn_top(base_speed, SPAWN_X + 220.0)
		3:
			_spawn_ground(fast_speed, SPAWN_X)


func _spawn_ground(speed: float, spawn_x: float) -> void:
	var safe_speed := _clamp_against(speed, _last_top_obstacle)
	_last_ground_obstacle = _spawn_obstacle(40.0, 60.0, GROUND_Y, safe_speed, spawn_x)


func _spawn_top(speed: float, spawn_x: float) -> void:
	var safe_speed := _clamp_against(speed, _last_ground_obstacle)
	_last_top_obstacle = _spawn_obstacle(40.0, 100.0, TOP_BOTTOM_Y, safe_speed, spawn_x, true)


func _clamp_against(speed: float, other: Node) -> float:
	# Karşıt tipteki bir önceki engel henüz oyuncuya ulaşmadıysa, yeni engel
	# onu yakalayıp geçemesin (aksi halde ikisi oyuncunun konumunda çakışıp
	# aynı anda hem zıplama hem eğilme gerektiren kaçınılmaz bir durum oluşur).
	if is_instance_valid(other) and other.position.x > PLAYER_X:
		return min(speed, other.speed)
	return speed


func _spawn_obstacle(width: float, height: float, bottom_y: float, speed: float, spawn_x: float, is_hanging: bool = false) -> Node:
	var obstacle := OBSTACLE_SCENE.instantiate()
	obstacle.width = width
	obstacle.height = height
	obstacle.bottom_y = bottom_y
	obstacle.speed = speed
	obstacle.is_hanging = is_hanging
	obstacle.position.x = spawn_x
	get_tree().current_scene.add_child(obstacle)
	return obstacle
