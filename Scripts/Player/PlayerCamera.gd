extends SpringArm3D

@export_node_path(Node3D) var lookAtTargetPath
var lookAtTarget : Node3D

@export_node_path(Camera3D) var cameraPath
var cam : Camera3D

enum cameraStyle { FOLLOW, MOUSE, KEYBOARD }
@export var currentCameraStyle : cameraStyle = cameraStyle.MOUSE
var camRotX: float = 0.0
var camRotY: float = 0.0

@export var defaultCameraOffset: Vector3 = Vector3(0.0, 2.0, 7.0)
@export var defaultCameraAngle: float = 20.0
var currentCameraOffset: Vector3

@export var cameraTiltEnabled: bool = true
@export var cameraMovementLerpSpeed: float = 3.0
@export var tiltLerpSpeed: float = 5.0
@export var tiltAmount: Vector2 = Vector2(5,10)

func _ready():
	set_as_top_level(true)
	lookAtTarget = get_node(lookAtTargetPath)
	cam = get_node(cameraPath)
	pass 

func _unhandled_input(event):
	if currentCameraStyle == cameraStyle.MOUSE:
		if event is InputEventMouseMotion:
			camRotX += -event.relative.x * 0.02
			camRotY += -event.relative.y * 0.02
	pass
	
func _process(delta):
	handleTilts(delta)
	handleFOV(delta)
	handleInput(delta)
	pass
	
func _physics_process(delta):	
	handlePosition(delta)
	handleRotation(delta)
	pass

func handleTilts(delta): 
	# Camera Tilts
	var currentCameraTiltAmount: Vector2 = Vector2(0,0)
	var currentCameraTiltAmountDeg2Rad: Vector2 = Vector2(0,0)
	
	if cameraTiltEnabled:
		# Horizontal Tilt
		if Input.is_action_pressed("MoveRight"):
			currentCameraTiltAmount.x = tiltAmount.x
		elif Input.is_action_pressed("MoveLeft"):
			currentCameraTiltAmount.x = -tiltAmount.x
		else:
			currentCameraTiltAmount.x = 0
			
		# Forward/Backwards Tilt
		if Input.is_action_pressed("MoveUp"):
			currentCameraTiltAmount.y = tiltAmount.y
		elif Input.is_action_pressed("MoveDown"):
			currentCameraTiltAmount.y = -tiltAmount.y
		else:
			currentCameraTiltAmount.y = 0
			
	# Apply Tilt
	currentCameraTiltAmountDeg2Rad.x = deg2rad(-defaultCameraAngle+currentCameraTiltAmount.y)
	currentCameraTiltAmountDeg2Rad.y = deg2rad(currentCameraTiltAmount.x)
	cam.rotation.x = lerp_angle(cam.rotation.x, currentCameraTiltAmountDeg2Rad.x, delta * tiltLerpSpeed)
	cam.rotation.z = lerp_angle(cam.rotation.z, currentCameraTiltAmountDeg2Rad.y, delta * tiltLerpSpeed)
	pass
	
func handleFOV(delta):
	var currentCameraFOV: float = 75.0
	if Input.is_action_pressed("MoveUp"):
		currentCameraFOV = 80.0
	elif Input.is_action_pressed("MoveDown"):
		currentCameraFOV = 70.0
	else:
		currentCameraFOV = 75.0
	cam.fov = lerp(cam.fov, currentCameraFOV, delta*5)
	pass

func handleInput(delta):
	if currentCameraStyle == cameraStyle.KEYBOARD:
		if Input.is_action_pressed("LookUp"):
			camRotY -= -delta * 3
		if Input.is_action_pressed("LookDown"):
			camRotY += -delta * 3
		if Input.is_action_pressed("LookLeft"):
			camRotX -= -delta * 3
		if Input.is_action_pressed("LookRight"):
			camRotX += -delta * 3
	pass

func handlePosition(delta):
	position.x = lerp(position.x, lookAtTarget.position.x, delta * cameraMovementLerpSpeed)
	position.y = lerp(position.y, lookAtTarget.position.y, delta * cameraMovementLerpSpeed)
	position.z = lerp(position.z, lookAtTarget.position.z, delta * cameraMovementLerpSpeed)
	pass
	
func handleRotation(delta):
	var lookAtTargetFwdVec = lookAtTarget.global_transform.basis.z
	var radius = 3
	var orbitSpeed = (PI - lookAtTargetFwdVec.angle_to(global_transform.basis.z)) * radius
	
	if currentCameraStyle == cameraStyle.FOLLOW:
		rotation.y = lerp_angle(rotation.y, lookAtTarget.global_transform.basis.get_euler().y, delta * orbitSpeed)
		camRotX = deg2rad(rotation.y)
	elif currentCameraStyle == cameraStyle.MOUSE:
		rotation.y = lerp(rotation.y, camRotX, delta * 3)
	elif currentCameraStyle == cameraStyle.KEYBOARD:
		rotation.y = lerp(rotation.y, camRotX, delta * 3)
			
	camRotY = clamp(camRotY, deg2rad(-50), deg2rad(25))
	rotation.x = lerp(rotation.x, camRotY, delta * 3)
	pass
