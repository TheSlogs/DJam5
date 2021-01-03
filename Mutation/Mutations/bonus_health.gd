extends Mutation


func _init():
	mutation_name = "Strong Heart"
	rarity = "Common"
	name = mutation_name


func mutate_player() -> void:
	get_parent().get_parent()._health += 1
