extends Projectile


func _on_HitBox_body_entered(body):

	match body.get_collision_layer():
		4:
			body.take_damage(_damage)
			if get_node("/root/Main/World/Player").explosive_bullets == true:
				create_explosion()
			queue_free()
		32:
			if get_node("/root/Main/World/Player").explosive_bullets == true:
				create_explosion()
			queue_free()
	pass


func _on_HitBox_area_entered(area):
	if get_node("/root/Main/World/Player").hungry_bullets == true:
		if area.get_parent().name != "WeaponPoint":
			match area.get_collision_layer():
				8:
					if randf() > 0.75:
						area.queue_free()
						scale *= 1.5
						_damage *= 1.5


func create_explosion() -> void:
	var explosion_area = Area2D.new()
	explosion_area.name = "Explosion"
	add_child(explosion_area)
	
	var explosion_collider = CollisionShape2D.new()
	var collider_shape = CircleShape2D.new()
	collider_shape.radius = 50
	explosion_collider.set_shape(collider_shape)
	explosion_collider.name = "ExplosionCollider"
	
	explosion_area.add_child(explosion_collider)
	
	explosion_area.set_collision_layer_bit(1, 2)
	explosion_area.set_collision_mask_bit(2, 4)
	
	for body in explosion_area.get_overlapping_bodies():
		print(body)
		if body.get_collsion_layer() == 4:
			body.take_damage(_damage)
	
	explosion_area.queue_free()
