extends Control




func _on_TouchScreenButton_pressed():
	OS.shell_open("https://audiotrimmer.com/de/lizenzfreie-musik")



func _on_Back_pressed():
	get_tree().change_scene("res://Scenes/settings.tscn")
