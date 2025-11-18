local pawnCoords = Config.pawnCoords
local exporterPedCoords = Config.exporterPedCoords
local exporterVanCoords = Config.exporterVanCoords
local exprtDropOffCoords = Config.exportDropOffCoords
local exportDropOffPedCoords = Config.exportDropOffPedCoords


local animDic = Config.animDic
local exporterPedHash = Config.exporterPedHash
local exporterVanHash = Config.exporterVanHash
local exportDropOffPed = Config.exportDropOffPed

local workTruck
local clipboard
local exporterPed
local pawnPed = nil
local destinationBlip
local dropOffPed



local function sellItems()
    TriggerServerEvent('bl_pawnshop:server:sellItems')
end

local function spawnExporterPed()
    

  while not HasModelLoaded('p_amb_clipboard_01') do
    Citizen.Wait(0)
    RequestModel('p_amb_clipboard_01')
  end

  while not HasAnimDictLoaded("missfam4") do
    Citizen.Wait(0)
    RequestAnimDict("missfam4")
  end


  RequestModel(exporterPedHash)
  while (not HasModelLoaded(exporterPedHash)) do Citizen.Wait(1) RequestModel(exporterPedHash) end

  exporterPed = CreatePed(1, exporterPedHash, exporterPedCoords.x, exporterPedCoords.y ,exporterPedCoords.z - 1, exporterPedCoords.w, false, false)
  FreezeEntityPosition(exporterPed, true)
  SetEntityInvincible(exporterPed, true)
  SetBlockingOfNonTemporaryEvents(exporterPed, true)

  local clipboardProp = 'p_amb_clipboard_01'
    clipboard = CreateObject(clipboardProp, exporterPedCoords.x, exporterPedCoords.y, exporterPedCoords.z, false, false, false)
    TaskPlayAnim(exporterPed, "missfam4", "base", 2.0, 2.0, 50000000, 51, 0, false, false, false)
    AttachEntityToEntity(clipboard, exporterPed, GetPedBoneIndex(exporterPed, 36029), 0.16, 0.08, 0.1, -130.0, -50.0, 0.0, true, true, false, true, 1, true)


    exports.ox_target:addLocalEntity(exporterPed, {
        {
            distance = 1.5,
            name = "br_exporter_ped",
            icon = 'fas fa-box',
            label = 'Exporter',
            onSelect = function()
                exports.dialog:OpenDialog(exporterPed, Config.ExporterInteraction)
            end,
        }
    })
end



local function spawnExporterDropOffPed()
    dropOffPed = CreatePed(1, exportDropOffPed, exportDropOffPedCoords.x, exportDropOffPedCoords.y, exportDropOffPedCoords.z - 1, exportDropOffPedCoords.w, false, false)
    FreezeEntityPosition(dropOffPed, true)
    SetEntityInvincible(dropOffPed, true)
    SetBlockingOfNonTemporaryEvents(dropOffPed, true)

    exports.ox_target:addLocalEntity(dropOffPed, {
        {
            distance = 1.5,
            name = "br_dropoff_ped",
            icon = 'fas fa-box',
            label = 'Exporter',
            onSelect = function()
                RemoveBlip(destinationBlip)
                TriggerServerEvent('bl_pawnshop:server:sellToExporter')
            end,
        }
    })

end

local function startExport()
    destinationBlip = AddBlipForCoord(exprtDropOffCoords.x, exprtDropOffCoords.y, exprtDropOffCoords.z)

    SetBlipSprite(destinationBlip, 1)
    SetBlipColour(destinationBlip, 5)
    SetBlipRoute(destinationBlip, true)

    TriggerEvent('ox_lib:notify', {
        type = 'success',
        description = 'A location was set on your gps',
    })

    spawnExporterDropOffPed()
end



