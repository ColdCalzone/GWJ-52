extends Control

onready var grid = $Grid
onready var level = $HBoxContainer/SpinBox
onready var width = $VBoxContainer/HBoxContainer/SpinBox
onready var height = $VBoxContainer/HBoxContainer2/SpinBox
onready var name_box = $HBoxContainer2/A

onready var mirrors_allowed = $VBoxContainer2/HBoxContainer/SpinBox
onready var spotlights_allowed = $VBoxContainer2/HBoxContainer2/SpinBox

const GHOST = preload("res://objects/Ghost.tscn")
const BLOCK = preload("res://objects/Block.tscn")
const HALF_BLOCK = preload("res://objects/HalfBlock.tscn")
const MIRROR = preload("res://objects/MirrorBlock.tscn")

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
	if event.is_action_pressed("rotate_left"):
		var mirror = MIRROR.instance()
		mirror.state = 1
		mirror.ungrabbable = true
		var pos = (get_global_mouse_position() - grid.position) / grid.scale
		mirror.position = pos
		grid.add_child(mirror)
		grid.snap_block_to_position(mirror)
	if event.is_action_pressed("rotate_right"):
		var mirror = MIRROR.instance()
		mirror.ungrabbable = true
		var pos = (get_global_mouse_position() - grid.position) / grid.scale
		mirror.position = pos
		grid.add_child(mirror)
		grid.snap_block_to_position(mirror)


func _on_Width_value_changed(value):
	grid.size.x = value
	grid.scale.x = grid.rect_scale.x / value / 2
	grid.scale.y = grid.scale.x
	grid.update()


func _on_Height_value_changed(value):
	grid.size.y = value
	grid.update()


func _on_Button_pressed():
	var file = File.new()
	if file.open("res://levels/level" + String(level.value) + ".tres", File.WRITE) == OK:
		var objects = {}
		for key in grid.grid.keys():
			if grid.grid[key] is Ghost:
				objects[key] = "ghost"
			if grid.grid[key] is HalfBlock:
				objects[key] = "halfblock"
			if grid.grid[key] is Block:
				objects[key] = "block"
			if grid.grid[key] is MirrorBlock:
				if grid.grid[key].state == 1:
					objects[key] = "leftmirror"
				else:
					objects[key] = "rightmirror"
		file.store_string(JSON.print(
			{"grid_objects": objects,
			"size": grid.size,
			"allowed": {"mirror": mirrors_allowed.value,
						"spotlight": spotlights_allowed.value},
			"name": name_box.text}
		))
		file.close()
