/*
	Zupa's Capture Points
	Configuration of ZCP
	Capture points and earn rewards.

	╔════╗─────────╔═══╗────────╔╗─────────────╔╗
	╚══╗═║─────────╚╗╔╗║────────║║────────────╔╝╚╗
	──╔╝╔╬╗╔╦══╦══╗─║║║╠══╦╗╔╦══╣║╔══╦╗╔╦══╦═╗╚╗╔╬══╗
	─╔╝╔╝║║║║╔╗║╔╗║─║║║║║═╣╚╝║║═╣║║╔╗║╚╝║║═╣╔╗╗║║║══╣
	╔╝═╚═╣╚╝║╚╝║╔╗║╔╝╚╝║║═╬╗╔╣║═╣╚╣╚╝║║║║║═╣║║║║╚╬══║
	╚════╩══╣╔═╩╝╚╝╚═══╩══╝╚╝╚══╩═╩══╩╩╩╩══╩╝╚╝╚═╩══╝
	────────║║
	────────╚╝
*/

// First person in the Cap zone is the capper (If he leaves, the closest on of the group is the new capper but time is reset!).
// When multiple people are in the zone and not in the same group, the zone is contested.
// Being first in the zone starts the timer.
// Holding a zone  gives you a reward after x Min.

ZCP_CapTime = 600; // Seconds to cap an area uncontested
ZCP_CapRadius = 70; // Meter radius of the capture circle around the first object.
ZCP_MinWaitTime = 20; // seconds to wait to spawn a new capturepoint when 1 was capped.
ZCP_StartMinWaitTime = 20 // seconds to wait to spawn the FIRST capturepoints wave.
ZCP_WaitPeriodRandom = 100 // random period in seconds added to first start time to let the mission spawn not all at once.
ZCP_BaseCleanupDelay = 300; // seconds to wait to delete a captured base.
ZCP_MaxMissions = 2; // Ammount of cap points at the same time.
ZCP_Minimum_Online_Players = 0; // Ammount of players to be online before it allows to spawn capture points. !!! O = always

ZCP_RewardRelativeToPlayersOnline = true; // This will recalculate the crypto reward according the amount of online players.
ZCP_KryptoReward = 1500; // Crypto reward for capping.
ZCP_ServerMaxPlayers = 60; // Only needed to recalcuate the reward.
ZCP_MinKryptoReward = 500; // The crypto reward can never be recalculated lower then this.

ZCP_VehicleReward = ["B_Truck_01_box_EPOCH","B_Truck_01_box_EPOCH","B_Truck_01_box_EPOCH"]; // Vehicle classes for vehicle reward

ZCP_WeaponReward = [["LMG_Zafir_F",1],["Machinegun_arifle_MX_SW_F",1],["arifle_MX_SW_Black_F",1],["1911_pistol_epoch",1],["arifle_TRG21_F",1]]; // Classname + amount in an array in the reward array for weapons
ZCP_ItemWeaponReward = [["optic_NVS",1]]; // Ammo is assigned automaticly.

ZCP_BuildingReward = [['PartPlankPack',8],['KitStudWall',4],["KitFoundation",2],["KitWoodFloor",2],['KitPlotPole',1],['ItemLockbox',1],['KitShelf',1],['KitCinderWall',2],['CircuitParts',1]]; // Classname + amount in an array in the reward array for buildings

ZCP_StaticPoints = false; // If true, the missions will use the provided location as spawnpoint.

// Server will keep as many missions up as ZCP_MaxMissions, And they will be randomly choosen from the following list
// Location is ignored if not using static points. just put [0,0,0] then.
// valid rewards -> Crypto , WeaponBox , BuildBox , Vehicle
ZCP_CapPoints = [ // [name,[x,y,z],reward, varname,index]
	["Cap Point Alpha",[3085.37,8775.07,0],"Crypto","alpha",0] ,
	["Cap Point Bravo",[3085.37,8775.07,0],"WeaponBox","beta",1] ,
	["Cap Point Charlie",[3085.37,8775.07,0],"BuildBox","charlie",2] ,
	["Cap Point Delta",[3085.37,8775.07,0],"Vehicle","delta",3] 
];

// For every spawned mission, 
ZCP_CapBases = [ // located in capbases folder
	"base1.sqf"
];

/* These are arma 3 colors, look up the color naming if you are going to change this */
ZCP_FreeColor = "ColorIndependent"; // uncontested marker color
ZCP_CappedColor = "ColorCivilian"; // uncontested capped marker color
ZCP_ContestColor = "ColorOPFOR"; // contested capped marker color

ZCP_DisableVehicleReward = false; // Because it doesnt save without changing epoch code.
/* Do not change this*/
ZCP_Version = "2.0";
ZCP_Data = [];
ZCP_MissionCounter = 0;
