#include <a_samp> //DEVELOPED BY ANTICHEAT
#include <zcmd>

#pragma warning disable 203

#define GIFT_MODEL      19054  
#define RED_NEON_MODEL  18647
#define WREATH          19060
#define REWARD_AMOUNT   1000    
#define MUSIC_URL       "Song url" //add song url
#define MUSIC_LENGTH    75

new MusicTimer[MAX_PLAYERS];
new XmasTruck = INVALID_VEHICLE_ID;
new XmasGifts[5];
new ExtraObjects[11];
new bool:MusicPlaying[MAX_PLAYERS];

forward MusicCheck();
forward ReplayMusic(playerid);

public ReplayMusic(playerid)
{
    if(!IsPlayerConnected(playerid)) return 0;

    if(XmasTruck == INVALID_VEHICLE_ID) return 0;

    new Float:vx, Float:vy, Float:vz;
    GetVehiclePos(XmasTruck, vx, vy, vz);

    if(IsPlayerInRangeOfPoint(playerid, 35.0, vx, vy, vz))
    {
        StopAudioStreamForPlayer(playerid);
        PlayAudioStreamForPlayer(playerid, MUSIC_URL);

        MusicTimer[playerid] = SetTimerEx("ReplayMusic", MUSIC_LENGTH * 1000, false, "i", playerid);
    }
    return 1;
}


public OnFilterScriptInit()
{
    print("\n-------------------------------------------");
    print(" Xmas Truck Script By AnTiChEaT Loaded!      ");
    print("-------------------------------------------\n");
    
    SetTimer("MusicCheck", 2000, true);
    return 1;
}

public OnFilterScriptExit()
{
    CleanupTruck();
    return 1;
}

stock CleanupTruck()
{
    if(XmasTruck != INVALID_VEHICLE_ID)
    {
        DestroyVehicle(XmasTruck);
        for(new i = 0; i < sizeof(ExtraObjects); i++)
        {
            if(IsValidObject(ExtraObjects[i])) DestroyObject(ExtraObjects[i]);
            ExtraObjects[i] = INVALID_OBJECT_ID;
        }
        XmasTruck = INVALID_VEHICLE_ID;
    }
}


CMD:xmastruck(playerid, params[])
{
    new Float:x, Float:y, Float:z, Float:a;
    GetPlayerPos(playerid, x, y, z);
    GetPlayerFacingAngle(playerid, a);

    CleanupTruck();

    XmasTruck = CreateVehicle(573, x + 2, y + 2, z + 1, a, 3, 1, -1);
    
    ExtraObjects[0] = CreateObject(RED_NEON_MODEL, 0, 0, 0, 0, 0, 0);
    AttachObjectToVehicle(ExtraObjects[0], XmasTruck, -1.2, 0.0, -1.3, 0.0, 0.0, 0.0);
    ExtraObjects[1] = CreateObject(RED_NEON_MODEL, 0, 0, 0, 0, 0, 0);
    AttachObjectToVehicle(ExtraObjects[1], XmasTruck, 1.2, 0.0, -1.3, 0.0, 0.0, 0.0);

    ExtraObjects[2] = CreateObject(WREATH, 0, 0, 0, 0, 0, 0);
    AttachObjectToVehicle(ExtraObjects[2], XmasTruck, 0.0, 3.3, 0.5, 90.0, 0.0, 0.0);

    ExtraObjects[3] = CreateObject(GIFT_MODEL, 0, 0, 0, 0, 0, 0);
    AttachObjectToVehicle(ExtraObjects[3], XmasTruck, -0.5, -2.5, 1.8, 0.0, 0.0, 0.0);

    ExtraObjects[4] = CreateObject(GIFT_MODEL, 0, 0, 0, 0, 0, 0);
    AttachObjectToVehicle(ExtraObjects[4], XmasTruck, 0.5, -2.5, 1.8, 0.0, 0.0, 0.0);

    ExtraObjects[5] = CreateObject(GIFT_MODEL, 0, 0, 0, 0, 0, 0);
    AttachObjectToVehicle(ExtraObjects[5], XmasTruck, -0.5, -1.5, 1.8, 0.0, 0.0, 0.0);

    ExtraObjects[6] = CreateObject(GIFT_MODEL, 0, 0, 0, 0, 0, 0);
    AttachObjectToVehicle(ExtraObjects[6], XmasTruck, 0.5, -1.5, 1.8, 0.0, 0.0, 0.0);

    ExtraObjects[7] = CreateObject(GIFT_MODEL, 0, 0, 0, 0, 0, 0);
    AttachObjectToVehicle(ExtraObjects[7], XmasTruck, -0.5, -0.5, 1.8, 0.0, 0.0, 0.0);

    ExtraObjects[8] = CreateObject(GIFT_MODEL, 0, 0, 0, 0, 0, 0);
    AttachObjectToVehicle(ExtraObjects[8], XmasTruck, 0.5, -0.5, 1.8, 0.0, 0.0, 0.0);

    ExtraObjects[9] = CreateObject(GIFT_MODEL, 0, 0, 0, 0, 0, 0);
    AttachObjectToVehicle(ExtraObjects[9], XmasTruck, -0.5, 0.5, 1.8, 0.0, 0.0, 0.0);

    ExtraObjects[10] = CreateObject(GIFT_MODEL, 0, 0, 0, 0, 0, 0);
    AttachObjectToVehicle(ExtraObjects[10], XmasTruck, 0.5, 0.5, 1.8, 0.0, 0.0, 0.0);

    SendClientMessage(playerid, 0xFF0000FF, "Santa Truck Spawned!");
    SendClientMessageToAll(0xFF0000FF, "ATTENTION CITIZENS!  [Santa Arrived In The City]");
    return 1;
}

