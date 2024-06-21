/// @desc 
// image details
sprite = sGrass;
count = 200;
frames = sprite_get_number(sprite);
texture = sprite_get_texture(sprite, 0);
width = sprite_get_width(sprite);
height = sprite_get_height(sprite);
color = c_white;
alpha = 1;

// 3D settings
gpu_set_alphatestenable(true);
gpu_set_ztestenable(true);

// store vertex format
vertex_format_begin();
vertex_format_add_position_3d();
vertex_format_add_texcoord();
vertex_format_add_color();
format = vertex_format_end();

// vertex buffer
vbuff = vertex_create_buffer();
vertex_begin(vbuff, format);
repeat(count) {
	
}