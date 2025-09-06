extends MeshInstance3D

func _ready() -> void:
	if !Engine.is_editor_hint():
		# Load or define your shader source
		var shader := preload("res://second_post_process.gdshader")
		
		# Create a ShaderMaterial instance in code
		var material := ShaderMaterial.new()
		material.shader = shader

		# Set the SubViewport texture as a shader parameter, if needed
		var root = self.get_tree().get_root()
		var viewport: SubViewport = root.find_child("SubViewport", true, false)
		
		material.set("shader_parameter/view_port_tex", viewport.get_texture())
		
		# Assign the material to your postprocess quad
		self.set_surface_override_material(0, material)
