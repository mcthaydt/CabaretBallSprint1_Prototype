extends Node3D

class_name GameManager
signal remove_life()

@export var respawnTimerUnfreezeTime : float = 0.5
var respawnTimer : float = 0.0

@export_node_path(Camera3D) var cameraNodePath
var cam : Camera3D

@export_node_path(Camera3D) var deathCamNodePath
var dCam : Camera3D

@export_node_path(CanvasLayer) var hudNodePath
var hud : CanvasLayer

@export_node_path(Node3D) var characterPath
var character : Node3D

@export_node_path(RigidDynamicBody3D) var playerBodyNodePath
var player : RigidDynamicBody3D

@export_node_path(SpringArm3D) var springArmPath
var springArm : SpringArm3D

@export_node_path(Node3D) var spawnPointNodePath
var spawnPoint : Node3D

@export_node_path(Node3D) var collectablesNodePath
var collectablesCollection : Node3D

@export_node_path(Node3D) var deathYTriggerPath
var deathYTrigger : Node3D

@export_node_path(Node3D) var fallCamYTriggerPath
var fallCamYTrigger : Node3D

var failedRound = false

func _ready():
	dCam = get_node(deathCamNodePath)
	cam = get_node(cameraNodePath)
	hud = get_node(hudNodePath)
	character = get_node(characterPath)
	player = get_node(playerBodyNodePath)
	springArm = get_node(springArmPath)
	spawnPoint = get_node(spawnPointNodePath)
	collectablesCollection = get_node(collectablesNodePath)
	deathYTrigger = get_node(deathYTriggerPath)
	fallCamYTrigger = get_node(fallCamYTriggerPath)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	pass 
	
func _process(delta):
	respawnTimer += delta 
	if respawnTimer > respawnTimerUnfreezeTime:
		player.canMove = true
	else:
		player.canMove = false
	pass
	
func _physics_process(delta):
		
	#if Input.is_action_just_pressed("ui_focus_next"):
	#	respawnPlayer(delta)
		
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
		
	if player.global_transform.origin.y < fallCamYTrigger.global_transform.origin.y:
		failedRound = true
		deathCam()
		
	if player.global_transform.origin.y < deathYTrigger.global_transform.origin.y:
		respawnPlayer(delta)
		
	if Input.is_action_just_pressed("ToggleFullscreen"):
		if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			
func deathCam():
	dCam.current = true
	dCam.top_level = true
	dCam.global_transform.origin.x = player.global_transform.origin.x
	dCam.global_transform.origin.z = player.global_transform.origin.z
	pass
			
func respawnPlayer(delta):
	cam.current = true
	player.global_transform.origin = spawnPoint.global_transform.origin + Vector3(0, 0, 5)
	player.global_transform.basis = spawnPoint.global_transform.basis
	collectablesCollection.reset()
	if dCam.top_level and dCam.get_parent() != character:
		character.add_child(dCam)
	springArm.resetCamera(delta)
	if failedRound:
		emit_signal("remove_life")
		failedRound = false
	respawnTimer = 0 
	pass
