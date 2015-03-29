class CfgPatches {
	class A3_epoch_zcp {
		units[] = {};
		weapons[] = {};
		requiredVersion = 0.1;
		requiredAddons[] = {"A3_server_settings"};
	};
};
class CfgFunctions {
	class zcp {
		class main {
			file = "x\addons\a3_epoch_server_zcp\zcp";
			class init {postInit = 1;};
			class config {};
			class missionLooper {};

		};
		class compileFunctions {
			file = "x\addons\a3_epoch_server_zcp\zcp\functions";
			class inDebug {};
			class nearWater {};
			class paraDrop {};
			class start {};
			class findPosition {};
			class cleanupBase {};
			class initCPData {};
			class giveReward {};
			class keepMarker {};
			class createBase {};
		};
	};
};