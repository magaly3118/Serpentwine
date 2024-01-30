extends Control

@onready var OptionsScene: ColorRect = find_child("OptionsMenu")
@onready var menu: VBoxContainer = get_node("Menu")
@onready var optionsbutton: Button = get_node("VBoxContainer/Options")
@onready var returnbutton: Button = get_node("OptionsMenu/CenterContainer/PanelContainer/MarginContainer/VBoxContainer/Button")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_start_pressed():
	get_tree().change_scene_to_file("res://scenes/level0.tscn")


func _on_quit_pressed():
	get_tree().quit()


func _on_options_pressed():
	OptionsScene.visible = true
	menu.visible = false

func _input(event):
	if OptionsScene.visible == true:
		if returnbutton.button_pressed:
			OptionsScene.visible = false
			menu.visible = true
