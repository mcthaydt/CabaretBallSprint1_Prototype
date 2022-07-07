extends RigidDynamicBody3D

# Reference Objects
@export_node_path(Node3D) var characterNodePath
var character : Node3D

@export_node_path(SpringArm3D) var springArmNodePath
var springArm : SpringArm3D

@export_node_path(Node) var gameManagerNodePath
var gameManager : Node

@export_node_path(CanvasLayer) var hudManagerNodePath
var hudManager : CanvasLayer

# Class Properties
@export var movementSpeed: float = 1.0
var movementVelocity: Vector3 = Vector3.ZERO

@export var jumpPower: float = 10.0
var jumpVelocity: Vector3 = Vector3.ZERO

# State Checking
var isMoving: bool = false
var isGrounded: bool = false
var canMove: bool = false
var currentlySlamming : bool = false

func _ready() -> void:
	# Assign References
	character = get_node(characterNodePath)
	springArm = get_node(springArmNodePath)
	gameManager = get_node(gameManagerNodePath)
	hudManager = get_node(hudManagerNodePath)
	pass
	
func _process(delta) -> void:
	updateInput()
	orientMovementToCamera()
	updateState()
	rotateMeshByFacingDirection(character)
	fixingtimestep(delta, 120.0)
	pass
	
func _physics_process(_delta) -> void:
	if canMove:
		movePlayer()
		freeze = false
	else:
		freeze = true
	pass
	
func updateInput():
	movementVelocity = Vector3.ZERO
	if Input.is_action_pressed("MoveUp"):
		movementVelocity += Vector3.FORWARD
	elif Input.is_action_pressed("MoveDown"):
		movementVelocity += Vector3.BACK	
	if Input.is_action_pressed("MoveRight"):
		movementVelocity += Vector3.RIGHT
	elif Input.is_action_pressed("MoveLeft"):
		movementVelocity += Vector3.LEFT
	pass

func orientMovementToCamera():
	movementVelocity = movementVelocity.rotated(Vector3.UP, springArm.rotation.y).normalized() * movementSpeed
	pass
	
func updateState():
	# Non-Signal State Checking
	if linear_velocity.abs() > Vector3.ZERO:
		isMoving = true
	else:
		isMoving = false
		
	# Player Actions
	if  isGrounded and Input.is_action_just_pressed("Jump"):
		jump()
	elif !isGrounded and !currentlySlamming and Input.is_action_just_pressed("Jump"):
		slam()
		
	# Apply Powerup
	if gameManager.curPowerup == GameplayManager.Powerups.DASH:
		if Input.is_action_just_pressed("UsePowerup"):
			apply_central_impulse(Vector3.FORWARD * jumpPower * 60)
			apply_central_impulse(Vector3.UP * jumpPower * 30)
			gameManager.removePowerup()
			pass
	
	# Velocity is doubled because big numbers look cooler in game
	var velToMPH = get_linear_velocity().length() * 2.0
	hudManager.updateSpeed(velToMPH)
	pass
	
func movePlayer():
	apply_central_impulse(movementVelocity)
	pass
	
func jump():
	apply_central_impulse(Vector3.UP * jumpPower * 30)
	pass	

func slam():
	apply_central_impulse(Vector3.UP * -jumpPower * 60)
	currentlySlamming = true
	pass

func fixingtimestep(delta, targetFPS):
	# Taken from Garbaj on YouTube
	var fps = Engine.get_frames_per_second()
	var lerp_interval = movementVelocity / fps
	var lerp_position = global_transform.origin + lerp_interval
	var character_lerp_position = global_transform.origin + lerp_interval + Vector3(0, 2.471, 0)
	
	if fps > targetFPS:
		$BallMesh.top_level = true
		$BallMesh.global_transform.origin = $BallMesh.global_transform.origin.lerp(lerp_position, 20 * delta)
		character.top_level = true
		character.global_transform.origin = character.global_transform.origin.lerp(character_lerp_position, 20 * delta)
	else:
		$BallMesh.global_transform = global_transform
		$BallMesh.top_level = false
		character.global_transform.origin  = global_transform.origin + Vector3(0, 2.471, 0)
		character.top_level = true
	$BallMesh.global_transform.basis = global_transform.basis
	pass

func rotateMeshByFacingDirection(mesh):
	# Rotate the mesh horizontally by the angle between the input vector's forward and right vector
	if movementVelocity.length() > 0.2:
		mesh.rotation.y = atan2(-movementVelocity.x, -movementVelocity.z)
	pass

func _on_ball_body_entered(body):
	if body.collision_layer == 1:
		isGrounded = true
		currentlySlamming = false
	pass

func _on_ball_body_exited(body):
	if body.collision_layer == 1:
		isGrounded = false
	pass
