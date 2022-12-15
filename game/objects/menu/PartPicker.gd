extends Control

signal part_grabbed(part)

onready var list = $ScrollContainer/CenterContainer/VBoxContainer

onready var part_types = [
	{"part": preload("res://objects/MirrorBlock.tscn"), "texture": preload("res://sprites/parts/mirror_part.tres")},
	{"part": preload("res://objects/Spotlight.tscn"), "texture": preload("res://sprites/parts/spotlight_part.tres")},
]
onready var part_preview = preload("res://objects/menu/PartPreview.tscn")

func _ready():
	for part in part_types:
		var preview = part_preview.instance()
		list.add_child(preview)
		preview.load_part(part.part, part.texture)

func add_part(part : Node):
	emit_signal("part_grabbed", part)
