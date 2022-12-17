extends TextureButton

onready var label = $Label

func set_tutorial():
	texture_normal = load("res://sprites/tutorial_ghost.png")
	rect_min_size.x = 144
