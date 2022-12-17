tool
extends AnimatedSprite
class_name Ghost

var grid_position : Vector2 = -Vector2.ONE

export var hit_by_beam : bool = false setget set_hit_by_beam

func set_hit_by_beam(is_hit : bool):
	hit_by_beam = is_hit
	var curr_frame = frame
	if !hit_by_beam:
		animation = "visible"
	else:
		animation = "heart"
	frame = curr_frame
