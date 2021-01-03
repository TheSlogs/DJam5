extends Mutation


func _init():
	mutation_name = "Extremely Buff Legs"
	rarity = "Common"
	name = mutation_name


func mutate_player() -> void:
	get_parent().get_parent()._move_speed *= 2
