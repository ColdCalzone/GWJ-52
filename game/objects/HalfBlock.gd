extends Sprite
class_name HalfBlock

var grid_position : Vector2 = -Vector2.ONE

var light = 0

func set_light(direction : int):
	light |= direction + 1
	if direction < 0:
		light = 0
	region_rect.position.x = 32 * (light)
