cbrn_maxDamage = 100; // how much damage before death, 50% starts internal contamination
cbrn_backpacks = [
    "B_SCBA_01_F",
    "rhs_rk_sht_30_emr",
    "UK3CB_TKA_O_B_RIF_Khk_Radio",
    "OLIVE_B_RadioBag_01",
    "clf_Olive_prc117g_co",
    "unv_olive_big_rt1523g",
    "rhs_rd54_emr1",
    "rhs_rd54_vest_emr1",
    "rhs_rk_sht_30_emr",
    "rhs_rk_sht_30_emr_engineer_empty",
    "rhs_rk_sht_30_olive",
    "rhs_rk_sht_30_olive_engineer_empty"
];
cbrn_suits = [
    "U_C_CBRN_Suit_01_Blue_F",
    "U_B_CBRN_Suit_01_MTP_F",
    "U_B_CBRN_Suit_01_Tropic_F",
    "U_C_CBRN_Suit_01_White_F",
    "U_B_CBRN_Suit_01_Wdl_F",
    "U_I_CBRN_Suit_01_AAF_F",
    "U_I_E_CBRN_Suit_01_EAF_F",
    "U_CBRN_B_blue",
    "UK3CB_ADC_C_Pants_U_20",
    "U_CBRN_C_blue",
    "U_CBRN_B_blue"
];
cbrn_masks = ["G_CBRN_A"];
cbrn_threatMeteritem = "ACE_microDAGR";
cbrn_maxOxygenTime = 60 * 30;

// do not edit below here unless you know what you are doing
if !(hasInterface) exitWith {};
cbrn_localZones = [];
cbrn_curThreat = 0;
cbrn_lastBeep = -1;
cbrn_beepVolume = 2;
cbrn_beep = true;
["cbrn_createZone", {
    params ["_pos", "_threatLevel", "_size", "_falloffArea", "_height"];
    private _trg = createTrigger ["EmptyDetector", _pos, false];
    _trg setVariable ["cbrn_zone", true];
    _trg enableDynamicSimulation false;
    _trg setVariable ["cbrn_active", true];
    _trg setVariable ["cbrn_threatLevel", _threatLevel];
    _trg setVariable ["cbrn_size", _size];
    _trg setVariable ["cbrn_falloffArea", _falloffArea];
    _trg setVariable ["cbrn_height", _height];
    private _radius = _size + _falloffArea;
    _trg setTriggerArea [_radius, _radius, 0, false, _radius];
    _trg setTriggerActivation ["ANYPLAYER", "PRESENT", true];
    _trg setTriggerStatements ["thisTrigger getVariable ['cbrn_active',false] && {this && {(vehicle ace_player) in thisList}}", "[thisTrigger, ace_player, true] call cbrn_fnc_addZone", "[thisTrigger, ace_player, false] call cbrn_fnc_addZone"];
    cbrn_localZones pushBack _trg;
}] call CBA_fnc_addEventhandler;


// display gas mask overlay above ace nvg and below DUI
if !(isNil "ace_nightvision") then {
    "ace_nightvision_display" cutFadeOut 0;
};
"cbrn_gasmask_overlay" cutFadeOut 0;
if !(isNil "diwako_dui_radar") then {
    "diwako_dui_compass" cutFadeOut 0;
    "diwako_dui_namebox" cutFadeOut 0;
};
