local Keys = {
    ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
    ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
    ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
    ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
    ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
    ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
    ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
    ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
    ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}
ESX						= nil
local PlayerData		= {}

local assaltoDisponivel  = false
local roubarCaixaDisponivel = false

-- contagem de vitrines roubadas
local cVr = 0

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
end)

function DrawText3Ds(x, y, z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)

    local scale = 0.3

    if onScreen then
        SetTextScale(scale, scale)
        SetTextFont(6)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
    end
end

function loadAnimDict( dict )  
    while ( not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(5)
    end
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        -- coordenadas do jogador
        local coordsJogador = GetEntityCoords(GetPlayerPed(-1), false)
        -- comparar coordenadas do jogador com coordenadas do roubo
        local distanciaJogadorRoubo = Vdist(coordsJogador.x, coordsJogador.y, coordsJogador.z, Config.IniciarAssalto.x, Config.IniciarAssalto.y, Config.IniciarAssalto.z) 

        if distanciaJogadorRoubo <= 1.5 then
            if IsPedShooting(GetPlayerPed(-1)) then
                TriggerServerEvent('ghost-jewelryHeist:IniciarAssalto')

                Citizen.Wait(1000)
            end
        end
    end
end)

RegisterNetEvent('ghost-jewelryHeist:NotificarPolicia')
AddEventHandler('ghost-jewelryHeist:NotificarPolicia', function()
    -- jogador
    local jogador = ESX.GetPlayerData()

    if jogador.job.name == "police" then
        -- notificação, notificar policias do assalto a acontecer
        exports["mythic_notify"]:SendAlert("error", "ASSALTO INICIADO NA JOALHERIA", 10000, {["background-color"] = "#ff0000", ["color"] = "#ffffff"})
    end
end)

