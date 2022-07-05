extends Node3D

class_name GameplayManager

# Reference Objects
@export_node_path(Camera3D) var cameraNodePath
var cam : Camera3D

@export_node_path(Camera3D) var deathCamNodePath
var dCam : Camera3D

@export_node_path(CanvasLayer) var hudNodePath
var hud : CanvasLayer

@export_node_path(Node3D) var characterNodePath
var character : Node3D

@export_node_path(RigidDynamicBody3D) var playerBodyNodePath
var player : RigidDynamicBody3D

@export_node_path(SpringArm3D) var springArmNodePath
var springArm : SpringArm3D

@export_node_path(Node3D) var spawnPointNodePath
var spawnPoint : Node3D

@export_node_path(Node3D) var collectablesNodePath
var collectablesCollection : Node3D

@export_node_path(Node3D) var deathYTriggerPath
var deathYTrigger : Node3D

@export_node_path(Node3D) var fallCamYTriggerPath
var fallCamYTrigger : Node3D

@export var respawnTimerUnfreezeTime : float = 0.5
var respawnTimer : float = 0.0

# Class Settings
var curCoinCount : int = 0
var totalCoinCount : int = 5

var curLivesRemaining : int = 3
var totalLives : int = 3

var curSpeed : float = 0.0

# State Settings
enum Powerups { NONE, DASH }
var curPowerup : Powerups = Powerups.NONE

var failedRound : bool = false

func _ready() -> void:
	cam = get_node(cameraNodePath)
	dCam = get_node(deathCamNodePath)
	hud = get_node(hudNodePath)
	character = get_node(characterNodePath)
	player = get_node(playerBodyNodePath)
	springArm = get_node(springArmNodePath)
	spawnPoint = get_node(spawnPointNodePath)
	collectablesCollection = get_node(collectablesNodePath)
	deathYTrigger = get_node(deathYTriggerPath)
	fallCamYTrigger = get_node(fallCamYTriggerPath)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	pass 
	
func _process(delta) -> void:
	respawnTimer += delta 
	if respawnTimer > respawnTimerUnfreezeTime:
		player.canMove = true
	else:
		player.canMove = false
	pass
	
func _physics_process(delta) -> void:
		
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
		
	if player.global_transform.origin.y < fallCamYTrigger.global_transform.origin.y:
		handleFailure()
		
	if player.global_transform.origin.y < deathYTrigger.global_transform.origin.y:
		respawnPlayer(delta)
		
	if Input.is_action_just_pressed("ToggleFullscreen"):
		if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)

func handleFailure() -> void:
	failedRound = true
	dCam.current = true
	dCam.top_level = true
	dCam.global_transform.origin.x = player.global_transform.origin.x
	dCam.global_transform.origin.z = player.global_transform.origin.z
	pass 		
			
func respawnPlayer(delta) -> void:
	player.global_transform.origin = spawnPoint.global_transform.origin + Vector3(0, 0, 5)
	player.global_transform.basis = spawnPoint.global_transform.basis
	
	collectablesCollection.reset()
	springArm.resetCamera(delta)
	
	if dCam.top_level and dCam.get_parent() != character:
		character.add_child(dCam)
	if failedRound:
		removeLife()
		failedRound = false
		
	cam.current = true
	respawnTimer = 0 
	pass

func increase() -> void:
	curCoinCount += 1
	pass

func decrease() -> void:
	curCoinCount -= 1
	pass

func removeLife() -> void:
	curLivesRemaining -= 1
	pass
	
func addPowerup() -> void:
	curPowerup = Powerups.DASH
	hud.addPowerup()
	pass

func removePowerup() -> void:
	curPowerup = Powerups.NONE
	hud.removePowerup()
	pass
	
func reset() -> void:
	curCoinCount = 0
	curSpeed = 0.0
	hud.reset()
	pass
