tool
extends Sprite
class_name MirrorBlock

var being_dragged : bool = false

var delay = 0.150

enum States {RIGHT, LEFT}
enum LightStates {NONE, BOTTOM, TOP, BOTH}

export(States) var state = States.RIGHT
export(LightStates) var light_state = LightStates.NONE

var time_elapsed = 0.0

var rotation_offset : int = 0

export var ungrabbable = false

onready var grid = get_tree().get_nodes_in_group("Grid")[0]

var grid_position : Vector2 = Vector2.ZERO

signal placed(block)

func _ready():
	region_rect.position.y = 32 * int(ungrabbable)
	region_rect.position.x = 64 * int(state)
	$ClickArea.visible = true

func _process(delta : float):
	if Engine.editor_hint:
		region_rect.position.y = 32 * int(ungrabbable)
		region_rect.position.x = state * 64
		#reflect_light(light_state)
	else:
		if being_dragged: 
			position = get_global_mouse_position() / grid.scale
		if rotation_offset != 0:
			time_elapsed += delta
		if time_elapsed >= delay:
			time_elapsed = 0
			region_rect.position.x = int(region_rect.position.x + (32 * clamp(rotation_offset, -1, 1))) % 128
			if region_rect.position.x < 0:
				region_rect.position.x = 96
			rotation_offset -= clamp(rotation_offset, -1, 1)

func _on_ClickArea_input_event(viewport, event : InputEvent, shape_idx):
	if event is InputEventMouseButton and not ungrabbable:
		being_dragged = event.pressed
		if !being_dragged:
			emit_signal("placed", self)
			rotation_offset = sign(rotation_offset) * (int(rotation_offset * sign(rotation_offset)) % 2)

func _input(event):
	if being_dragged:
		if event.is_action_pressed("rotate_right"):
			state = (state + 1) % 2
			rotation_offset = (rotation_offset + 2)
		if event.is_action_pressed("rotate_left"):
			state -= 1
			if state < 0:
				state = States.LEFT
			rotation_offset = (rotation_offset - 2)

# from direction is 1 or 2 (Bottom or Top in LightStates) and returns the direction the light will bounce to
func reflect_light(from_direction : int):
	light_state += from_direction
	match [light_state, state]:
		[LightStates.BOTTOM, States.RIGHT]: 
			region_rect.position = Vector2(0, 64 + (32 * int(ungrabbable)))
		[LightStates.BOTTOM, States.LEFT]: 
			region_rect.position = Vector2(96, 64 + (32 * int(ungrabbable)))
		[LightStates.TOP, States.RIGHT]: 
			region_rect.position = Vector2(32, 64 + (32 * int(ungrabbable)))
		[LightStates.TOP, States.LEFT]: 
			region_rect.position = Vector2(128, 64 + (32 * int(ungrabbable)))
		[LightStates.BOTH, States.RIGHT]: 
			region_rect.position = Vector2(64, 64 + (32 * int(ungrabbable)))
		[LightStates.BOTH, States.LEFT]: 
			region_rect.position = Vector2(160, 64 + (32 * int(ungrabbable)))
		_: 
			region_rect.position.y = 32 * int(ungrabbable)
			region_rect.position.x = 64 * int(state)
			light_state = LightStates.NONE
