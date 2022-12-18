extends AudioStreamPlayer

onready var music = {
	"titlescreen": preload("res://music/Refractoplasm.ogg"),
	"paused" : preload("res://music/Relaxoplasm.ogg")
}

func play_music(key : String):
	if !music.has(key): return
	if stream == music[key]: return
	stream = music[key]
	play()

func change_music(key : String):
	if !music.has(key): return
	if stream == music[key]: return
	stream = music[key]
