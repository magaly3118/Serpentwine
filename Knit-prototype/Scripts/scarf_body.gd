extends Area2D
var move_trail=[] # List of head movement for body tiles to follow
var direction
var time = 0.2
var time_to_move = 0.015
@export var move_distance : float = 6
enum{nan, UP, DOWN, LEFT, RIGHT}
var previous_piece


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Timer for movement
	time -= delta
	if (time < 0):
		direction = move_trail.pop_front() # removes first item from list and returns it
		if(direction): # should keep game from crashing, tile will just stop moving
			move_scarf()
		time = time_to_move
	
# moves scarf body tile
func move_scarf():
	if(direction == UP):
		global_translate(Vector2(0,-1) * move_distance)
	elif(direction == DOWN):
		global_translate(Vector2(0,1) * move_distance)
	elif(direction == LEFT):
		global_translate(Vector2(-1,0) * move_distance)
	elif(direction == RIGHT):
		global_translate(Vector2(1,0) * move_distance)
	look_at(previous_piece.global_position)

# adding movement of the head to the movement trail list
func add_to_trail(dir):
	move_trail.append(dir)

func _on_area_entered(area):
	if(area.name == "head"):
	 #calling end_game func in level
		var main = get_tree().get_first_node_in_group("main")
		main.end_game()
