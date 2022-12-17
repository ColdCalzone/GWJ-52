extends Node

var current_level = 0

var levels = []

func _ready():
	var dir : Directory = Directory.new()
	if dir.open("res://levels/") == OK:
		dir.list_dir_begin(true, true)
		var file_name = dir.get_next()
		while file_name != "":
			if !dir.current_is_dir():
				var file : File = File.new()
				if file.open("res://levels/" + file_name, File.READ) == OK:
					var index = int(file_name.split("level")[1])
					if index >= levels.size():
						levels.resize(index + 1)
					levels[int(file_name.split("level")[1])] = JSON.parse(file.get_as_text()).result
			file_name = dir.get_next()
		dir.list_dir_end()

