extends Node2D

onready var grid = $Grid

var grid_objects : Dictionary = {}

var state : bool = false

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
