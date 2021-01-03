extends Mutation


func _ready():
	mutation_name = "Loose Bowels"
	rarity = "Rare"
	name = mutation_name


func mutate_player() -> void:
	var drop_bomb_timer = Timer.new()
	drop_bomb_timer.name = "DropBombCooldown"
	drop_bomb_timer.wait_time = 2.0
	drop_bomb_timer.autostart = true
	drop_bomb_timer.one_shot = false
	get_parent().get_parent().add_child(drop_bomb_timer)
	drop_bomb_timer.start()
	drop_bomb_timer.connect("timeout", get_parent().get_parent(), "drop_bomb")
