extends AudioStreamPlayer


func _ready():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "volume_db", -8.0, 5)
	pass


func _process(delta):
	pass
