extends Sprite2D

var _tile_width: float


func _ready() -> void:
	# region + texture_repeat: aynı görsel yan yana sonsuz tekrarlanır.
	# Bölge boyutu görselin kendi boyutuyla aynı kalır, böylece sahnede
	# ayarlanmış konum/ölçek (zemin hizası) değişmez; yalnızca bölgenin
	# kaynak içindeki başlangıç noktası kaydırılır.
	texture_repeat = CanvasItem.TEXTURE_REPEAT_ENABLED
	_tile_width = texture.get_width()
	region_enabled = true
	region_rect = Rect2(0.0, 0.0, _tile_width, texture.get_height())


func _process(delta: float) -> void:
	if not GameManager.is_running:
		return

	# Normal engellerle birebir aynı ekran hızı: Obstacle.current_speed() ile aynı
	# formül (BASE_SPEED * BASE_FACTOR * speed_multiplier), her karede yeniden
	# hesaplandığı için zorluk arttıkça ikisi birlikte hızlanır. region_rect doku
	# uzayında olduğundan, sprite'ın ölçeğine bölerek ekran hızını eşitliyoruz.
	var screen_speed := SpawnManager.BASE_SPEED * SpawnManager.BASE_FACTOR * GameManager.speed_multiplier
	region_rect.position.x += screen_speed / scale.x * delta

	# Tam bir görsel genişliği kaydıkça başa sar; sayı büyümesin ve dikiş görünmesin.
	if region_rect.position.x >= _tile_width:
		region_rect.position.x -= _tile_width
