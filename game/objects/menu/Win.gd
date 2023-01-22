extends CanvasLayer

onready var nodes = {
	"mirror": $Center/VBoxContainer/HBoxContainer,
	"mirror_label": $Center/VBoxContainer/HBoxContainer/Label,
	"spotlight": $Center/VBoxContainer/HBoxContainer2,
	"spotlight_label": $Center/VBoxContainer/HBoxContainer2/Label
}

var amounts = {}

func _ready():
	for key in amounts.keys():
		nodes[key].visible = true
		nodes[key + "_label"].text = amounts[key]
	get_tree().paused = true

func _on_Button_pressed():
	get_tree().paused = false
	if Save.data["scores"].size() == Levels.levels.size() and !Save.data["viewed_thanks"]:
		TransitionManager.transition_to("res://scenes/Thanks.tscn")
	else:
		TransitionManager.transition_to("res://scenes/LevelSelect.tscn")


func _on_Button2_pressed():
	get_tree().paused = false
	queue_free()
