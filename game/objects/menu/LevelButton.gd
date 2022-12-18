extends TextureButton

onready var label = $Label

func set_tutorial():
	texture_normal = load("res://sprites/tutorial_ghost.png")
	texture_focused = null
	texture_pressed = null
	texture_hover = null
	rect_min_size.x = 144
