extends Node2D

@onready var yarn = preload("res://Scenes/yarn.tscn")
var score = 0

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

# Called when the node enters the scene tree for the first time.
func _ready():
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
	# play sound effect of collecting yarn
	$collect_sound.play(0)
	# currently, score is just adding 5 for every ball of yarn grabbed
	score += 5
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
	$VBoxContainer/VBoxContainer/score_lable.text = "Length: " + (str(score))

func end_game():
	$scarf.can_move = false
	# add end game code!!!
	#get_tree().paused = true
	# pops up the end game screen, need to resize the image with finalized asset
	#$game_over/game_over_screen.show()

	
