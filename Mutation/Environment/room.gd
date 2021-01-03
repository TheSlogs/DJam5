extends Node2D
class_name Room


export var room_number: int

onready var door_collider = $Door/CollisionShape2D
onready var camera = $Camera

signal enemy_died_sig
signal room_clear

var center_of_room := Vector2(512, 288)

var enemies_left: int = 0
var rng = RandomNumberGenerator.new()


func _ready():
	rng.randomize()
	room_number = 1

func create_room() -> void:
	spawn_enemies()
	pass


func spawn_enemies() -> void:
	var spawn_extents: = Vector2(450, 255)
	var total_enemy_spawn_weight: int = 4 * room_number
	var weight_left = total_enemy_spawn_weight
	while weight_left > 0:
		var random = randi()
		if weight_left < 3:
			random %= 2
		if weight_left < 2:
			random %= 1
		if weight_left < 1:
			random = 0
		else:
			random %= 3
		match random:
			0:
				var new_enemy = preload("res://Enemies/Grunt/grunt.tscn").instance()
				new_enemy.position = center_of_room + Vector2(rng.randf_range(-1.0, 1.0) * spawn_extents.x, rng.randf_range(-1.0, 1.0) * spawn_extents.y)
				add_child(new_enemy)
				new_enemy.connect("enemy_died_sig", self, "enemy_died")
				weight_left -= 1
			1:
				if total_enemy_spawn_weight >= 2:
					var new_enemy = preload("res://Enemies/Basic Security/basic_security.tscn").instance()
					new_enemy.position = center_of_room + Vector2(rng.randf_range(-1.0, 1.0) * spawn_extents.x, rng.randf_range(-1.0, 1.0) * spawn_extents.y)
					add_child(new_enemy)
					new_enemy.connect("enemy_died_sig", self, "enemy_died")
					weight_left -= 2
			2:
				if total_enemy_spawn_weight >= 3:
					var new_enemy = preload("res://Enemies/Advance Security/advance_security.tscn").instance()
					new_enemy.position = center_of_room + Vector2(rng.randf_range(-1.0, 1.0)  * spawn_extents.x, rng.randf_range(-1.0, 1.0) * spawn_extents.y)
					add_child(new_enemy)
					new_enemy.connect("enemy_died_sig", self, "enemy_died")
					weight_left -= 3
		
		enemies_left += 1
	


func enemy_died() -> void:
	enemies_left -= 1
	if enemies_left == 0:
		room_cleared()


func room_cleared() -> void:
	emit_signal("room_clear")
	room_number += 1
	spawn_enemies()
	pass

