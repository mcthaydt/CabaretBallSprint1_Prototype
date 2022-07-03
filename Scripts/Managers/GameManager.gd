extends Node3D

class_name GameManager

@export var respawnTimerUnfreezeTime : float = 0.5
var respawnTimer : float = 0.0

@export_node_path(CanvasLayer) var hudNodePath
var hud : CanvasLayer

@export_node_path(RigidDynamicBody3D) var playerBodyNodePath
var player : RigidDynamicBody3D

@export_node_path(SpringArm3D) var springArmPath
var springArm : SpringArm3D

@export_node_path(Node3D) var spawnPointNodePath
var spawnPoint : Node3D

@export_node_path(Node3D) var collectablesNodePath
var collectablesCollection : Node3D

@export_node_path(Node3D) var fallYTriggerNodePath
var fallYTrigger : Node3D


func _ready():
	hud = get_node(hudNodePath)
	player = get_node(playerBodyNodePath)
	springArm = get_node(springArmPath)
	spawnPoint = get_node(spawnPointNodePath)
	collectablesCollection = get_node(collectablesNodePath)
	fallYTrigger = get_node(fallYTriggerNodePath)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	pass 

func _process(delta):
	respawnTimer += delta 
	if respawnTimer > respawnTimerUnfreezeTime:
		player.freeze = false
	else:
		player.freeze = true
		
	#if Input.is_action_just_pressed("ui_focus_next"):
	#	respawnPlayer(delta)
		
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
		
	if player.global_transform.origin.y < fallYTrigger.global_transform.origin.y:
		respawnPlayer(delta)
		
	if Input.is_action_just_pressed("ToggleFullscreen"):
		if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)

	
func respawnPlayer(delta):
	player.global_transform.origin = spawnPoint.global_transform.origin
	player.global_transform.basis = spawnPoint.global_transform.basis
	collectablesCollection.reset()
	springArm.resetCamera(delta)
	respawnTimer = 0 
	pass
