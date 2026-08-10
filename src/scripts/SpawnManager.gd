extends Node

const OBSTACLE_SCENE := preload("res://scenes/Obstacle.tscn")
const BUFF_SCENE := preload("res://scenes/Buff.tscn")

const SPAWN_X := 1330.0
const PLAYER_X := 200.0
const GROUND_Y := 585.0
const TOP_BOTTOM_Y := 525.0
const BASE_SPEED := 300.0
# Taban hıza göre katsayılar; gerçek hız engelin içinde güncel zorluk çarpanıyla
# hesaplanır (bkz. Obstacle.current_speed()).
const BASE_FACTOR := 1.0
const FAST_FACTOR := 1.6
const MIN_SPAWN_INTERVAL := 1.2
const MAX_SPAWN_INTERVAL := 2.2
const FIRST_SPAWN_DELAY := 2.0

# Buff üretimi engel ritminden bağımsız kendi zamanlayıcısıyla çalışır.
const MIN_BUFF_INTERVAL := 7.0
const MAX_BUFF_INTERVAL := 12.0
const FIRST_BUFF_DELAY := 6.0
# Buff'ın toplanabileceği yükseklikler: zeminde koşarken ve zıplarken erişilebilir
# iki bant. Engellerle aynı hatta olmadıkları için çakışma riski düşük.
const BUFF_LOW_Y := 545.0
const BUFF_HIGH_Y := 450.0
# Buff ile engel arasında bırakılan en az yatay mesafe. Engel genişliği (40) ve
# buff yarıçapı (26) toplamının çok üzerinde; oyuncunun engeli aşıp buff'ı
# toplayabilmesi için rahat bir pay bırakır.
const BUFF_GAP := 220.0
# Buff'a çok yakın düşecek bir engel üretimi bu kadar ertelenir; bu sürede buff
# sola kayarak aradaki mesafeyi açar.
const BUFF_RETRY_DELAY := 0.35
# Kademe olasılıkları: güçlü kademe daha nadir, ama fark abartılı değil.
const TIER_WEIGHTS := [45, 33, 22]

var timer: Timer
var buff_timer: Timer

var _last_ground_obstacle = null
var _last_top_obstacle = null
var _is_first_spawn := true


func _ready() -> void:
	timer = Timer.new()
	timer.one_shot = true
	timer.timeout.connect(_on_timer_timeout)
	add_child(timer)
	_start_timer()

	buff_timer = Timer.new()
	buff_timer.one_shot = true
	buff_timer.timeout.connect(_on_buff_timer_timeout)
	add_child(buff_timer)
	_start_buff_timer()


func reset() -> void:
	# Sahne yeniden yüklendiğinde eski engel referansları geçersizleşir.
	_last_ground_obstacle = null
	_last_top_obstacle = null
	_is_first_spawn = true
	# Zamanlayıcı menüde de dönmeye devam ettiği için kalan süresi rastgeledir;
	# tur başında sıfırlanmazsa ilk engel oyun açılır açılmaz belirebilir.
	if timer:
		timer.start(FIRST_SPAWN_DELAY)
	if buff_timer:
		buff_timer.start(FIRST_BUFF_DELAY)


func _start_timer() -> void:
	var interval := randf_range(MIN_SPAWN_INTERVAL, MAX_SPAWN_INTERVAL)
	timer.start(interval * GameManager.spawn_interval_multiplier)


func _on_timer_timeout() -> void:
	# Yalnızca oyun sahnesi aktifken engel üret; menüdeyken üretim durur.
	if not GameManager.is_running:
		_start_timer()
		return

	# Buff'lar sağdaki üretim noktasının ötesine yerleştiği için, sonradan doğan
	# bir engel onların dibine denk gelebilir. Bu durumda engeli biraz geciktirip
	# aradaki mesafeyi koruyoruz (buff'lar seyrek olduğu için ritim bozulmaz).
	if not _is_clear_of_buffs():
		timer.start(BUFF_RETRY_DELAY)
		return

	_spawn_random_obstacle()
	_start_timer()


func _is_clear_of_buffs() -> bool:
	# Çift engel varyantı SPAWN_X + 220'ye de üretim yapabildiği için iki nokta da
	# kontrol edilir.
	for buff in get_tree().get_nodes_in_group("buff"):
		if not is_instance_valid(buff):
			continue
		if absf(buff.position.x - SPAWN_X) < BUFF_GAP:
			return false
		if absf(buff.position.x - (SPAWN_X + 220.0)) < BUFF_GAP:
			return false
	return true


