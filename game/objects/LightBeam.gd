tool
extends Sprite

enum LightState {OFF, SMALL, MEDIUM, ON}

export(LightState) var light_state = LightState.OFF

enum Direction {UP, DOWN, LEFT, RIGHT}

onready var grid = get_tree().get_nodes_in_group("Grid")[0]

var grid_position : Vector2 = Vector2(2, 5)

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
	if grid.grid.has(grid_pos):
		var entity = grid.grid[grid_pos]
		if entity is MirrorBlock:
			match [direction, entity.state]:
				[0, 0]:
					entity.reflect_light(1)
					direction = Direction.RIGHT
				[1, 1]:
					entity.reflect_light(2)
					direction = Direction.RIGHT
				[3, 0], [2, 1]: 
					entity.reflect_light(2)
					direction = Direction.UP
				[3, 1], [2, 0]: 
					entity.reflect_light(1)
					direction = Direction.DOWN
				[0, 1]:
					entity.reflect_light(1)
					direction = Direction.LEFT
				[1, 0]: 
					entity.reflect_light(2)
					direction = Direction.LEFT
			impacted = true
		if entity is Ghost:
			entity.hit_by_beam = true
	self.grid_position = grid_pos
	position = grid_position * grid.rect_scale - grid.half_size
	var next = self.duplicate()
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
