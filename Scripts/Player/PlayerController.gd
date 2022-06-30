extends RigidDynamicBody3D

@export var movementSpeed: float = 1.0
var movementVelocity: Vector3 = Vector3.ZERO

@export var jumpPower: float = 10.0
var jumpVelocity: Vector3 = Vector3.ZERO

var isMoving: bool = false
var isGrounded: bool = false

@onready var character : Node3D = $Character
@onready var springArm : SpringArm3D = $SpringArm3D

@export_node_path(CanvasLayer) var hudNodePath
var HUD : CanvasLayer

func _ready() -> void:
	HUD = get_node(hudNodePath)
	pass

func _physics_process(_delta) -> void:
	updateVelocity()
	orientMovementToCamera()
	updateState()
	movePlayer()
	pass
	
func _process(delta) -> void:
	fixingtimestep(delta)
	rotateMeshByFacingDirection(character)
	pass
	
func updateVelocity():
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
	if linear_velocity.abs() > (Vector3.ZERO):
		isMoving = true
	else:
		isMoving = false
	if  isGrounded and Input.is_action_just_pressed("Jump"):
		jump()
		
	if HUD.curPowerup == HUDManager.Powerups.DASH:
		if Input.is_action_just_pressed("UsePowerup"):
			apply_central_impulse(Vector3.FORWARD * jumpPower * 60)
			apply_central_impulse(Vector3.UP * jumpPower * 30)
			HUD.removePowerup()
		pass
	pass
	
func movePlayer():
	apply_central_impulse(movementVelocity)
	pass
	
func jump():
	apply_central_impulse(Vector3.UP * jumpPower * 30)
	pass	

func fixingtimestep(delta):
	var fps = Engine.get_frames_per_second()
	var lerp_interval = movementVelocity / fps
	var lerp_position = global_transform.origin + lerp_interval
	var character_lerp_position = global_transform.origin + lerp_interval + Vector3(0, 2.471, 0)
	
	if fps > 120:
		$BallMesh.top_level = true
		$BallMesh.global_transform.origin = $BallMesh.global_transform.origin.lerp(lerp_position, 20 * delta)
		
		character.top_level = true
		character.global_transform.origin = character.global_transform.origin.lerp(character_lerp_position, 20 * delta)
	else:
		$BallMesh.global_transform = global_transform
		$BallMesh.top_level = false
		
		character.global_transform.origin  = global_transform.origin + Vector3(0, 2.471, 0)
	$BallMesh.global_transform.basis = global_transform.basis
	pass

func rotateMeshByFacingDirection(mesh):
	if movementVelocity.length() > 0.2:
		mesh.rotation.y = atan2(-movementVelocity.x, -movementVelocity.z)
	pass

func _on_ball_body_entered(body):
	if body.collision_layer == 1:
		isGrounded = true
	pass

func _on_ball_body_exited(body):
	if body.collision_layer == 1:
		isGrounded = false
	pass
