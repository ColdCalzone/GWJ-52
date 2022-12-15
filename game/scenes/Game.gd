extends Control

onready var grid = $Grid
onready var part_pick = $PartPicker

var grid_objects : Dictionary = {}

var state : bool = false

var dragged_parts = []

func _ready():
	part_pick.connect("part_grabbed", self, "add_part")

func _input(event):
	if event.is_action_pressed("ui_home"):
		grid_objects.clear()
		for entity in get_tree().get_nodes_in_group("grid_object"):
			grid_objects[entity.grid_position] = entity
		for spot in get_tree().get_nodes_in_group("spotlight"):
			if !state: 
				spot.turn_on()
			else: spot.turn_off()
		if state:
			for light in get_tree().get_nodes_in_group("light"):
				light.die()
			for mirror in get_tree().get_nodes_in_group("mirror_blocks"):
				mirror.reflect_light(-99)
			for ghost in get_tree().get_nodes_in_group("ghost"):
				ghost.set_hit_by_beam(false)
		state = !state
	if event is InputEventMouseButton:
		if event.pressed or dragged_parts.empty(): return
		var part = dragged_parts.pop_front()
		part._on_Click_input_event(null, event, null)

func add_part(part):
	var new_part = part.duplicate()
	grid.add_child(new_part)
	new_part.connect("placed", grid, "snap_block_to_position")
	new_part.being_dragged = true
	dragged_parts.append(new_part)
