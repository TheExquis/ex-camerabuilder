local cam1 = nil
local ped = nil
local speed = 1.0
local buildMode = false
local HelpNotification = function(msg)
    AddTextEntry('HelpNotification', msg)
    BeginTextCommandDisplayHelp('HelpNotification')
    EndTextCommandDisplayHelp(0, false, true, -1)
end

CreateThread(function()
    while true do
        local sleep = 3000
        if buildMode then
            sleep = 0
            local camCoords = GetCamCoord(cam1)
            local camRot = GetCamRot(cam1)
            local camHeading = GetEntityHeading(ped)
            local camFov = GetCamFov(cam1)
            local coords = nil
            HelpNotification(
                '~INPUT_MOVE_UP_ONLY~ to move forward ~n~~INPUT_MOVE_DOWN_ONLY~ to move backward ~n~~INPUT_MOVE_LEFT_ONLY~ to move left ~n~~INPUT_MOVE_RIGHT_ONLY~ to move right ~n~~INPUT_VEH_RADIO_WHEEL~ to go upwards ~n~~INPUT_HUD_SPECIAL~ to go downwards ~n~~INPUT_SPRINT~ to go faster ~n~~INPUT_CHARACTER_WHEEL~ to go slower ~n~~INPUT_CELLPHONE_UP~ to Look up ~n~~INPUT_CELLPHONE_DOWN~ to Look down ~n~~INPUT_CELLPHONE_LEFT~ to Look left ~n~~INPUT_CELLPHONE_RIGHT~ to Look right ~n~~INPUT_WEAPON_WHEEL_PREV~ to Zoom In ~n~~INPUT_WEAPON_WHEEL_NEXT~ to Zoom Out ~n~~INPUT_FRONTEND_RDOWN~ to copy code')
            if IsControlPressed(0, 19) or IsControlPressed(0, 21) then
                if IsControlPressed(0, 19) then
                    speed = 0.1
                end
                if IsControlPressed(0, 21) then
                    speed = 3.0
                end
            else
                speed = 1.0
            end
            if IsControlPressed(0, 14) then
                if camFov ~= 130 then
                    SetCamFov(cam1, camFov + 1)
                end
            end
            if IsControlPressed(0, 15) then
                if camFov ~= 1 then
                    SetCamFov(cam1, camFov - 1)
                end
            end

            if IsControlPressed(0, 172) then
                camRot = vec3(camRot.x + speed, camRot.y, camRot.z)
            end
            if IsControlPressed(0, 173) then
                camRot = vec3(camRot.x - speed, camRot.y, camRot.z)
            end
            if IsControlPressed(0, 174) then
                camRot = vec3(camRot.x, camRot.y, camRot.z + speed)
            end
            if IsControlPressed(0, 175) then
                camRot = vec3(camRot.x, camRot.y, camRot.z - speed)
            end
            if IsControlPressed(0, 312) then
                camRot = vec3(camRot.x, camRot.y - speed, camRot.z)
            end
            if IsControlPressed(0, 313) then
                camRot = vec3(camRot.x, camRot.y + speed, camRot.z)
            end
            if IsControlPressed(0, 32) then
                if not coords then
                    coords = GetObjectOffsetFromCoords(camCoords.xyz, camHeading, 0, speed, 0)
                else
                    coords = GetObjectOffsetFromCoords(coords.xyz, camHeading, 0, speed, 0)
                end
            end
            if IsControlPressed(0, 33) then
                if not coords then
                    coords = GetObjectOffsetFromCoords(camCoords.xyz, camHeading, 0, -speed, 0)
                else
                    coords = GetObjectOffsetFromCoords(coords.xyz, camHeading, 0, -speed, 0)
                end
            end
            if IsControlPressed(0, 35) then
                if not coords then
                    coords = GetObjectOffsetFromCoords(camCoords.xyz, camHeading, speed, 0, 0)
                else
                    coords = GetObjectOffsetFromCoords(coords.xyz, camHeading, speed, 0, 0)
                end
            end
            if IsControlPressed(0, 34) then
                if not coords then
                    coords = GetObjectOffsetFromCoords(camCoords.xyz, camHeading, -speed, 0, 0)
                else
                    coords = GetObjectOffsetFromCoords(coords.xyz, camHeading, -speed, 0, 0)
                end
            end
            if IsControlPressed(0, 85) then
                if not coords then
                    coords = GetObjectOffsetFromCoords(camCoords.xyz, camHeading, 0, 0, speed)
                else
                    coords = GetObjectOffsetFromCoords(coords.xyz, camHeading, 0, 0, speed)
                end
            end
            if IsControlPressed(0, 48) then
                if not coords then
                    coords = GetObjectOffsetFromCoords(camCoords.xyz, camHeading, 0, 0, -speed)
                else
                    coords = GetObjectOffsetFromCoords(coords.xyz, camHeading, 0, 0, -speed)
                end
            end
            if IsControlJustPressed(0, 191) then
                local str =
                    'CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA",' .. camCoords.x .. ',' .. camCoords.y .. ',' ..
                        camCoords.z .. ',' .. camRot.x .. ',' .. camRot.y .. ',' .. camRot.z .. ',' .. camFov ..
                        ', true, 2)'
                SendNUIMessage({
                    type = 'copy',
                    data = str
                })
            end
            if coords then
                SetCamCoord(cam1, coords.xyz)
            end
            SetCamRot(cam1, camRot.xyz)
        end
        Wait(sleep)
    end
end)
RegisterCommand('togglecambuilder', function()
    if not buildMode then
        ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        cam1 = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", coords.x, coords.y, coords.z, GetEntityRotation(ped).xyz,
            100.0, true, 2)
        RenderScriptCams(true, true, 1, true, true)
        FreezeEntityPosition(ped, true)
        SetEntityVisible(ped, false, 0)
        Wait(0) -- Needed to load map
        SetCamActive(cam1, true)
        buildMode = true
    else
        buildMode = false
        RenderScriptCams(false)
        DestroyAllCams(true)
        cam1 = nil
        SetEntityVisible(ped, true, 0)
        FreezeEntityPosition(ped, false)
    end
end)
