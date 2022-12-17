extends Control

const LEVEL_BUTTON = preload("res://objects/menu/LevelButton.tscn")

onready var grid = $ScrollContainer/GridContainer

func _ready():
	for i in range(Levels.levels.size()):
		var button = LEVEL_BUTTON.instance()
		grid.add_child(button)
		if i == 0: button.set_tutorial()
		else: button.label.text = String(i)
		button.connect("pressed", self, "go_to_level", [i])

func go_to_level(level : int):
	Levels.current_level = level
	TransitionManager.transition_to("res://scenes/Game.tscn")


func _on_Back_pressed():
	TransitionManager.transition_to("res://scenes/Titlescreen.tscn")
