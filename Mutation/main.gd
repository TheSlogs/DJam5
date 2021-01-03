extends Node2D

# TODO:
	# Mutations:
		# Double Shot, faster attack speed, drop bombs, more
	
	# Player:
		# Dash
		# Weapons
		# Sprites
		
	# Enemies:
		# All of them
	
	# Item Pickup on death
	
	# Environment:
		# Creating levels
		# Populating them
	
	# Sounds:
		# Music
		# Attack
		# Enemies

var isPause = false
signal pause
signal unpause
signal player_died

func _ready():
	randomize()
	connect("pause", self, "pause_game")
	connect("unpause", self, "unpause_game")
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
	Input.set_custom_mouse_cursor(load("res://Assets/cross_hair.png"))
	
	var new_room = load("res://Environment/room.tscn").instance()
	$World.add_child(new_room)
	new_room.create_room()
	


func _input(event):
	if Input.is_action_just_pressed("pause"):
		isPause = !isPause
		if isPause:
			emit_signal("pause")
		else:
			emit_signal("unpause")


func pause_game() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().paused = true
	Input.set_custom_mouse_cursor(load("res://Assets/Cursor.png"))
	pass


func unpause_game() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
	get_tree().paused = false
	Input.set_custom_mouse_cursor(load("res://Assets/cross_hair.png"))
	pass
