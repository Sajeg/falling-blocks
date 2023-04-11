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
var music_changed = false
var is_touching = false
var still_touching = false

var PlayerX = 310
var blocks = ["Blocks/Blue", "Blocks/Blue2", "Blocks/Blue3", "Blocks/Green", "Blocks/Green2", "Blocks/Green3", "Blocks/Pink", "Blocks/Pink2", "Blocks/Pink3"]

func _ready():
	if G.dark_mode:
		$UI/Score.add_color_override("font_color", Color(1,1,1))
		
		$Player/BlockBlue.modulate = Color("3F7CB4")
		$Player/BlockGreen.modulate = Color("81C24E")
		$Player/BlockPink.modulate = Color("A842B7")
		$UI/Pause/pause.set_texture(preload("res://Assets/pause_light.png"))
		$UI/Play/play2.set_texture(preload("res://Assets/play1_light.png"))
		$Blocks/Blue/BlockBlue.modulate = Color("3F7CB4")
		$Blocks/Blue2/BlockBlue.modulate = Color("3F7CB4")
		$Blocks/Blue3/BlockBlue.modulate = Color("3F7CB4")
		$Blocks/Green/BlockGreen.modulate = Color("81C24E")
		$Blocks/Green2/BlockGreen.modulate = Color("81C24E")
		$Blocks/Green3/BlockGreen.modulate = Color("81C24E")
		$Blocks/Pink/BlockPink.modulate = Color("A842B7")
		$Blocks/Pink2/BlockPink.modulate = Color("A842B7")
		$Blocks/Pink3/BlockPink.modulate = Color("A842B7")
	else:
		$UI/Score.add_color_override("font_color", Color(0,0,0))
		
		$Player/BlockBlue.modulate = Color("82B7E8")
		$Player/BlockGreen.modulate = Color("AEE881")
		$Player/BlockPink.modulate = Color("DB81E8")
		$UI/Pause/pause.set_texture(preload("res://Assets/pause.png"))
		$UI/Play/play2.set_texture(preload("res://Assets/play1.png"))
		$Blocks/Blue/BlockBlue.modulate = Color("82B7E8")
		$Blocks/Blue2/BlockBlue.modulate = Color("82B7E8")
		$Blocks/Blue3/BlockBlue.modulate = Color("82B7E8")
		$Blocks/Green/BlockGreen.modulate = Color("AEE881")
		$Blocks/Green2/BlockGreen.modulate = Color("AEE881")
		$Blocks/Green3/BlockGreen.modulate = Color("AEE881")
		$Blocks/Pink/BlockPink.modulate = Color("DB81E8")
		$Blocks/Pink2/BlockPink.modulate = Color("DB81E8")
		$Blocks/Pink3/BlockPink.modulate = Color("DB81E8")
	if G.system == "Windows" or "X11":
		speed = 3
		multiplicator = 0.005
	if G.system == "Android":
		speed = 6
	
	freeze = false
	if bool(G.audio) == true:
		$Sound/MusicUnder1000.volume_db = 0
		$Sound/MusicUnder1000.play()
	
	for BlockNum in blocks.size():
		blocks[BlockNum] = get_node(blocks[BlockNum])
	
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
	
	
	if score >= 1000 and music_changed == false and bool(G.audio) == true:
		music_change()
	
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
				if G.dark_mode:
					child.play("crash_dark")
				else:
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
			if G.dark_mode:
				if G.mode_dead == false:
					if child.current_animation != "crash_dark":
						child.play("idle_dark")
				else:
					child.play("special_dark")
			else:
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
	$Sound/MusicUnder1000.stop()
	$Sound/MusicOver1000.stop()
	$UI/Score.visible = false
	
	if G.mode_dead == true:
		for BlockNum in blocks.size():
			blocks[BlockNum].play("idle")
	
	
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
	Block.position.y = -100
	var randpos = randi()%3
	if randpos == 0:
		if lastblock_num == 0:
			Block 
		else:
			Block.position.x = pos1
			lastblock_num = 0
	if randpos == 1:
		if lastblock_num == 1:
			new_pos(Block)
		else:
			Block.position.x = pos2
			lastblock_num = 1
	if randpos == 2:
		if lastblock_num == 2:
			new_pos(Block)
		else:
			Block.position.x = pos3
			lastblock_num = 2
	Block.visible = true
	
	for child in Block.get_children():
		if child is AnimationPlayer:
			if G.dark_mode:
				child.play("idle_dark")
			else:
				child.play("idle")



#Player positions
func _on_pos1_pressed():
	PlayerX = 100
func _on_pos2_pressed():
	PlayerX = 310
func _on_pos3_pressed():
	PlayerX = 520


func music_change():
	$Sound/MusicFade.play("MusicFade1000")
	music_changed = true


func _on_pause2_pressed():
	$pos1.visible = false
	$pos2.visible = false
	$pos3.visible = false
	freeze = true
	$Sound/MusicUnder1000.set_stream_paused(true)
	$Sound/MusicOver1000.set_stream_paused(true)
	$UI/Play.visible = true
	$UI/Pause.visible = false
	$UI/Score.visible = false


func _on_play_pressed():
	$pos1.visible = true
	$pos2.visible = true
	$pos3.visible = true
	freeze = false
	if score > 1000:
		$Sound/MusicOver1000.set_stream_paused(false)
	else:
		$Sound/MusicUnder1000.set_stream_paused(false)
	$UI/Play.visible = false
	$UI/Pause.visible = true
	$UI/Score.visible = true





