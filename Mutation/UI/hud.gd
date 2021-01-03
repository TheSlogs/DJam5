extends CanvasLayer

onready var health_container = $Game/VBoxContainer/Health
onready var mutation_container = $Game/VBoxContainer/Mutations

onready var settings_button = $Pause/CenterContainer/SettingsButton
onready var menu_button = $Pause/CenterContainer/MenuButton
onready var desktop_button = $Pause/CenterContainer/DesktopButton

onready var mutation_button1 = $Death/HBoxContainer/MutationButton1
onready var mutation_button2 = $Death/HBoxContainer/MutationButton2
onready var mutation_button3 = $Death/HBoxContainer/MutationButton3

signal player_hit
signal player_died

signal pause
signal unpause


enum MenuState {Main, Game, Pause, Settings}
var current_menu_state = MenuState.Main


func _ready():
	game_start()


func game_start():
	$MainMenu.visible = false
	$Game.visible = true
	current_menu_state = MenuState.Game
	connect_signals()
	update_health()
	update_mutations()


func connect_signals():
	get_node("/root/Main").connect("pause", self, "pause")
	get_node("/root/Main").connect("unpause", self, "unpause")
	
	get_node("/root/Main/World/Player").connect("player_hit", self, "update_health")
	get_node("/root/Main/World/Player").connect("player_died", self, "player_died")


func update_health() -> void:
	for child in health_container.get_children():
		child.queue_free()
		
	var player = get_node("/root/Main/World/Player")
	
	var i: int = 0
	while i < player._health:
		var health_icon = TextureRect.new()
		
		if i + 2 <= player._health:
			health_icon.texture = load("res://Assets/fullheart.png")
			i += 2
		else:
			health_icon.texture = load("res://Assets/halfheart.png")
			i += 1
			
		health_container.add_child(health_icon)


func update_mutations() -> void:
	pass


func pause() -> void:
	$Game.visible = false
	$Pause.visible = true
	current_menu_state = MenuState.Pause


func unpause() -> void:
	$Game.visible = true
	$Pause.visible = false
	current_menu_state = MenuState.Game


func _on_MenuButton_pressed():
	$Pause.visible = false
	$MainMenu.visible = true
	current_menu_state = MenuState.Main


func _on_DesktopButton_pressed():
	get_tree().quit()


func _on_MasterVolumeSlider_value_changed(value):
	Settings.master_vol = value


func _on_MusicVolumeSlider_value_changed(value):
	Settings.music_vol = value


func _on_SoundFXSlider_value_changed(value):
	Settings.sound_fx_vol = value


func _on_QuitButton_pressed():
	get_tree().quit()


func _on_PlayButton_pressed():
	pass # Replace with function body.


func _on_SettingsButton_pressed():
	$MainMenu.visible = false
	$Pause.visible = false
	$Settings.visible = true


func _on_Fullscreen_pressed():
	OS.window_fullscreen = !OS.window_fullscreen


func _on_BackButton_pressed():
	if current_menu_state == MenuState.Main:
		$MainMenu.visible = true
	elif current_menu_state == MenuState.Pause:
		$Pause.visible = true
	$Settings.visible = false


func player_died() -> void:
	$Death.visible = true
	var selected_mutations = GameState.roll_mutations()
	mutation_button1.text = selected_mutations[0]
	mutation_button2.text = selected_mutations[1]
	mutation_button3.text = selected_mutations[2]


func _on_MutationButton1_pressed():
	get_node("/root/Main/World/Player").add_mutation(mutation_button1.text)


func _on_MutationButton2_pressed():
	get_node("/root/Main/World/Player").add_mutation(mutation_button2.text)


func _on_MutationButton3_pressed():
	get_node("/root/Main/World/Player").add_mutation(mutation_button3.text)
