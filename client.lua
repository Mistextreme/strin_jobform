ESX = nil
display = false

Citizen.CreateThread(function()
  while ESX == nil do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Citizen.Wait(0)
  end
    Citizen.Wait(1000)
  while ESX.GetPlayerData().job == nil do
    Citizen.Wait(1000)
  end

  ESX.PlayerData = ESX.GetPlayerData()
      Citizen.Wait(1000)
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  ESX.PlayerData = xPlayer
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        ped = GetPlayerPed(-1)
        coords = GetEntityCoords(ped)

        for k, v in pairs(Config.Forms) do
          local distance = #(coords - v.pos)
          if not display then
            if distance < 1.0 then
                DrawText3D(v.pos, '~g~[E]~w~ '..v.label)
                if IsControlJustReleased(0, 38) then
                    SetDisplay(true, v.job, v.label)
                end
            end
          end
        end
    end
end)

RegisterNUICallback("send_form", function(data)
    SetDisplay(false)
    if data ~= nil then
      sendForm(data)
      ESX.ShowNotification('~g~Your form has been sent to - '..data.job)
    else
      ESX.ShowNotification('~r~Your form is empty!')
    end
end)

RegisterNUICallback("exit_form", function(data)
    if data.error ~= nil then
      ESX.ShowNotification(data.error)
    end
    SetDisplay(false)
end)


function SetDisplay(bool, form_job, form_label)
    display = bool
    SetNuiFocus(bool, bool)
    ESX.TriggerServerCallback('strin_jobform:getInfo', function(info)
      SendNUIMessage({
        type = "ui",
        status = bool,
        job = form_job,
        label = form_label,
        player = {
          firstname = info.firstname,
          lastname = info.lastname,
          phone = info.phone
        }
    })
    end)
end

function sendForm(data)
  TriggerServerEvent('strin_jobform:sendWebhook', GetPlayerServerId(), data)
end

function DrawText3D(coords, text)
  local onScreen,_x,_y=World3dToScreen2d(coords.x,coords.y,coords.z)
  local px,py,pz=table.unpack(GetGameplayCamCoords())
  
  SetTextScale(0.5, 0.35)
  SetTextFont(4)
  SetTextProportional(1)
  SetTextColour(255, 255, 255, 215)
  SetTextEntry("STRING")
  SetTextCentre(1)
  AddTextComponentString(text)
  DrawText(_x,_y)
  local factor = (string.len(text)) / 200
  DrawRect(_x,_y+0.0105, 0.015+ factor, 0.035, 44, 44, 44, 100)
end