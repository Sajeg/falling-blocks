extends Control

func _ready():
	$Vibrate/Vibrate.pressed = G.vibration
	$Music/Music.pressed = G.audio
	$Effects/sounds.pressed = G.sounds


func save_settings():
	#Saves the configuartion
	var config = ConfigFile.new()
	config.set_value("sounds", "music", G.audio)
	config.set_value("general", "vibrate", G.vibration)
	config.set_value("sounds", "effects", G.sounds)
	var err = config.save(G.path)



func _on_Back_pressed():
	save_settings()
	get_tree().change_scene("res://Scenes/Main.tscn")


func _on_Vibrate_toggled(button_pressed):
	G.vibration = button_pressed


func _on_Music_toggled(button_pressed):
	G.audio = button_pressed


func _on_Credits_pressed():
	get_tree().change_scene("res://Scenes/Credits.tscn")





func _on_sounds_toggled(button_pressed):
	G.sounds = button_pressed
