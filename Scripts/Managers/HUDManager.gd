extends CanvasLayer

class_name HUDManager

var curCount = 0
var totalCount = 5

var curLives = 3
var totalLives = 3

enum Powerups {
	NONE,
	DASH
}
var curPowerup = Powerups.NONE

var curSpeed = 0.0

@onready var counterUI = $Counter
@onready var livesUI = $Lives
@onready var powerupUI = $Powerup
@onready var speedUI = $Speed

func _ready():
	reset()
	pass

func _process(_delta):
	# Counter Update
	var counterLabel = counterUI.get_node("CounterLabel")
	counterLabel.text = str(curCount) + "/" + str(totalCount)
	
	# Lives Update
	var heart1 = livesUI.get_node("Heart1")
	var heart2 = livesUI.get_node("Heart2")
	var heart3 = livesUI.get_node("Heart3")
	if curLives == 3:
		heart3.frame = 0
		heart2.frame = 0
		heart1.frame = 0
	elif curLives == 2:
		heart3.frame = 2
		heart2.frame = 1
		heart1.frame = 0
	elif curLives == 1:
		heart3.frame = 2
		heart2.frame = 2
		heart1.frame = 1
	elif curLives == 0:
		heart3.frame = 2
		heart2.frame = 2
		heart1.frame = 2
	pass

func showHUD():
	counterUI.visible = true
	livesUI.visible = true
	powerupUI.visible = true
	speedUI.visible = true
	pass

func hideHUD():
	counterUI.visible = false
	livesUI.visible = false
	powerupUI.visible = false
	speedUI.visible = false
	pass

func increase():
	curCount += 1
	pass

func decrease():
	curCount -= 1
	pass

func removeLife():
	curLives -= 1
	pass
	
func addPowerup():
	var powerupIcon = powerupUI.get_node("PowerupIcon")
	powerupIcon.visible = true
	curPowerup = Powerups.DASH
	pass

func removePowerup():
	var powerupIcon = powerupUI.get_node("PowerupIcon")
	powerupIcon.visible = false
	curPowerup = Powerups.NONE
	pass
	
func updateSpeed(currentSpeed):
	var speedText = speedUI.get_node("SpeedText")
	speedText.text = str(currentSpeed).pad_zeros(3).pad_decimals(0)
	pass
	
func reset():
	curCount = 0
	curSpeed = 0.0
	removePowerup()
	pass


func _on_main_remove_life():
	removeLife()
	pass 
