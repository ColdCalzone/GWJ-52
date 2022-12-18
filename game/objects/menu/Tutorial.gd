extends CenterContainer

onready var timer = $Timer
onready var tween = $Tween
onready var label = $RichTextLabel/CenterContainer/Label
onready var text = $RichTextLabel

var done = false
var leaving = false

func _ready():
	tween.interpolate_property(self, "modulate:a", 0.0, 1.0, 1.0)
	tween.interpolate_property(self, "rect_position:y", 360, 0, 1.0, Tween.TRANS_CIRC)
	tween.start()
	yield(tween, "tween_all_completed")
	timer.connect("timeout", self, "add_text")
	timer.start()

func _input(event):
	if event is InputEventKey:
		if !event.pressed: return
		if !done:
			tween.stop_all()
			timer.stop()
			modulate.a = 1
			rect_position.y = 0
			text.percent_visible = 1.0
			label.modulate.a = 1
			done = true
		elif !leaving:
			leaving = true
			tween.interpolate_property(self, "modulate:a", 1.0, 0.0, 1.0)
			tween.interpolate_property(self, "rect_position:y", 0, 360, 1.0, Tween.TRANS_CIRC)
			tween.start()
			yield(tween, "tween_all_completed")
			Save.set_viewed_tutorial()
			get_parent().queue_free()

func add_text():
	text.visible_characters += 1
	if text.visible_characters == text.get_total_character_count():
		timer.stop()
		tween.interpolate_property(label, "modulate:a", 0.0, 1.0, 0.2)
		tween.start()
