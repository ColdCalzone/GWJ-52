tool
extends Sprite

enum LightState {OFF, SMALL, MEDIUM, ON}

export(LightState) var light_state = LightState.OFF

enum Direction {UP, RIGHT, DOWN, LEFT}

onready var grid = get_tree().get_nodes_in_group("Grid")[0]
onready var game = get_tree().get_nodes_in_group("Game")[0]

var grid_position : Vector2 = Vector2(2, 5)

var parent_spotlight : Node2D

var time = 0.0

func _process(delta):
	if Engine.editor_hint:
		time += delta
		if time > 1:
			set_light_state(light_state)

func set_light_state(state : int):
	region_rect.position.y = state * 14

func set_orientation(state : int):
	match state:
		Direction.UP, Direction.DOWN: region_rect.position.x = 20
		Direction.LEFT, Direction.RIGHT: region_rect.position.x = 0

func populate(direction : int, grid_pos : Vector2):
	set_orientation(direction)
	var impacted : bool = false
	if game.grid_objects.has(grid_pos):
		var entity = game.grid_objects[grid_pos]
		if entity is MirrorBlock:
			match [direction, entity.state]:
				[Direction.UP, 0]:
					entity.reflect_light(1)
					direction = Direction.RIGHT
				[Direction.DOWN, 1]:
					entity.reflect_light(2)
					direction = Direction.RIGHT
				[Direction.RIGHT, 0], [Direction.LEFT, 1]: 
					entity.reflect_light(2)
					direction = Direction.UP
				[Direction.RIGHT, 1], [Direction.LEFT, 0]: 
					entity.reflect_light(1)
					direction = Direction.DOWN
				[Direction.UP, 1]:
					entity.reflect_light(1)
					direction = Direction.LEFT
				[Direction.DOWN, 0]: 
					entity.reflect_light(2)
					direction = Direction.LEFT
			impacted = true
		if entity is Ghost:
			entity.hit_by_beam = true
		if entity is Block:
			queue_free()
			return
	self.grid_position = grid_pos
	position = grid_position * grid.rect_scale
	var next = self.duplicate()
	next.parent_spotlight = parent_spotlight
	get_parent().add_child(next)
	var next_pos : Vector2
	match direction:
		Direction.UP:
			next_pos = grid_pos + Vector2.UP
		Direction.DOWN:
			next_pos = grid_pos + Vector2.DOWN
		Direction.LEFT:
			next_pos = grid_pos + Vector2.LEFT
		Direction.RIGHT:
			next_pos = grid_pos + Vector2.RIGHT
	if next_pos.x > grid.size.x - 1 or next_pos.x < 0 or next_pos.y > grid.size.y - 1 or next_pos.y < 0:
		return
	next.populate(direction, next_pos)
	if impacted:
		queue_free()

func die():
	queue_free()
