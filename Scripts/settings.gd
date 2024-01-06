extends Control

func _ready():
	update_ui()
	if G.fdroid_version:
		$VBoxContainer/Vibration.queue_free()
	$AnimationPlayer.play("start")
	update_Labels()

func update_ui():
	$BlockBlue.modulate = Color8(G.block0[0], G.block0[1], G.block0[2])
	$BlockBlue2.modulate = Color8(G.block0[0], G.block0[1], G.block0[2])
	$BlockGreen.modulate = Color8(G.block1[0], G.block1[1], G.block1[2])
	$BlockGreen2.modulate = Color8(G.block1[0], G.block1[1], G.block1[2])
	$BlockPink.modulate = Color8(G.block2[0], G.block2[1], G.block2[2])
	$BlockPink2.modulate = Color8(G.block2[0], G.block2[1], G.block2[2])
	if G.dark_mode:
		VisualServer.set_default_clear_color(Color(0,0,0))
		$Title.add_color_override("font_color", Color(1,1,1))
		$Credits.add_color_override("font_color", Color(1,1,1))
		$VBoxContainer/Vibration.add_color_override("font_color", Color(1,1,1))
		$VBoxContainer/Music.add_color_override("font_color", Color(1,1,1))
		$VBoxContainer/Sound.add_color_override("font_color", Color(1,1,1))
		$VBoxContainer/Mode.add_color_override("font_color", Color(1,1,1))
		$VBoxContainer/Tutorial.add_color_override("font_color", Color(1,1,1))
		$Back/Back.set_texture(preload("res://Assets/angle-left-solid_light.png"))
		
	else:
		VisualServer.set_default_clear_color(Color(1,1,1))
		$Title.add_color_override("font_color", Color(0,0,0))
		$Credits.add_color_override("font_color", Color(0,0,0))
		$VBoxContainer/Music.add_color_override("font_color", Color(0,0,0))
		$VBoxContainer/Sound.add_color_override("font_color", Color(0,0,0))
		$VBoxContainer/Vibration.add_color_override("font_color", Color(0,0,0))
		$VBoxContainer/Mode.add_color_override("font_color", Color(0,0,0))
		$VBoxContainer/Tutorial.add_color_override("font_color", Color(0,0,0))
		$Back/Back.set_texture(preload("res://Assets/angle-left-solid.png"))

func update_block_color():
	pass 


func save_settings():
	#Saves the configuartion
	var config = ConfigFile.new()
	config.set_value("sounds", "music", G.audio)
	config.set_value("general", "vibrate", G.vibration)
	config.set_value("general", "dark_mode", G.dark_mode)
	config.set_value("sounds", "effects", G.sounds)
	var err = config.save(G.path)


func _on_Back_pressed():
	$AnimationPlayer.play("end")
	save_settings()
	yield(get_node("AnimationPlayer"), "animation_finished")
	get_tree().change_scene("res://Scenes/Main.tscn")


func _on_MusicButton_pressed():
	G.audio = !G.audio
	save_settings()
	update_Labels()


func _on_SoundButton_pressed():
	G.sounds = !G.sounds
	save_settings()
	update_Labels()


func _on_VibrationButton_pressed():
	G.vibration = !G.vibration
	save_settings()
	update_Labels()


func _on_ModeButton_pressed():
	$AnimationPlayer.play("end")
	yield(get_node("AnimationPlayer"), "animation_finished")
	G.dark_mode = !G.dark_mode
	update_block_color()
	update_ui()
	save_settings()
	save_colors()
	update_Labels()
	$AnimationPlayer.play("start")


func _on_Tutorial_pressed():
	$AnimationPlayer.play("end")
	save_settings()
	yield(get_node("AnimationPlayer"), "animation_finished")
	get_tree().change_scene("res://Scenes/Tutorial.tscn")


func update_Labels():
	
	if G.audio:
		$VBoxContainer/Music.text = "Music: ON"
	else:
		$VBoxContainer/Music.text = "Music: OFF"
	
	if G.sounds:
		$VBoxContainer/Sound.text = "Sound: ON"
	else:
		$VBoxContainer/Sound.text = "Sound: OFF"
	
	if G.dark_mode:
		$VBoxContainer/Mode.text = "Light Mode"
	else:
		$VBoxContainer/Mode.text = "Dark Mode"
	
	if G.fdroid_version:
		return
	
	if G.vibration:
		$VBoxContainer/Vibration.text = "Vibration: ON"
	else:
		$VBoxContainer/Vibration.text = "Vibration: OFF"


func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST:
		_on_Back_pressed()

func save_colors():
	#Saves the configuration
	var config = ConfigFile.new()
	config.set_value("color", "block0", G.block0)
	config.set_value("color", "block1", G.block1)
	config.set_value("color", "block2", G.block2)
	var err = config.save(G.color_path)

func _on_TouchScreenButton_pressed():
	OS.shell_open("https://github.com/Sajeg/falling-blocks/")
