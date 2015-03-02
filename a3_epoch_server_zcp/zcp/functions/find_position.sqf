/*
* 	THese are modified WAI FUNCTIONS
*/

if(isServer) then {	
	private ["_i","_safepos","_validspot","_position"];
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
			if ([_position,10] call ZCP_fnc_isNearWater) then { 
			_validspot = false;
			}; 
		};
	};
	_position set [2, 0];
	_position
};