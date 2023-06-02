extends Control

var edited_block #For the Name of the current edited block
var tmp_block #The Global Colors of the  current edited block
var is_changing_color = false

func _ready():
	update_labels()
	mode()
	$Colors/Color0.visible = true
	$Colors/Color0/Color0Button.visible = true
	$Colors/Color0/ColorName.visible = true
	$Colors/Color1.visible = true
	$Colors/Color1/Color1Button.visible = true
	$Colors/Color1/ColorName.visible = true
	$Colors/Color2.visible = true
	$Colors/Color2/Color2Button.visible = true
	$Colors/Color2/ColorName.visible = true
	$AnimationPlayer.play("start")
	yield(get_node("AnimationPlayer"), "animation_finished")
	$ColorRect.visible = false


func change_color():
	$ChangeColor.visible = true
	$Colors.visible = false
	$ChangeColor/Color.color = Color8(tmp_block[0], tmp_block[1], tmp_block[2])
	$ChangeColor/ColorName.text = rgb_to_hex(tmp_block[0], tmp_block[1], tmp_block[2])
	update_sliders()


func update_labels():
	$Colors/Color0/Color.color = Color8(G.block0[0], G.block0[1], G.block0[2])
	$Colors/Color0/ColorName.text =  "#" + rgb_to_hex(G.block0[0], G.block0[1], G.block0[2])
	$Colors/Color1/Color.color = Color8(G.block1[0], G.block1[1], G.block1[2])
	$Colors/Color1/ColorName.text =  "#" + rgb_to_hex(G.block1[0], G.block1[1], G.block1[2])
	$Colors/Color2/Color.color = Color8(G.block2[0], G.block2[1], G.block2[2])
	$Colors/Color2/ColorName.text =  "#" + rgb_to_hex(G.block2[0], G.block2[1], G.block2[2])


func update_color_and_text():
	$ChangeColor/ColorName.text = rgb_to_hex(tmp_block[0], tmp_block[1], tmp_block[2])
	$ChangeColor/Color.color = Color8(tmp_block[0], tmp_block[1], tmp_block[2])


func update_sliders():
	$ChangeColor/R/R.value = tmp_block[0]
	$ChangeColor/G/G.value = tmp_block[1]
	$ChangeColor/B/B.value = tmp_block[2]


func mode():
	if G.dark_mode:
		VisualServer.set_default_clear_color(Color(0,0,0))
		$Title.add_color_override("font_color", Color(1,1,1))
		$Back/Back.set_texture(preload("res://Assets/angle-left-solid_light.png"))
		$Colors/Color0/ColorName.add_color_override("font_color", Color(1,1,1))
		$Colors/Color1/ColorName.add_color_override("font_color", Color(1,1,1))
		$Colors/Color2/ColorName.add_color_override("font_color", Color(1,1,1))
		$ChangeColor/R/Label.add_color_override("font_color", Color(1,1,1))
		$ChangeColor/G/Label.add_color_override("font_color", Color(1,1,1))
		$ChangeColor/B/Label.add_color_override("font_color", Color(1,1,1))
		$ChangeColor/ColorName.add_color_override("font_color", Color(1,1,1))
		$ChangeColor/CancelButton/Label.add_color_override("font_color", Color(1,1,1))
		$ChangeColor/SaveButton/Label.add_color_override("font_color", Color(1,1,1))
		$Colors/Reset/Label.add_color_override("font_color", Color(1,1,1))
	else:
		VisualServer.set_default_clear_color(Color(1,1,1))
		$Title.add_color_override("font_color", Color(0,0,0))
		$Back/Back.set_texture(preload("res://Assets/angle-left-solid.png"))
		$Colors/Color0/ColorName.add_color_override("font_color", Color(0,0,0))
		$Colors/Color1/ColorName.add_color_override("font_color", Color(0,0,0))
		$Colors/Color2/ColorName.add_color_override("font_color", Color(0,0,0))
		$ChangeColor/R/Label.add_color_override("font_color", Color(0,0,0))
		$ChangeColor/G/Label.add_color_override("font_color", Color(0,0,0))
		$ChangeColor/B/Label.add_color_override("font_color", Color(0,0,0))
		$ChangeColor/ColorName.add_color_override("font_color", Color(0,0,0))
		$ChangeColor/CancelButton/Label.add_color_override("font_color", Color(0,0,0))
		$ChangeColor/SaveButton/Label.add_color_override("font_color", Color(0,0,0))
		$Colors/Reset/Label.add_color_override("font_color", Color(0,0,0))


