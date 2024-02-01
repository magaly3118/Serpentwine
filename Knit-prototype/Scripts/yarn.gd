extends Area2D
signal yarn_used

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_yarn_grabbed(area):
	if(area.name == "head"):
		yarn_used.emit()
		queue_free()
