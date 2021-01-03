extends Node2D
class_name Projectile

var _damage : float
var _speed : float


func set_variables(damage, speed, new_rotation, starting_position):
	_damage = damage
	_speed = speed
	rotation = new_rotation
	position = starting_position


func deal_damage(target) -> void:
	target.take_damage(_damage)


func _process(delta):
	position += Vector2(cos(rotation), \
								 sin(rotation)) * _speed * delta
	


