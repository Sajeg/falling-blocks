extends Control

const pos1 = 100
const pos2 = 310
const pos3 = 520

export var speed = 6
export var multiplicator = 0.01

var score = 0

var freeze = false
var playername = null
var vibrate
var gameover = false
var lastblock_num = 0
var is_touching = false
var still_touching = false

var PlayerX = 310
var blocks = ["Blocks/Blue", "Blocks/Blue2", "Blocks/Blue3", "Blocks/Green", "Blocks/Green2", "Blocks/Green3", "Blocks/Pink", "Blocks/Pink2", "Blocks/Pink3"]
var blocks_animation = ["Blocks/Blue/AnimationPlayer", "Blocks/Blue2/AnimationPlayer", "Blocks/Blue3/AnimationPlayer", "Blocks/Green/AnimationPlayer", "Blocks/Green2/AnimationPlayer", "Blocks/Green3/AnimationPlayer", "Blocks/Pink/AnimationPlayer", "Blocks/Pink2/AnimationPlayer", "Blocks/Pink3/AnimationPlayer"]

func _ready():
	$Blocks/Blue/BlockBlue.modulate = Color8(G.block0[0], G.block0[1], G.block0[2])
	$Blocks/Blue2/BlockBlue.modulate = Color8(G.block0[0], G.block0[1], G.block0[2])
	$Blocks/Blue3/BlockBlue.modulate = Color8(G.block0[0], G.block0[1], G.block0[2])
	$Blocks/Green/BlockGreen.modulate = Color8(G.block1[0], G.block1[1], G.block1[2])
	$Blocks/Green2/BlockGreen.modulate = Color8(G.block1[0], G.block1[1], G.block1[2])
	$Blocks/Green3/BlockGreen.modulate = Color8(G.block1[0], G.block1[1], G.block1[2])
	$Blocks/Pink/BlockPink.modulate = Color8(G.block2[0], G.block2[1], G.block2[2])
	$Blocks/Pink2/BlockPink.modulate = Color8(G.block2[0], G.block2[1], G.block2[2])
	$Blocks/Pink3/BlockPink.modulate = Color8(G.block2[0], G.block2[1], G.block2[2])
	$Player/BlockBlue.modulate = Color8(G.block0[0], G.block0[1], G.block0[2])
	$Player/BlockGreen.modulate = Color8(G.block1[0], G.block1[1], G.block1[2])
	$Player/BlockPink.modulate = Color8(G.block2[0], G.block2[1], G.block2[2])
	
	if G.dark_mode:
		$UI/Score.add_color_override("font_color", Color(1,1,1))
		
		
		$UI/Pause/pause.set_texture(preload("res://Assets/pause_light.png"))
		$UI/Play/play2.set_texture(preload("res://Assets/play1_light.png"))
		
	else:
		$UI/Score.add_color_override("font_color", Color(0,0,0))
		
		$UI/Pause/pause.set_texture(preload("res://Assets/pause.png"))
		$UI/Play/play2.set_texture(preload("res://Assets/play1.png"))
	if G.system == "Windows" or "X11":
		speed = 3
		multiplicator = 0.005
	if G.system == "Android":
		speed = 6
	
	freeze = false
	if G.audio == true:
		$Sound/Music.play()
	
	for BlockNum in blocks.size():
		blocks[BlockNum] = get_node(blocks[BlockNum])
		blocks_animation[BlockNum] = get_node(blocks_animation[BlockNum])
	
	#Player Color:
	var rand = randi()%3
	if rand == 0:
		$Player/BlockBlue.visible = true
		playername = "Blue"
	if rand == 1:
		$Player/BlockGreen.visible = true
		playername = "Green"
	if rand == 2:
		$Player/BlockPink.visible = true
		playername = "Pink"

func _process(delta):
	$Player.position.x = PlayerX
	if freeze == true:
		return
	#Controls for the Desktop version
	
	if Input.is_action_just_pressed("left"):
		PlayerX = pos1
	if Input.is_action_just_pressed("middle"):
		PlayerX = pos2
	if Input.is_action_just_pressed("right"):
		PlayerX = pos3
	
	G.score = score
	
	#Displays the Score
	$UI/Score.text = str(score)
	
	
	for BlockNum in blocks.size():
		animation(blocks[BlockNum], BlockNum)
		
		#The Script for falling
		blocks[BlockNum].position.y += speed
		
		#Detects the postions from the blocks
		if blocks[BlockNum].position.y > 1800:
			new_pos(blocks[BlockNum])
	
	
	
	if is_touching:
		if bool(G.vibration) == true:
			Input.vibrate_handheld(5)
		score += 1
		speed += multiplicator

