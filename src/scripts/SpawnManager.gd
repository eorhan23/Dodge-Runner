extends Node

const OBSTACLE_SCENE := preload("res://scenes/Obstacle.tscn")
const BUFF_SCENE := preload("res://scenes/Buff.tscn")

enum Variant { GROUND, TOP, PAIR, FAST }

const SPAWN_X := 1330.0
const PLAYER_X := 200.0
const GROUND_Y := 585.0
const TOP_BOTTOM_Y := 525.0
const BASE_SPEED := 300.0
# Taban hıza göre katsayılar; gerçek hız engelin içinde güncel zorluk çarpanıyla
# hesaplanır (bkz. Obstacle.current_speed()).
const BASE_FACTOR := 1.0
const FAST_FACTOR := 1.6
# Üretim aralığı. Bu değerler oyunun temposunu belirler; adaleti değil. Kaçılamaz
# durum koruması aşağıdaki alt sınırlarla ayrıca sağlandığı için, tempo serbestçe
# sıkılaştırılabilir — aralık ne kadar kısalırsa kısalsın alt sınırların altına
# inemez.
const MIN_SPAWN_INTERVAL := 0.75
const MAX_SPAWN_INTERVAL := 1.35
const FIRST_SPAWN_DELAY := 2.0

# --- Kaçılamaz durum koruması ------------------------------------------------
# Engeller arası boşluk PİKSEL değil ZAMAN cinsinden tanımlanır. Zıplama süresi
# (2 * |JUMP_VELOCITY| / GRAVITY = 0.8 sn) oyun hızından bağımsız sabittir, ama
# engeller hızlandıkça sabit bir piksel mesafesini giderek daha kısa sürede kat
# eder. Dolayısıyla sabit bir piksel mesafesi yüksek hızlarda kaçınılmaz ölüm
# üretir.
#
# Gereken boşluk, ÖNCEKİ engelin türüne bağlıdır — ikisine de aynı süreyi
# dayatmak oyunu gereksiz yere seyrekleştirir:
#
# - Zemin engeli zıplamayı zorunlu kılar ve oyuncu 0.8 sn havada kalır. Bu süre
#   boyunca eğilemez, yani ardından gelen bir tavan engeli için yere inmiş olması
#   gerekir. Ölçülen alt sınır ~0.72 sn; üstüne tepki payı bırakıyoruz.
const GAP_AFTER_GROUND_SECONDS := 0.88
# - Tavan engeli eğilerek geçilir. Eğilme tuşu bırakılır bırakılmaz oyuncu
#   zıplayabildiği için, ardından gelen engel çok daha yakın olabilir.
const GAP_AFTER_TOP_SECONDS := 0.38
# Yavaş oyunda süre cinsinden yeterli olan bir boşluk, PİKSEL olarak dar kalır ve
# iki engel ekranda dip dibe görünür; oyuncu ikisini tek bir küme gibi algılayıp
# hangisine nasıl tepki vereceğini ayırt edemez. Bu yüzden her boşluk aynı zamanda
# asgari bir piksel mesafesi tutar. Değer, oyuncunun (40) ve engelin (40) genişliği
# toplamının belirgin şekilde üzerindedir.
const MIN_VISUAL_GAP_PIXELS := 260.0
# Çift engel varyantında zemin ve tavan engeli arasındaki boşluk: oyuncu önce
# zıplayıp inmek, sonra eğilmek zorundadır (yani zemin engeli kuralı geçerlidir).
const PAIR_GAP_SECONDS := 1.05
# Buff'ın toplanabilir kalması için çevresinde bırakılan boşluk.
const BUFF_CLEARANCE_SECONDS := 0.7
# Üretim noktası doluysa üretim bu kadar ertelenir; bu sürede ekrandaki nesneler
# sola kayarak yer açar.
const SPACING_RETRY_DELAY := 0.2
# Konum kontrolü, zamanlayıcının hedeflediği boşluğun bu oranını arar. Zamanlayıcı
# zaten tam süreyi bekletir; konum kontrolü onun modelleyemediği durumlar (çift
# engelin ikinci parçası, buff'lar, hız artışıyla sıkışan eski aralıklar) için bir
# güvenlik ağıdır. Eşiği birebir aynı tutmak, sınırdaki her durumu gereksiz yere
# reddedip üretimi sürekli erteliyor ve oyunu seyrekleştiriyordu. Bu pay sonrasında
# bile beklenen boşluk fiziksel sınırların (0.72 / 0.20 sn) belirgin şekilde üzerinde.
const CLEARANCE_TOLERANCE := 0.9

# Buff üretimi engel ritminden bağımsız kendi zamanlayıcısıyla çalışır.
const MIN_BUFF_INTERVAL := 7.0
const MAX_BUFF_INTERVAL := 12.0
const FIRST_BUFF_DELAY := 6.0
# Buff'ın toplanabileceği yükseklikler: zeminde koşarken ve zıplarken erişilebilir
# iki bant.
const BUFF_LOW_Y := 545.0
const BUFF_HIGH_Y := 450.0
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
	_start_timer(Variant.GROUND)

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


