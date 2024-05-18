extends StaticBody3D

class_name Card


var card_model: CardModel
var texture_front: Texture
var texture_back: Texture

# Called when the node enters the scene tree for the first time.
func _ready():
	texture_front = load(card_model.theme.frontPath + "%s" % card_model.card_num)
	texture_back = load(card_model.theme.backPath)
	var backMesh = get_node("Back") as MeshInstance3D
	var frontMesh = get_node("Front") as MeshInstance3D
	var backMat = StandardMaterial3D.new()
	var frontMat = StandardMaterial3D.new()
	backMat.albedo_texture = texture_back
	backMat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	backMat.cull_mode = BaseMaterial3D.CULL_FRONT
	
	frontMat.albedo_texture = texture_front
	frontMat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	
	backMesh.set_surface_override_material(0, backMat)
	frontMesh.set_surface_override_material(0, frontMat)

# TODO: need to figure out when children nodes are loaded into the scene

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
