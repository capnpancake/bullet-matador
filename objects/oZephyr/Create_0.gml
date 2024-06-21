// @desc

// inputs
left = 0;
right = 0;
up = 0;
down = 0;
attack = 0;

port = 0;

// attributes
storedDir = {
	angle: 0,
	horz: 0,
	vert: 0
}
dir = {
	angle: 0,
	horz: 0,
	vert: 0
};
skidFrames = 10;
skidCancel = false;
spd = 3;
dashSpd = 5;

image_speed = 1;

enum PLAYERSTATE {
	IDLE,
	RUN,
	RUNSTART,
	DASH,
	SKID,
	ATTACK,
	CLANK,
	DAMAGED,
	DIE
}
state = PLAYERSTATE.IDLE;

//@func getDirection()
//@desc calculate horizontal and vertical directions and angle value
//@return {struct} angle: Real, horz: Real, vert: Real
function getDirection() {
	var _horzDir = right-left;
	var _vertDir = down-up;

	// SOCD sanitation
	if (right && left) _horzDir = dir.horz;
	if (down && up) _vertDir = dir.vert;

	var tempDir = {
		angle: dir.angle,
		horz: _horzDir,
		vert: _vertDir
	};
	
	if (_horzDir == 1 && _vertDir == 0) tempDir.angle = 0;
	if (_horzDir == 1 && _vertDir == -1) tempDir.angle = 45;
	if (_horzDir == 0 && _vertDir == -1) tempDir.angle = 90;
	if (_horzDir == -1 && _vertDir == -1) tempDir.angle = 135;
	if (_horzDir == -1 && _vertDir == 0) tempDir.angle = 180;
	if (_horzDir == -1 && _vertDir == 1) tempDir.angle = 225;
	if (_horzDir == 0 && _vertDir == 1) tempDir.angle = 270;
	if (_horzDir == 1 && _vertDir == 1) tempDir.angle = 315;
	
	return tempDir;
}

// @func getPenaltySkidFrames(clockwise, ctrClockwise, targetAngle)
// @desc determine the amount of frames the player is locked into the skid based on the severity of the angle increase
function getPenaltySkidFrames(_clockwise, _ctrClockwise, _targetAngle) {
	if (dir.horz == 0 && dir.vert == 0) return 4;
	if (_clockwise - _targetAngle <= 90 && _targetAngle - _ctrClockwise <= 90) return 6;
	return 10;
}

// @func setOctagonalSprite(stateDesc)
// @desc Generate string reference and set sprite_index to the requested sprite
// @param {String} unique aspect of sprite name reference (i.e. 'sZephyr'+stateDesc+{angle})
function setOctagonalSprite(stateDesc) {
	var spriteName = "sZephyr" + stateDesc + string(dir.angle);
	if (stateDesc == "Skid") spriteName = "sZephyrSkid";
	if (sprite_index != asset_get_index(spriteName)) {
		var index = asset_get_index(spriteName);
		if (index > -1) {
			image_index = 0;
			sprite_index = index;
		}
		return true;
	} else return false;
}

// >>>>> START - state machine methods <<<<<

// func player_state_idle
function player_state_idle() {
	dir = getDirection();
	setOctagonalSprite("Stand");
    if (right || left || up || down) {
		dir = getDirection();
		state = PLAYERSTATE.RUNSTART;
		return;
    }
	if (attack) {
		state = PLAYERSTATE.ATTACK;
		return;
	}
}

// func player_state_run
function player_state_run() {
	storedDir = dir;
	dir = getDirection();
	var _moveX = dir.horz*spd*1.5;
	var _moveY = dir.vert*spd;

	var clockwise = storedDir.angle - 45;
	var ctrClockwise = storedDir.angle + 45;
	var targetAngle = dir.angle;

	if (dir.angle == 0 && storedDir.angle >= 180) {
		targetAngle = 360;
	}
	if (storedDir.angle == 0 && dir.angle >= 180) {
		clockwise += 360;
		ctrClockwise += 360;
	}

	if (
		(_moveX != 0 || _moveY != 0) &&
		(ctrClockwise >= targetAngle && clockwise <= targetAngle)
	) {
	  if (place_meeting(x+_moveX, y+_moveY, oIsoFloor)) {
			x += _moveX;
			y += _moveY;
		}
		setOctagonalSprite("Run");
	} else {
		skidFrames = 10;
		skidCancel = false;
		alarm[0] = getPenaltySkidFrames(clockwise, ctrClockwise, targetAngle);
		state = PLAYERSTATE.SKID;
	}
	if (attack) {
		state = PLAYERSTATE.ATTACK;
		return;
	}
}

// func player_state_runstart
function player_state_runstart() {
	var _moveX = dir.horz*dashSpd*1.5;
	var _moveY = dir.vert*dashSpd;
	
	if (place_meeting(x+_moveX, y+_moveY, oIsoFloor)) {
		x += _moveX;
		y += _moveY;
	}
	setOctagonalSprite("RunStart");
	if (animation_end()) state = PLAYERSTATE.RUN;
	if (attack) {
		// TODO: dash attack code
		//state = PLAYERSTATE.DASHATTACK;
		//return;
	}
}
	

// func player_state_skid
function player_state_skid() {
	setOctagonalSprite("Skid");

	var _skidFriction = 1;
	var _moveX = (skidFrames/2)*storedDir.horz*1.5;
	var _moveY = (skidFrames/2)*storedDir.vert;
	skidFrames -= _skidFriction;

	if (place_meeting(x+_moveX, y+_moveY, oIsoFloor)) {
		x += _moveX;
		y += _moveY;
	}
	
	if (skidCancel) {
		if (left-right != 0 || down-up != 0) {
			dir = getDirection();
			state = PLAYERSTATE.RUNSTART;
			return;
		}
		if (attack) {
			state = PLAYERSTATE.ATTACK;
			return;
		}
	}

	if (skidFrames <= 0) { // TODO: animation to be added. logic is superficial
		state = PLAYERSTATE.IDLE;
	}
}

// func player_state_attack
function player_state_attack() {
	if (setOctagonalSprite("Slash")) {
		with(instance_create_layer(x, y, layer, oZephyrHitbox)) {
			sprite_index = asset_get_index("sZephyrSlashHitbox");
			image_angle = other.dir;
			image_index = 0;
			image_speed = 1;
			//playerRef = other.id;
		}
		show_debug_message("attacking!");
	} else {
		if (animation_end()) {
			state = PLAYERSTATE.IDLE;
		}
	}
}
