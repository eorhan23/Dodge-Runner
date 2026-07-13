extends Node

const GAME_OVER_SCENE := preload("res://scenes/GameOver.tscn")

const DIFFICULTY_INTERVAL := 10.0
const SPEED_INCREASE := 0.08
const SPAWN_INTERVAL_DECREASE := 0.08
const MAX_SPEED_MULTIPLIER := 2.2
const MIN_SPAWN_INTERVAL_MULTIPLIER := 0.5
const SCORE_PER_SECOND := 10.0

var elapsed_time: float = 0.0
var score: int = 0
var speed_multiplier: float = 1.0
var spawn_interval_multiplier: float = 1.0
var is_game_over: bool = false

var _difficulty_timer: float = 0.0


func _process(delta: float) -> void:
	elapsed_time += delta
	score = int(elapsed_time * SCORE_PER_SECOND)

	_difficulty_timer += delta
	if _difficulty_timer >= DIFFICULTY_INTERVAL:
		_difficulty_timer -= DIFFICULTY_INTERVAL
		speed_multiplier = min(speed_multiplier * (1.0 + SPEED_INCREASE), MAX_SPEED_MULTIPLIER)
		spawn_interval_multiplier = max(spawn_interval_multiplier * (1.0 - SPAWN_INTERVAL_DECREASE), MIN_SPAWN_INTERVAL_MULTIPLIER)


func game_over() -> void:
	if is_game_over:
		return
	is_game_over = true
	get_tree().paused = true
	var game_over_ui := GAME_OVER_SCENE.instantiate()
	get_tree().current_scene.add_child(game_over_ui)


func reset() -> void:
	elapsed_time = 0.0
	score = 0
	speed_multiplier = 1.0
	spawn_interval_multiplier = 1.0
	_difficulty_timer = 0.0
	is_game_over = false
