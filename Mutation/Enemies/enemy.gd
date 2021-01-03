extends KinematicBody2D
class_name enemy

signal enemy_died_sig

var _health: float
var _move_speed: float
var weight: int

var is_spawning = true


func spawn() -> void:
	var spawn_timer = Timer.new()
	spawn_timer.wait_time = 1.0
	spawn_timer.autostart = true
	spawn_timer.one_shot = true
	spawn_timer.name = "SpawnTimer"
	add_child(spawn_timer)
	spawn_timer.connect("timeout", self, "end_spawn")
	get_node("AnimatedSprite").animation = "spawn"
	get_node("CollisionShape2D").disabled = true


func get_player_position() -> Vector2:
	return get_node("/root/Main/World/Player").position - position


func get_players_move_speed() -> float:
	return get_node("/root/Main/World/Player")._move_speed


func end_spawn() -> void:
	get_node("SpawnTimer").queue_free()
	get_node("CollisionShape2D").disabled = false
	is_spawning = false
	


func take_damage(amount) -> void:
	_health -= amount
	if _health <= 0:
		die()


func die():
	emit_signal("enemy_died_sig")
	queue_free()
