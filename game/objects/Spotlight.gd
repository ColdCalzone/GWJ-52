extends AnimatedSprite

#enum LightState {OFF, SMALL, MEDIUM, ON}

enum Direction {UP, DOWN, LEFT, RIGHT}
export(Direction) var direction = Direction.UP

onready var LIGHT = preload("res://objects/LightBeam.tscn")
onready var grid = get_tree().get_nodes_in_group("Grid")[0]

var grid_position : Vector2 = Vector2.ZERO

func turn_on():
	var light = LIGHT.instance()
	light.set_orientation(direction)
	get_parent().add_child(light)
	light.populate(direction, grid_position)
	play()

func turn_off():
	playing = false
	set_frame(0)

func _on_Spotlight_frame_changed():
	for light in get_tree().get_nodes_in_group("light"):
		light.set_light_state(int(max(frame - 1, 0)))
