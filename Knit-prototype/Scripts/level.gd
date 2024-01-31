extends Node2D

@onready var yarn = preload("res://Scenes/yarn.tscn")
var score = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	add_yarn()


func add_yarn():
	var instance = yarn.instantiate()
	# randmizer to pick yarn color
	# assign corrisponding colored yarn ball asset, maybe make a function for it
	
	# sets the yarn ball in a random position Vector2(rand_x,rand_y)
	instance.global_position = Vector2(randi_range(200,1100),randi_range(55,500))
	# in yarn, connect signal "yarn_used" to calling function spawn_yarn
	instance.yarn_used.connect(spawn_yarn)
	# adding a yarn node to level node
	add_child(instance)

func spawn_yarn():
	# currently, score is just adding 5 for every ball of yarn grabbed
	score += 5
	# adds new yarn ball onto play area
	add_yarn()
	# add a scarf body tile
	$scarf.add_body_tile()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$VBoxContainer/VBoxContainer/score_lable.text = "Rows: " + (str(score))

func end_game():
	# add end game code!!!
	get_tree().paused = true
	game_over() 

#enables the CanvasLayer node called GameOverLayer
func game_over():
	var game_over_image = get_node("GameOverLayer/GameOverScreen") 
	game_over_image.visible = true #sets the visibility of the layer to true
	
