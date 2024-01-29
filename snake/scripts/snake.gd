extends Node2D


var head := Scarfsquare.new()
var scarfsquares := [] as Array[Scarfsquare]

var curr_direction := Vector2.RIGHT #starts snake moving right
var next_direction := Vector2.RIGHT

var tween_move: Tween #used to make snake slower
# Called when the node enters the scene tree for the first time.
func _ready():
	head.size = Game.CELL_SIZE #makes the head fill the cell size
	head.color = Colors.BLUE_DARK #sets head color
	scarfsquares.push_front(head) #pushes head to front of array
	
	tween_move = create_tween().set_loops()
	tween_move.tween_callback(move).set_delay(.075)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	queue_redraw()
	
	

func _draw():
	
	for scarfsquare in scarfsquares:
		draw_rect(scarfsquare.get_rect(), scarfsquare.color)

func _input(event):
	#the if statements ensure that the snake can't switch to the opposite direction
	#responds to user keys for movement
	if event.is_action_pressed("move_left") and curr_direction != Vector2.RIGHT:
		next_direction = Vector2.LEFT
	if event.is_action_pressed("move_right") and curr_direction != Vector2.LEFT:
		next_direction = Vector2.RIGHT
	if event.is_action_pressed("move_up") and curr_direction != Vector2.DOWN:
		next_direction = Vector2.UP
	if event.is_action_pressed("move_down") and curr_direction != Vector2.UP:
		next_direction = Vector2.DOWN
		
		if event.is_action_pressed("grow"): grow()
		
func move() -> void:
	curr_direction = next_direction
	var next_position = head.curr_position + (curr_direction * Game.CELL_SIZE) #calculates the next position the snake will move to
	next_position.x = Utils.repeat(next_position.x, Game.GRID_SIZE.x)
	next_position.y = Utils.repeat(next_position.y, Game.GRID_SIZE.y)
	head.curr_position = next_position #moves head

func grow() -> void:
	var scarfsquare := Scarfsquare.new()
	var last_scarfsquare := scarfsquares.back() as Scarfsquare
	
	scarfsquare.curr_position = last_scarfsquare.curr_position
	scarfsquare.color = Colors.BLUE
	scarfsquare.size = Game.CELL_SIZE
	scarfsquare.push_back(scarfsquare)
