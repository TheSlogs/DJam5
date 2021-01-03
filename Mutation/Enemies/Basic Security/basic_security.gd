extends enemy


onready var weapon_point = $WeaponPoint
onready var shoot_cooldown = $ShootCooldown

var weapon_distance: float = 50.0
var min_distance_away: float = 300.0
var buffer_distance: float = 10.0


func _ready():
	spawn()
	_health = 75.0
	_move_speed = 100.0
	min_distance_away = randf() * 300 + 50
	var weapon = preload("res://Enemies/Basic Security/basic_security_weapon.tscn").instance()
	weapon_point.add_child(weapon)
	weight = 2


func _physics_process(delta):
	if not is_spawning:
		look_at_player()
		move()
		shoot()


func look_at_player() -> void:
	var player_position = get_player_position()
	weapon_point.rotation = player_position.angle()
	weapon_point.position = Vector2(weapon_distance * cos(player_position.angle()), \
	 				weapon_distance * sin(player_position.angle()))


func move() -> void:
	var player_position = get_player_position()
	var move_direction = player_position.normalized()
	
	if HelpingFunctions.magnitude(player_position) > min_distance_away + buffer_distance:
		move_and_slide(move_direction * _move_speed)
	elif HelpingFunctions.magnitude(player_position) < min_distance_away - buffer_distance:
		move_and_slide(move_direction * _move_speed * -1)
	else:
		pass
	
	

func shoot() -> void:
	if shoot_cooldown.is_stopped():
		get_node("WeaponPoint/" + "Weapon").shoot()
		shoot_cooldown.start()
		min_distance_away = randf() * 300 + 50
