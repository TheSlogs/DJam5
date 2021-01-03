extends Mutation


func _init():
	mutation_name = "Super Hot"
	rarity = "Rare"
	name = mutation_name


func mutate_player() -> void:
	get_node("/root/Main/World/Player").super_hot = true
