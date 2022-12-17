tool
extends AnimatedSprite
class_name Ghost

var grid_position : Vector2 = -Vector2.ONE

export var hit_by_beam : bool = false setget set_hit_by_beam

func set_hit_by_beam(is_hit : bool):
	hit_by_beam = is_hit
	if !hit_by_beam:
		animation = "visible"
		remove_from_group("heart")
	else:
		animation = "die"


func _on_Ghost_animation_finished():
	if animation != "die": return
	animation = "heart"
	add_to_group("heart")
