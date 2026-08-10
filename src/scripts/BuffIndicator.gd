extends VBoxContainer

# Ekranın sol üstünde aktif buff'ları, kalan sürelerini ve kademe renklerini
# gösterir. Buff yokken tamamen gizlenir ki oyun ekranı kalabalıklaşmasın.

const FONT_SIZE := 18


func _process(_delta: float) -> void:
	var entries := []

	if BuffManager.is_active(BuffManager.Type.SHIELD):
		entries.append({
			"tier": BuffManager.get_tier(BuffManager.Type.SHIELD),
			"text": "Kalkan x%d  (%.1f sn)" % [
				BuffManager.get_shield_charges(),
				BuffManager.get_remaining(BuffManager.Type.SHIELD),
			],
		})

	if BuffManager.is_active(BuffManager.Type.TIME):
		entries.append({
			"tier": BuffManager.get_tier(BuffManager.Type.TIME),
			"text": "Yavaşlatma  (%.1f sn)" % BuffManager.get_remaining(BuffManager.Type.TIME),
		})

	if BuffManager.is_active(BuffManager.Type.SCORE):
		entries.append({
			"tier": BuffManager.get_tier(BuffManager.Type.SCORE),
			"text": "Skor %dx  (%.1f sn)" % [
				BuffManager.get_score_multiplier(),
				BuffManager.get_remaining(BuffManager.Type.SCORE),
			],
		})

	visible = not entries.is_empty()
	_sync_rows(entries)


func _sync_rows(entries: Array) -> void:
	# Satır sayısı aktif buff sayısına göre değiştiği için etiketler gerektikçe
	# oluşturulur; her karede yeniden yaratmak yerine yeniden kullanılırlar.
	while get_child_count() < entries.size():
		var label := Label.new()
		label.add_theme_font_size_override("font_size", FONT_SIZE)
		add_child(label)

	for index in get_child_count():
		var label := get_child(index) as Label
		if index < entries.size():
			label.visible = true
			label.text = entries[index]["text"]
			label.add_theme_color_override("font_color", BuffManager.TIER_COLORS[entries[index]["tier"]])
		else:
			label.visible = false
