extends Node

const GAME_OVER_SCENE := preload("res://scenes/GameOver.tscn")

enum Difficulty { EASY, NORMAL, HARD }

const DIFFICULTY_SETTINGS := {
	Difficulty.EASY: {
		"start_speed": 0.85,
		"max_speed": 1.8,
		"start_spawn": 1.15,
		"min_spawn": 0.6,
	},
	Difficulty.NORMAL: {
		"start_speed": 1.0,
		"max_speed": 2.2,
		"start_spawn": 1.0,
		"min_spawn": 0.5,
	},
	Difficulty.HARD: {
		"start_speed": 1.25,
		"max_speed": 2.8,
		"start_spawn": 0.85,
		"min_spawn": 0.4,
	},
}

const DIFFICULTY_INTERVAL := 10.0
const SPEED_INCREASE := 0.08
const SPAWN_INTERVAL_DECREASE := 0.08
const SCORE_PER_SECOND := 10.0

var difficulty: Difficulty = Difficulty.NORMAL
var elapsed_time: float = 0.0
var score: int = 0
var speed_multiplier: float = 1.0
var spawn_interval_multiplier: float = 1.0
var is_game_over: bool = false
var is_running: bool = false

var _difficulty_timer: float = 0.0


func _process(delta: float) -> void:
	if not is_running:
		return

	elapsed_time += delta
	score = int(elapsed_time * SCORE_PER_SECOND)

	_difficulty_timer += delta
	if _difficulty_timer >= DIFFICULTY_INTERVAL:
		_difficulty_timer -= DIFFICULTY_INTERVAL
		var settings: Dictionary = DIFFICULTY_SETTINGS[difficulty]
		speed_multiplier = min(speed_multiplier * (1.0 + SPEED_INCREASE), settings["max_speed"])
		spawn_interval_multiplier = max(spawn_interval_multiplier * (1.0 - SPAWN_INTERVAL_DECREASE), settings["min_spawn"])


func set_difficulty(new_difficulty: Difficulty) -> void:
	difficulty = new_difficulty
	reset()


func start_game() -> void:
	reset()
	SpawnManager.reset()
	AudioManager.start_music()
	is_running = true


func game_over() -> void:
	if is_game_over:
		return
	is_game_over = true
	is_running = false
	AudioManager.stop_music()
	AudioManager.play_death()
	get_tree().paused = true
	var game_over_ui := GAME_OVER_SCENE.instantiate()
	get_tree().current_scene.add_child(game_over_ui)


func reset() -> void:
	var settings: Dictionary = DIFFICULTY_SETTINGS[difficulty]
	elapsed_time = 0.0
	score = 0
	speed_multiplier = settings["start_speed"]
	spawn_interval_multiplier = settings["start_spawn"]
	_difficulty_timer = 0.0
	is_game_over = false
	is_running = false
