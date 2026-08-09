extends Node

const SAVE_PATH := "user://settings.cfg"
const SECTION := "character"

# Ortadaki kare bacakları bitişik duruş pozudur; zıplama/eğilmede ve menü
# önizlemesinde bu kullanılır. Koşarken ise aynı kare iki adım arasındaki
# "geçiş" pozu görevi görür, bu yüzden döngü üç kareyi sırayla oynatır.
const IDLE_FRAME := 1
const RUN_FRAMES := [0, 1, 2]

# Her karakterin 3 koşma karesi. Dosya adları karakterden karaktere farklı
# olduğu için tam yolları burada tutuyoruz.
const CHARACTERS := [
	{
		"id": "blue",
		"label": "Mavi",
		"frames": [
			"res://assets/sprites/characters/blue/character82.png",
			"res://assets/sprites/characters/blue/character83.png",
			"res://assets/sprites/characters/blue/character84.png",
		],
	},
	{
		"id": "green",
		"label": "Yeşil",
		"frames": [
			"res://assets/sprites/characters/green/character178.png",
			"res://assets/sprites/characters/green/character179.png",
			"res://assets/sprites/characters/green/character180.png",
		],
	},
	{
		"id": "orange",
		"label": "Turuncu",
		"frames": [
			"res://assets/sprites/characters/orange/character175.png",
			"res://assets/sprites/characters/orange/character176.png",
			"res://assets/sprites/characters/orange/character177.png",
		],
	},
	{
		"id": "purple",
		"label": "Mor",
		"frames": [
			"res://assets/sprites/characters/purple/character31.png",
			"res://assets/sprites/characters/purple/character32.png",
			"res://assets/sprites/characters/purple/character33.png",
		],
	},
	{
		"id": "white",
		"label": "Beyaz",
		"frames": [
			"res://assets/sprites/characters/white/character28.png",
			"res://assets/sprites/characters/white/character29.png",
			"res://assets/sprites/characters/white/character30.png",
		],
	},
	{
		"id": "yellow",
		"label": "Sarı",
		"frames": [
			"res://assets/sprites/characters/yellow/character217.png",
			"res://assets/sprites/characters/yellow/character218.png",
			"res://assets/sprites/characters/yellow/character219.png",
		],
	},
]

var _config := ConfigFile.new()
var selected_index := 0


func _ready() -> void:
	# Ayarlar dosyası tuş atamaları ve ses seviyeleriyle paylaşılıyor.
	_config.load(SAVE_PATH)
	selected_index = _config.get_value(SECTION, "selected", 0)
	# Kayıt bozuksa veya karakter listesi küçüldüyse geçerli bir değere düş.
	if selected_index < 0 or selected_index >= CHARACTERS.size():
		selected_index = 0


func select(index: int) -> void:
	if index < 0 or index >= CHARACTERS.size():
		return
	selected_index = index
	_config.set_value(SECTION, "selected", index)
	_config.save(SAVE_PATH)


func get_selected() -> Dictionary:
	return CHARACTERS[selected_index]


func get_frames() -> Array:
	# Seçili karakterin 3 koşma karesini yüklenmiş doku olarak döndürür.
	var textures := []
	for path in CHARACTERS[selected_index]["frames"]:
		textures.append(load(path))
	return textures


func get_preview_texture(index: int) -> Texture2D:
	# Menüdeki seçim düğmeleri için duruş karesi (bacaklar bitişik) kullanılır;
	# ilk iki kare koşma adımlarıdır ve durağan bir önizleme için uygun değildir.
	return load(CHARACTERS[index]["frames"][IDLE_FRAME])
