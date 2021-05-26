extends Control

func _ready():
	$Vibrate/Vibrate.pressed = G.vibration
	
	$Music/Music.pressed = G.audio


func save_settings():
	
	var config = ConfigFile.new()
	config.set_value("general", "sound", G.audio)
	config.set_value("general", "vibrate", G.vibration)
	var err = config.save(G.path)
	if err != OK:
		print("something went wrong")



func _on_Back_pressed():
	save_settings()
	get_tree().change_scene("res://Scenes/Main.tscn")


func _on_Vibrate_toggled(button_pressed):
	G.vibration = button_pressed


func _on_Music_toggled(button_pressed):
	G.audio = button_pressed


func _on_TouchScreenButton_pressed():
	OS.shell_open("https://audiotrimmer.com/de/lizenzfreie-musik")


func _on_Credits_pressed():
	get_tree().change_scene("res://Scenes/Credits.tscn")