CMD:dropgift(playerid, params[])
{
    if(GetPlayerVehicleID(playerid) != XmasTruck) return SendClientMessage(playerid, -1, "You must be driving the Christmas Truck!");
    
    new Float:gx, Float:gy, Float:gz;
    GetVehiclePos(XmasTruck, gx, gy, gz);

    for(new i = 0; i < 5; i++) {
        if(XmasGifts[i] != 0) DestroyPickup(XmasGifts[i]);
        XmasGifts[i] = CreatePickup(GIFT_MODEL, 4, gx + (random(8) - 4), gy + (random(8) - 4), gz);
    }

    SendClientMessageToAll(0xFF0000FF, "Santa has dropped 5 gifts near the Truck! Grab Yours Now");
    return 1;
}


public OnPlayerPickUpPickup(playerid, pickupid)
{
    for(new i = 0; i < 5; i++)
    {
        if(pickupid == XmasGifts[i])
        {
            GivePlayerMoney(playerid, REWARD_AMOUNT);
            DestroyPickup(XmasGifts[i]);
            XmasGifts[i] = 0;
            SendClientMessage(playerid, 0x00FF00FF, "You found a gift from santa! +$1000 Merry Christmas");
            return 1;
        }
    }
    return 1;
}


public MusicCheck()
{
    if(XmasTruck == INVALID_VEHICLE_ID) 
    {
        for(new i = 0; i < MAX_PLAYERS; i++)
        {
            if(MusicPlaying[i]) {
                StopAudioStreamForPlayer(i);
                MusicPlaying[i] = false;
            }
        }
        return 1;
    }

    new Float:vx, Float:vy, Float:vz;
    GetVehiclePos(XmasTruck, vx, vy, vz);

    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(IsPlayerConnected(i))
        {
            if(IsPlayerInRangeOfPoint(i, 35.0, vx, vy, vz))
            {
                if(!MusicPlaying[i])
                {
                    PlayAudioStreamForPlayer(i, MUSIC_URL);
                    MusicPlaying[i] = true;

                    if(MusicTimer[i]) KillTimer(MusicTimer[i]);
                    MusicTimer[i] = SetTimerEx("ReplayMusic", MUSIC_LENGTH * 1000, false, "i", i);

                }
            }
            else
            {
                if(MusicPlaying[i])
                {
                    StopAudioStreamForPlayer(i);
                    MusicPlaying[i] = false;

                    if(MusicTimer[i])
                    {
                       KillTimer(MusicTimer[i]);
                       MusicTimer[i] = 0;
                    }

                }
            }
        }
    }
    return 1;
}