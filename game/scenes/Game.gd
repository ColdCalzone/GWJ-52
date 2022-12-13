extends Node2D

onready var grid = $Grid

var state : bool = false

func _input(event):
	if event.is_action_pressed("click"):
		for spot in get_tree().get_nodes_in_group("spotlight"):
			if !state: spot.turn_on()
			else: spot.turn_off()
		if state:
			for light in get_tree().get_nodes_in_group("light"):
				light.queue_free()
			for mirror in get_tree().get_nodes_in_group("mirror_blocks"):
				mirror.reflect_light(-99)
		state = !state
