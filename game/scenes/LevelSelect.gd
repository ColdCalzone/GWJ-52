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
	for i in range(1 if Save.data["viewed_tutorial"] else 0, Levels.levels.size() if Save.data["viewed_tutorial"] else 1):
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
	level_title.text = String(level) + ") " + Levels.levels[level]["name"]
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
	level_title.text = ""
	mirrors.modulate = UNHIGHLIGHTED
	spotlights.modulate = UNHIGHLIGHTED

func _on_Back_pressed():
	TransitionManager.transition_to("res://scenes/Titlescreen.tscn")
