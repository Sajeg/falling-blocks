extends Control

var score = G.score
var highscore = G.highscore

func _ready():
	$AnimationPlayer.play("In")
	if G.mode_dead == false:
		G.load_data()
		$Score/Score.text = str(G.score)
		highscore = G.highscore
		if highscore != null:
			highscore = 0
		if highscore < score:
			highscore = score
			save(highscore)
			G.highscore = highscore
		
		
		$Score2/Score.text = str(highscore)
	else:
		G.load_dead_data()
		$Score/Score.text = str(G.score)
		highscore = G.dead_highscore
		
		if highscore < score:
			highscore = score
			dead_save(highscore)
			G.dead_highscore = highscore
		
		
		$Score2/Score.text = str(highscore)
		


func save(content):
	var file = File.new()
	file.open("user://save.fall", File.WRITE)
	file.store_string(str(content))
	file.close()

func dead_save(content):
	var file = File.new()
	file.open("user://dead_score.fall", File.WRITE)
	file.store_string(str(content))
	file.close()

func _on_Main_pressed():
	$AnimationPlayer.play("out")
	get_tree().change_scene("res://Scenes/Main.tscn")

func _on_again_pressed():
	$AnimationPlayer.play("out")
	get_tree().change_scene("res://Scenes/Game.tscn")
