extends Control

var part : Node
onready var tex : TextureRect = $Texture
onready var game = get_tree().get_nodes_in_group("Game")[0]
onready var part_picker = get_tree().get_nodes_in_group("part_picker")[0]

func load_part(new_part : PackedScene, new_texture : Texture):
	part = new_part.instance()
	tex.texture = new_texture

func _on_PartPreview_gui_input(event : InputEvent):
	if part == null: return
	if event is InputEventMouseButton:
		if !event.pressed: return
		part_picker.add_part(part)
