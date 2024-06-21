/// @desc
switch (state) {
	case PLAYERSTATE.IDLE:
		player_state_idle();
		break;
		
	case PLAYERSTATE.RUNSTART:
		player_state_runstart();
		break;
	
	case PLAYERSTATE.RUN:
		player_state_run();
		break;
	
	case PLAYERSTATE.SKID:
		player_state_skid();
		break;
	
	case PLAYERSTATE.ATTACK:
		player_state_attack();
		break;
	
	default:
		break;
}