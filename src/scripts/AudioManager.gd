extends Node

const JUMP_SFX := preload("res://assets/audio/sfx/game/jump.mp3")
const DEATH_SFX := preload("res://assets/audio/sfx/game/death.mp3")
const UI_CLICK_SFX := preload("res://assets/audio/sfx/ui/click.mp3")
const UI_START_SFX := preload("res://assets/audio/sfx/ui/start.mp3")
const MUSIC := preload("res://assets/audio/music/background_loop.mp3")

const MUSIC_BUS := "Music"
const SFX_BUS := "SFX"

var jump_player: AudioStreamPlayer
var death_player: AudioStreamPlayer
var ui_click_player: AudioStreamPlayer
var ui_start_player: AudioStreamPlayer
var music_player: AudioStreamPlayer

var _music_pending := false


func _ready() -> void:
	# Müzik ve efektlerin bağımsız kısılabilmesi için ayrı ses yolları.
	_ensure_bus(MUSIC_BUS)
	_ensure_bus(SFX_BUS)

	jump_player = _create_player(JUMP_SFX, SFX_BUS)
	death_player = _create_player(DEATH_SFX, SFX_BUS)
	ui_click_player = _create_player(UI_CLICK_SFX, SFX_BUS)
	ui_start_player = _create_player(UI_START_SFX, SFX_BUS)
	music_player = _create_player(MUSIC, MUSIC_BUS)

	# MP3 döngüsü içe aktarma ayarında kapalı; döngüyü çalışma zamanında kuruyoruz.
	music_player.finished.connect(_on_music_finished)
	ui_start_player.finished.connect(_on_ui_start_finished)


func _ensure_bus(bus_name: String) -> void:
	# Ses yolları default_bus_layout.tres yerine koddan kurulur; oynatıcıların da
	# koddan üretilmesiyle tutarlı ve elle .tres yazma riskini ortadan kaldırır.
	if AudioServer.get_bus_index(bus_name) != -1:
		return
	var index := AudioServer.bus_count
	AudioServer.add_bus(index)
	AudioServer.set_bus_name(index, bus_name)
	AudioServer.set_bus_send(index, "Master")


func _create_player(stream: AudioStream, bus_name: String) -> AudioStreamPlayer:
	var player := AudioStreamPlayer.new()
	player.stream = stream
	player.bus = bus_name
	# Oyun sonu ekranında ağaç duraklatıldığı için sesler yine de çalabilmeli.
	player.process_mode = Node.PROCESS_MODE_ALWAYS
	add_child(player)
	return player


func set_music_volume(percent: float) -> void:
	_apply_volume(MUSIC_BUS, percent)


func set_sfx_volume(percent: float) -> void:
	_apply_volume(SFX_BUS, percent)


func _apply_volume(bus_name: String, percent: float) -> void:
	var index := AudioServer.get_bus_index(bus_name)
	if index == -1:
		return

	# %0'da linear_to_db() eksi sonsuz döneceği için yolu doğrudan sessize alıyoruz.
	if percent <= 0.0:
		AudioServer.set_bus_mute(index, true)
		return

	AudioServer.set_bus_mute(index, false)
	# Ses algısı logaritmik: doğrusal yüzde doğrudan dB olarak kullanılamaz.
	AudioServer.set_bus_volume_db(index, linear_to_db(percent / 100.0))


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
