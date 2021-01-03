extends enemy


signal boss_killed

enum state {IDLE, MOVE, ATTACK, DEAD}
enum attackState {NONE, RAPID_FIRE, CIRCLE, BACK_FORTH, SHOTGUN}

var current_state = state.IDLE
var current_attack = attackState.NONE

onready var weapon_point = $WeaponPoint
onready var state_timer = $StateTimer
onready var shoot_timer = $ShootTimer

var rng = RandomNumberGenerator.new()

var weapon_distance = 50.0

var circle_number: int = 0

func _ready():
	spawn()
	_health = 500.0
	_move_speed = 100.0
	var main_weapon = preload("res://Enemies/Basic Security/basic_security_weapon.tscn").instance()
	weapon_point.add_child(main_weapon)
	rng.randomize()


func _physics_process(delta):
	if state_timer.is_stopped():
		switch_state()
	if current_state == state.MOVE:
		move()
	if current_state == state.ATTACK:
		match current_attack:
			attackState.RAPID_FIRE:
				rapid_fire()
			attackState.CIRCLE:
				circle()
			attackState.BACK_FORTH:
				back_forth()
			attackState.SHOTGUN:
				shotgun()
	pass


func switch_state() -> void:
	match current_state:
		state.IDLE:
			if rng.randf() < 0.25:
				current_state = state.MOVE
				print("Current State: Move")
			else:
				current_state = state.ATTACK
				print("Current State: Attack")
				choose_attack()
		state.MOVE:
			current_state = state.ATTACK
			choose_attack()
			print("Current State: Attack")
		state.ATTACK:
			if rng.randf() < 0.5:
				current_state = state.MOVE
				print("Current State: Move")
			else:
				current_state = state.ATTACK
				print("Current State: Attack")
				choose_attack()
		state.DEAD:
			pass


func choose_attack() -> void:
	var rand = rng.randf()
	print(rand)
	if rand <= 0.25:
		current_attack = attackState.RAPID_FIRE
	elif rand <= 0.5:
		current_attack = attackState.CIRCLE
	elif rand <= 0.75:
		current_attack = attackState.BACK_FORTH
	else:
		current_attack = attackState.SHOTGUN
	pass


func move() -> void:
	if state_timer.is_stopped():
		state_timer.wait_time = rng.randf_range(1.0, 3.0)
		state_timer.start()
	var player_position = get_player_position()
	var move_direction = player_position.normalized()
	move_and_slide(move_direction * _move_speed)


func rapid_fire() -> void:
	
	if state_timer.is_stopped():
		print("Current Attack: Rapid Fire")
		shoot_timer.wait_time = 0.1
		state_timer.wait_time = 5.0
		state_timer.start()
	
	if !state_timer.is_stopped():
		look_at_player()
		if shoot_timer.is_stopped():
			get_node("WeaponPoint/" + "Weapon").shoot()
			shoot_timer.start()
		


func circle() -> void:
	if state_timer.is_stopped():
		print("Current Attack: Circle")
		state_timer.wait_time = 5.0
		state_timer.start()
		shoot_timer.wait_time = 0.30
		circle_number = 0
	
	if !state_timer.is_stopped():
		#look_at_player()
		if shoot_timer.is_stopped():
			
			if circle_number % 2 == 0:
				weapon_point.rotation_degrees += 7.5
			
			weapon_point.position = Vector2(weapon_distance * cos(weapon_point.rotation), \
					weapon_distance * sin(weapon_point.rotation))
			get_node("WeaponPoint/" + "Weapon").shoot()
			
			for i in range(23):
				weapon_point.rotation_degrees -= 15
				weapon_point.position = Vector2(weapon_distance * cos(weapon_point.rotation), \
					weapon_distance * sin(weapon_point.rotation))
				get_node("WeaponPoint/" + "Weapon").shoot()
			
			circle_number += 1
			shoot_timer.start()


func back_forth() -> void:
	if state_timer.is_stopped():
		print("Current Attack: Back Forth")
		state_timer.wait_time = 5.0
		state_timer.start()
		shoot_timer.wait_time = 0.30
		
		if !state_timer.is_stopped():
			
			if shoot_timer.is_stopped():
				
				weapon_point.rotation_degrees += 7.5
				
				weapon_point.position = Vector2(weapon_distance * cos(weapon_point.rotation), \
						weapon_distance * sin(weapon_point.rotation))
				get_node("WeaponPoint/" + "Weapon").shoot()
				
				for i in range(23):
					weapon_point.rotation_degrees -= 15
					weapon_point.position = Vector2(weapon_distance * cos(weapon_point.rotation), \
						weapon_distance * sin(weapon_point.rotation))
					get_node("WeaponPoint/" + "Weapon").shoot()


func shotgun() -> void:
	if state_timer.is_stopped():
		print("Current Attack: Shotgun")
		state_timer.wait_time = 5.0
		state_timer.start()
		shoot_timer.wait_time = 0.9
	
	if !state_timer.is_stopped():
		look_at_player()
		if shoot_timer.is_stopped():
			weapon_point.rotation_degrees += 60
			weapon_point.position = Vector2(weapon_distance * cos(weapon_point.rotation), \
	 				weapon_distance * sin(weapon_point.rotation))
			get_node("WeaponPoint/" + "Weapon").shoot()
			
			for i in range(8):
				weapon_point.rotation_degrees -= 15
				weapon_point.position = Vector2(weapon_distance * cos(weapon_point.rotation), \
		 				weapon_distance * sin(weapon_point.rotation))
				get_node("WeaponPoint/" + "Weapon").shoot()
			
			shoot_timer.start()


func look_at_player() -> void:
	var player_position = get_player_position()
	weapon_point.rotation = player_position.angle()
	if current_attack == attackState.RAPID_FIRE:
		weapon_point.rotation += rng.randf_range(-0.15, 0.15) * 2 * PI
	weapon_point.position = Vector2(weapon_distance * cos(player_position.angle()), \
	 				weapon_distance * sin(player_position.angle()))
