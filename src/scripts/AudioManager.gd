extends Node

const JUMP_SFX := preload("res://assets/audio/sfx/game/jump.mp3")
const DEATH_SFX := preload("res://assets/audio/sfx/game/death.mp3")
const UI_CLICK_SFX := preload("res://assets/audio/sfx/ui/click.mp3")
const UI_START_SFX := preload("res://assets/audio/sfx/ui/start.mp3")
const MUSIC := preload("res://assets/audio/music/background_loop.mp3")

var jump_player: AudioStreamPlayer
var death_player: AudioStreamPlayer
var ui_click_player: AudioStreamPlayer
var ui_start_player: AudioStreamPlayer
var music_player: AudioStreamPlayer

var _music_pending := false


func _ready() -> void:
	jump_player = _create_player(JUMP_SFX)
	death_player = _create_player(DEATH_SFX)
	ui_click_player = _create_player(UI_CLICK_SFX)
	ui_start_player = _create_player(UI_START_SFX)
	music_player = _create_player(MUSIC)

	# MP3 döngüsü içe aktarma ayarında kapalı; döngüyü çalışma zamanında kuruyoruz.
	music_player.finished.connect(_on_music_finished)
	ui_start_player.finished.connect(_on_ui_start_finished)


func _create_player(stream: AudioStream) -> AudioStreamPlayer:
	var player := AudioStreamPlayer.new()
	player.stream = stream
	# Oyun sonu ekranında ağaç duraklatıldığı için sesler yine de çalabilmeli.
	player.process_mode = Node.PROCESS_MODE_ALWAYS
	add_child(player)
	return player


func play_jump() -> void:
	jump_player.play()


func play_death() -> void:
	death_player.play()


func play_ui_click() -> void:
	ui_click_player.play()


func play_ui_start() -> void:
	ui_start_player.play()


func start_music() -> void:
	# Başlangıç sesiyle çakışmasın: hâlâ çalıyorsa müziği bitmesini bekleyip başlat.
	if ui_start_player.playing:
		_music_pending = true
		return
	_music_pending = false
	music_player.play()


func stop_music() -> void:
	_music_pending = false
	music_player.stop()


func _on_music_finished() -> void:
	music_player.play()


func _on_ui_start_finished() -> void:
	if _music_pending:
		_music_pending = false
		music_player.play()
