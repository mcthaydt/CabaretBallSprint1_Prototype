extends CanvasLayer

class_name HUDManager

# Reference Objects
@export_node_path(Node3D) var gameManagerNodePath
var gameManager : Node3D

var counterUI : TextureRect
var livesUI : TextureRect
var powerupUI : TextureRect
var speedUI : TextureRect

func _ready() -> void:
	# Assign Reference
	gameManager = get_node(gameManagerNodePath)
	counterUI = get_node("Counter")
	livesUI = get_node("Lives")
	powerupUI = get_node("Powerup")
	speedUI = get_node("Speed")
	reset()
	pass

func _process(_delta) -> void:
	updateCoinCounter()
	updateLives()
	pass

func showHUD() -> void:
	counterUI.visible = true
	livesUI.visible = true
	powerupUI.visible = true
	speedUI.visible = true
	pass

func hideHUD() -> void:
	counterUI.visible = false
	livesUI.visible = false
	powerupUI.visible = false
	speedUI.visible = false
	pass
	
func addPowerup() -> void:
	var powerupIcon = powerupUI.get_node("PowerupIcon")
	powerupIcon.visible = true
	pass

func removePowerup() -> void:
	var powerupIcon = powerupUI.get_node("PowerupIcon")
	powerupIcon.visible = false
	pass
	
func updateCoinCounter() -> void:
	var counterLabel = counterUI.get_node("CounterLabel")
	counterLabel.text = str(gameManager.curCoinCount) + "/" + str(gameManager.totalCoinCount)
	pass
	
func updateLives() -> void:
	# Lives Update
	var heart1 = livesUI.get_node("Heart1")
	var heart2 = livesUI.get_node("Heart2")
	var heart3 = livesUI.get_node("Heart3")
	if gameManager.curLivesRemaining == 3:
		heart3.frame = 0
		heart2.frame = 0
		heart1.frame = 0
	elif gameManager.curLivesRemaining == 2:
		heart3.frame = 2
		heart2.frame = 1
		heart1.frame = 0
	elif gameManager.curLivesRemaining == 1:
		heart3.frame = 2
		heart2.frame = 2
		heart1.frame = 1
	elif gameManager.curLivesRemaining == 0:
		heart3.frame = 2
		heart2.frame = 2
		heart1.frame = 2
	pass
	
func updateSpeed(currentSpeed) -> void:
	var speedText = speedUI.get_node("SpeedText")
	speedText.text = str(currentSpeed).pad_zeros(3).pad_decimals(0)
	pass
	
func reset() -> void:
	removePowerup()
	pass
