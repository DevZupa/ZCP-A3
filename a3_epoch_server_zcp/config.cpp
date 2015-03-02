class CfgPatches {
	class A3_epoch_zcp {
		units[] = {};
		weapons[] = {};
		requiredVersion = 0.1;
		requiredAddons[] = {"A3_server_settings"};
	};
};
class CfgFunctions {
	class custom {
		class main {
			file = "x\addons\a3_epoch_server_zcp\init";
			class init {
				postInit = 1;
			};
		};
	};
};