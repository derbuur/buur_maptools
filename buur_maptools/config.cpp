class CfgPatches
{
    class buur_maptools
    {
        units[] = {};
        weapons[] = {};
        requiredVersion = 1.70;
        requiredAddons[] = {};
		version = "1.0";
		versionStr = "1.0";
		author = "[SeL] buur // Thomas";
		authorUrl = "http://spezialeinheit-luchs.de/";
    };
};

class CfgFunctions {
	class buur_maptools {
		tag = "buur_maptools";
		class init {
			file = "buur_maptools\functions";
			class init { postInit = 1; };
      class mapmeasure {};
      class straight_lines {};
		};
	};
};
