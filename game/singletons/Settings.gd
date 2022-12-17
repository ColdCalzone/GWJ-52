extends Node

var fullscreen = false setget set_fullscreen
var sfx_volume = 1.0 setget set_sfx_volume
var mus_volume = 1.0 setget set_mus_volume

func set_fullscreen(value : bool):
	fullscreen = value
	OS.window_fullscreen = fullscreen

func set_sfx_volume(num : float):
	sfx_volume = num
	AudioServer.set_bus_volume_db(1, linear2db(sfx_volume))

func set_mus_volume(num : float):
	mus_volume = num
	AudioServer.set_bus_volume_db(1, linear2db(mus_volume))
