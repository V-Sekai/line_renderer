extends Spatial
tool
#
var geometry = null
export (Material) var material = null setget set_material
export (float) var thickness = 0.01
export (Vector3) var start = Vector3()
export (Vector3) var end = Vector3()


#
func set_material(p_material):
	material = p_material
	if geometry:
		geometry.material_override = material


func add_vertex(p_point):
	if geometry:
		geometry.add_vertex(p_point)


func update(p_a, p_b):
	if geometry:
		geometry.clear()

		var camera = get_viewport().get_camera()
		if camera:
			geometry.begin(Mesh.PRIMITIVE_TRIANGLES)

			var ab = p_b - p_a
			var start = (
				(camera.global_transform.origin - ((p_a + p_b) / 2)).cross(ab).normalized()
				* thickness
			)
			var end = (
				(camera.global_transform.origin - ((p_a + p_b) / 2)).cross(ab).normalized()
				* thickness
			)

			var a_upper = p_a + start
			var b_upper = p_b + end
			var a_lower = p_a - start
			var b_lower = p_b - end

			add_vertex(a_upper)
			add_vertex(b_upper)
			add_vertex(a_lower)
			add_vertex(b_upper)
			add_vertex(b_lower)
			add_vertex(a_lower)

			geometry.end()


func _process(_delta):
	update(start, end)


func _ready():
	geometry = ImmediateGeometry.new()
	geometry.cast_shadow = GeometryInstance.SHADOW_CASTING_SETTING_DOUBLE_SIDED
	geometry.material_override = material
	geometry.set_as_toplevel(true)

	add_child(geometry)
	geometry.global_transform = Transform()
