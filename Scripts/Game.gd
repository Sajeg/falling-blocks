extends Node2D
const pos1 = 100
const pos2 = 310
const pos3 = 520
export var speed = 6
var score = 0
var PlayerX = 310
var crash = [false,false,false,false,false,false]
var audiostream: AudioStream = preload("res://Assets/Music/Song04.wav")
var freeze = false
var playername = null
var vibrate

func _ready():
	speed = 6
	freeze = false
	if bool(G.audio) == true:
		music()
	var rand = randi()%3
	if rand == 0:
		$Player/BlockBlue.visible = true
		playername = "blue"
	if rand == 1:
		$Player/BlockGreen.visible = true
		playername = "green"
	if rand == 2:
		$Player/BlockPink.visible = true
		playername = "pink"

func _process(delta):
	if freeze == false:
		G.score = score
		
		invisible("Blue", 0)
		invisible("Green", 2)
		invisible("Pink", 4)
		invisible("Blue2", 1)
		invisible("Green2", 3)
		invisible("Pink2", 5)
		
		$Player.position.x = PlayerX
		$Label.text = str(score)
		$Blue.position.y += speed
		$Blue2.position.y += speed
		$Green.position.y += speed
		$Green2.position.y += speed
		$Pink.position.y += speed
		$Pink2.position.y += speed
		if $Blue.position.y >1200:
			crash[0] = false
			new_pos($Blue)
		if $Blue2.position.y >1200:
			new_pos($Blue2)
			crash[1] = false
		if $Green.position.y >1200:
			new_pos($Green)
			crash[2] = false
		if $Green2.position.y >1200:
			new_pos($Green2)
			crash[3] = false
		if $Pink.position.y >1200:
			new_pos($Pink)
			crash[4] = false
		if $Pink2.position.y >1200:
			new_pos($Pink2)
			crash[5] = false
		
		
		
		
		touching() 

func touching():
	for body in $Player/Area2D.get_overlapping_bodies():
		if body != null:
			if playername == "blue" and body.name == "Blue":
				score += 1
				speed +=0.01
				if bool(G.vibration) == true:
					Input.vibrate_handheld(5)
				crash[0] = true
			elif playername == "green" and body.name == "Green":
				score += 1
				speed +=0.01
				if bool(G.vibration) == true:
					Input.vibrate_handheld(5)
				crash[2] = true
			elif playername == "pink" and body.name == "Pink":
				score += 1
				speed +=0.01
				if bool(G.vibration) == true:
					Input.vibrate_handheld(5)
				crash[4] = true
			elif playername == "blue" and body.name == "Blue2":
				score += 1
				speed +=0.01
				if bool(G.vibration) == true:
					Input.vibrate_handheld(5)
				crash[1] = true
			elif playername == "green" and body.name == "Green2":
				score += 1
				speed +=0.01
				if bool(G.vibration) == true:
					Input.vibrate_handheld(5)
				crash[3] = true
			elif playername == "pink" and body.name == "Pink2":
				score += 1
				speed +=0.01
				if bool(G.vibration) == true:
					Input.vibrate_handheld(5)
				crash[5] = true
			else:
				$Timer.start()
				freeze = true
		else:
			return


func invisible(block, num):
	var anim = get_node(str(block)+"/AnimationPlayer")
	if crash[num] == false:
		if G.mode_dead == false:
			get_node(str(block)+"/AnimationPlayer").play("idle")
		else:
			get_node(str(block)+"/AnimationPlayer").play("special")
	else:
		get_node(str(block)+"/AnimationPlayer").play("crash")






func new_pos(Block):
	Block.position.y = -100
	var randpos = randi()%3
	if randpos == 0:
		Block.position.x = pos1
	if randpos == 1:
		Block.position.x = pos2
	if randpos == 2:
		Block.position.x = pos3
	Block.visible = true

func music():
	#var rand = randi()%3
	#if rand == 0:
	$Music.set_stream(audiostream)
	$Music.play()
	#if rand == 1:
	#	$Music.set_stream(audiostream1)
	#	$Music.play()
	#if rand == 2:
	#	$Music.set_stream(audiostream2)
	#	$Music.play()


func _on_pos1_pressed():
	PlayerX = 100
func _on_pos2_pressed():
	PlayerX = 310
func _on_pos3_pressed():
	PlayerX = 520


func _on_Music_finished():
	music()


func _on_Timer_timeout():
	freeze = false
	get_tree().change_scene("res://Scenes/gameover.tscn")
