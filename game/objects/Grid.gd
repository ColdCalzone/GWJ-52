tool
extends Node2D

export var size = Vector2(1, 1)
var rect_scale = Vector2(20, 14)

const BACK_COLOR : Color = Color("141013")
const GRID_COLOR : Color = Color("221c1a")
const RAIL : PackedScene = preload("res://objects/Rail.tscn")

var top_rail
var left_rail
var bottom_rail
var right_rail

var time = 0

var grid : Dictionary = {}

signal deleted

func _ready():
	for block in get_tree().get_nodes_in_group("mirror_blocks"):
		block.connect("placed", self, "snap_block_to_position")
	for spotlight in get_tree().get_nodes_in_group("spotlight"):
		spotlight.connect("placed", self, "snap_block_to_position")
		spotlight.change_direction(spotlight.direction)
	for entity in get_tree().get_nodes_in_group("grid_object"):
		snap_to_position(entity)
	for light in get_tree().get_nodes_in_group("light"):
		light.populate(0, light.grid_position)

func _draw():
	var area = Rect2(Vector2.ZERO, size * rect_scale)
	area.size.x += 1
	area.size.y += 1
	# Drawing main area
	draw_rect(area, BACK_COLOR)
	for x in range(0, area.size.x, rect_scale.x):
		draw_line(Vector2(x + 0.5, 0), Vector2(x + 0.5, area.size.y), GRID_COLOR, 1.05)
	for y in range(0, area.size.y, rect_scale.y):
		draw_line(Vector2(0, y + 0.5), Vector2(area.size.x, y + 0.5), GRID_COLOR, 1.05)
	# Drawing rails
	if top_rail != null:
		top_rail.queue_free()
		top_rail = null
	top_rail = RAIL.instance()
	top_rail.rect_rotation = -90
	top_rail.rect_position = Vector2(0, -rect_scale.y/2 + 1)
	top_rail.rect_size.y = rect_scale.x * size.x
	add_child(top_rail)
	if left_rail != null:
		left_rail.queue_free()
		left_rail = null
	left_rail = RAIL.instance()
	left_rail.rect_position = Vector2(-rect_scale.x - 5, 0)
	left_rail.rect_size.y = rect_scale.y * size.y
	add_child(left_rail)
	if right_rail != null:
		right_rail.queue_free()
		right_rail = null
	right_rail = RAIL.instance()
	right_rail.rect_position = Vector2((size.x + 1) * rect_scale.x - 1, 0)
	right_rail.rect_size.y = rect_scale.y * size.y
	add_child(right_rail)
	if bottom_rail != null:
		bottom_rail.queue_free()
		bottom_rail = null
	bottom_rail = RAIL.instance()
	bottom_rail.rect_rotation = -90
	bottom_rail.rect_position = Vector2(0, rect_scale.y * (size.y + 1.4))
	bottom_rail.rect_size.y= rect_scale.x * size.x
	add_child(bottom_rail)

func _process(delta):
	if Engine.editor_hint:
		time += delta
		if time > 1:
			update()
			time = 0

func snap_block_to_position(block : Node2D):
	if block is MirrorBlock or block is Ghost or block is Block or block is HalfBlock:
		if (block.position.x > 0 and block.position.y > 0) and (
			block.position.x < rect_scale.x * size.x and block.position.y < rect_scale.y * size.y):
			snap_to_position(block)
		else:
			if grid.has(block.grid_position):
				grid.erase(block.grid_position)
			block.queue_free()
			yield(block, "tree_exited")
			emit_signal("deleted")
	if block is Spotlight:
		if (block.position.x > 0 and block.position.x < size.x * rect_scale.x) and (
			(block.position.y > size.y * rect_scale.y and block.position.y < (size.y + 2) * rect_scale.y) or
			(block.position.y < 0 and block.position.y > -2 * rect_scale.y)):
				block.change_direction(0 if block.position.y > 0 else 2)
				snap_to_position(block)
		elif (block.position.y >= 0 and block.position.y <= size.y * rect_scale.y) and (
			(block.position.x < 0 and block.position.x > -2 * rect_scale.x) or
			(block.position.x > size.x * rect_scale.x and block.position.x < (size.x + 2) * rect_scale.x)):
				block.change_direction(3 if block.position.x > 0 else 1)
				snap_to_position(block)
		else:
			if grid.has(block.grid_position):
				grid.erase(block.grid_position)
			block.queue_free()
			yield(block, "tree_exited")
			emit_signal("deleted")

func calculate_grid_position(pos : Vector2):
	pos = pos + rect_scale/2
	var new_pos = Vector2 (
			stepify(clamp(pos.x, -rect_scale.x, rect_scale.x * (size.x + 1)), rect_scale.x),
			stepify(clamp(pos.y, -rect_scale.y, rect_scale.y * (size.y + 1)), rect_scale.y)
		) - rect_scale/2
	return [new_pos, (new_pos - rect_scale/2) / rect_scale]

func snap_to_position(entity : Node2D):
	var calculated = calculate_grid_position(entity.position)
	var new_pos = calculated[0]
	var new_grid_pos = calculated[1]
	if grid.has(new_grid_pos):
		if grid.has(entity.grid_position):
			entity.position = entity.grid_position * rect_scale + rect_scale/2
		else:
			entity.queue_free()
			yield(entity, "tree_exited")
			emit_signal("deleted")
	else:
		grid.erase(entity.grid_position)
		grid[new_grid_pos] = entity
		entity.position = new_pos
		entity.grid_position = new_grid_pos
		