RegisterNetEvent('ghost-jewelryHeist:AssaltoDisponivel')
AddEventHandler('ghost-jewelryHeist:AssaltoDisponivel', function()
    -- assalto iniciado
    assaltoDisponivel = true
    -- disponibilizar a caixa registadora
    roubarCaixaDisponivel = true
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        -- coordenadas jogador
        local coordsJogador = GetEntityCoords(GetPlayerPed(-1), false)

        if assaltoDisponivel == true then

            if Vdist(coordsJogador.x, coordsJogador.y, coordsJogador.z, -633.53, -239.07, 38.07) <= 2.0 then
                -- notificação, cancelaste o assalto
                exports['mythic_notify']:SendAlert('error', 'Assalto cancelado', 1500, {['background-color'] = '#ff0000', ['color'] = '#ffffff'})
                -- cancela o assalto
                assaltoDisponivel = false  
            end

            for _,v in pairs(Config.Vitrines) do
                -- distancia do jogador as vitrines
                distanciaJogadorVitrine = Vdist(coordsJogador.x, coordsJogador.y, coordsJogador.z, v.x, v.y, v.z)

                if distanciaJogadorVitrine <= 0.5 and not v.roubada then
                    DrawText3Ds(v.x, v.y, v.z, 'Pressione ~p~[E]~w~ para partir a vitrine')

                    if IsControlJustPressed(0, Keys['E']) then
                        -- colocar jogador nas coordenadas do drawtext
                        SetEntityCoords(GetPlayerPed(-1), v.x, v.y, v.z-0.95)
                        -- colocar a direção par o jogador olhar
					    SetEntityHeading(GetPlayerPed(-1), v.h)

                        -- retirado de outro código
                        SetPtfxAssetNextCall("scr_jewelheist")
    
                        if not HasNamedPtfxAssetLoaded("scr_jewelheist") then
                            RequestNamedPtfxAsset("scr_jewelheist")
                        end
    
                        while not HasNamedPtfxAssetLoaded("scr_jewelheist") do
                            Citizen.Wait(500)
                        end
                        
                        -- retirado de outro código
                        SetPtfxAssetNextCall("scr_jewelheist")
                        -- fazer particulas na posição da vitrine
                        StartParticleFxLoopedAtCoord("scr_jewel_cab_smash", v.x, v.y, v.z, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
                        -- carregar animação
                        loadAnimDict("missheist_jewel") 
                        -- fazer animação no jogador
                        TaskPlayAnim(GetPlayerPed(-1), "missheist_jewel", "smash_case", 8.0, 1.0, -1, 2, 0, 0, 0, 0 ) 
    
                        -- tempo de roubar a vitrine
                        Citizen.Wait(Config.TempoRoubarVitrine)
                        
                        -- apanhar items
                        TriggerServerEvent('ghost-jewelryHeist:RoubarItems')
                        -- som de apanhar items
                        PlaySound(-1, "PICK_UP", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                        -- parar animações do jogador
                        ClearPedTasksImmediately(GetPlayerPed(-1))
                        
                        -- vitrine foi roubada
                        v.roubada = true
                        -- +1 vitrine roubada
                        cVr = cVr + 1
                    end
                end
            end

            if roubarCaixaDisponivel == true then
                -- distancia do jogador e a caixa registadora
                local distanciaJogadorCaixa = Vdist(coordsJogador.x, coordsJogador.y, coordsJogador.z, Config.RoubarCaixa.x, Config.RoubarCaixa.y, Config.RoubarCaixa.z)

                if distanciaJogadorCaixa <= 0.5 then
                    DrawText3Ds(Config.RoubarCaixa.x, Config.RoubarCaixa.y, Config.RoubarCaixa.z, "Pressione ~p~[E]~w~ para roubar a caixa")

                    if IsControlJustPressed(0, Keys['E']) then
                        -- recolhe o dinheiro da caixa
                        RecolherDinheiroCaixa(coordsJogador)
                    end
                end
            end

            if cVr == 28 and roubarCaixaDisponivel == false then
                -- notificação, assalto encerrado
                exports['mythic_notify']:SendAlert('inform', 'Assalto encerrado', 1500, { ['background-color'] = '#0000ff', ['color'] = '#ffffff' })
                -- assalto acabou
                assaltoDisponivel = false
            end
        end
    end
end)

function RecolherDinheiroCaixa(coordsJogador)
    -- animação, colocar dinheiro na mala
    RequestAnimDict('anim@heists@ornate_bank@grab_cash_heels')

    -- carregar animação
    while not HasAnimDictLoaded('anim@heists@ornate_bank@grab_cash_heels') do
    Citizen.Wait(100)
    end

    -- criar a mala
    mala = CreateObject(GetHashKey('prop_cs_heist_bag_02'), coordsJogador.x, coordsJogador.y, coordsJogador.z, true, true, true)
    -- colocar mala no jogador  
    AttachEntityToEntity(mala, GetPlayerPed(-1), GetPedBoneIndex(GetPlayerPed(-1), 57005), 0.0, 0.0, -0.16, 250.0, -30.0, 0.0, false, false, false, false, 2, true)

    -- executar animação
    TaskPlayAnim(PlayerPedId(), "anim@heists@ornate_bank@grab_cash_heels", "grab", 8.0, -8.0, -1, 1, 0, false, false, false)
    -- bloquear posição do jogador
    FreezeEntityPosition(GetPlayerPed(-1), true)
    
    -- tempo de colocar dinheiro na mala
    Citizen.Wait(Config.TempoRoubarCaixa) 
    
    -- remover a mala do jogador
    DeleteEntity(mala)
    -- parar animação do jogador
    ClearPedTasks(GetPlayerPed(-1))
    -- jogador pode andar novamente
    FreezeEntityPosition(GetPlayerPed(-1), false)

    -- retirado de outro código
    SetPedComponentVariation(GetPlayerPed(-1), 5, 45, 0, 2)
    -- função de encerrar assalto
    TriggerServerEvent("ghost-jewelryHeist:DarSaque")

    Citizen.Wait(2500)

    -- roubar a caixa deixa de estar disponível
    roubarCaixaDisponivel = false
end

function DisplayHelpText(str)
    SetTextComponentFormat("STRING")
    AddTextComponentString(str)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end