extends Control

var pos1_pressed = false
var pos2_pressed = false
var pos3_pressed = false

var anim_finished = false

func _ready():
	$Blocks/Player/BlockBlue.modulate = Color("82B7E8")
	$Blocks/Blue/BlockBlue.modulate = Color("82B7E8")
	$Blocks/Green/BlockGreen.modulate = Color("AEE881")
	$Blocks/Pink/BlockPink.modulate = Color("DB81E8")
	$AnimationPlayer.play("tutorial")
	yield($AnimationPlayer, "animation_finished")
	anim_finished = true


func _process(delta):
	if $Blocks/Blue.visible:
		$Blocks/Blue.position.y += 1
		if $Blocks/Blue.position.y > 1800:
			$Blocks/Blue.position.x = 310
			$Blocks/Blue.position.y = -100
	if $Blocks/Pink.visible:
		$Blocks/Pink.position.y += 1
		if $Blocks/Blue.position.y > 1800:
			get_tree().change_scene("res://Scenes/Main.tscn")
	if $Blocks/Green.visible:
		$Blocks/Green.position.y += 1


func next_animation():
	$AnimationPlayer.play("tutorial_2")
	yield($AnimationPlayer, "animation_finished")
	$Blocks/Blue.visible = true
	$Blocks/Blue.position.x = 310
	$Blocks/Blue.position.y = -100


func _on_pos1_pressed():
	$Blocks/Player.position.x = 100
	pos1_pressed = true
	if pos1_pressed and pos2_pressed and pos3_pressed and anim_finished:
		anim_finished = false
		next_animation()


func _on_pos2_pressed():
	$Blocks/Player.position.x = 310
	pos2_pressed = true
	if pos1_pressed and pos2_pressed and pos3_pressed and anim_finished:
		anim_finished = false
		next_animation()


func _on_pos3_pressed():
	$Blocks/Player.position.x = 520
	pos3_pressed = true
	if pos1_pressed and pos2_pressed and pos3_pressed and anim_finished:
		anim_finished = false
		next_animation()


func _on_Area2D_area_entered(area):
	if area.name == "Blue":
		$Blocks/Blue.visible = false
		$AnimationPlayer.play("tutorial_3")
	if area.name == "Pink" or "Green":
		$AnimationPlayer.play("tutorial_3")
