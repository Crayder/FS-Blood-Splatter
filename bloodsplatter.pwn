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

stock Float:frandom(Float:max, Float:m2 = 0.0, dp = 3)
{
	new Float:mn = m2;
	if(m2 > max) {
		mn = max,
		max = m2;
	}
    m2 = floatpower(10.0, dp);
    
	return floatadd(floatdiv(float(random(floatround(floatmul(floatsub(max, mn), m2)))), m2), mn);
}

public OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ) {
    if(hittype == BULLET_HIT_TYPE_PLAYER) {
        new Float:rDist = frandom(-5.0, 6.0);
        if(rDist > 0.0) {
            new index = Iter_Free(Blood);
            if(index != cellmin) {
                new Float:vX, Float:vY, Float:vZ,
                    Float:pX, Float:pY, Float:pZ;
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
                
                vX += fX + frandom(-0.5, 0.5);
                vY += fY + frandom(-0.5, 0.5);
                vZ += fZ + frandom(-0.5, 0.5);
                
                if(CA_RayCastLineNormal(fX, fY, fZ, vX, vY, vZ, pX, pY, pZ, pX, pY, pZ)) {
                    CA_RayCastLineAngle(fX, fY, fZ, vX, vY, vZ, fX, fY, fZ, vX, vY, vZ);
                    
                    bloodObject[index] = CreateDynamicObject(19836, fX + (pX * 0.05), fY + (pY * 0.05), fZ + (pZ * 0.05), vX, vY, vZ);
                    bloodAlpha[index] = 0xFF;
                    
                    if(IsValidDynamicObject(bloodObject[index])) {
                        Iter_Add(Blood, index);
                        
                        SetDynamicObjectMaterial(bloodObject[index], 0, -1, "none", "none", 0xFF0000 | (bloodAlpha[index] << 24));
                        
                        bloodTimer[index] = SetTimerEx("FadeBlood", 50, true, "i", index);
                    }
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

public OnFilterScriptInit() {
    CA_Init();
    return 1;
}
