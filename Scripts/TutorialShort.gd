extends Control


func _ready():
	$AnimationPlayer.play("start")
	update_mode()


func _on_TouchScreenButton_pressed():
	G.dark_mode = !G.dark_mode
	update_mode()
	yield(get_node("AnimationPlayer"), "animation_finished")
	


func update_mode():
	$AnimationPlayer.play("end")
	yield(get_node("AnimationPlayer"), "animation_finished")
	if G.dark_mode:
		$DarkModeLabel.text = "Light Mode"
	else:
		$DarkModeLabel.text = "Dark Mode"
	if G.dark_mode:
		VisualServer.set_default_clear_color(Color(0,0,0))
		$Title.add_color_override("default_color", Color(1,1,1))
		$ShortTutorial.add_color_override("default_color", Color(1,1,1))
		$DarkModeLabel.add_color_override("font_color", Color(1,1,1))
		$PlayLabel.add_color_override("font_color", Color(1,1,1))
		G.block0 = [63, 124, 180]
		G.block1 = [129, 194, 78]
		G.block2 = [168, 66, 183]
	else:
		VisualServer.set_default_clear_color(Color(1,1,1))
		$Title.add_color_override("default_color", Color(0,0,0))
		$ShortTutorial.add_color_override("default_color", Color(0,0,0))
		$DarkModeLabel.add_color_override("font_color", Color(0,0,0))
		$PlayLabel.add_color_override("font_color", Color(0,0,0))
		G.block0 = [130, 183, 232]
		G.block1 = [174, 232, 129]
		G.block2 = [219, 129, 232]
	save_colors()
	$AnimationPlayer.play("start")

func save_colors():
	#Saves the configuration
	var config = ConfigFile.new()
	config.set_value("color", "block0", G.block0)
	config.set_value("color", "block1", G.block1)
	config.set_value("color", "block2", G.block2)
	var err = config.save(G.color_path)


func _on_Play_pressed():
	$AnimationPlayer.play("end")
	yield(get_node("AnimationPlayer"), "animation_finished")
	get_tree().change_scene("res://Scenes/Main.tscn")
