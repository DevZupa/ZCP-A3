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
ZCP_MinWaitTime = 60; // seconds to wait to spawn a new capturepoint when 1 was capped.
ZCP_BaseCleanupDelay = 120; // seconds to wait to delete a captured base.
ZCP_KryptoReward = 1500; // reward for capping.

ZCP_Minimum_Online_Players = 0; // Ammount of players to be online before it allows to spawn capture points. !!! O = always

ZCP_RewardRelativeToPlayersOnline = true; // This will recalculate the reward according the amount of online players.
ZCP_ServerMaxPlayers = 60; //Only Needed to recalcuate the reward.
ZCP_MinKryptoReward = 500; // The reward can never be recalculated lower then this.

ZCP_StaticPoints = false;

// The more cappoints u have the lower the server performance.
// Location is ignored if not using static points. just put [0,0,0] then.
ZCP_CapPoints = [ // [name,[x,y,z],file in capbases folder, varname,index]
	["Cap Point Alpha",[3085.37,8775.07,0],"notUsedAnymore","alpha",0] ,
	["Cap Point Beta",[3085.37,8775.07,0],"notUsedAnymore","beta",1] 
];

// For every spawned mission, 
ZCP_CapBases = [ // located in capbases folder
"base1.sqf"
];

/* This are arma 3 colors, look up the color names if you are going to change this */
ZCP_FreeColor = "ColorIndependent"; // uncontested marker color
ZCP_CappedColor = "ColorCivilian"; // uncontested capped marker color
ZCP_ContestColor = "ColorOPFOR"; // contested capped marker color


/* Do not change this*/
ZCP_Version = "1.1";