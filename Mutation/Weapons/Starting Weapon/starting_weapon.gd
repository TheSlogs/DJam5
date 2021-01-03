extends Weapon



func _ready():
	weapon_name = "StartingWeapon"

func shoot() -> void:
	
	if get_node("/root/Main/Player/Mutations/Second Third Eye"):
		var proj1 = preload("res://Weapons/Starting Weapon/starting_weapon_proj.tscn").instance()
		proj1.set_variables(damage, speed, get_parent().rotation, global_position)
		proj1.position += Vector2(cos(proj1.rotation) + cos(deg2rad(5.711)), sin(proj1.rotation) + cos(deg2rad(5.711))) * 10
		get_node("/root/Main/World").add_child(proj1)
		
		var proj2 = preload("res://Weapons/Starting Weapon/starting_weapon_proj.tscn").instance()
		proj2.set_variables(damage, speed, get_parent().rotation, global_position)
		proj2.position += Vector2(cos(proj2.rotation) - cos(deg2rad(5.711)), sin(proj2.rotation) - cos(deg2rad(5.711))) * 10
		get_node("/root/Main/World").add_child(proj2)
		
	else:
		var proj = preload("res://Weapons/Starting Weapon/starting_weapon_proj.tscn").instance()
		proj.set_variables(damage, speed, get_parent().rotation, global_position)
		get_node("/root/Main/World").add_child(proj)
		
		
