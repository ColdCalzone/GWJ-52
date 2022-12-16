extends Control

var part : Node
onready var texture : TextureRect = $Texture
onready var label : Label = $Label
onready var game = get_tree().get_nodes_in_group("Game")[0]
onready var part_picker = get_tree().get_nodes_in_group("part_picker")[0]

export var total_allowed : int = 20
var current : int = 0

var disabled : bool = false

func load_part(new_part : PackedScene, new_texture : Texture):
	part = new_part.instance()
	texture.texture = new_texture

func _on_PartPreview_gui_input(event : InputEvent):
	if part == null or disabled: return
	if event is InputEventMouseButton:
		if !event.pressed: return
		part_picker.add_part(part)

func set_number(num : int):
	current = num
	if current >= total_allowed:
		disable()
	else:
		enable()
	label.text = String(current) + "/" + String(total_allowed)

func disable():
	modulate = Color(0.72549, 0.72549, 0.72549)
	disabled = true

func enable():
	modulate = Color.white
	disabled = false
