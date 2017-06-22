/*
This short script draws a straight line on the map while pressing the lef alt key.
No needs for input Variables.
Written by buur (derbuur@googlemail.com)

Also thanks to pierremgi for finding selected color and Killzonekid for scaling the line.

*/

if (!hasInterface) exitWith {};
missionNamespace setVariable ["buur_straight_lines_MarkerID",100000];

0 = [] spawn {
  waitUntil {!isnull (findDisplay 12)};
  colors = ["colorBlack","colorRed","colorYellow","colorGreen","colorBlue","colorWhite","colorBLUFOR","colorOPFOR","colorIndependent","colorCivilian","colorUNKNOWN"];
    _handle = (findDisplay 12 displayCtrl 1090) ctrlSetEventHandler ["LBSelChanged",
			"player setVariable ['buur_straight_lines_myColor',colors select (lbCurSel (_this select 0))];
      false"
   ]
};

findDisplay 12 displayaddEventHandler ["MouseButtonDown",
		{if (_this select 6) then
			{
					player setVariable ["buur_straight_lines_myStartCoordinates",((findDisplay 12) displayCtrl 51) ctrlMapScreenToWorld [(_this select 2), (_this select 3)]];
					player setVariable ["buur_straight_lines_myActualCoordinates",(player getVariable "buur_straight_lines_myStartCoordinates")];


					_id_MouseMoving = ((findDisplay 12) displayCtrl 51) ctrladdEventHandler
						["MouseMoving",
							{player setVariable ["buur_straight_lines_myActualCoordinates", ((findDisplay 12) displayCtrl 51) ctrlMapScreenToWorld [(_this select 1),(_this select 2)]];
							_meters = round ((player getVariable "buur_straight_lines_myActualCoordinates") distance2D (player getVariable "buur_straight_lines_myStartCoordinates"));
							_azimuth = round ((player getVariable "buur_straight_lines_myStartCoordinates") getDir (player getVariable "buur_straight_lines_myActualCoordinates"));
              _displaytext = format ["Distance: %1, Direction: %2",_meters,_azimuth];

              if (("ace_common" in configSourceAddonList (configFile )) && ("ace_interaction" in configSourceAddonList (configFile ))  ) then
        				{
        					if (("ACE_MapTools" in items player)) then
        						{
        							[_displaytext,false,1] call ace_common_fnc_displayText;
        						};
        				}
        			else
        			  {
        					hint _displaytext;
        				};

              }
						];

					_id_Draw = findDisplay 12 displayCtrl 51 ctrlAddEventHandler ["Draw",
						{
							_this select 0 drawLine
							[
								(player getVariable "buur_straight_lines_myStartCoordinates"), (player getVariable "buur_straight_lines_myActualCoordinates"), [1,0,0,1]
							];
						}
					];

					player setVariable ["buur_straight_lines_id_MouseMoving",_id_MouseMoving];
					player setVariable ["buur_straight_lines_id_Draw",_id_Draw];
			}
		}
	];

findDisplay 12 displayaddEventHandler
	["MouseButtonUp",
		{if ((_this select 6) && (isnil str (player getVariable "buur_straight_lines_myStartCoordinates"))) then
			{
				_id_MouseMoving = player getVariable "buur_straight_lines_id_MouseMoving";
				_id_Draw = player getVariable "buur_straight_lines_id_Draw";
        _myStartCoordinates = player getVariable "buur_straight_lines_myStartCoordinates";
        _myActualCoordinates = player getVariable "buur_straight_lines_myActualCoordinates";

        _myCenterCoordinates = [(((_myStartCoordinates select 0) + (_myActualCoordinates select 0)) / 2),(((_myStartCoordinates select 1) + (_myActualCoordinates select 1)) / 2),0];
        _myDirection = _myStartCoordinates getDir _myActualCoordinates;
        _mylenght = (_myStartCoordinates distance _myActualCoordinates)/2;


        _lastMarkerID = missionNamespace getVariable "buur_straight_lines_MarkerID";
        _newMarkerID = _lastMarkerID + 1;
        missionNamespace setVariable ["buur_straight_lines_MarkerID",_newMarkerID];

        _myMarkerName = "_USER_DEFINED #" + str clientOwner + "/" + str _newMarkerID + "/" + str currentChannel;
				_myColor = player getVariable ["buur_straight_lines_myColor","colorBlack"];
        _mywidth = (sqrt worldsize)/5;

        _myMarkerName = createMarker [_myMarkerName,_myCenterCoordinates];
        _myMarkerName setMarkerShape "RECTANGLE";
        _myMarkerName setMarkerDir _myDirection;
        _myMarkerName setMarkerSize [_mywidth, _mylenght];
        _myMarkerName setMarkerColor _myColor;
				_myMarkerName setMarkerBrush "SolidFull";



				((findDisplay 12) displayCtrl 51) ctrlRemoveEventHandler ["Draw",_id_Draw];
				((findDisplay 12) displayCtrl 51) ctrlRemoveEventHandler ["MouseMoving",_id_MouseMoving];
				player setVariable ["buur_straight_lines_myStartCoordinates",nil];
				player setVariable ["buur_straight_lines_myActualCoordinates",nil];
			}
      else
      {
        _id_MouseMoving = player getVariable "buur_straight_lines_id_MouseMoving";
				_id_Draw = player getVariable "buur_straight_lines_id_Draw";

        ((findDisplay 12) displayCtrl 51) ctrlRemoveEventHandler ["Draw",_id_Draw];
        ((findDisplay 12) displayCtrl 51) ctrlRemoveEventHandler ["MouseMoving",_id_MouseMoving];
        player setVariable ["buur_straight_lines_myStartCoordinates",nil];
        player setVariable ["buur_straight_lines_myActualCoordinates",nil];
      };
		}
	];


	0 = 0 spawn {
	    waitUntil {!isNull findDisplay 12};
	    findDisplay 12 displayCtrl 51 ctrlAddEventHandler ["Draw", {
	        if (visibleMap) then {
	            _scale = ctrlMapScale (_this select 0);
	            {
	                _m = "#markerSize_" + _x;
	                if (parseNumber ((_x splitString "/") select 1) >= 100000) then {
	                    if (isNil {player getVariable _m}) then {
	                        player setVariable [_m, markerSize _x];
	                    };
	                    _x setMarkerSizeLocal [
	                        ((player getVariable _m) select 0) * _scale,
	                        ((player getVariable _m) select 1)
	                    ];
	                };
	            } forEach allMapMarkers;
	        };
	    }];
	};
