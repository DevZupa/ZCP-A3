/*
	Zupa's Capture Points
	Configuration of ZCP
	Capture points and earn money over time.
*/

// First person in the Cap zone is the capper (If he leaves, the closest on of the group is the new capper but time is reset!).
// When multiple people are in the zone and not in the same group, the zone is contested.
// Being first in the zone starts the timer.
// Holding a zone  gives you a reward after x Min.

ZCP_CapTime = 300; // Seconds to cap an area uncontested
ZCP_CapRadius = 70; // Meter radius of the capture circle around the flag.

ZCP_KryptoReward = 1000; // reward for capping

ZCP_StaticPoints = false;

// The more cappoints u have the lower the server performance.
// Location is ignored if not using static points. just put [0,0,0] then.
ZCP_CapPoints = [ // [name,[x,y,z],file in capbases folder, varname,index]
	["Cap Point Alpha",[3085.37,8775.07,0],"notUsedAnymore","alpha",0] ,
	["Cap Point Beta",[3085.37,8775.07,0],"notUsedAnymore","beta",1] 
];
ZCP_CapBases = [ // located in capbases folder
"base1.sqf"
];

ZCP_FreeColor = "ColorIndependent"; // uncontested marker color
ZCP_CappedColor = "ColorCivilian"; // uncontested capped marker color
ZCP_ContestColor = "ColorOPFOR"; // contested capped marker color

ZCP_MinWaitTime = 60; // seconds to wait to spawn a new capturepoint when 1 was capped.

ZCP_Version = "1.0";
