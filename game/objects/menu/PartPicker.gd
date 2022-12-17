extends Control

signal part_grabbed(part)

onready var list = $ScrollContainer/CenterContainer/VBoxContainer

onready var part_preview = preload("res://objects/menu/PartPreview.tscn")

var parts : Dictionary = {}

func create_previews(part_types):
	for part in part_types:
		var preview = part_preview.instance()
		list.add_child(preview)
		preview.load_part(part.part, part.texture)
		preview.total_allowed = part.allowed
		preview.set_number(0)
		parts[part["name"]] = preview

func add_part(part : Node):
	emit_signal("part_grabbed", part)

func update_totals(totals : Dictionary):
	for key in totals.keys():
		if parts.has(key):
			parts[key].set_number(totals[key])

func get_amounts():
	var out = {}
	for key in parts.keys():
		out[key] = String(parts[key].current) + "/" + String(parts[key].total_allowed)
	return out
