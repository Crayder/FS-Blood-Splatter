#define FILTERSCRIPT

#include <a_samp>
#include <streamer>
#include <colandreas>

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
                rDist = frandom(0.005, 0.020, 4);
                pX *= rDist;
                pY *= rDist;
                pZ *= rDist;
                
                CA_RayCastLineAngle(fX, fY, fZ, vX, vY, vZ, fX, fY, fZ, vX, vY, vZ);
                
                new objectid = CreateDynamicObject(19836, fX + pX, fY + pY, fZ + pZ, vX, vY, vZ);
                if(IsValidDynamicObject(objectid)) {
                    SetDynamicObjectMaterial(objectid, 0, -1, "none", "none", 0xFFFF0000);
                    
                    SetTimerEx("FadeBlood", 1500, false, "ii", objectid, 255);
                }
            }
        }
    }
}

forward FadeBlood(objectid, alpha);
public FadeBlood(objectid, alpha)
{
    alpha -= 5;
    
    if(alpha) {
        SetDynamicObjectMaterial(objectid, 0, -1, "none", "none", 0xFF0000 | (alpha << 24));
        SetTimerEx("FadeBlood", 50, false, "ii", objectid, alpha);
    }
    else {
        DestroyDynamicObject(objectid);
    }
}
