tool
extends Node2D

export var size = Vector2(1, 1)
var rect_scale = Vector2(20, 14)

var half_size = size * rect_scale / 2

var offset = rect_scale/2

const BACK_COLOR : Color = Color("141013")
const GRID_COLOR : Color = Color("221c1a")

var time = 0

var grid : Dictionary = {}

func _ready():
	for block in get_tree().get_nodes_in_group("mirror_blocks"):
		block.connect("placed", self, "snap_block_to_position")
	for entity in get_tree().get_nodes_in_group("grid_object"):
		snap_to_position(entity, entity.position)
	half_size = size * rect_scale / 2
	for light in get_tree().get_nodes_in_group("light"):
		light.populate(0, light.grid_position)

func _draw():
	var area = Rect2(-half_size, size * rect_scale)
	area.size.x += 1
	area.size.y += 1
	draw_rect(area, BACK_COLOR)
	for x in range(0, area.size.x, rect_scale.x):
		draw_line(Vector2(x + 0.5, 0) - half_size, Vector2(x + 0.5, area.size.y) - half_size, GRID_COLOR, 1.05)
	for y in range(0, area.size.y, rect_scale.y):
		draw_line(Vector2(0, y + 0.5) - half_size, Vector2(area.size.x, y + 0.5) - half_size, GRID_COLOR, 1.05)

func _process(delta):
	if Engine.editor_hint:
		time += delta
		if time > 1:
			half_size = size * rect_scale / 2
			update()
			time = 0

func snap_block_to_position(block : Node2D):
	var mouse_pos = get_global_mouse_position() / scale
	if -half_size < mouse_pos and mouse_pos < half_size:
		snap_to_position(block, mouse_pos)

func snap_to_position(entity : Node2D, pos : Vector2):
	var off_y_set_y_thing = Vector2(rect_scale.x/(int(size.x) % 2 + 1), rect_scale.y/(int(size.y) % 2 + 1)) + offset
	pos -= off_y_set_y_thing
	entity.position = Vector2(
			stepify(pos.x, rect_scale.x),
			stepify(pos.y, rect_scale.y)
		) + off_y_set_y_thing
	var index = (entity.position - half_size) / rect_scale + (size / 2)
	entity.grid_position = index
	grid.clear()
	for entity_ in get_tree().get_nodes_in_group("grid_object"):
		grid[entity_.grid_position] = entity_
