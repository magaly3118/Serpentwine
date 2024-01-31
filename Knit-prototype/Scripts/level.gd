extends Node2D

@onready var yarn = preload("res://Scenes/yarn.tscn")
var score = 0

# yarn textures
var dark_yarn = preload("res://TestingAssets/BallYarn_ColorReshadedPink_Tiny.png")
var light_yarn = preload("res://TestingAssets/BallYarn_Pink_Tiny.png")
var textures = [dark_yarn, light_yarn]

# texture id for body tiles
var next_body_texture_id: int

# Called when the node enters the scene tree for the first time.
func _ready():
	add_yarn()


func add_yarn():
	var instance = yarn.instantiate()
	
	# randomize yarn texture (color)
	var texture_id = randi_range(0, textures.size()-1)
	var new_texture = textures[texture_id]
	var yarn_sprite = instance.get_child(0)
	if yarn_sprite.texture != new_texture:
		yarn_sprite.texture = new_texture
	next_body_texture_id = texture_id # update id for future use 
	
	# sets the yarn ball in a random position 
	instance.global_position = Vector2(randi_range(-500,500),randi_range(-250,250))
	# in yarn, connect signal "yarn_used" to calling function spawn_yarn
	instance.yarn_used.connect(spawn_yarn)
	# adding a yarn node to level node
	add_child(instance)

func spawn_yarn():
	# currently, score is just adding 5 for every ball of yarn grabbed
	score += 5
	# add a scarf body tile
	$scarf.add_body_tile(next_body_texture_id)
	# adds new yarn ball onto play area
	add_yarn()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$VBoxContainer/score_lable.text = "Rows: " + (str(score))

func end_game():
	# add end game code!!!
	get_tree().paused = true
	
