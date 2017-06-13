/*
This short script measures the length of a free drawn line. It is like a mapmeassure.
No needs for input Variables.
Written by buur (derbuur@googlemail.com)

*/
if (!hasInterface) exitWith {};
findDisplay 12 displayaddEventHandler ["MouseButtonDown",
	{if (_this select 5) then
		{
			private ["_id_MouseMoving","_myActualCoordinates"];
		player setVariable [ "buur_mapmeasurer_start",((findDisplay 12) displayCtrl 51) ctrlMapScreenToWorld [(_this select 2), (_this select 3)]];
		player setVariable ["buur_mapmeasurere_myDistance",0];

		_id_MouseMoving = ((findDisplay 12) displayCtrl 51) ctrladdEventHandler ["MouseMoving",
			{_myActualCoordinates = ((findDisplay 12) displayCtrl 51) ctrlMapScreenToWorld [(_this select 1),(_this select 2)];
				private ["_myDistance","_myStartCoordinates","_myActualCoordinates"];
				_myDistance = player getVariable "buur_mapmeasurere_myDistance";
				_myStartCoordinates = player getVariable "buur_mapmeasurer_start";
				_myDistance =  (_myActualCoordinates distance2D _myStartCoordinates) + _myDistance;
			player setVariable [ "buur_mapmeasurer_start",_myActualCoordinates];
			player setVariable ["buur_mapmeasurere_myDistance",_myDistance];
			}
			];
			player setVariable ["buur_mapmeasurer_id_MouseMoving",_id_MouseMoving];
		}
	}
	];
findDisplay 12 displayaddEventHandler ["MouseButtonUp",
	{if ((isnil str (player getVariable "buur_mapmeasurere_myDistance")) && ((player getVariable "buur_mapmeasurere_myDistance") > 1)) then
		{
			private ["_displaytext","_id_MouseMoving"];
			_displaytext =  format ["Distance: %1 meters",round (player getVariable "buur_mapmeasurere_myDistance")];
			if (("ace_common" in configSourceAddonList (configFile )) && ("ace_interaction" in configSourceAddonList (configFile ))  ) then
				{
					if (("ACE_MapTools" in items player)) then
						{
							[_displaytext] call ace_common_fnc_displayTextStructured;
						};
				}
			else
			  {
					hint _displaytext;
				};
			player setVariable ["buur_mapmeasurere_myDistance", nil];
			player setVariable ["buur_mapmeasurer_start", nil];
			_id_MouseMoving = player getVariable "buur_mapmeasurer_id_MouseMoving";
			((findDisplay 12) displayCtrl 51) ctrlRemoveEventHandler ["MouseMoving",_id_MouseMoving];
		};
	}];
