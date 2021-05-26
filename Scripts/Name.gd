extends Control

var name_exist



func _ready():
	load_name()

func load_name():
	var file = File.new()
	if file.file_exists("user://name.fall"):
		name_exist = true
		file.open("user://name.fall", File.READ)
		var content = file.get_as_text()
		content = str(content) 
		file.close()
		G.player_name = content
		get_tree().change_scene("res://Scenes/Main.tscn")
	else:
		name_exist = false



func _on_weitername_pressed():
	OS.hide_virtual_keyboard()
	save_name($LineEdit.text)
	get_tree().change_scene("res://Scenes/Tutorial.tscn")
	load_name()


func save_name(content):
	var file = File.new()
	file.open("user://name.fall", File.WRITE)
	file.store_string(str(content))
	file.close()
	print(content)
