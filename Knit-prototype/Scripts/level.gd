extends Node2D
@onready var OptionsScene: ColorRect = find_child("OptionsMenu")
@onready var PauseScene: ColorRect = find_child("PauseMenu")
@onready var optionsbutton: Button = get_node("PauseMenu/CenterContainer/PanelContainer/MarginContainer/VBoxContainer/Options")
@onready var returnbutton: Button = get_node("OptionsMenu/CenterContainer/PanelContainer/MarginContainer/VBoxContainer/Button")
@onready var yarn = preload("res://Scenes/yarn.tscn")

@onready var timer = get_node("YarnTimer")
@onready var every_ten = get_node("Every10")
@onready var pb = get_node("YarnProgress")

var score = 0
var time = 0
var time_to_move = 5

# yarn textures
var blue_yarn = preload("res://Assets/YarnBalls/BallYarn_ColorReshadedBlue_Tiny.png")
var pink_yarn = preload("res://Assets/YarnBalls/BallYarn_ColorReshadedPink_Tiny.png")
var purp_yarn = preload("res://Assets/YarnBalls/BallYarn_ColorReshadedPurple_Tiny.png")
var textures = [blue_yarn, pink_yarn, purp_yarn]

# texture id for body tiles
var next_texture_id: int

# needle textures
var blue_needle_1 = preload("res://Assets/KnittingNeedles/AnimatedNeedle01_Blue_Tiny.png")
var pink_needle_1 = preload("res://Assets/KnittingNeedles/AnimatedNeedle01_Pink_Tiny.png")
var purp_needle_1 = preload("res://Assets/KnittingNeedles/AnimatedNeedle01_Purple_Tiny.png")
var needles_textures_1 = [blue_needle_1, pink_needle_1, purp_needle_1]

var blue_needle_2 = preload("res://Assets/KnittingNeedles/AnimatedNeedle02_Blue_Tiny.png")
var pink_needle_2 = preload("res://Assets/KnittingNeedles/AnimatedNeedle02_Pink_Tiny.png")
var purp_needle_2 = preload("res://Assets/KnittingNeedles/AnimatedNeedle02_Purple_Tiny.png")
var needles_textures_2 = [blue_needle_2, pink_needle_2, purp_needle_2]

var start_time = 4
var total_time = start_time
# Called when the node enters the scene tree for the first time.
func _ready():
	timer.wait_time = start_time
	every_ten.wait_time = 10
	pb.value = 100
	add_yarn()
	_update_needle_sprites(next_texture_id) # mathc needles to the first spawned yarn

	
func add_yarn():
	var instance = yarn.instantiate()
	
	# randomize yarn texture (color)
	var texture_id = randi_range(0, textures.size()-1)
	var new_texture = textures[texture_id]
	var yarn_sprite = instance.get_child(0)
	if yarn_sprite.texture != new_texture:
		yarn_sprite.texture = new_texture
	next_texture_id = texture_id # update id for future use 
	
	# sets the yarn ball in a random position 
	instance.global_position = Vector2(randi_range(220,1080),randi_range(100,500))
	# in yarn, connect signal "yarn_used" to calling function spawn_yarn
	instance.yarn_used.connect(spawn_yarn)
	# adding a yarn node to level node
	add_child(instance)

func spawn_yarn():
	timer.stop
	timer.wait_time = 4
	pb.value =100
	timer.start
	# play sound effect of collecting yarn
	$collect_sound.play(0)
	# currently, score is just adding 5 for every ball of yarn grabbed
	score += 100
	# add a scarf body tile
	$scarf.add_body_tile(next_texture_id)
	# change needles color to match new body tile
	_update_needle_sprites(next_texture_id)
	# adds new yarn ball onto play area
	add_yarn()

	
	

func _update_needle_sprites(texture_id):
	$scarf/head/needles_sprite_01.texture = needles_textures_1[texture_id]
	$scarf/head/needles_sprite_02.texture = needles_textures_2[texture_id]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Control/score_lable.text = "Score: " + (str(score))
	time -= delta
	# timer for adding score for being alive
	if (time < 0): 
		score += 10
		time = time_to_move
	
	if every_ten.wait_time <= 0:
		start_time = start_time - 0.2
		total_time = start_time
		
	pb.value = round((timer.time_left/total_time)*100)
	
		
	if pb.value == 0:
		#end_game(0)
		pass

func end_game(sec):
	$scarf.can_move = false # stop scarf movement
	await get_tree().create_timer(sec).timeout # wait for sounds to play
	
	# delete scarf and body nodes
	$scarf.queue_free()
	var body_tiles = get_tree().get_nodes_in_group("body") # get all body tiles as a list
	for tile in body_tiles: # for each scarf_body node in the list
		tile.can_move = not tile.can_move # toggle can_move
	
	# pops up the end game screen, need to resize the image with finalized asset
	get_tree().change_scene_to_file("res://Scenes/game_over.tscn")

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		if OptionsScene.visible == false:
			if PauseScene.visible == true:
				PauseScene.visible = false
				$scarf/head/knit_sound.play(1)
			else:
				PauseScene.visible = true
				$scarf/head/knit_sound.stop()
			$scarf.toggle_can_move()
			
func _input(event):
	if PauseScene.visible == true:
		if optionsbutton.button_pressed:
			PauseScene.visible = false
			OptionsScene.visible = true
	if OptionsScene.visible == true:
		if returnbutton.button_pressed:
			OptionsScene.visible = false
			PauseScene.visible = true
