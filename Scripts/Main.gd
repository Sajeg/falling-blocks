extends Control
var system 
var score = 0
var highscore = 0
var dead_highscore = 0
var settings
var mode_dead = false
var player_name = "Player"
var _config_file = ConfigFile.new()
var path = "user://settings.cfg"
var color_path = "user://colors.cfg"
var is_selecting_game_mode = false

export var audio = true
export var vibration = true
export var sounds = true
export var dark_mode = false
export var fdroid_version = false

#The Colors of the Blocks
var block0 = [130, 183, 232]
var block1 = [174, 232, 129]
var block2 = [219, 129, 232]

func _ready():
	#system = OS.get_name()
	$ColorRect.visible = true
	mode()
	load_colors()
	update_background()
	$ColorRect.material.set_shader_param("screen_width", $ColorRect.rect_size.x)
	$ColorRect.material.set_shader_param("screen_heigth", $ColorRect.rect_size.y)
	
	highscore = load_data()
	dead_highscore = load_dead_data()
	load_settings()
	yield(get_tree().create_timer(0.3), "timeout")
	if fdroid_version:
		vibration == false
	$AnimationPlayer.play("in")

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
		file.open("user://save.fall", File.WRITE)
		file.store_string("0")
		file.close()
		get_tree().change_scene("res://Scenes/Tutorial.tscn")
		$"/root/G".visible = false
		return 0


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
		file.open("user://dead_score.fall", File.WRITE)
		file.close()


func load_settings():
	#loads the settings
	var config = ConfigFile.new()
	var default_options = {
			"music": true,
			"vibrate": false,
			"effects": true,
			"dark_mode": false
			}
	var err = config.load(path)
	if err != OK:
		return default_options
	var options = {}
	audio = config.get_value("sounds", "music", default_options.music)
	vibration = config.get_value("general", "vibrate", default_options.vibrate)
	sounds = config.get_value("sounds", "effects", default_options.effects)
	dark_mode = config.get_value("general", "dark_mode", default_options.dark_mode)
	return options


func load_colors():
	var config = ConfigFile.new()
	var default_options = {
			"block0": [130, 183, 232],
			"block1": [174, 232, 129],
			"block2": [219, 129, 232]
			}
	var err = config.load(color_path)
	if err != OK:
		config.set_value("color", "block0", block0)
		config.set_value("color", "block1", block1)
		config.set_value("color", "block2", block2)
		err = config.save(color_path)
		load_colors()
	block0 = config.get_value("color", "block0")
	block1 = config.get_value("color", "block1")
	block2 = config.get_value("color", "block2")


func mode():
	if G.dark_mode:
		VisualServer.set_default_clear_color(Color(0,0,0))
		$Title.add_color_override("default_color", Color(1,1,1))
		$UI/Selection/Start/LabelStart.add_color_override("font_color", Color(1,1,1))
		$UI/Selection/Quit/Labelquit.add_color_override("font_color", Color(1,1,1))
		$UI/Selection/Mode/Death/LabelModeDeath.add_color_override("font_color", Color(1,1,1))
		$UI/Selection/Mode/Normal/LabelModeNormal.add_color_override("font_color", Color(1,1,1))
		$UI/settings/gear.set_texture(preload("res://Assets/gear_light.png"))
		$UI/Palette/Palette.set_texture(preload("res://Assets/brush_light.png"))
	else:
		VisualServer.set_default_clear_color(Color(1,1,1))
		$Title.add_color_override("default_color", Color(0,0,0))
		$UI/Selection/Start/LabelStart.add_color_override("font_color", Color(0,0,0))
		$UI/Selection/Quit/Labelquit.add_color_override("font_color", Color(0,0,0))
		$UI/Selection/Mode/Death/LabelModeDeath.add_color_override("font_color", Color(0,0,0))
		$UI/Selection/Mode/Normal/LabelModeNormal.add_color_override("font_color", Color(0,0,0))
		$UI/settings/gear.set_texture(preload("res://Assets/gear.png"))
		$UI/Palette/Palette.set_texture(preload("res://Assets/brush.png"))


func update_background():
	$BlockBlue.modulate = Color8(block0[0], block0[1], block0[2])
	$BlockBlue2.modulate = Color8(block0[0], block0[1], block0[2])
	$BlockGreen.modulate = Color8(block1[0], block1[1], block1[2])
	$BlockGreen2.modulate = Color8(block1[0], block1[1], block1[2])
	$BlockPink.modulate = Color8(block2[0], block2[1], block2[2])
	$BlockPink2.modulate = Color8(block2[0], block2[1], block2[2])


func _on_quit_pressed():
	$AnimationPlayer.play("out")
	yield(get_node("AnimationPlayer"), "animation_finished")
	get_tree().quit()


func _on_start_pressed():
	is_selecting_game_mode = true
	$AnimationPlayer.play("mode")


func _on_settings_pressed():
	$AnimationPlayer.play("change_scene")
	yield(get_node("AnimationPlayer"), "animation_finished")
	get_tree().change_scene("res://Scenes/settings.tscn")
	$"/root/G".visible = false


func _unhandled_key_input(event):
	get_tree().change_scene("res://Scenes/Tutorial.tscn")
	$"/root/G".visible = false


func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST:
		if is_selecting_game_mode:
			is_selecting_game_mode = false
			$AnimationPlayer.play_backwards("mode")
			yield($AnimationPlayer, "animation_finished")
			$UI/Selection/Mode/Death/death.visible = false
			$UI/Selection/Mode/Normal/Normal.visible = false
			$UI/Selection/Start/start.visible = true
			$UI/Selection/Quit/quit.visible = true

func _on_death_pressed():
	G.mode_dead = true
	$AnimationPlayer.play("start")
	yield(get_node("AnimationPlayer"), "animation_finished")
	get_tree().change_scene("res://Scenes/Game.tscn")
	$"/root/G".visible = false


func _on_Normal_pressed():
	G.mode_dead = false
	$AnimationPlayer.play("start")
	yield(get_node("AnimationPlayer"), "animation_finished")
	get_tree().change_scene("res://Scenes/Game.tscn")
	$"/root/G".visible = false


func _on_Main_resized():
	$ColorRect.material.set_shader_param("screen_width", $ColorRect.rect_size.x)
	$ColorRect.material.set_shader_param("screen_heigth", $ColorRect.rect_size.y)


func _on_Back_pressed():
	$AnimationPlayer.play("change_scene")
	yield(get_node("AnimationPlayer"), "animation_finished")
	get_tree().change_scene("res://Scenes/Palette.tscn")
	$"/root/G".visible = false
