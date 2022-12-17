extends Control


func _on_Play_pressed():
	TransitionManager.transition_to("res://scenes/LevelSelect.tscn")

func _on_Options_pressed():
	TransitionManager.transition_to("res://scenes/OptionScreen.tscn")

func _on_Quit_pressed():
	TransitionManager.transition_to("quit")
