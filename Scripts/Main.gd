extends Control
var score = 0
var highscore = 0
var dead_highscore = 0
var settings
var mode_dead = false
var player_name = "Player"
var _config_file = ConfigFile.new()
export var audio = true
export var vibration = true
export var sounds = true
var path = "user://settings.cfg"

func _ready():
	$UiElements/Mode.visible = false
	$AnimationPlayer.play("in")
	highscore = load_data()
	dead_highscore = load_dead_data()
	load_settings()

func load_data(): 
	#loads the highscore data
	var file = File.new()
	if file.file_exists("user://save.fall"):
		file.open("user://save.fall", File.READ)
		var content = file.get_as_text()
		content = int(content) 
		file.close()
		return content
	else:
		$"/root/G".visible = false
# warning-ignore:return_value_discarded
		get_tree().change_scene("res://Scenes/Tutorial.tscn")
		file.open("user://save.fall", File.WRITE)
		file.close()

func load_dead_data():
	#loads the highscore data in Death mode
	var file = File.new()
	if file.file_exists("user://dead_score.fall"):
		file.open("user://dead_score.fall", File.READ)
		var content = file.get_as_text()
		content = int(content) 
		file.close()
		return content
	else:
		$"/root/G".visible = false
# warning-ignore:return_value_discarded
		get_tree().change_scene("res://Scenes/Tutorial.tscn")
		file.open("user://dead_score.fall", File.WRITE)
		file.close()

func load_settings():
	#loads the settings
	var config = ConfigFile.new()
	var default_options = {
			"music": true,
			"vibrate": true,
			"effects": true
			}
	var err = config.load(path)
	if err != OK:
		return default_options
	var options = {}
	audio = config.get_value("sounds", "music", default_options.music)
	vibration = config.get_value("general", "vibrate", default_options.vibrate)
	sounds = config.get_value("sounds", "effects", default_options.effects)
	return options




func _on_quit_pressed():
	$AnimationPlayer.play("out")
	get_tree().quit()



func _on_start_pressed():
	$UiElements/Start/start.visible = false
	$UiElements/Quit/quit.visible = false
	$UiElements/Mode.visible = true
	$AnimationPlayer.play("mode")




func _on_settings_pressed():
	$AnimationPlayer.play("Settings_open")
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Scenes/settings.tscn")
	$"/root/G".visible = false



func _on_death_pressed():
	G.mode_dead = true
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Scenes/Game.tscn")
	$"/root/G".visible = false


func _on_Normal_pressed():
	G.mode_dead = false
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Scenes/Game.tscn")
	$"/root/G".visible = false

