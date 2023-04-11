extends Control

var highscore = G.highscore

func _ready():
	if G.dark_mode:
		$Title.add_color_override("default_color", Color(1,1,1))
		$main/Label.add_color_override("font_color", Color(1,1,1))
		$again/Label.add_color_override("font_color", Color(1,1,1))
		$BlockBlue.modulate = Color("3F7CB4")
		$BlockBlue2.modulate = Color("3F7CB4")
		$BlockGreen.modulate = Color("81C24E")
		$BlockGreen2.modulate = Color("81C24E")
		$BlockPink.modulate = Color("A842B7")
		$BlockPink2.modulate = Color("A842B7")
	else:
		$Title.add_color_override("default_color", Color(0,0,0))
		$main/Label.add_color_override("font_color", Color(0,0,0))
		$again/Label.add_color_override("font_color", Color(0,0,0))
		$BlockBlue.modulate = Color("82B7E8")
		$BlockBlue2.modulate = Color("82B7E8")
		$BlockGreen.modulate = Color("AEE881")
		$BlockGreen2.modulate = Color("AEE881")
		$BlockPink.modulate = Color("DB81E8")
		$BlockPink2.modulate = Color("DB81E8")
func end():
	$AnimationPlayer.play("In")
	if G.mode_dead == false:
		#In NORMAL mode this script checks and displays the score and highscore
		G.load_data()
		$Score/Score.text = str(G.score)
		highscore = G.highscore
		if int(highscore) < G.score:
			highscore = G.score
			save(highscore)
			G.highscore = highscore
		
		
		$Score2/Score.text = str(highscore)
	else:
		#In DEATH mode this script checks and displays the score and highscore
		G.load_dead_data()
		$Score/Score.text = str(G.score)
		highscore = G.dead_highscore
		
		if highscore < G.score:
			highscore = G.score
			dead_save(highscore)
			G.dead_highscore = highscore
		
		
		$Score2/Score.text = str(highscore)
		


func save(content): #Save the highscore in NORMAL mode
	var file = File.new()
	file.open("user://save.fall", File.WRITE)
	file.store_string(str(content))
	file.close()

func dead_save(content): #Save the highscore in DEATH mode
	var file = File.new()
	file.open("user://dead_score.fall", File.WRITE)
	file.store_string(str(content))
	file.close()

func _on_Main_pressed(): #Button for the Main screen
	$AnimationPlayer.play("change_scene")
	yield(get_node("AnimationPlayer"), "animation_finished")
	get_tree().change_scene("res://Scenes/Main.tscn")

func _on_again_pressed(): #Button for restart game
	$AnimationPlayer.play("out")
	get_tree().change_scene("res://Scenes/Game.tscn")
