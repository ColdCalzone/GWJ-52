tool
extends Node2D

export var size = Vector2(1, 1)
var rect_scale = Vector2(20, 14)

const BACK_COLOR : Color = Color("141013")
const GRID_COLOR : Color = Color("221c1a")

var time = 0

var grid : Dictionary = {}

func _ready():
	for block in get_tree().get_nodes_in_group("mirror_blocks"):
		block.connect("placed", self, "snap_block_to_position")
	for entity in get_tree().get_nodes_in_group("grid_object"):
		snap_to_position(entity)
	for light in get_tree().get_nodes_in_group("light"):
		light.populate(0, light.grid_position)

func _draw():
	var area = Rect2(Vector2.ZERO, size * rect_scale)
	area.size.x += 1
	area.size.y += 1
	draw_rect(area, BACK_COLOR)
	for x in range(0, area.size.x, rect_scale.x):
		draw_line(Vector2(x + 0.5, 0), Vector2(x + 0.5, area.size.y), GRID_COLOR, 1.05)
	for y in range(0, area.size.y, rect_scale.y):
		draw_line(Vector2(0, y + 0.5), Vector2(area.size.x, y + 0.5), GRID_COLOR, 1.05)

func _process(delta):
	if Engine.editor_hint:
		time += delta
		if time > 1:
			update()
			time = 0

func snap_block_to_position(block : Node2D):
	if Vector2.ZERO < block.position and block.position < rect_scale * size:
		snap_to_position(block)
	print(block.grid_position)

func snap_to_position(entity : Node2D):
	var pos = entity.position + rect_scale/2
	entity.position = Vector2 (
			stepify(pos.x, rect_scale.x),
			stepify(pos.y, rect_scale.y)
		) - rect_scale/2
	entity.grid_position = (entity.position - rect_scale/2) / rect_scale
