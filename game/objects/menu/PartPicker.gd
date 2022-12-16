extends Control

signal part_grabbed(part)

onready var list = $ScrollContainer/CenterContainer/VBoxContainer

onready var part_types = [
	{"name": "mirror", "part": preload("res://objects/MirrorBlock.tscn"), "texture": preload("res://sprites/parts/mirror_part.tres")},
	{"name": "spotlight", "part": preload("res://objects/Spotlight.tscn"), "texture": preload("res://sprites/parts/spotlight_part.tres")},
]

onready var part_preview = preload("res://objects/menu/PartPreview.tscn")

var parts : Dictionary = {}

func _ready():
	for part in part_types:
		var preview = part_preview.instance()
		list.add_child(preview)
		preview.load_part(part.part, part.texture)
		parts[part["name"]] = preview

func add_part(part : Node):
	emit_signal("part_grabbed", part)

func update_totals(totals : Dictionary):
	for key in totals.keys():
		parts[key].set_number(totals[key])
