extends Sprite3D

class_name Collectable

var player : RigidDynamicBody3D
var hud : CanvasLayer
var area3D : Area3D

var collisionSize 
func _ready():
	pass

func _process(_delta):
	if area3D != null and player != null:
		if area3D.overlaps_body(player):
			applyOverlap()
			queue_free()
	pass
	
func generateCollisionShape(size):
	area3D = Area3D.new()
	add_child(area3D)
	
	var collisionShape = CollisionShape3D.new()
	collisionShape.shape = BoxShape3D.new()
	collisionShape.shape.set("Size", size)
	area3D.add_child(collisionShape)
	pass
	
func applyOverlap():
	pass
