extends Spatial
tool
#
var geometry = null
export (Material) var material = null setget set_material
export (float) var thickness = 0.01
export (Vector3) var start = Vector3()
export (Vector3) var end = Vector3()

#
func set_material(p_material: Material):
	material = p_material
	if geometry:
		geometry.material_override = material


func add_vertex(p_point: Vector3):
	if geometry:
		geometry.add_vertex(p_point)


func update(p_a: Vector3, p_b: Vector3):
	if geometry:
		geometry.clear()
		
		var camera = get_viewport().get_camera()
		if camera:
			geometry.begin(Mesh.PRIMITIVE_TRIANGLES)
			
			var ab = p_b - p_a
			var transform_start: Vector3 = (
				(camera.global_transform.origin - ((p_a + p_b) / 2)).cross(ab).normalized()
				* thickness
			)
			var transform_end: Vector3 = (
				(camera.global_transform.origin - ((p_a + p_b) / 2)).cross(ab).normalized()
				* thickness
			)
			
			var a_upper: Vector3 = p_a + transform_start
			var b_upper: Vector3 = p_b + transform_end
			var a_lower: Vector3 = p_a - transform_start
			var b_lower: Vector3 = p_b - transform_end
			
			add_vertex(a_upper)
			add_vertex(b_upper)
			add_vertex(a_lower)
			add_vertex(b_upper)
			add_vertex(b_lower)
			add_vertex(a_lower)
			
			geometry.end()


func _process(_delta: float) -> void:
	update(start, end)


func _ready() -> void:
	geometry = ImmediateGeometry.new()
	geometry.cast_shadow = GeometryInstance.SHADOW_CASTING_SETTING_DOUBLE_SIDED
	geometry.material_override = material
	geometry.set_as_toplevel(true)

	add_child(geometry)
	geometry.global_transform = Transform()
