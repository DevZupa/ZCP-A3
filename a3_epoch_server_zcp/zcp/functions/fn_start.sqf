/*
	Zupa's Capture Points
	Mission starter of ZCP
	Capture points and earn money over time.

	╔════╗─────────╔═══╗────────╔╗─────────────╔╗
	╚══╗═║─────────╚╗╔╗║────────║║────────────╔╝╚╗
	──╔╝╔╬╗╔╦══╦══╗─║║║╠══╦╗╔╦══╣║╔══╦╗╔╦══╦═╗╚╗╔╬══╗
	─╔╝╔╝║║║║╔╗║╔╗║─║║║║║═╣╚╝║║═╣║║╔╗║╚╝║║═╣╔╗╗║║║══╣
	╔╝═╚═╣╚╝║╚╝║╔╗║╔╝╚╝║║═╬╗╔╣║═╣╚╣╚╝║║║║║═╣║║║║╚╬══║
	╚════╩══╣╔═╩╝╚╝╚═══╩══╝╚╝╚══╩═╩══╩╩╩╩══╩╝╚╝╚═╩══╝
	────────║║
	────────╚╝
*/

private["_currentCapper","_ZCP_continue","_ZCP_flag","_currentGroup","_ZCP_name","_ZCP_baseFile","_ZCP_baseClasses",
"_ZCP_lastOwnerChange","_proximityList","_ZCP_baseObjects","_theFlagPos","_theFlagX","_theFlagY","_XChange","_YChange",
"_ZCP_currentCapper","_ZCP_previousCapper","_ZCP_currentGroup","_ZCP_wasContested",
"_ZCP_startContested","_ZCP_index","_capturePosition","_randomTime","_changedReward","_ZCP_Halfway","_ZCP_min"
];

_capturePosition = [0,0,0];
_ZCP_name = _this select 0;
_ZCP_index = _this select 4;
_randomTime = 100;

if( (ZCP_Data select _ZCP_index) select 2) then {
	_randomTime = (floor random ZCP_WaitPeriodRandom) + ZCP_MinWaitTime;	
} else {
	_randomTime = (floor random ZCP_WaitPeriodRandom) + ZCP_StartMinWaitTime;		
};

(ZCP_Data select _ZCP_index) set[2, false];

uiSleep _randomTime;
diag_log text format ["[ZCP]: Waiting for %1 players to be online.",ZCP_Minimum_Online_Players];
waitUntil { count( playableUnits ) > ( ZCP_Minimum_Online_Players - 1 ) };
diag_log text format ["[ZCP]: %1 players reached, starting cap point.",ZCP_Minimum_Online_Players];

if(ZCP_StaticPoints)then{
	_capturePosition = _this select 1;
	diag_log text format ["[ZCP]: %1 :Spawning static on %2",_ZCP_name,_capturePosition];
}else{
	_capturePosition = [40] call ZCP_fnc_findPosition;
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

_ZCP_baseObjects = _ZCP_baseClasses call ZCP_fnc_createBase;

if(count _ZCP_baseObjects != 0)then{

	PV_ZCP_zupastic = ["ZCP",format["%1 has made Camp. Check your map for the location and claim it for your own!",_ZCP_name]];
	publicVariable "PV_ZCP_zupastic";	
	diag_log text format ["[ZCP]: %1 started.",_ZCP_name];

	_ZCP_changedOwner = true;
	_ZCP_currentCapper = objNull;
	_ZCP_previousCapper = objNull;
	_ZCP_currentGroup = objNull;
	_ZCP_startContested = 0;	
	_ZCP_wasContested = false;
	_ZCP_continue = true;		
	_ZCP_Halfway = false;
	_ZCP_min = false;
     	
	_this spawn ZCP_fnc_keepMarker;
	
	while{_ZCP_continue}do{					
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
							(ZCP_Data select _ZCP_index) set[1,2];   
						};
					};
				}count _proximityList;
											
				if(!_ZCP_wasContested)then{
					_ZCP_startContested = diag_tickTime;	
					_ZCP_wasContested = true;
				};
										
				if( _ZCP_startContested != 0 && (diag_tickTime - _ZCP_startContested) >  ZCP_CapTime )then{						
						_ZCP_continue = false;				
						_ZCP_startContested = 0;
						_ZCP_wasContested = false;	
				};	

				if( !_ZCP_Halfway && _ZCP_startContested != 0 && (diag_tickTime - _ZCP_startContested) >  (ZCP_CapTime / 2))then{				
					PV_ZCP_zupastic = ["ZCP",format["%1 is 50%4 captured by %2. You still have %3 minutes to prevent this.",_ZCP_name,name _ZCP_currentCapper,(ZCP_CapTime / 2 / 60),"%"]];
					publicVariable "PV_ZCP_zupastic";		
					_ZCP_Halfway = true;				
				};	
				
				if( !_ZCP_min && _ZCP_startContested != 0 && (diag_tickTime - _ZCP_startContested) >  (ZCP_CapTime - 60))then{					
					PV_ZCP_zupastic = ["ZCP",format["%1 is almost captured by %2. 60 seconds left. Move in!",_ZCP_name,name _ZCP_currentCapper]];
					publicVariable "PV_ZCP_zupastic";		
					_ZCP_min = true;
				};	
			
				_ZCP_previousCapper = _ZCP_currentCapper;					
			};																						
		uiSleep 1;
	};
	
	[_ZCP_currentCapper,_ZCP_name,_capturePosition,_this select 2] call ZCP_fnc_giveReward;
	(ZCP_Data select _ZCP_index) set[0,false];
	(ZCP_Data select _ZCP_index) set[1,0];
	ZCP_MissionCounter = ZCP_MissionCounter - 1;
	diag_log text format ["[ZCP]: %1 cleaned up and ended.",_ZCP_name];	
	[] spawn ZCP_fnc_missionLooper;		
	uiSleep ZCP_BaseCleanupDelay;
	_ZCP_baseObjects spawn ZCP_fnc_cleanupBase;	
}else{
	diag_log text "[ZCP]: No correct Basefile found.";
};

