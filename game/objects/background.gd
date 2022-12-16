extends Node2D

const LIGHT = preload("res://sprites/chibighost_light.tres")
const DARK = preload("res://sprites/chibighost_dark.tres")

var time : float = 0.0

export var size : Vector2 = Vector2(40, 23)

export var distance_factor : Vector2 =  Vector2.ONE

export var speed : float = 5.0

func _process(delta):
	time += delta
	if time * speed >= 27 * distance_factor.y: time = 0
	update()

func _draw():
	for y in range(size.y):
		for x in range(0, size.x, 2):
			draw_texture(LIGHT, Vector2(x * 27 * distance_factor.x, (y * 27 * distance_factor.y - time * speed)))
			draw_texture(DARK, Vector2((x + 1) * 27 * distance_factor.x, (y * 27 * distance_factor.y + time * speed)))
