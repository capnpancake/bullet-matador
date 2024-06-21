// initialize global variables and constants

// display and camera constants
#macro VIEW view_camera[0]
#macro DISPLAY_SCALE 4
#macro ASPECT_RATIO (display_get_width()/display_get_height())
#macro DISPLAY_HEIGHT (1080/DISPLAY_SCALE)
#macro DISPLAY_WIDTH round(DISPLAY_HEIGHT*ASPECT_RATIO)
#macro FRAMES_PER_SECOND 60
