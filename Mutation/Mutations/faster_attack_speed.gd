extends Mutation


func _ready():
	mutation_name = "Faster Attack"
	rarity = "Common"
	name = mutation_name


func mutate_player() -> void:
	get_parent().get_parent()._attack_speed /= 2.0
	get_parent().get_parent().update_attack_speed()
