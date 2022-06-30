extends CanvasLayer

class_name HUDManager

@onready var counterUI = $CounterUI
@onready var powerupUI = $PowerupUI

var curCount = 0
var totalCount = 5

enum Powerups {
	NONE,
	DASH
}
var curPowerup = Powerups.NONE

func _ready():
	reset()
	pass

func _process(_delta):
	var textLabel = counterUI.get_node("Label")
	textLabel.text = str(curCount) + " / " + str(totalCount)
	pass
	
func showHUD():
	counterUI.visible = true
	powerupUI.visible = true
	pass
	
func hideHUD():
	counterUI.visible = false
	powerupUI.visible = false
	pass

func increase():
	curCount += 1
	pass
	
func decrease():
	curCount -= 1
	pass
	
func addPowerup():
	var powerupIcon = powerupUI.get_node("PowerupImage")
	powerupIcon.visible = true
	
	var instrucLabel = powerupUI.get_node("InstructionLabel")
	instrucLabel.visible = true
	
	curPowerup = Powerups.DASH
	pass
	
func removePowerup():
	var powerupIcon = powerupUI.get_node("PowerupImage")
	powerupIcon.visible = false
	
	var instrucLabel = powerupUI.get_node("InstructionLabel")
	instrucLabel.visible = false
	
	curPowerup = Powerups.NONE
	pass

func reset():
	curCount = 0
	removePowerup()
	pass
