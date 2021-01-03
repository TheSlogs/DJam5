extends enemy

onready var weapon_point = $WeaponPoint

var just_hit_player: bool = false
var weapon_distance: float = 50.0


func _ready():
	spawn()
	_health = 50.0
	_move_speed = 100.0
	weight = 1


func _physics_process(delta):
	if not is_spawning:
		if $WeaponPoint/Area2D/CollisionShape2D.disabled == true:
			$WeaponPoint/Area2D/CollisionShape2D.disabled = false
		look_at_player()
		move()


func look_at_player() -> void:
	var player_position = get_player_position()
	weapon_point.rotation = player_position.angle()
	weapon_point.position = Vector2(weapon_distance * cos(player_position.angle()), \
	 				weapon_distance * sin(player_position.angle()))


func move() -> void:
	var player_position = get_player_position()
	var move_direction = player_position.normalized()
	if just_hit_player:
		move_direction *= -1
		move_and_slide(move_direction * (_move_speed * 3.0))
		
	else:
		move_and_slide(move_direction * _move_speed)
	


func _on_Area2D_body_entered(body) -> void:
	if body.get_collision_layer() == 1:
		body.take_damage()
		just_hit_player = true
		var hit_back_timer = Timer.new()
		hit_back_timer.autostart = true
		hit_back_timer.one_shot = true
		hit_back_timer.wait_time = 0.25
		hit_back_timer.name = "HitBackTimer"
		add_child(hit_back_timer)
		hit_back_timer.connect("timeout", self, "_on_hit_back_timer_timeout")


func _on_hit_back_timer_timeout() -> void:
	just_hit_player = false
	get_node("HitBackTimer").queue_free()
