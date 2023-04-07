extends Control

func _ready():
	if G.dark_mode:
		$Title.add_color_override("font_color", Color(1,1,1))
		$Credits.add_color_override("font_color", Color(1,1,1))
		$VBoxContainer/Vibration.add_color_override("font_color", Color(1,1,1))
		$VBoxContainer/Music.add_color_override("font_color", Color(1,1,1))
		$VBoxContainer/Sound.add_color_override("font_color", Color(1,1,1))
		$VBoxContainer/Mode.add_color_override("font_color", Color(1,1,1))
		$Back/Back.set_texture(preload("res://Assets/angle-left-solid_light.png"))
		
		$BlockBlue.set_texture(preload("res://Assets/BlockBlueDark.png"))
		$BlockBlue2.set_texture(preload("res://Assets/BlockBlueDark.png"))
		$BlockGreen.set_texture(preload("res://Assets/BlockGreenDark.png"))
		$BlockGreen2.set_texture(preload("res://Assets/BlockGreenDark.png"))
		$BlockPink.set_texture(preload("res://Assets/BlockPinkDark.png"))
		$BlockPink2.set_texture(preload("res://Assets/BlockPinkDark.png"))
	else:
		$Title.add_color_override("font_color", Color(0,0,0))
		$Credits.add_color_override("font_color", Color(0,0,0))
		$VBoxContainer/Music.add_color_override("font_color", Color(0,0,0))
		$VBoxContainer/Sound.add_color_override("font_color", Color(0,0,0))
		$VBoxContainer/Vibration.add_color_override("font_color", Color(0,0,0))
		$VBoxContainer/Mode.add_color_override("font_color", Color(0,0,0))
		$Back/Back.set_texture(preload("res://Assets/angle-left-solid.png"))
		
		$BlockBlue.set_texture(preload("res://Assets/BlockBlue.png"))
		$BlockBlue2.set_texture(preload("res://Assets/BlockBlue.png"))
		$BlockGreen.set_texture(preload("res://Assets/BlockGreen.png"))
		$BlockGreen2.set_texture(preload("res://Assets/BlockGreen.png"))
		$BlockPink.set_texture(preload("res://Assets/BlockPink.png"))
		$BlockPink2.set_texture(preload("res://Assets/BlockPink.png"))
	
	if G.fdroid_version:
		$VBoxContainer/Vibration.queue_free()
	$AnimationPlayer.play("start")
	update_Labels()

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
	G.dark_mode = !G.dark_mode
	save_settings()
	update_Labels()

func update_Labels():
	print("update")
	if G.vibration:
		$VBoxContainer/Vibration.text = "Vibration: ON"
	else:
		$VBoxContainer/Vibration.text = "Vibration: OFF"
	
	if G.audio:
		$VBoxContainer/Music.text = "Music: ON"
	else:
		$VBoxContainer/Music.text = "Music: OFF"
	
	if G.sounds:
		$VBoxContainer/Sound.text = "Sound: ON"
	else:
		$VBoxContainer/Sound.text = "Sound: OFF"
	
	if G.dark_mode:
		$VBoxContainer/Mode.text = "Dark Mode"
	else:
		$VBoxContainer/Mode.text = "Light Mode"





func _on_TouchScreenButton_pressed():
	OS.shell_open("https://github.com/Sajeg/falling-blocks/")
