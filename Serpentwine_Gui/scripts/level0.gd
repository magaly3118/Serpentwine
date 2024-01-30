extends Node2D
@onready var OptionsScene: ColorRect = find_child("OptionsMenu")
@onready var PauseScene: ColorRect = find_child("PauseMenu")
@onready var optionsbutton: Button = get_node("PauseMenu/CenterContainer/PanelContainer/MarginContainer/VBoxContainer/Options")
@onready var returnbutton: Button = get_node("OptionsMenu/CenterContainer/PanelContainer/MarginContainer/VBoxContainer/Button")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		if PauseScene.visible == true:
			PauseScene.visible = false
		else:
			PauseScene.visible = true
			
func _input(event):
	if PauseScene.visible == true:
		if optionsbutton.button_pressed:
			PauseScene.visible = false
			OptionsScene.visible = true
	if OptionsScene.visible == true:
		if returnbutton.button_pressed:
			OptionsScene.visible = false
			PauseScene.visible = true
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