func _on_Area2D_area_entered(area: Area2D):
	if playername == area.name:
		score += 1
		speed += multiplicator
		if bool(G.vibration) == true:
			Input.vibrate_handheld(5)
		is_touching = true
		for child in area.get_parent().get_children():
			if child is AnimationPlayer:
				child.play("crash")
	else:
		if gameover:
			return
		still_touching = true
		freeze = true
		yield(get_tree().create_timer(0.1), "timeout")
		if not still_touching:
			freeze = false
			return
		if bool(G.vibration) == true:
			Input.vibrate_handheld(60)
		gameover()

func _on_Area2D_area_exited(area: Area2D):
	is_touching = false
	still_touching = false

func animation(block: KinematicBody2D, num):
	#animation script
	for child in block.get_children():
		if child is AnimationPlayer:
			if G.mode_dead == false:
				if child.current_animation != "crash":
					child.play("idle")
			else:
				child.play("special")


func gameover(): #Changes the Game screen to Gameover Screen
	if gameover:
		return
	gameover = true
	freeze = true
	$UI/Pause.visible = false
	$UI/Play.visible = false
	$Sound/Music.stop()
	$UI/Score.visible = false
	
	if G.mode_dead == true:
		for BlockNum in blocks_animation.size():
			blocks_animation[BlockNum].play("idle")
	
	
	#Block animation
	for BlockNum in blocks.size():
		if G.sounds == true:
			$Sound/SoundFX.play()
		for i in 25:
			if blocks[BlockNum].position.y > 0:
				blocks[BlockNum].scale.x += -0.01
				blocks[BlockNum].scale.y += -0.01
			yield(get_tree().create_timer(0.01), "timeout")
		blocks[BlockNum].visible = false
	#Player animation
	PlayerX = 310
	for i in 60:
		yield(get_tree().create_timer(0.001), "timeout")
		$Player.position.y += 1
	$Player.visible = false
	$Control.visible = true
	$Control.end()



func new_pos(Block):
	#if a block isn't visible this script
	#set the block on the top with a new postion
	var block_positions = [
		$Blocks/Blue.position.y, 
		$Blocks/Blue2.position.y, 
		$Blocks/Blue3.position.y,
		$Blocks/Green.position.y,
		$Blocks/Green2.position.y,
		$Blocks/Green3.position.y,
		$Blocks/Pink.position.y,
		$Blocks/Pink2.position.y,
		$Blocks/Pink3.position.y]
	
	var min_position = 0
	for i in range(1, block_positions.size()):
		if block_positions[i] < min_position:
			min_position = i
	
	if min_position - 200 > -100:
		Block.position.y = min_position - 200
	else:
		Block.position.y = -100
	
	var randpos = randi()%3
	if randpos == 0:
		Block.position.x = pos1
		lastblock_num = 0
	if randpos == 1:
		Block.position.x = pos2
		lastblock_num = 1
	if randpos == 2:
		Block.position.x = pos3
		lastblock_num = 2
	Block.visible = true
	
	for child in Block.get_children():
		if child is AnimationPlayer:
			child.play("idle")



#Player positions
func _on_pos1_pressed():
	PlayerX = 100
func _on_pos2_pressed():
	PlayerX = 310
func _on_pos3_pressed():
	PlayerX = 520


func _on_pause2_pressed():
	$pos1.visible = false
	$pos2.visible = false
	$pos3.visible = false
	freeze = true
	$Sound/Music.set_stream_paused(true)
	$UI/Play.visible = true
	$UI/Pause.visible = false
	$UI/Score.visible = false


func _on_play_pressed():
	$pos1.visible = true
	$pos2.visible = true
	$pos3.visible = true
	freeze = false
	$Sound/Music.set_stream_paused(false)
	$UI/Play.visible = false
	$UI/Pause.visible = true
	$UI/Score.visible = true





