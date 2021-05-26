extends Control


func _ready():
	$Blue/AnimationPlayer.play("Idle")
	$Pink/AnimationPlayer.play("idle")
	$Green/AnimationPlayer.play("idle")
	$Text/RichTextLabel.visible = true
	var rand = randi()%3
	if rand == 0:
		$Player/BlockBlue.visible = true
	if rand == 1:
		$Player/BlockGreen.visible = true
	if rand == 2:
		$Player/BlockPink.visible = true


func _on_TouchScreenButton_pressed():
	$Text/weiter2.visible = true
	$Text/TouchScreenButton.visible = false
	$Text/RichTextLabel.visible = false
	$Text/Label3.visible = true
	$arrow.visible = true
	$arrow2.visible = true
	$Label.visible = true
	$Label2.visible = true


func _on_weiter2_pressed():
	$Blue/AnimationPlayer.play("special")
	$Pink/AnimationPlayer.play("special")
	$Green/AnimationPlayer.play("special")
	$Text/startSpiel.visible = true
	$Text/RichTextLabel2.visible = true
	$Label3.visible = true
	$Text/Label3.visible = false
	$arrow.visible = false
	$arrow2.visible = false
	$Label.visible = false
	$Label2.visible = false


func _on_startSpiel_pressed():
	get_tree().change_scene("res://Scenes/Game.tscn")


func _on_pos1_pressed():
	$Player.position.x = 100

func _on_pos2_pressed():
	$Player.position.x = 310


func _on_pos3_pressed():
	$Player.position.x = 520