func seconds_to_pixels(seconds: float) -> float:
	# Bir süreyi güncel oyun hızındaki piksel karşılığına çevirir. Zaman buff'ı
	# hesaba katılmaz: yavaşlatma oyuncunun lehinedir, üretim mesafesini
	# daraltmak için kullanılmamalıdır.
	var pixels := BASE_SPEED * GameManager.speed_multiplier * seconds
	return max(pixels, MIN_VISUAL_GAP_PIXELS)


func gap_seconds_after(is_hanging: bool) -> float:
	return GAP_AFTER_TOP_SECONDS if is_hanging else GAP_AFTER_GROUND_SECONDS


func current_pair_gap() -> float:
	return seconds_to_pixels(PAIR_GAP_SECONDS)


func _start_timer(variant: int) -> void:
	var interval := randf_range(MIN_SPAWN_INTERVAL, MAX_SPAWN_INTERVAL) * GameManager.spawn_interval_multiplier

	# Alt sınır, üretilen grubun SON engeline göre hesaplanır. Çift engelin ikinci
	# parçası üretim noktasının sağına konduğu için, beklenecek süre o parçanın
	# gecikmesini de kapsamalıdır — aksi halde bir sonraki engel onun dibine düşer.
	var trailing_offset := 0.0
	var trailing_hanging := false
	match variant:
		Variant.TOP:
			trailing_hanging = true
		Variant.PAIR:
			trailing_offset = PAIR_GAP_SECONDS
			trailing_hanging = true

	var floor_seconds := trailing_offset + gap_seconds_after(trailing_hanging)
	timer.start(max(interval, floor_seconds))


func _on_timer_timeout() -> void:
	# Yalnızca oyun sahnesi aktifken engel üret; menüdeyken üretim durur.
	if not GameManager.is_running:
		_start_timer(Variant.GROUND)
		return

	var variant := _pick_variant()

	# Zamanlayıcı aralığı tek başına yeterli değildir: ekranda çift engelin ikinci
	# parçası veya üretim noktasının ötesine konmuş bir buff bulunabilir. Üretim
	# noktaları boş değilse hiçbir şey üretmeyip kısa süre sonra tekrar deniyoruz.
	if not _are_points_clear(_spawn_points_for(variant)):
		timer.start(SPACING_RETRY_DELAY)
		return

	_spawn_variant(variant)
	_is_first_spawn = false
	_start_timer(variant)


func _pick_variant() -> int:
	# Turun ilk engeli hızlı varyant olmasın: ekran boş olduğu için hız kırpması
	# devreye girmez ve oyuncu daha yerleşmeden tam hızla gelen bir engelle karşılaşır.
	if _is_first_spawn:
		return randi() % 3
	return randi() % 4


func _spawn_points_for(variant: int) -> Array:
	match variant:
		Variant.TOP:
			return [{"x": SPAWN_X, "hanging": true}]
		Variant.PAIR:
			return [
				{"x": SPAWN_X, "hanging": false},
				{"x": SPAWN_X + current_pair_gap(), "hanging": true},
			]
		_:
			return [{"x": SPAWN_X, "hanging": false}]


func _are_points_clear(points: Array) -> bool:
	# Engeller ve buff'lar birlikte kontrol edilir: ikisi de oyuncunun manevra
	# alanını daraltır.
	var blockers := get_tree().get_nodes_in_group("obstacle") + get_tree().get_nodes_in_group("buff")

	for node in blockers:
		if not is_instance_valid(node):
			continue
		var is_obstacle: bool = node.is_in_group("obstacle")

		for point in points:
			var needed_seconds: float
			if not is_obstacle:
				needed_seconds = BUFF_CLEARANCE_SECONDS
			elif node.position.x < point["x"]:
				# Mevcut engel daha solda, yani oyuncuya önce ulaşır: bekleme süresi
				# onun türüne göre belirlenir.
				needed_seconds = gap_seconds_after(node.is_hanging)
			else:
				# Yeni engel önce ulaşacak; bu kez kural yeni engelin türünden gelir.
				needed_seconds = gap_seconds_after(point["hanging"])

			if absf(node.position.x - point["x"]) < seconds_to_pixels(needed_seconds) * CLEARANCE_TOLERANCE:
				return false

	return true


func _spawn_variant(variant: int) -> void:
	match variant:
		Variant.GROUND:
			_spawn_ground(BASE_FACTOR, SPAWN_X)
		Variant.TOP:
			_spawn_top(BASE_FACTOR, SPAWN_X)
		Variant.PAIR:
			_spawn_ground(BASE_FACTOR, SPAWN_X)
			_spawn_top(BASE_FACTOR, SPAWN_X + current_pair_gap())
		Variant.FAST:
			_spawn_ground(FAST_FACTOR, SPAWN_X)


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
	# olarak önler. Engel tarafındaki koruma için bkz. _are_points_clear().
	var obstacles := get_tree().get_nodes_in_group("obstacle")
	var clearance := seconds_to_pixels(BUFF_CLEARANCE_SECONDS)

	for step in 6:
		var candidate := SPAWN_X + step * clearance
		var is_free := true
		for obstacle in obstacles:
			if not is_instance_valid(obstacle):
				continue
			if absf(obstacle.position.x - candidate) < clearance:
				is_free = false
				break
		if is_free:
			return candidate

	return SPAWN_X + 6 * clearance


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
