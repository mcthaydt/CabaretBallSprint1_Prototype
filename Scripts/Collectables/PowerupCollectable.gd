extends Collectable

class_name PowerupCollectable 

func _ready():
	collisionSize = Vector3(0.929 * 2, 0.824 * 2, 0.628 * 2)
	generateCollisionShape(collisionSize)
	pass
	
func applyOverlap():
	hud.addPowerup()
	pass
