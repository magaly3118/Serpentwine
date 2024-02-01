extends Node2D

# scarf movement variables
var can_move = true
var time = 0
var time_to_move = 0.015
@export var move_distance : float = 6

# scarf head sprite changing variables
var sprite_timer = 0
var sprite_swap_time = 0.4

# scarf tile direction variables
var direction = UP
enum{nan, UP, DOWN, LEFT, RIGHT}

# scarf body tiles tracking variables
var body_tiles_list = [] # list of scarf body tiles, see func add_body_tiles()

@onready var scarf_body = preload("res://Scenes/scarf_body.tscn")

# body tile textures
var blue_yarn = preload("res://Assets/ScarfBodyTiles/KnittingSquare_Blue_Tiny.png")
var pink_yarn = preload("res://Assets/ScarfBodyTiles/KnittingSquare_Pink_Tiny.png")
var purp_yarn = preload("res://Assets/ScarfBodyTiles/KnittingSquare_Purple_Tiny.png")
var textures = [blue_yarn, pink_yarn, purp_yarn]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(can_move):
		user_inputs()
		# Timer for movement
		time -= delta
		sprite_timer -= delta
		# timer for scarf movement
		if (time < 0): 
			move_scarf()
			time = time_to_move
		
		# timer for head sprite changes, pseudo animation
		if(sprite_timer < 0):
			change_head_sprite()
			sprite_timer = sprite_swap_time
	else:
		var body_tiles = get_tree().get_nodes_in_group("body") # get all body tiles as a list
		for tile in body_tiles: # for each scarf_body node in the list
			tile.can_move = false

# moves head of scarf based off user input
func move_scarf():
	if(direction == UP):
		global_translate(Vector2(0,-1) * move_distance)
	elif(direction == DOWN):
		global_translate(Vector2(0,1) * move_distance)
	elif(direction == LEFT):
		global_translate(Vector2(-1,0) * move_distance)
	elif(direction == RIGHT):
		global_translate(Vector2(1,0) * move_distance)
	
	# Move body along aswell
	# all body tiles are grouped together in a group called "body"
	# utilizing grouping in godot can be helpful
	var body_tiles = get_tree().get_nodes_in_group("body") # get all body tiles as a list
	for tile in body_tiles: # for each scarf_body node in the list
		tile.add_to_trail(direction) # adds heads movement to each tiles trail list

# Taking in user input for movement control
func user_inputs():
	if(Input.is_action_just_pressed("ui_up") and direction != DOWN):
		direction = UP
		set_rotation(0)
	elif(Input.is_action_just_pressed("ui_down") and direction != UP):
		direction = DOWN
		set_rotation(PI)
	elif(Input.is_action_just_pressed("ui_left") and direction != RIGHT):
		direction = LEFT
		set_rotation((3*PI)/2)
	elif(Input.is_action_just_pressed("ui_right") and direction != LEFT):
		direction = RIGHT
		set_rotation(PI/2)

func add_body_tile(texture_id: int):
	var body_tiles = get_tree().get_nodes_in_group("body") # get all body tiles as a list
	for tile in body_tiles: # for each scarf_body node in the list
		tile.time += 0.2 # makes rest of body tiles wait

	var first_tile = body_tiles_list.back() # gets current first_tile, returns null if empty
	var instance = scarf_body.instantiate() # create scarf_body node
	
	# COLOR
	# apply corrext texture to body tile based on color of yarn grabbed
	var sprite = instance.get_child(0)
	var texture = textures[texture_id]
	sprite.texture = texture
		
	# NEWVMENT
	if(first_tile):# if there are body tiles in the list
		get_owner().add_child(instance) # add this scarf_body as child to owner node
		instance.global_position = global_position # get position from head
		body_tiles_list.append(instance) # add to my body tile list, note list is opposite of neck to tail order
		first_tile.collisionsEnabled = true # enable collision of previous first tile
		first_tile.prev_tile = instance
		instance.prev_tile = self
		first_tile = instance
	else: # first body tile being added to head, there are not any body tiles in the list yet
		get_owner().add_child(instance) # add this scarf_body as child to owner node
		instance.global_position = global_position # get position from head
		body_tiles_list.append(instance) # add to my body tile list, note list is opposite of neck to tail order
		instance.prev_tile = self # prev_tile is head
		first_tile = instance
		
func change_head_sprite():
	# reverse sprite visibility
	# originally, one sprite is set to visible and one is set to not visible
	$head/needles_sprite_01.visible = not $head/needles_sprite_01.visible 
	$head/needles_sprite_02.visible = not $head/needles_sprite_02.visible
	$head/knit_sound.play(0)
