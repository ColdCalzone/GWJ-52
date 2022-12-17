extends Control

const LEVEL_BUTTON = preload("res://objects/menu/LevelButton.tscn")
const UNHIGHLIGHTED = Color("bcbcbc")

onready var grid = $ScrollContainer/GridContainer

onready var level_title = $VBoxContainer/LevelName
onready var mirror_count = $VBoxContainer/Mirrors/Label
onready var mirrors = $VBoxContainer/Mirrors
onready var spotlight_count = $VBoxContainer/Spotlights/Label
onready var spotlights = $VBoxContainer/Spotlights

func _ready():
	for i in range(Levels.levels.size()):
		var button = LEVEL_BUTTON.instance()
		grid.add_child(button)
		if i == 0: button.set_tutorial()
		else: button.label.text = String(i)
		button.connect("pressed", self, "go_to_level", [i])
		button.connect("mouse_entered", self, "highlight_level", [i])
		button.connect("mouse_exited", self, "unhighlight_level")

func go_to_level(level : int):
	Levels.current_level = level
	TransitionManager.transition_to("res://scenes/Game.tscn")

func highlight_level(level : int):
	if Save.data["scores"].size() <= level: return
	var score = Save.data["scores"][level]
	if score == null: return
	for key in score.keys():
		match key:
			"spotlight":
				spotlight_count.text = score[key]
				spotlights.modulate = Color.white
			"mirror":
				mirror_count.text = score[key]
				mirrors.modulate = Color.white

func unhighlight_level():
	mirror_count.text = "--/--"
	spotlight_count.text = "--/--"
	mirrors.modulate = UNHIGHLIGHTED
	spotlights.modulate = UNHIGHLIGHTED

func _on_Back_pressed():
	TransitionManager.transition_to("res://scenes/Titlescreen.tscn")
