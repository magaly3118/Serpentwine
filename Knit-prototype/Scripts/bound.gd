extends Area2D
# This script is for the bound collision shapes in the level node
# Acts as the wall that the snake dies if it hits

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_area_entered(area):
	# if head of scarf entires any of the bound collision shapes
	if(area.name == "head"):
		print("collision into wall bounds") # prints into console
	 #calling end_game func in level
		var main = get_tree().get_first_node_in_group("main")
		main.end_game()
