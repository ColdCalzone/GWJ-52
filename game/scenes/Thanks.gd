extends Control

func _ready():
	Save.set_viewed_thanks()

func _on_Button_pressed():
	TransitionManager.transition_to("res://scenes/Titlescreen.tscn")
