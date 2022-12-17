extends Control

func _ready():
	update_options()

func update_options():
	$SFX/SFX.value = Settings.sfx_volume
	$Music/Music.value = Settings.mus_volume
	$Fullscreen/Fullscreen.pressed = OS.window_fullscreen

func _on_Button_toggled(button_pressed):
	Settings.fullscreen = button_pressed

func _on_Music_value_changed(value):
	Settings.mus_volume = value

func _on_SFX_value_changed(value):
	Settings.sfx_volume = value
