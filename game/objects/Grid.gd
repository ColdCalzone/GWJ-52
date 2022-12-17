tool
extends Node2D

export var size = Vector2(1, 1)
var rect_scale = Vector2(20, 14)

const BACK_COLOR : Color = Color("141013")
const GRID_COLOR : Color = Color("221c1a")

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
	draw_line(Vector2(0, -rect_scale.y), Vector2(rect_scale.x * size.x, -rect_scale.y), GRID_COLOR, 1.1)
	draw_line(Vector2(0, (size.y + 1) * rect_scale.y), Vector2(rect_scale.x * size.x, (size.y + 1) * rect_scale.y), GRID_COLOR, 1.1)
	draw_line(Vector2(-rect_scale.x, 0), Vector2(-rect_scale.x, rect_scale.y * size.y), GRID_COLOR, 1.1)
	draw_line(Vector2((size.x + 1) * rect_scale.x, 0), Vector2((size.x + 1) * rect_scale.x, rect_scale.y * size.y), GRID_COLOR, 1.1)

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
			(block.position.y > size.y * rect_scale.y and block.position.y < (size.y + 1) * rect_scale.y) or
			(block.position.y < 0 and block.position.y > -rect_scale.y)):
				block.change_direction(0 if block.position.y > 0 else 2)
				snap_to_position(block)
		elif (block.position.y >= 0 and block.position.y <= size.y * rect_scale.y) and (
			(block.position.x < 0 and block.position.x > -rect_scale.x) or
			(block.position.x > size.x * rect_scale.x and block.position.x < (size.x + 1) * rect_scale.x)):
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
			stepify(pos.x, rect_scale.x),
			stepify(pos.y, rect_scale.y)
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
		
