extends Control

onready var popup = $CenterContainer/ConfirmationDialog

func _on_Button_pressed():
	TransitionManager.transition_to("res://scenes/Titlescreen.tscn")


func _on_Delete_pressed():
	popup.popup()


func _on_ConfirmationDialog_confirmed():
	Save.data = {
		"viewed_tutorial" : false,
		"viewed_thanks" : false,
		"scores": [
		]
	}
	Save.save_game()
	TransitionManager.transition_to("res://scenes/Titlescreen.tscn")
