extends Node

enum Type { SHIELD, TIME, SCORE }

# Kademe renkleri: dairenin rengi buff'ın gücünü belirtir (tür değil).
const TIER_COLORS := [
	Color(0.20, 0.72, 0.30),  # Kademe 1 — yeşil
	Color(0.20, 0.48, 0.95),  # Kademe 2 — mavi
	Color(0.90, 0.20, 0.20),  # Kademe 3 — kırmızı
]

const SHIELD_ICON := preload("res://assets/sprites/buffs/protection_buff.png")
const TIME_ICON := preload("res://assets/sprites/buffs/time_buff.png")

# Etki süresi yalnızca kademeye bağlıdır; tüm buff türleri aynı süreyi paylaşır.
const TIER_DURATIONS := [7.0, 10.0, 13.0]

# Her tür için kademe başına etki değerleri.
const DEFINITIONS := {
	Type.SHIELD: {
		# Kaç çarpışmaya dayanır.
		"charges": [1, 2, 3],
	},
	Type.TIME: {
		# Oyun akışı bu orana düşer (0.80 = %20 yavaşlama). Zıplama fiziği gerçek
		# zamanda kaldığı için aşırı yavaşlatma, havada kalma süresini engellere
		# göre orantısız kısaltıp zıplayarak geçmeyi zorlaştırır.
		"slow_factor": [0.80, 0.70, 0.60],
	},
	Type.SCORE: {
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
		"remaining": TIER_DURATIONS[tier],
	}
	if type == Type.SHIELD:
		entry["charges"] = definition["charges"][tier]
	active[type] = entry


func is_active(type: int) -> bool:
	return active.has(type)


func get_time_slow_factor() -> float:
	# Oyun akışının çarpılacağı oran; buff yoksa 1.0 (yavaşlama yok).
	if not active.has(Type.TIME):
		return 1.0
	var tier: int = active[Type.TIME]["tier"]
	return DEFINITIONS[Type.TIME]["slow_factor"][tier]


func get_score_multiplier() -> int:
	if not active.has(Type.SCORE):
		return 1
	var tier: int = active[Type.SCORE]["tier"]
	return DEFINITIONS[Type.SCORE]["multiplier"][tier]


func get_shield_charges() -> int:
	if not active.has(Type.SHIELD):
		return 0
	return active[Type.SHIELD]["charges"]


func consume_shield_charge() -> bool:
	# Çarpışma anında çağrılır. Kalkan varsa bir hak harcanır ve true döner
	# (oyuncu korundu); haklar biterse kalkan hemen kalkar.
	if not active.has(Type.SHIELD):
		return false

	active[Type.SHIELD]["charges"] -= 1
	if active[Type.SHIELD]["charges"] <= 0:
		active.erase(Type.SHIELD)
	return true


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
