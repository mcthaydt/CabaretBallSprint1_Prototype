extends SpringArm3D

# Refrence Objects
@export_node_path(Node3D) var lookAtTargetNodePath
var lookAtTarget : Node3D

@export_node_path(Camera3D) var cameraNodePath
var cam : Camera3D

# Class Properties
@export var mouseSensitivity: float = 0.02
@export var keyboardSensitivity: float = 3.0
@export var cameraPositionLerpSpeed: float = 3.0
@export var cameraRotationLerpSpeed: float = 3.0

@export var minCamAngle: float = -50.0
@export var maxCamAngle: float = 25.0

var camRotX: float = 0.0
var camRotY: float = 0.0

@export var cameraTiltEnabled: bool = true
@export var cameraMovementLerpSpeed: float = 3.0
@export var tiltLerpSpeed: float = 5.0
@export var tiltAmount: Vector2 = Vector2(5,10)
var defaultCameraTiltAngle: float = 20.0

# State Checking
enum cameraStyle { MOUSE, KEYBOARD }
@export var currentCameraStyle : cameraStyle = cameraStyle.KEYBOARD

func _ready() -> void:
	# Assign References
	lookAtTarget = get_node(lookAtTargetNodePath)
	cam = get_node(cameraNodePath)
	
	# Assign Baseline Settings
	top_level = true
	pass 

func _unhandled_input(event) -> void:
	if currentCameraStyle == cameraStyle.MOUSE:
		if event is InputEventMouseMotion:
			camRotX += -event.relative.x * mouseSensitivity
			camRotY += -event.relative.y * mouseSensitivity
	pass
	
func _process(delta) -> void:
	handleTilts(delta)
	handleFOV(delta)
	handleInput(delta)
	pass
	
func _physics_process(delta) -> void:	
	handlePosition(delta)
	handleRotation(delta)
	pass

func handleTilts(delta) -> void: 
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
	currentCameraTiltAmountDeg2Rad.x = deg2rad(-defaultCameraTiltAngle+currentCameraTiltAmount.y)
	currentCameraTiltAmountDeg2Rad.y = deg2rad(currentCameraTiltAmount.x)
	cam.rotation.x = lerp_angle(cam.rotation.x, currentCameraTiltAmountDeg2Rad.x, delta * tiltLerpSpeed)
	cam.rotation.z = lerp_angle(cam.rotation.z, currentCameraTiltAmountDeg2Rad.y, delta * tiltLerpSpeed)
	pass
	
func handleFOV(delta) -> void:
	var currentCameraFOV: float = 75.0
	if Input.is_action_pressed("MoveUp"):
		currentCameraFOV = 80.0
	elif Input.is_action_pressed("MoveDown"):
		currentCameraFOV = 70.0
	else:
		currentCameraFOV = 75.0
	cam.fov = lerp(cam.fov, currentCameraFOV, delta * tiltLerpSpeed)
	pass

func handleInput(delta) -> void:
	if currentCameraStyle == cameraStyle.KEYBOARD:
		if Input.is_action_pressed("LookUp"):
			camRotY -= -delta * keyboardSensitivity
		if Input.is_action_pressed("LookDown"):
			camRotY += -delta * keyboardSensitivity
		if Input.is_action_pressed("LookLeft"):
			camRotX -= -delta * keyboardSensitivity
		if Input.is_action_pressed("LookRight"):
			camRotX += -delta * keyboardSensitivity
	pass

func handlePosition(delta) -> void:
	position.x = lerp(position.x, lookAtTarget.position.x, delta * cameraPositionLerpSpeed)
	position.y = lerp(position.y, lookAtTarget.position.y, delta * cameraPositionLerpSpeed)
	position.z = lerp(position.z, lookAtTarget.position.z, delta * cameraPositionLerpSpeed)
	pass
	
func handleRotation(delta) -> void:
	# X-Rotation
	if currentCameraStyle == cameraStyle.MOUSE:
		rotation.y = lerp(rotation.y, camRotX, delta * cameraRotationLerpSpeed)
	elif currentCameraStyle == cameraStyle.KEYBOARD:
		rotation.y = lerp(rotation.y, camRotX, delta * cameraRotationLerpSpeed)
	
	# Y-Rotation
	camRotY = clamp(camRotY, deg2rad(minCamAngle), deg2rad(maxCamAngle))
	rotation.x = lerp(rotation.x, camRotY, delta * cameraRotationLerpSpeed)
	pass

func resetCamera(delta) -> void:
	# Reset to Active Camera
	cam.current = true
	
	# Reset Tilt
	cam.rotation.x = lerp_angle(cam.rotation.x, 0, delta * tiltLerpSpeed)
	cam.rotation.z = lerp_angle(cam.rotation.z, 0, delta * tiltLerpSpeed)
	
	# Reset Rotation
	camRotX = 0
	camRotY = 0
	rotation.y = lerp_angle(rotation.y, camRotX, delta * 5)
	rotation.x = lerp_angle(rotation.z, camRotY, delta * 5)
	pass
