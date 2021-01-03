extends Node

var rng = RandomNumberGenerator.new()

var list_of_common_mutations = {
	1 : "bonus_health", #done
	2 : "faster_attack_speed", #done
	3 : "faster_movespeed", #done
	4 : "life_steal",
	5 : "poison_path",
	6 : "increase_invicibility_time",
	7 : "damage_nearby_enemies",
	8 : "bouncy_bullets"
}

var list_of_rare_mutations = {
	1 : "drop_bombs", # Need to hurt Enemies
	2 : "bonus_third_shot",
	3 : "explosive_bullets", 
	4 : "hungry_bullets", #done
	5 : "slow_enemy_bullets", #done
	6 : "super_hot" #done
}


func _ready():
	rng.randomize()

func roll_mutations():
	var selected_mutations = []
	for i in range(3):
		selected_mutations.append(list_of_common_mutations[rng.randi_range(1, len(list_of_common_mutations))])
	
	return selected_mutations
