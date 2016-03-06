#define FILTERSCRIPT

#include <a_samp>
#include <streamer>
#include <colandreas>
#include <YSI\y_iterate>

#define MAX_BLOOD 300

new Iterator:Blood<MAX_BLOOD>,
    bloodObject[MAX_BLOOD],
    bloodAlpha[MAX_BLOOD],
    bloodTimer[MAX_BLOOD];

public OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ) {
    new Float:rDist = float(random(6));
    if(rDist) {
        new index = Iter_Free(Blood);
        if(index != cellmin) {
            new Float: vX, Float: vY, Float: vZ;
            GetPlayerLastShotVectors(playerid, vX, vY, vZ, fX, fY, fZ); 
            
            vX = fX - vX; 
            vY = fY - vY; 
            vZ = fZ - vZ; 

            new Float:d = VectorSize(vX, vY, vZ);
            vX /= d;
            vY /= d;
            vZ /= d;
            
            vX *= rDist;
            vY *= rDist;
            vZ *= rDist;
            
            if(CA_RayCastLineAngle(fX, fY, fZ, fX + vX, fY + vY, fZ + vZ, vX, vY, vZ, fX, fY, fZ)) {
                bloodObject[index] = CreateDynamicObject(19836, vX, vY, vZ, fX, fY, fZ);
                bloodAlpha[index] = 0xFF;
                
                if(IsValidDynamicObject(bloodObject[index])) {
                    Iter_Add(Blood, index);
                    
                    SetDynamicObjectMaterial(bloodObject[index], 0, -1, "none", "none", 0xFF0000 | (bloodAlpha[index] << 24));
                    
                    bloodTimer[index] = SetTimerEx("FadeBlood", 6, true, "i", index);
                }
            }
        }
    }
}

forward FadeBlood(index);
public FadeBlood(index)
{
    bloodAlpha[index] -= 5;
    
    if(bloodAlpha[index]) {
        SetDynamicObjectMaterial(bloodObject[index], 0, -1, "none", "none", 0xFF0000 | (bloodAlpha[index] << 24));
    }
	else {
        DestroyDynamicObject(index);
        KillTimer(bloodTimer[index]);
        
        Iter_Remove(Blood, index);
    }
}
