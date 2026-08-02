extends Control

@onready var rows_container: VBoxContainer = $RowsContainer
@onready var reset_button: Button = $BottomButtons/ResetButton
@onready var back_button: Button = $BottomButtons/BackButton
@onready var music_slider: HSlider = $MusicRow/MusicSlider
@onready var music_value: Label = $MusicRow/MusicValue
@onready var sfx_slider: HSlider = $SfxRow/SfxSlider
@onready var sfx_value: Label = $SfxRow/SfxValue

# Tuş bekleme modundayken hangi yuvanın atandığı; boşsa bekleme yok.
var _awaiting_entry = null
var _awaiting_button: Button = null


func _ready() -> void:
	reset_button.pressed.connect(_on_reset_pressed)
	back_button.pressed.connect(_on_back_pressed)
	music_slider.value_changed.connect(_on_music_changed)
	sfx_slider.value_changed.connect(_on_sfx_changed)
	# Sürükleme bitince bir kez örnek ses; sürükleme boyunca çalmak rahatsız edici olurdu.
	sfx_slider.drag_ended.connect(_on_sfx_drag_ended)
	_build_rows()
	_refresh_sliders()


func _build_rows() -> void:
	for entry in SettingsManager.SLOTS:
		var row := HBoxContainer.new()
		row.add_theme_constant_override("separation", 20)

		var label := Label.new()
		label.text = entry["label"]
		label.custom_minimum_size = Vector2(200, 40)
		label.add_theme_font_size_override("font_size", 20)
		row.add_child(label)

		var button := Button.new()
		button.custom_minimum_size = Vector2(200, 40)
		button.add_theme_font_size_override("font_size", 20)
		button.pressed.connect(_on_bind_pressed.bind(entry, button))
		row.add_child(button)

		rows_container.add_child(row)

	_refresh_labels()


func _refresh_labels() -> void:
	var index := 0
	for entry in SettingsManager.SLOTS:
		var row := rows_container.get_child(index) as HBoxContainer
		var button := row.get_child(1) as Button
		button.text = SettingsManager.get_binding_text(entry["action"], entry["slot"])
		index += 1


func _on_bind_pressed(entry, button: Button) -> void:
	AudioManager.play_ui_click()
	# Önceki bekleyen yuvanın "Bir tuşa basın..." yazısını geri al; aynı anda
	# yalnızca bir yuva bekliyor olmalı.
	_refresh_labels()
	_awaiting_entry = entry
	_awaiting_button = button
	button.text = "Bir tuşa basın..."


func _input(event: InputEvent) -> void:
	if _awaiting_entry == null:
		return

	var key_event := event as InputEventKey
	if key_event == null or not key_event.pressed or key_event.echo:
		return

	# Bu girdinin oyun aksiyonlarını tetiklemesini engelle.
	get_viewport().set_input_as_handled()

	if key_event.keycode != KEY_ESCAPE:
		SettingsManager.set_binding(_awaiting_entry["action"], _awaiting_entry["slot"], key_event.keycode)

	_awaiting_entry = null
	_awaiting_button = null
	_refresh_labels()


func _refresh_sliders() -> void:
	# set_value_no_signal: kaydıraçları doldururken value_changed tetiklenip
	# ayarları gereksizce diske yazmasın.
	music_slider.set_value_no_signal(SettingsManager.get_music_volume())
	sfx_slider.set_value_no_signal(SettingsManager.get_sfx_volume())
	music_value.text = "%d%%" % int(music_slider.value)
	sfx_value.text = "%d%%" % int(sfx_slider.value)


func _on_music_changed(value: float) -> void:
	SettingsManager.set_music_volume(value)
	music_value.text = "%d%%" % int(value)


func _on_sfx_changed(value: float) -> void:
	SettingsManager.set_sfx_volume(value)
	sfx_value.text = "%d%%" % int(value)


func _on_sfx_drag_ended(_value_changed: bool) -> void:
	# Oyuncu seçtiği efekt seviyesini duyabilsin.
	AudioManager.play_ui_click()


func _on_reset_pressed() -> void:
	AudioManager.play_ui_click()
	SettingsManager.reset_to_defaults()
	_refresh_labels()
	_refresh_sliders()


func _on_back_pressed() -> void:
	AudioManager.play_ui_click()
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")
