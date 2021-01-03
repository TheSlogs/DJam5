extends Projectile


func _on_HitBox_body_entered(body):
	match body.get_collision_layer():
		1:
			body.take_damage()
			queue_free()
		32:
			queue_free()
	pass

