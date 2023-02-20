extends Control

func _ready():
	$AnimationPlayer.play("start")
	update_Labels()

func save_settings():
	#Saves the configuartion
	var config = ConfigFile.new()
	config.set_value("sounds", "music", G.audio)
	config.set_value("general", "vibrate", G.vibration)
	config.set_value("sounds", "effects", G.sounds)
	var err = config.save(G.path)



func _on_Back_pressed():
	$AnimationPlayer.play_backwards("start")
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
