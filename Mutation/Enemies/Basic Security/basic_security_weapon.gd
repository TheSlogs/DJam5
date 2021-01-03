extends Weapon


func _ready():
	speed = 150.0
	name = "Weapon"


func shoot() -> void:
	var proj = preload("res://Enemies/Basic Security/basic_security_weapon_proj.tscn").instance()
	var proj_speed = speed
	if get_node("/root/Main/World/Player").slow_enemy_bullets:
		proj_speed *= 0.75
	proj.set_variables(damage, proj_speed, get_parent().rotation, global_position)
	get_node("/root/Main/World").add_child(proj)
