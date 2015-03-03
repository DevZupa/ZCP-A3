/*
	Zupa's Capture Points
	Mission starter of ZCP
	Capture points and earn money over time.
*/

private["_currentCapper","_ZCP_continue","_ZCP_flag","_currentGroup","_ZCP_name","_ZCP_baseFile","_ZCP_baseClasses",
"_ZCP_lastOwnerChange","_proximityList","_ZCP_baseObjects","_theFlagPos","_theFlagX","_theFlagY","_XChange","_YChange",
"_ZCP_currentCapper","_ZCP_previousCapper","_ZCP_currentGroup","_ZCP_wasContested",
"_ZCP_startContested","_ZCP_index","_capturePosition","_randomTime","_changedReward","_ZCP_Halfway","_ZCP_min"
];

_randomTime = (floor random  100) + ZCP_MinWaitTime ;

diag_log text format ["[ZCP]: Waiting %1 secs for next cap point.",_randomTime];

UIsleep _randomTime;

diag_log text format ["[ZCP]: Waiting for %1 players to be online.",ZCP_Minimum_Online_Players];

waitUntil { count( playableUnits ) > ( ZCP_Minimum_Online_Players - 1 ) };

diag_log text format ["[ZCP]: %1 players reached, starting cap point.",ZCP_Minimum_Online_Players];

_capturePosition = [0,0,0];
_ZCP_name = _this select 0;
_ZCP_index = _this select 4;

if(ZCP_StaticPoints)then{
	_capturePosition = _this select 1;
	diag_log text format ["[ZCP]: %1 :Spawning static on %2",_ZCP_name,_capturePosition];
}else{
	_capturePosition = [40] call ZCP_fnc_find_position;
	diag_log text format ["[ZCP]: %1 :Spawning dynamic on %2",_ZCP_name,_capturePosition];
};

_ZCP_baseFile = format["x\addons\a3_epoch_server_zcp\zcp\capbases\%1",(ZCP_CapBases call BIS_fnc_selectRandom)];
_ZCP_baseClasses = call compile preprocessFileLineNumbers _ZCP_baseFile;	
_ZCP_baseObjects = [];

_theFlagPos = (_ZCP_baseClasses select 0) select 1;

_theFlagX = _theFlagPos select 0;
_theFlagY = _theFlagPos select 1;

_XChange = _capturePosition select 0;
_YChange = _capturePosition select 1;

_this set [1,_capturePosition];	

{ 
	private ["_obj","_pos","_nil","_newPos"];
	_obj = createVehicle [_x select 0, [0,0,0], [], 0, "CAN_COLLIDE"];
	_pos = _x select 1;
	_newPos = [((_pos select 0) - _theFlagX + _XChange), ((_pos select 1) - _theFlagY + _YChange),(_pos select 2)];
	if (_x select 4) then {
		_obj setDir (_x select 2);		
		_obj setPos _newPos; 
	} else {
		_obj setPosATL _newPos; 
		_obj setVectorDirAndUp (_x select 3);
	};
	_nil = _ZCP_baseObjects pushBack _obj;
		
}count _ZCP_baseClasses;

