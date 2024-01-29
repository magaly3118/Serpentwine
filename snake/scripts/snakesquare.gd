class_name Snakesquare

var curr_position := Vector2()
var size := Vector2()
var color := Color()

func get_rect() -> Rect2:
	return Rect2(curr_position, size)
