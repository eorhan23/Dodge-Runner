extends Node

const SAVE_PATH := "user://settings.cfg"
const SECTION_INPUT := "input"
const SECTION_AUDIO := "audio"

const DEFAULT_MUSIC_VOLUME := 100.0
const DEFAULT_SFX_VOLUME := 100.0

# Ayarlar ekranında gösterilecek atanabilir yuvalar.
# "jump" iki yuvalıdır: varsayılan olarak Yukarı Ok ve Boşluk.
const SLOTS := [
	{"action": "jump", "slot": 0, "label": "Zıpla (1)"},
	{"action": "jump", "slot": 1, "label": "Zıpla (2)"},
	{"action": "duck", "slot": 0, "label": "Eğil"},
]

var _config := ConfigFile.new()
# Yuva -> keycode eşlemesi. InputMap'in olay dizisi boşluk kabul etmediği için
# (bir olay silinince sonrakiler kayar) yuva indekslerini burada tutuyoruz.
var _slots := {}
# project.godot'taki varsayılan keycode'lar; "Varsayılana Sıfırla" için saklanır.
var _defaults := {}


func _ready() -> void:
	_capture_defaults()
	_config.load(SAVE_PATH)
	_load_saved_bindings()
	_rebuild_input_map()
	_apply_volumes()


func _capture_defaults() -> void:
	# Kayıtlı ayarlar uygulanmadan ÖNCE çağrılmalı, aksi halde varsayılanlar kaybolur.
	for entry in SLOTS:
		var action: String = entry["action"]
		var slot: int = entry["slot"]
		var events := InputMap.action_get_events(action)
		var keycode := -1
		if slot < events.size():
			var event := events[slot] as InputEventKey
			if event != null:
				keycode = event.keycode
		_defaults[_key_for(action, slot)] = keycode
		_slots[_key_for(action, slot)] = keycode


func _load_saved_bindings() -> void:
	for entry in SLOTS:
		var key := _key_for(entry["action"], entry["slot"])
		var saved: int = _config.get_value(SECTION_INPUT, key, -2)
		# -2 = kayıt yok (varsayılan korunur), -1 = bilerek boşaltılmış yuva.
		if saved != -2:
			_slots[key] = saved


func get_music_volume() -> float:
	return _config.get_value(SECTION_AUDIO, "music", DEFAULT_MUSIC_VOLUME)


func get_sfx_volume() -> float:
	return _config.get_value(SECTION_AUDIO, "sfx", DEFAULT_SFX_VOLUME)


func set_music_volume(percent: float) -> void:
	_config.set_value(SECTION_AUDIO, "music", percent)
	_config.save(SAVE_PATH)
	AudioManager.set_music_volume(percent)


func set_sfx_volume(percent: float) -> void:
	_config.set_value(SECTION_AUDIO, "sfx", percent)
	_config.save(SAVE_PATH)
	AudioManager.set_sfx_volume(percent)


func _apply_volumes() -> void:
	# AudioManager autoload sırasında bizden önce geldiği için ses yolları hazır.
	AudioManager.set_music_volume(get_music_volume())
	AudioManager.set_sfx_volume(get_sfx_volume())


func get_binding_text(action: String, slot: int) -> String:
	var keycode := get_keycode(action, slot)
	if keycode == -1:
		return "—"
	return OS.get_keycode_string(keycode)


func get_keycode(action: String, slot: int) -> int:
	return _slots.get(_key_for(action, slot), -1)


func get_controls_hint() -> String:
	# Kontrol ipuçları sabit metin olamaz; oyuncunun atadığı güncel tuşları gösterir.
	var jump_keys := PackedStringArray()
	for slot in [0, 1]:
		var keycode := get_keycode("jump", slot)
		if keycode != -1:
			jump_keys.append(OS.get_keycode_string(keycode))

	var jump_text := " / ".join(jump_keys) if jump_keys.size() > 0 else "—"
	return "%s: Zıpla   |   %s: Eğil" % [jump_text, get_binding_text("duck", 0)]


func set_binding(action: String, slot: int, keycode: int) -> void:
	# Aynı tuş başka bir yuvada kullanılıyorsa oradan kaldır; iki eylem aynı
	# tuşta kalırsa oyuncu ikisini birden tetikler.
	for entry in SLOTS:
		var other_key := _key_for(entry["action"], entry["slot"])
		if other_key == _key_for(action, slot):
			continue
		if _slots.get(other_key, -1) == keycode:
			_slots[other_key] = -1
			_config.set_value(SECTION_INPUT, other_key, -1)

	_slots[_key_for(action, slot)] = keycode
	_config.set_value(SECTION_INPUT, _key_for(action, slot), keycode)
	_config.save(SAVE_PATH)
	_rebuild_input_map()


func reset_to_defaults() -> void:
	for key in _defaults:
		_slots[key] = _defaults[key]

	# Kayıtlı ayarları da temizle ki bir sonraki açılışta geri gelmesinler.
	if _config.has_section(SECTION_INPUT):
		_config.erase_section(SECTION_INPUT)
	if _config.has_section(SECTION_AUDIO):
		_config.erase_section(SECTION_AUDIO)
	_config.save(SAVE_PATH)
	_rebuild_input_map()
	_apply_volumes()


func _rebuild_input_map() -> void:
	# Her aksiyonun olaylarını yuva sözlüğünden yeniden kur; boş yuvalar atlanır.
	var actions := {}
	for entry in SLOTS:
		actions[entry["action"]] = true

	for action in actions:
		InputMap.action_erase_events(action)

	for entry in SLOTS:
		var keycode: int = _slots.get(_key_for(entry["action"], entry["slot"]), -1)
		if keycode == -1:
			continue
		var event := InputEventKey.new()
		event.keycode = keycode as Key
		InputMap.action_add_event(entry["action"], event)


func _key_for(action: String, slot: int) -> String:
	return "%s_%d" % [action, slot]