if(count _ZCP_baseObjects != 0)then{

	PV_ZCP_zupastic = ["ZCP",format["%1 has made Camp. Check your map for the location and claim it for your own!",_ZCP_name]];
	publicVariable "PV_ZCP_zupastic";	

	diag_log text format ["[ZCP]: %1 started.",_ZCP_name];

	(ZCP_Data select _ZCP_index) set[0,true];
	_ZCP_changedOwner = true;
	_ZCP_currentCapper = objNull;
	_ZCP_previousCapper = objNull;
	_ZCP_currentGroup = objNull;
	_ZCP_startContested = 0;	
	_ZCP_wasContested = false;
	_ZCP_continue = true;		
	_ZCP_Halfway = false;
	_ZCP_min = false;
     
	
	_this spawn { // based on wicked AI marker system.
			private["_position","_missiondata","_name","_index","_mission","_type","_marker","_dot"];		
			_position		= _this select 1;		
			_name 			= _this select 0;
			_mission 		= _this select 3;
			_index 			= _this select 4;		
			while {(ZCP_Data select _index) select 0} do {			
				_marker 		= createMarker [str(_mission), _position];
				if((ZCP_Data select _index) select 1 == 1)then{
					_marker 		setMarkerColor ZCP_CappedColor;
				}
				else{
					if((ZCP_Data select _index) select 1 == 2)then{
						_marker 		setMarkerColor ZCP_ContestColor;
					}else{
						_marker 		setMarkerColor ZCP_FreeColor;
					};
				};				
				_marker 		setMarkerShape "ELLIPSE";
				_marker 		setMarkerBrush "Solid";
				_marker 		setMarkerSize [ZCP_CapRadius*3,ZCP_CapRadius*3];
				_marker 		setMarkerText _name;
				_dot 			= createMarker [str(_mission) + "dot", _position];
				_dot 			setMarkerColor "ColorBlack";
				_dot 			setMarkerType "hd_flag";
				_dot 			setMarkerText _name;
				UIsleep 1;
				deleteMarker 	_marker;
				deleteMarker 	_dot;			
			};
		};
	
	while{_ZCP_continue}do{					
			// check if someone is close
			_proximityList = [];	
			{			
				if(isPlayer _x && alive _x)then{
					_nil =  _proximityList pushBack _x;
				};
			}count (_capturePosition nearEntities["CAManBase",ZCP_CapRadius]);

			if(count(_proximityList) == 0) then{
				_ZCP_currentCapper = objNull;
				_ZCP_previousCapper = objNull;
				(ZCP_Data select _ZCP_index) set[1,0];
				_ZCP_wasContested = false;	
				_ZCP_Halfway = false;
				_ZCP_min = false;				
			}else{	
				if(_ZCP_previousCapper in _proximityList)then{		
					_ZCP_currentCapper = _ZCP_previousCapper; 
					(ZCP_Data select _ZCP_index) set[1,1];
				}else{
					_ZCP_wasContested = false;	
					_ZCP_Halfway = false;
					_ZCP_min = false;
					_ZCP_currentCapper = _proximityList select 0;
					(ZCP_Data select _ZCP_index) set[1,1];
					PV_ZCP_zupastic = ["ZCP",format["%1 is being captured by %2. You have %3 minutes to prevent this.",_ZCP_name,name _ZCP_currentCapper,(ZCP_CapTime / 60)]];
					publicVariable "PV_ZCP_zupastic";			
				};
				_ZCP_currentGroup = group _ZCP_currentCapper;							
				{
					if( _x != _ZCP_currentCapper)then{
						if( _ZCP_currentGroup ==  grpNull || group _x != _ZCP_currentGroup)then{
						   // THere is an enemy in the zone which isn't in the capper his group. so make the circle contested.
							(ZCP_Data select _ZCP_index) set[1,2];   
						};
					};
				}count _proximityList;
											
				if(!_ZCP_wasContested)then{
					_ZCP_startContested = diag_tickTime;	
					_ZCP_wasContested = true;
				};
				// capture check		
							
				if( _ZCP_startContested != 0 && (diag_tickTime - _ZCP_startContested) >  ZCP_CapTime )then{
						// player survived for x seconds so he claimed the area							
						_ZCP_continue = false;				
						_ZCP_startContested = 0;
						_ZCP_wasContested = false;	
				};	

				if( !_ZCP_Halfway && _ZCP_startContested != 0 && (diag_tickTime - _ZCP_startContested) >  (ZCP_CapTime / 2)then{				
					PV_ZCP_zupastic = ["ZCP",format["%1 is 50% captured by %2. You still have %3 minutes to prevent this.",_ZCP_name,name _ZCP_currentCapper,(ZCP_CapTime / 2 / 60)]];
					publicVariable "PV_ZCP_zupastic";		
					_ZCP_Halfway = true;				
				};	
				
				if( !_ZCP_min && _ZCP_startContested != 0 && (diag_tickTime - _ZCP_startContested) >  (ZCP_CapTime - 60)then{					
					PV_ZCP_zupastic = ["ZCP",format["%1 is almost captured by %2. 60 seconds left. Move in!",_ZCP_name,name _ZCP_currentCapper]];
					publicVariable "PV_ZCP_zupastic";		
					_ZCP_min = false;
				};	
			
				_ZCP_previousCapper = _ZCP_currentCapper;					
			};																						
		uiSleep 1;
	};
	
	if(ZCP_RewardRelativeToPlayersOnline)then{
		_changedReward = (ZCP_KryptoReward / ZCP_ServerMaxPlayers) * (count playableUnits);
		if(_changedReward < ZCP_MinKryptoReward)then{
			_changedReward = ZCP_MinKryptoReward;
		};
		[["effectCrypto",floor(_changedReward)],owner _ZCP_currentCapper]call EPOCH_sendPublicVariableClient;					
		PV_ZCP_zupastic = ["ZCP",format["%2 captured %1 and received his %3 Krypto. The base will dismantle in seconds.",_ZCP_name,name _ZCP_currentCapper,floor(_changedReward),ZCP_BaseCleanupDelay]];
		publicVariable "PV_ZCP_zupastic";
		diag_log text format ["[ZCP]: %1 won %2, received %3 Krypto",name _ZCP_currentCapper,_ZCP_name, floor(_changedReward)];
	}else{	
		[["effectCrypto",ZCP_KryptoReward],owner _ZCP_currentCapper]call EPOCH_sendPublicVariableClient;					
		PV_ZCP_zupastic = ["ZCP",format["%2 captured %1 and received his %3 Krypto. The base will dismantle in seconds.",_ZCP_name,name _ZCP_currentCapper,ZCP_KryptoReward,ZCP_BaseCleanupDelay]];
		publicVariable "PV_ZCP_zupastic";	
		diag_log text format ["[ZCP]: %1 won %2, received %3 Krypto",name _ZCP_currentCapper,_ZCP_name,ZCP_KryptoReward];
	}	

	/* point was capped , reboot the cappoint*/ 
	(ZCP_Data select _ZCP_index) set[0,false];
	(ZCP_Data select _ZCP_index) set[1,0];
	
	diag_log text format ["[ZCP]: %1 cleaned up and ended.",_ZCP_name];
	
	_this execVM format["x\addons\a3_epoch_server_zcp\zcp\start.sqf",_this select 2];	
	
	UIsleep ZCP_BaseCleanupDelay;
	
	{
		deleteVehicle _x;
	}count _ZCP_baseObjects;
	
}else{
	diag_log text "[ZCP]: No correct Basefile found.";
};

