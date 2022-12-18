extends Node

var data = {
	"viewed_tutorial" : false,
	"viewed_thanks" : false,
	"scores": [
	]
}

func set_score(level : int, score : Dictionary):
	if data["scores"].size() <= level:
		data["scores"].resize(level + 1)
	if data["scores"][level] == null:
		data["scores"][level] = score
	else:
		for key in data["scores"][level]:
			if !score.has(key): continue
			if score[key] < data["scores"][level][key]:
				data["scores"][level][key] = score[key]
	save_game()

func set_viewed_tutorial(value = true):
	data["viewed_tutorial"] = value
	save_game()

func set_viewed_thanks(value = true):
	data["viewed_thanks"] = value
	save_game()

func load_game():
	var file = File.new()
	if file.open("user://save.json", File.READ) == OK:
		data = JSON.parse(file.get_as_text()).result

func save_game():
	var file = File.new()
	if file.open("user://save.json", File.WRITE) == OK:
		file.store_string(JSON.print(data))
		file.close()
