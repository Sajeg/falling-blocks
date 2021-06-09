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
	#Player Color:
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
	$Player.position.x = PlayerX
	if freeze == false:
		G.score = score
		
		animation("Blue", 0)
		animation("Green", 2)
		animation("Pink", 4)
		animation("Blue2", 1)
		animation("Green2", 3)
		animation("Pink2", 5)
		
		#Displays the Score
		$Label.text = str(score)
		
		#The Script for falling
		$Blue.position.y += speed
		$Blue2.position.y += speed
		$Green.position.y += speed
		$Green2.position.y += speed
		$Pink.position.y += speed
		$Pink2.position.y += speed
		
		#Detects the postions from the blocks
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
	#This Script checks when a block is touching another whether 
	#the player gets a point or die
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
				freeze = true
				$Music.stop()
				$Label.visible = false
				
				for block in [$Blue, $Blue2, $Green, $Green2, $Pink, $Pink2]:
					for i in 25: 
						block.scale.x += -0.01
						block.scale.y += -0.01
						yield(get_tree().create_timer(0.01), "timeout")
					block.visible = false
				PlayerX = 310
				for i in 50:
					yield(get_tree().create_timer(0.01), "timeout")
					$Player.position.y += 1
				$Player.visible = false
				$Control.visible = true
				$Control.end()
		else:
			return


func animation(block, num):
	#animation script
	var anim = get_node(str(block)+"/AnimationPlayer")
	if crash[num] == false:
		if G.mode_dead == false:
			get_node(str(block)+"/AnimationPlayer").play("idle")
		else:
			get_node(str(block)+"/AnimationPlayer").play("special")
	else:
		get_node(str(block)+"/AnimationPlayer").play("crash")






func new_pos(Block):
	#if a block isn't visible this script
	#set the block on the top with a new postion
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
	#Music Script
	$Music.set_stream(audiostream)
	$Music.play()


#Player positions
func _on_pos1_pressed():
	PlayerX = 100
func _on_pos2_pressed():
	PlayerX = 310
func _on_pos3_pressed():
	PlayerX = 520


func _on_Music_finished():
	music()

