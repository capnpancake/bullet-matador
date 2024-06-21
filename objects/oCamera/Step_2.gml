/// @desc 
camera_set_view_size(VIEW, view_width, view_height);

if (instance_exists(oZephyr)) {
	var _camX = clamp(oZephyr.x-view_width/2, 0, room_width-view_width);
	var _camY = clamp(oZephyr.y-view_height/2, 0, room_height-view_height);
	
	var _x = camera_get_view_x(VIEW);
	var _y = camera_get_view_y(VIEW);
	var _spd = 0.1;
	
	camera_set_view_pos(VIEW, lerp(_camX, _x, _spd), lerp(_camY, _y, _spd));
}
