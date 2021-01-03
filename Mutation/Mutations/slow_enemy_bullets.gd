extends Mutation


func _init():
	mutation_name = "Slow Enemy Bullets"
	rarity = "Rare"
	name = mutation_name


func mutate_player() -> void:
	get_node("/root/Main/World/Player").slow_bullets = true
