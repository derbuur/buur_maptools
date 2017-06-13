
call buur_maptools_fnc_straight_lines;
call buur_maptools_fnc_mapmeasure;

player createDiarySubject ["buur_maptools","Maptools"];
player createDiaryRecord ["buur_maptools", ["mapmeasurer", "If you are playing with ACE3 and you have the maptools, distance of a free drawn line will shown."]];
player createDiaryRecord ["buur_maptools", ["straight lines", "While hold the alt key and left mouse button straight line will be drawn.<br /> If you releas alt key before left mouse button drawing will interupted. <br />If you are playing with ACE3, and you have the maptool, distance and  angel will shown."]];
