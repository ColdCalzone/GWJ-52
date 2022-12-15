extends AnimatedSprite
class_name Spotlight

#enum LightState {OFF, SMALL, MEDIUM, ON}

enum Direction {UP, RIGHT, DOWN, LEFT}
export(Direction) var direction = Direction.DOWN

onready var LIGHT = preload("res://objects/LightBeam.tscn")
onready var grid = get_tree().get_nodes_in_group("Grid")[0]

onready var up_area : Area2D = $UpClick
onready var right_area : Area2D = $RightClick
onready var down_area : Area2D = $DownClick

var being_dragged : bool = false

var grid_position : Vector2 = Vector2.ZERO

signal placed(block)
signal complete

func _process(delta):
	if being_dragged: 
		position = (get_global_mouse_position() - grid.position) / grid.scale

func turn_on():
	var light = LIGHT.instance()
	light.set_orientation(direction)
	light.parent_spotlight = self
	get_parent().add_child(light)
	light.populate(direction, grid_position)
	play()

func turn_off():
	playing = false
	set_frame(0)

func _on_Spotlight_frame_changed():
	for light in get_tree().get_nodes_in_group("light"):
		light.set_light_state(int(max(frame - 1, 0)))

func change_direction(dir : int):
	while direction < 0:
		direction += 4
	direction %= 4
	direction = dir
	right_area.scale.x = 1
	flip_h = false
	for area in get_children():
		area.input_pickable = false
	match direction:
		Direction.UP:
			up_area.input_pickable = true
			animation = "up"
		Direction.DOWN:
			down_area.input_pickable = true
			animation = "down"
		Direction.RIGHT:
			right_area.input_pickable = true
			right_area.scale.x = 1
			animation = "right"
		Direction.LEFT:
			right_area.input_pickable = true
			right_area.scale.x = -1
			flip_h = true
			animation = "right"

func _on_Click_input_event(viewport, event : InputEvent, shape_idx):
	if event is InputEventMouseButton:
		being_dragged = event.pressed
		if !being_dragged:
			emit_signal("placed", self)
