extends CanvasLayer

@onready var textLabel = $ColorRect/Label
var curCount = 0
var totalCount = 5


func _process(_delta):
	textLabel.text = str(curCount) + " / " + str(totalCount)
	pass

func increase():
	curCount += 1
	pass
	
func decrease():
	curCount -= 1
	pass

func reset():
	curCount = 0
	pass
