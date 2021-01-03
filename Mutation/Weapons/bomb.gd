extends Area2D

var _damage: float = 50.0


func explode() -> void:
	$HitBox/CollisionShape2D.disabled = false
	for body in $HitBox.get_overlapping_bodies():
		print(body.get_collision_layer())
		match body.get_collision_layer():
			4:
				body.take_damage(_damage)
			8:
				body.queue_free()
	queue_free()


func _on_Lifetime_timeout():
	explode()


func _on_Bomb_area_entered(area):
	if area.get_collision_layer() == 2 && area.get_parent().name != "Bomb":
		explode()

func _process(delta):
	for body in $HitBox.get_overlapping_bodies():
		print(body.get_collision_layer())