RegisterNetEvent('bl_pawnshop:client:exporterVan', function ()
    startExport()
local maxVehAttempts = 10
    local vehAttempts = 0
    local closestVeh

    repeat
        closestVeh = GetClosestVehicle(exporterVanCoords.x, exporterVanCoords.y, exporterVanCoords.z, 5.0, 0, 70)
        vehAttempts = vehAttempts + 1
        if closestVeh ~= 0 then
            lib.notify({
                title = 'Exporter',
                description = 'Vehicle In Area',
                type = 'error',
            })

            return false                                                 -- Stop execution completely
        end
        Wait(1)
    until vehAttempts == maxVehAttempts


    while not HasModelLoaded(exporterVanHash) do
        Citizen.Wait(0)
        RequestModel(exporterVanHash)
      end

    local workTruckModel = exporterVanHash
    workTruck = CreateVehicle(workTruckModel, exporterVanCoords.x, exporterVanCoords.y, exporterVanCoords.z, exporterVanCoords.w, true, false)
    SetEntityAsMissionEntity(workTruck, true, true)
    SetPedIntoVehicle(PlayerPedId(), workTruck, -1)


    TriggerEvent('vehiclekeys:client:SetOwner', GetVehicleNumberPlateText(workTruck))

      local plrPed = PlayerPedId()

    Citizen.CreateThread(function()
        while true do
            Wait(10)
            local plrCoords = GetEntityCoords(plrPed)


            local inReturn = #(plrCoords.xy - exporterVanCoords.xy)
            if inReturn < 10.0 then
                if GetVehiclePedIsIn(plrPed, false) == workTruck then
                    if not lib.isTextUIOpen() then
                        lib.showTextUI('[E] - Return Vehicle')
                    end
                    if IsControlPressed(0, 38) then
                        lib.hideTextUI()
                        DeleteEntity(workTruck)
                        break
                    end
                else
                    lib.hideTextUI()
                end
            else
                lib.hideTextUI()
            end
        end
    end)
end)

RegisterNetEvent('bl_pawnshop:client:spawnPed', function ()
    if pawnPed then return end

    RequestModel('mp_m_waremech_01')
    while (not HasModelLoaded('mp_m_waremech_01')) do 
        Citizen.Wait(1)
        RequestModel('mp_m_waremech_01') 
    end
    while not HasAnimDictLoaded(animDic[1]) do
        Citizen.Wait(0)
        RequestAnimDict(animDic[1])
    end
    
    pawnPed = CreatePed(1, 'mp_m_waremech_01', pawnCoords.x, pawnCoords.y, pawnCoords.z - 1, pawnCoords.w, false, false)
    FreezeEntityPosition(pawnPed, true)
    SetEntityInvincible(pawnPed, true)
    SetBlockingOfNonTemporaryEvents(pawnPed, true)

    TaskPlayAnim(pawnPed, animDic[1], animDic[2], 2.0, 2.0, -1, 51, 0, false, false, false)

    exports.ox_target:addLocalEntity(pawnPed, {
        {
            distance = 1.5,
            name = "br_pawnshop_ped",
            icon = 'fas fa-dollar-sign',
            label = 'Pawn Boss',
            onSelect = function()
                exports.dialog:OpenDialog(pawnPed, Config.PawnBossInteraction)
            end,
        }
    })

end)


RegisterNetEvent('bl_pawnshop:client:despawnPed', function ()
    DeleteEntity(pawnPed)
    pawnPed = nil
end)

RegisterNetEvent('bl_pawnshop:client:sellItems', function()
    sellItems()
end)



Citizen.CreateThread(function()
    for _, value in ipairs(Config.Blips) do
       local blip = AddBlipForCoord(value.coords.x, value.coords.y, value.coords.z)
        SetBlipSprite(blip, value.sprite)
        SetBlipColour(blip, value.color)
        SetBlipScale(blip, value.size)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(value.name)
        EndTextCommandSetBlipName(blip)
    end



    spawnExporterPed()

    exports.ox_target:addBoxZone({
        coords = Config.Tray.coords.xyz,
        name = 'br_pawnshop_tray',
        size = vec3(0.5, 0.5, 0.5),
        rotation =  Config.Tray.coords.w,
        debug = Config.Debug,
    
        options = { {
            distance = 1.5,
            icon = Config.Tray.icon,
            label = Config.Tray.label,
            onSelect = function()
                exports.ox_inventory:openInventory('stash', Config.Tray.id)
            end
        } }
    })

    exports.ox_target:addBoxZone({
        coords = Config.BossStash.coords.xyz,
        name = 'br_pawnshop_bossstash',
        size = vec3(0.5, 0.5, 0.5),
        rotation =  Config.BossStash.coords.w,
        debug = Config.Debug,
    
        options = { {
            distance = 1.5,
            icon = Config.BossStash.icon,
            label = Config.BossStash.label,
            onSelect = function()
                exports.ox_inventory:openInventory('stash', Config.BossStash.id)
            end
        } }
    })
    


end)



RegisterCommand('duty', function()
TriggerServerEvent('QBCore:ToggleDuty')
end, false)

AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
      return
    end
    DeleteEntity(pawnPed)
    DeleteEntity(exporterPed)
    DeleteEntity(clipboard)
    DeleteEntity(workTruck)
end)