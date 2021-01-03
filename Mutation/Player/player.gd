extends KinematicBody2D


export var _health: int = 3
export var _move_speed: float = 150.0
export var _dash_speed: float = 450.0
export var _attack_speed: float = 1.0


onready var weapon_point = $WeaponPoint
onready var shoot_cooldown = $ShootCooldown
onready var dash_cooldown = $DashCooldown

signal player_hit
signal player_died

signal room_clear

var weapon_name := String()

var number_of_mutations = 0
var _is_dashing: bool = false

var num_enemies_killed

# Mutation Variables
var super_hot: bool = true
var life_steal: bool = false
var slow_enemy_bullets: bool = false
var hungry_bullets: bool = false
var explosive_bullets: bool = false

func _ready():
	var weapon = preload("res://Weapons/Starting Weapon/starting_weapon.tscn").instance()
	weapon_point.add_child(weapon)
	weapon_name = weapon.weapon_name


func _physics_process(delta):
	movement(delta)
	look_at_cursor()
	process_attack()


func movement(delta) -> void:
	var movement_input = Vector2.ZERO
		
	if Input.is_action_pressed("move_up"):
		movement_input.y -= 1
	if Input.is_action_pressed("move_down"):
		movement_input.y += 1
	if Input.is_action_pressed("move_right"):
		movement_input.x += 1
	if Input.is_action_pressed("move_left"):
		movement_input.x -= 1
	
	movement_input = movement_input.normalized()
	
	if movement_input == Vector2.ZERO && super_hot:
		Engine.time_scale = lerp(Engine.time_scale, 0.1, delta*2)
	else:
		Engine.time_scale = lerp(Engine.time_scale, 1.0, delta*4)
		
	move_and_slide(movement_input * _move_speed)


func look_at_cursor() -> void:
	var mouse_position = get_local_mouse_position()
	weapon_point.rotation = mouse_position.angle()
	weapon_point.position = Vector2(50 * cos(mouse_position.angle()), 50 * sin(mouse_position.angle()))


func process_attack() -> void:
	if Input.is_action_pressed("shoot") && shoot_cooldown.is_stopped():
		get_node("WeaponPoint/" + weapon_name).shoot()
		shoot_cooldown.start()


func add_mutation(mutation_name: String) -> void:
	var file_path = "res://Mutations/" + mutation_name + ".gd"
	var new_mutation = load(file_path).new()
	$Mutations.add_child(new_mutation)
	new_mutation.mutate_player()
	number_of_mutations += 1


func take_damage(damage: int = 1) -> void:
	_health -= damage
	emit_signal("player_hit")
	if _health <= 0.0:
		die()


func die() -> void:
	emit_signal("player_died")

func get_new_weapon(weapon_file := String()) -> void:
	get_node("WeaponPoint/" + weapon_name).queue_free()
	var weapon = load(weapon_file).instance()
	weapon_point.add_child(weapon)
	weapon_name = weapon.weapon_name


func update_attack_speed() -> void:
	shoot_cooldown.wait_time = _attack_speed


func drop_bomb() -> void:
	var bomb = preload("res://Weapons/bomb.tscn").instance()
	bomb.position = position
	get_parent().add_child(bomb)


func room_cleared() -> void:
	pass
