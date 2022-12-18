extends Node

var sfx_volume = 1.0 setget set_sfx_volume
var mus_volume = 1.0 setget set_mus_volume

var config_file : ConfigFile = ConfigFile.new()

func set_fullscreen(value : bool):
	OS.window_fullscreen = value
	config_file.set_value("visual", "FullScreen", value)
	save_settings()

func set_sfx_volume(num : float):
	sfx_volume = num
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear2db(sfx_volume))
	config_file.set_value("audio", "SFX", sfx_volume)
	save_settings()

func set_mus_volume(num : float):
	mus_volume = num
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear2db(mus_volume))
	config_file.set_value("audio", "Music", mus_volume)
	save_settings()

func load_settings():
	config_file.load("user://settings.cfg")
	OS.window_fullscreen = config_file.get_value("visual", "FullScreen", false)
	
	sfx_volume = config_file.get_value("audio", "SFX", 1.0)
	mus_volume = config_file.get_value("audio", "Music", 1.0)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear2db(sfx_volume))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear2db(mus_volume))

func save_settings():
	config_file.save("user://settings.cfg")