func rgb_to_hex(r:int, g:int, b:int) -> String: # Thank you Bing
	var hex_r = str("%02x" % r)
	var hex_g = str("%02x" % g)
	var hex_b = str("%02x" % b)
	return hex_r + hex_g + hex_b


func hex_to_rgb(hex): # I think this is a bad way to solve it, so feel free to change it.
	var rgba = Color(hex).to_rgba32()
	var r = (rgba >> 24) & 0xff
	var g = (rgba >> 16) & 0xff
	var b = (rgba >> 8) & 0xff
	return [r, g, b]


func save_colors():
	#Saves the configuration
	var config = ConfigFile.new()
	config.set_value("color", "block0", G.block0)
	config.set_value("color", "block1", G.block1)
	config.set_value("color", "block2", G.block2)
	var err = config.save(G.color_path)


func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST:
		if is_changing_color:
			_on_CancelButton_pressed()
		else:
			_on_Back_pressed()


func _on_Back_pressed():
	$ColorRect.visible = true
	$AnimationPlayer.play("end")
	yield(get_node("AnimationPlayer"), "animation_finished")
	get_tree().change_scene("res://Scenes/Main.tscn")


func _on_R_value_changed(value):
	if $ChangeColor/ColorName.has_focus():
		return
	tmp_block[0] = value
	update_color_and_text()


func _on_G_value_changed(value):
	if $ChangeColor/ColorName.has_focus():
		return
	tmp_block[1] = value
	update_color_and_text()


func _on_B_value_changed(value):
	if $ChangeColor/ColorName.has_focus():
		return
	tmp_block[2] = value
	update_color_and_text()


func _on_ColorName_text_changed(new_text):
	if String(new_text).is_valid_hex_number():
		var rgb = hex_to_rgb(new_text)
		tmp_block = rgb
		$ChangeColor/Color.color = Color8(tmp_block[0], tmp_block[1], tmp_block[2])
		update_sliders()


func _on_Color0Button_pressed():
	is_changing_color = true
	$AnimationPlayer.play("ChangeColor0")
	yield(get_node("AnimationPlayer"), "animation_finished")
	edited_block = "block0"
	tmp_block = G.block0
	change_color()


func _on_Color1Button_pressed():
	is_changing_color = true
	$AnimationPlayer.play("ChangeColor1")
	yield(get_node("AnimationPlayer"), "animation_finished")
	edited_block = "block1"
	tmp_block = G.block1
	change_color()


func _on_Color2Button_pressed():
	is_changing_color = true
	$AnimationPlayer.play("ChangeColor2")
	yield(get_node("AnimationPlayer"), "animation_finished")
	edited_block = "block2"
	tmp_block = G.block2
	change_color()


func _on_CancelButton_pressed():
	is_changing_color = false
	$ChangeColor.visible = false
	$Colors.visible = true
	if edited_block == "block0":
		G.block0 = hex_to_rgb($Colors/Color0/Color.get_frame_color().to_html(false))
		$AnimationPlayer.play("ChangeColor0Save")
	elif edited_block == "block1":
		G.block1 = hex_to_rgb($Colors/Color1/Color.get_frame_color().to_html(false))
		$AnimationPlayer.play("ChangeColor1Save")
	elif edited_block == "block2":
		G.block2 = hex_to_rgb($Colors/Color2/Color.get_frame_color().to_html(false))
		$AnimationPlayer.play("ChangeColor2Save")
	tmp_block = null
	edited_block = null


func _on_SaveButton_pressed():
	is_changing_color = false
	$ChangeColor.visible = false
	$Colors.visible = true
	
	if edited_block == "block0":
		$AnimationPlayer.play("ChangeColor0Save")
	elif edited_block == "block1":
		$AnimationPlayer.play("ChangeColor1Save")
	elif edited_block == "block2":
		$AnimationPlayer.play("ChangeColor2Save")
	update_labels()
	save_colors()
	yield(get_node("AnimationPlayer"), "animation_finished")
	$ChangeColor.visible = false


func _on_Reset_pressed():
	if G.dark_mode:
		G.block0 = [63, 124, 180]
		G.block1 = [129, 194, 78]
		G.block2 = [168, 66, 183]
	else:
		G.block0 = [130, 183, 232]
		G.block1 = [174, 232, 129]
		G.block2 = [219, 129, 232]
	update_labels()
	save_colors()
