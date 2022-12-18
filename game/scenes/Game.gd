extends Control

onready var grid = $Grid
onready var part_pick = $PartPicker
onready var timer = $VictoryTimer
onready var click_timer = $ClickDelay
onready var click = $SpotlightClick

const PAUSE = preload("res://objects/menu/Pause.tscn")
const MIRROR = preload("res://objects/MirrorBlock.tscn")
const GHOST = preload("res://objects/Ghost.tscn")
const BLOCK = preload("res://objects/Block.tscn")
const HALF_BLOCK = preload("res://objects/HalfBlock.tscn")

const WIN = preload("res://objects/menu/Win.tscn")

var part_types = [
	{"name": "mirror", "part": preload("res://objects/MirrorBlock.tscn"), "texture": preload("res://sprites/parts/mirror_part.tres"), "allowed": 20},
	{"name": "spotlight", "part": preload("res://objects/Spotlight.tscn"), "texture": preload("res://sprites/parts/spotlight_part.tres"), "allowed": 20},
]

var grid_objects : Dictionary = {}

var state : bool = false

var dragged_parts = []

var mouse_pressed

var totals : Dictionary = {}

func _ready():
	var level = Levels.levels[Levels.current_level]
	var to_remove = []
	for type in range(part_types.size()):
		if !level["allowed"].has(part_types[type]["name"]): continue
		if level["allowed"][part_types[type]["name"]] == 0:
			to_remove.append(part_types[type])
		else:
			part_types[type]["allowed"] = level["allowed"][part_types[type]["name"]]
	for i in to_remove:
		part_types.erase(i)
	grid.size = str2var("Vector2" + level["size"])
	grid.update()
	grid.scale.x = grid.rect_scale.x / grid.size.x / 2
	grid.scale.y = grid.scale.x
	
	var objects = level["grid_objects"]
	
	for pos in objects.keys():
		#jaaaaaaaank
		var obj_position = str2var("Vector2" + pos) * grid.rect_scale + grid.rect_scale/2
		match objects[pos]:
			"ghost":
				var ghost = GHOST.instance()
				grid.add_child(ghost)
				ghost.position = obj_position
				grid.snap_block_to_position(ghost)
			"halfblock":
				var block = HALF_BLOCK.instance()
				grid.add_child(block)
				block.position = obj_position
				grid.snap_block_to_position(block)
			"block":
				var block = BLOCK.instance()
				grid.add_child(block)
				block.position = obj_position
				grid.snap_block_to_position(block)
			"leftmirror":
				var mirror = MIRROR.instance()
				mirror.state = 1
				mirror.ungrabbable = true
				grid.add_child(mirror)
				mirror.position = obj_position
				grid.snap_block_to_position(mirror)
			"rightmirror":
				var mirror = MIRROR.instance()
				mirror.ungrabbable = true
				grid.add_child(mirror)
				mirror.position = obj_position
				grid.snap_block_to_position(mirror)
			_: continue
	part_pick.connect("part_grabbed", self, "add_part")
	grid.connect("deleted", self, "update_totals")
	part_pick.create_previews(part_types)
	update_totals()
	
	if Levels.current_level == 0 and !Save.data["viewed_tutorial"]:
		add_child(load("res://objects/menu/Tutorial.tscn").instance())
	Music.play_music("solving")

func _input(event):
	if event.is_action_pressed("fire_beams") and !mouse_pressed:
		grid_objects.clear()
		for entity in get_tree().get_nodes_in_group("grid_object"):
			grid_objects[entity.grid_position] = entity
		var spotlights = get_tree().get_nodes_in_group("spotlight")
		for spot in get_tree().get_nodes_in_group("spotlight"):
			if !state: 
				spot.turn_on()
				spot.disable()
				part_pick.disable()
			else: 
				spot.turn_off()
				spot.enable()
				part_pick.enable()
		if !state:
			for mirror in get_tree().get_nodes_in_group("mirror_blocks"):
				mirror.disable()
		if state:
			timer.stop()
			click_timer.stop()
			for light in get_tree().get_nodes_in_group("light"):
				light.die()
			for ghost in get_tree().get_nodes_in_group("ghost"):
				ghost.set_hit_by_beam(false)
			for block in get_tree().get_nodes_in_group("half_block"):
				block.set_light(-99)
			for entity in get_tree().get_nodes_in_group("spotlight"):
				entity.enable()
			for entity in get_tree().get_nodes_in_group("mirror_blocks"):
				entity.enable()
		elif spotlights.size() > 0:
			timer.start()
			click_timer.start()
		state = !state
	if event is InputEventMouseButton:
		mouse_pressed = event.pressed
		if event.pressed or dragged_parts.empty(): return
		var part = dragged_parts.pop_front()
		part._on_Click_input_event(null, event, null)
	if event.is_action_pressed("pause"):
		var pause = PAUSE.instance()
		add_child(pause)
		yield(pause, "child_exiting_tree")
		Music.play_music("titlescreen")
	if event.is_action_pressed("ui_end"):
		win()

func add_part(part):
	var new_part = part.duplicate()
	grid.add_child(new_part)
	new_part.connect("placed", grid, "snap_block_to_position")
	new_part.being_dragged = true
	dragged_parts.append(new_part)
	update_totals()

func update_totals():
	totals["mirror"] = get_tree().get_nodes_in_group("grabbable_mirror_blocks").size()
	totals["spotlight"] = get_tree().get_nodes_in_group("spotlight").size()
	part_pick.update_totals(totals)

func win():
	var win = WIN.instance()
	var amounts = part_pick.get_amounts()
	win.amounts = amounts
	Save.set_score(Levels.current_level, amounts)
	add_child(win)

func _on_VictoryTimer_timeout():
	if get_tree().get_nodes_in_group("ghost").size() <= get_tree().get_nodes_in_group("heart").size():
		win()
		timer.stop()


func _on_ClickDelay_timeout():
	click.play()
