extends Sprite

var being_dragged : bool = false

var delay = 0.150

enum States {RIGHT, LEFT}

var state = States.RIGHT

var time_elapsed = 0.0

var rotation_offset = 0

export var ungrabbable = false

func _ready():
	region_rect.position.y = 32 * int(ungrabbable)

func _process(delta : float):
	if being_dragged: 
		position = get_global_mouse_position()
	if rotation_offset != 0:
		time_elapsed += delta
	if time_elapsed >= delay:
		time_elapsed = 0
		region_rect.position.x = int(region_rect.position.x + (32 * clamp(rotation_offset, -1, 1))) % 128
		if region_rect.position.x < 0:
			region_rect.position.x = 96
		rotation_offset -= clamp(rotation_offset, -1, 1)

func _on_ClickArea_input_event(viewport, event : InputEvent, shape_idx):
	if event is InputEventMouseButton:# and not ungrabbable:
		being_dragged = event.pressed

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
