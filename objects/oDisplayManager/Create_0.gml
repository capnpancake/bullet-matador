/// @desc 
game_set_speed(FRAMES_PER_SECOND, gamespeed_fps);

height = DISPLAY_HEIGHT;
width = DISPLAY_WIDTH;
window_scale = 3;
max_scale = DISPLAY_SCALE - 1;

if (width & 1) width++;
// if (height & 1) height++;

window_set_size(width*window_scale, height*window_scale);
alarm[0] = 1;
surface_resize(application_surface, width, height);

camera = instance_create_layer(x, y, layer, oCamera);

room_goto_next();