func _start_buff_timer() -> void:
	buff_timer.start(randf_range(MIN_BUFF_INTERVAL, MAX_BUFF_INTERVAL))


func _on_buff_timer_timeout() -> void:
	if GameManager.is_running:
		_spawn_random_buff()
	_start_buff_timer()


func _spawn_random_buff() -> void:
	# Türler arasında eşit olasılık; kademe içinde güçlü olan daha nadir.
	var type: int = randi() % BuffManager.Type.size()
	var tier := _pick_tier()

	var buff := BUFF_SCENE.instantiate()
	buff.buff_type = type
	buff.tier = tier
	buff.position.x = _find_free_buff_x()
	# Yüksek bant zıplamayı gerektirir; ikisi arasında rastgele seçim çeşitlilik verir.
	buff.position.y = BUFF_LOW_Y if randi() % 2 == 0 else BUFF_HIGH_Y
	get_tree().current_scene.add_child(buff)


func _find_free_buff_x() -> float:
	# Buff ve engeller aynı hızda aktığı için aralarındaki yatay mesafe sabit kalır;
	# üretim anında yeterli boşluk bırakmak, buff'ın engel içinde kalmasını kalıcı
	# olarak önler. Boşluk bulunamazsa en uzak aday yine de kullanılabilir olur.
	var obstacles := get_tree().get_nodes_in_group("obstacle")

	for step in 6:
		var candidate := SPAWN_X + step * BUFF_GAP
		var is_free := true
		for obstacle in obstacles:
			if not is_instance_valid(obstacle):
				continue
			if absf(obstacle.position.x - candidate) < BUFF_GAP:
				is_free = false
				break
		if is_free:
			return candidate

	return SPAWN_X + 6 * BUFF_GAP


func _pick_tier() -> int:
	var total := 0
	for weight in TIER_WEIGHTS:
		total += weight

	var roll := randi() % total
	var cumulative := 0
	for index in TIER_WEIGHTS.size():
		cumulative += TIER_WEIGHTS[index]
		if roll < cumulative:
			return index
	return 0


func _spawn_random_obstacle() -> void:
	# Turun ilk engeli hızlı varyant olmasın: ekran boş olduğu için hız kırpması
	# devreye girmez ve oyuncu daha yerleşmeden tam hızla gelen bir engelle karşılaşır.
	var variant := randi() % 4
	if _is_first_spawn:
		variant = randi() % 3
		_is_first_spawn = false

	match variant:
		0:
			_spawn_ground(BASE_FACTOR, SPAWN_X)
		1:
			_spawn_top(BASE_FACTOR, SPAWN_X)
		2:
			_spawn_ground(BASE_FACTOR, SPAWN_X)
			_spawn_top(BASE_FACTOR, SPAWN_X + 220.0)
		3:
			_spawn_ground(FAST_FACTOR, SPAWN_X)


func _spawn_ground(speed_factor: float, spawn_x: float) -> void:
	var safe_factor := _clamp_against_pending(speed_factor)
	_last_ground_obstacle = _spawn_obstacle(40.0, 60.0, GROUND_Y, safe_factor, spawn_x)


func _spawn_top(speed_factor: float, spawn_x: float) -> void:
	var safe_factor := _clamp_against_pending(speed_factor)
	_last_top_obstacle = _spawn_obstacle(40.0, 100.0, TOP_BOTTOM_Y, safe_factor, spawn_x, true)


func _clamp_against_pending(speed_factor: float) -> float:
	# Oyuncuya henüz ulaşmamış hiçbir engel geçilemesin: yeni engelin katsayısı,
	# ekranda bekleyen engellerin en yavaşını aşamaz. Aksi halde hızlı bir engel
	# yavaş olanı yakalayıp yanından/üstünden geçer; karşıt tiplerde bu kaçınılmaz
	# çarpışma yaratır, aynı tipte ise engeller üst üste binmiş gibi görünür.
	var limit := speed_factor
	for other in [_last_ground_obstacle, _last_top_obstacle]:
		if is_instance_valid(other) and other.position.x > PLAYER_X:
			limit = min(limit, other.speed_factor)
	return limit


func _spawn_obstacle(width: float, height: float, bottom_y: float, speed_factor: float, spawn_x: float, is_hanging: bool = false) -> Node:
	var obstacle := OBSTACLE_SCENE.instantiate()
	obstacle.width = width
	obstacle.height = height
	obstacle.bottom_y = bottom_y
	obstacle.speed_factor = speed_factor
	obstacle.is_hanging = is_hanging
	obstacle.position.x = spawn_x
	get_tree().current_scene.add_child(obstacle)
	return obstacle
