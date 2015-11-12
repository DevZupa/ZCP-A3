private ["_i","_safepos","_validspot","_position"];

//      _this select 0: center position (Array)
//						Note: passing [] (empty Array), the world's safePositionAnchor entry will be used.
//	_this select 1: minimum distance from the center position (Number)
//	_this select 2: maximum distance from the center position (Number)
//						Note: passing -1, the world's safePositionRadius entry will be used.
//	_this select 3: minimum distance from the nearest object (Number)
//	_this select 4: water mode (Number)
//						0: cannot be in water
//						1: can either be in water or not
//						2: must be in water
//	_this select 5: maximum terrain gradient (average altitude difference in meters - Number)
//	_this select 6: shore mode (Number):
//						0: does not have to be at a shore
//						1: must be at a shore
// 	_safepos = [getMarkerPos "center",0,8500,10,0,0.5,0];	
//  	_safepos = [[15000,15000,0],0,15000,10,0,80,0];
//	_safepos = [getMarkerPos "center", 0 , (getMarkerPos "center") select 0, 10, 0, 50, 0];

_safepos		= [getMarkerPos "center",0,8500,(_this select 0),0,0.5,0];
_validspot 	= false;
_i 			= 1;
while{!_validspot} do {
	sleep 1;
	_position 	= _safepos call BIS_fnc_findSafePos;
	_i 			= _i + 1;
	_validspot	= true;
	if (_position call ZCP_fnc_inDebug) then { 
		_validspot = false; 
	}; 
	if(_validspot ) then {
		if ([_position,10] call ZCP_fnc_nearWater) then { 
		_validspot = false;
		}; 
	};
};
_position set [2, 0];
_position
