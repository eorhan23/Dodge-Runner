extends Node

enum Type { SHIELD, TIME, SCORE }

# Kademe renkleri: dairenin rengi buff'ın gücünü belirtir (tür değil).
const TIER_COLORS := [
	Color(0.20, 0.45, 0.95),  # Kademe 1 — mavi
	Color(0.20, 0.70, 0.30),  # Kademe 2 — yeşil
	Color(0.95, 0.55, 0.10),  # Kademe 3 — turuncu
]

const SHIELD_ICON := preload("res://assets/sprites/buffs/protection_buff.png")
const TIME_ICON := preload("res://assets/sprites/buffs/time_buff.png")

# Her tür için kademe başına etki değerleri ve süreler (saniye).
# Etkilerin kendisi Faz 13'te uygulanacak; burada yalnızca tanımlanıyorlar.
const DEFINITIONS := {
	Type.SHIELD: {
		"duration": [8.0, 10.0, 12.0],
		# Kaç çarpışmaya dayanır.
		"charges": [1, 2, 3],
	},
	Type.TIME: {
		"duration": [5.0, 6.5, 8.0],
		# Oyun akışı bu orana düşer (0.75 = %25 yavaşlama).
		"slow_factor": [0.75, 0.60, 0.45],
	},
	Type.SCORE: {
		"duration": [8.0, 10.0, 12.0],
		"multiplier": [2, 3, 4],
	},
}

# Aktif buff'lar: tür -> {"tier": int, "remaining": float, "charges": int}
# Aynı türden yalnızca bir buff aktif olabilir; yenisi eskisinin yerini alır.
var active := {}


func _process(delta: float) -> void:
	if not GameManager.is_running:
		return

	for type in active.keys():
		active[type]["remaining"] -= delta
		if active[type]["remaining"] <= 0.0:
			active.erase(type)


func activate(type: int, tier: int) -> void:
	var definition: Dictionary = DEFINITIONS[type]
	var entry := {
		"tier": tier,
		"remaining": definition["duration"][tier],
	}
	if type == Type.SHIELD:
		entry["charges"] = definition["charges"][tier]
	active[type] = entry


func is_active(type: int) -> bool:
	return active.has(type)


func get_tier(type: int) -> int:
	if not active.has(type):
		return -1
	return active[type]["tier"]


func get_remaining(type: int) -> float:
	if not active.has(type):
		return 0.0
	return active[type]["remaining"]


func reset() -> void:
	active.clear()
