extends Control

onready var grid = $Grid
const GHOST = preload("res://objects/Ghost.tscn")
const BLOCK = preload("res://objects/Block.tscn")
const HALF_BLOCK = preload("res://objects/HalfBlock.tscn")

var holding_shift : bool = false



func _input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			var pos = (get_global_mouse_position() - grid.position) / grid.scale
			var grid_pos = grid.calculate_grid_position(pos)[1]
			if event.button_index == BUTTON_LEFT:
				if grid.grid.has(grid_pos):
					grid.grid[grid_pos].queue_free()
					grid.grid.erase(grid_pos)
				else:
					var ghost = GHOST.instance()
					ghost.position = pos
					grid.add_child(ghost)
					grid.snap_block_to_position(ghost)
			if event.button_index == BUTTON_RIGHT:
				if grid.grid.has(grid_pos):
					grid.grid[grid_pos].queue_free()
					grid.grid.erase(grid_pos)
				else:
					var block = BLOCK.instance() if !holding_shift else HALF_BLOCK.instance()
					block.position = pos
					grid.add_child(block)
					grid.snap_block_to_position(block)
	if event is InputEventKey:
		if event.scancode == KEY_SHIFT:
			holding_shift = event.pressed
