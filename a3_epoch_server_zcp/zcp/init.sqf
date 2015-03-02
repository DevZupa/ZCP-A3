/*
	Zupa's Capture Points
	Initiates the cap actions.
	Capture points and earn money over time.
*/

diag_log text format ["[ZCP]: Giving server some time to boot."];

sleep 120;

diag_log text format ["[ZCP]: Initiate Zupa's Capture Points"];
call compile preprocessFileLineNumbers "x\addons\a3_epoch_server_zcp\zcp\ZCPConfig.sqf";
call compile preprocessFileLineNumbers "x\addons\a3_epoch_server_zcp\zcp\functions\position_functions.sqf";
ZCP_fnc_cleanUpBase = call compile preprocessFile "x\addons\a3_epoch_server_zcp\zcp\functions\cleanupBase.sqf";
ZCP_fnc_find_position	= compile preprocessFileLineNumbers "x\addons\a3_epoch_server_zcp\zcp\functions\find_position.sqf";

ZCP_Data = [];

{
	ZCP_Data pushBack [true,0];
	_x execVM "x\addons\a3_epoch_server_zcp\zcp\start.sqf";	
	diag_log text format ["[ZCP]: ZCP No %1 started.",_x select 4];
}count ZCP_CapPoints;

diag_log text format ["[ZCP]: All Capture Points are running."];