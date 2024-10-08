extends StaticBody3D

class_name Card


var card_model: CardModel
var texture_front: Texture
var texture_back: Texture
var movement_component:StaticMovementComponent = StaticMovementComponent.new(self)
var hoverable_component:HoverableComponent = HoverableComponent.new(func(param): pass, func(param): pass)

# Called when the node enters the scene tree for the first time.
func _ready():
	texture_front = load(card_model.theme.frontPath + "%s" % card_model.card_num + ".png")
	texture_back = load(card_model.theme.backPath)
	var backMesh = get_node("Back") as MeshInstance3D
	var frontMesh = get_node("Front") as MeshInstance3D
	var backMat = StandardMaterial3D.new()
	var frontMat = StandardMaterial3D.new()
	backMat.albedo_texture = texture_back
	# Reason for Alpha Scissor: https://docs.godotengine.org/en/latest/tutorials/3d/3d_rendering_limitations.html#transparency-sorting
	backMat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA_SCISSOR
	backMat.cull_mode = BaseMaterial3D.CULL_FRONT

	frontMat.albedo_texture = texture_front
	frontMat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA_SCISSOR

	backMesh.set_surface_override_material(0, backMat)
	frontMesh.set_surface_override_material(0, frontMat)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	movement_component.process(delta)

func get_width():
	return get_child(0).shape.extents.x * 2

func set_on_hover(new_on_hover:Callable):
	hoverable_component.on_hover = new_on_hover

func set_on_leave(new_on_leave:Callable):
	hoverable_component.on_leave = new_on_leave
