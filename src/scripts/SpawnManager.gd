extends Node

const OBSTACLE_SCENE := preload("res://scenes/Obstacle.tscn")

const SPAWN_X := 1330.0
const GROUND_Y := 550.0
const TOP_BOTTOM_Y := 500.0
const BASE_SPEED := 300.0
const FAST_SPEED := 480.0
const MIN_SPAWN_INTERVAL := 1.2
const MAX_SPAWN_INTERVAL := 2.2

var timer: Timer


func _ready() -> void:
	timer = Timer.new()
	timer.one_shot = true
	timer.timeout.connect(_on_timer_timeout)
	add_child(timer)
	_start_timer()


func _start_timer() -> void:
	timer.start(randf_range(MIN_SPAWN_INTERVAL, MAX_SPAWN_INTERVAL))


func _on_timer_timeout() -> void:
	_spawn_random_obstacle()
	_start_timer()


func _spawn_random_obstacle() -> void:
	match randi() % 4:
		0:
			_spawn_obstacle(40.0, 60.0, GROUND_Y, BASE_SPEED, SPAWN_X)
		1:
			_spawn_obstacle(40.0, 100.0, TOP_BOTTOM_Y, BASE_SPEED, SPAWN_X)
		2:
			_spawn_obstacle(40.0, 60.0, GROUND_Y, BASE_SPEED, SPAWN_X)
			_spawn_obstacle(40.0, 100.0, TOP_BOTTOM_Y, BASE_SPEED, SPAWN_X + 220.0)
		3:
			_spawn_obstacle(40.0, 60.0, GROUND_Y, FAST_SPEED, SPAWN_X)


func _spawn_obstacle(width: float, height: float, bottom_y: float, speed: float, spawn_x: float) -> void:
	var obstacle := OBSTACLE_SCENE.instantiate()
	obstacle.width = width
	obstacle.height = height
	obstacle.bottom_y = bottom_y
	obstacle.speed = speed
	obstacle.position.x = spawn_x
	get_tree().current_scene.add_child(obstacle)
