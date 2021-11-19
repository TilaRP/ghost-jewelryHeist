local assaltoAtivo = false

ESX = nil

TriggerEvent('esx:getSharedObject', function(object) ESX = object end)

RegisterServerEvent('ghost-jewelryHeist:IniciarAssalto')
AddEventHandler('ghost-jewelryHeist:IniciarAssalto', function()
    -- policias de serviço
    local policiasDeServico = 0 
    -- jogadores do server
	local listaJogadores = ESX.GetPlayers()
    -- source
	local _source = source
    -- jogador
	local xPlayer = ESX.GetPlayerFromId(_source)

    if assaltoAtivo == false then
        for i=1, #listaJogadores, 1 do
            -- verifica todos os jogadores
            local xPlayer = ESX.GetPlayerFromId(listaJogadores[i])
            -- adiciona os policias de serviço
            if xPlayer["job"]["name"] == "police" then
                -- adiciona os policias de serviço
                policiasDeServico = policiasDeServico + 1
            end
        end

        if policiasDeServico >= Config.PoliciasNecessarios then
            -- assalto esta disponivel
            TriggerClientEvent('ghost-jewelryHeist:AssaltoDisponivel', _source)
            -- notificação, iniciou um assalto à joalheria
            TriggerClientEvent('mythic_notify:client:SendAlert', source, {type = 'inform', text = 'Assalto iniciado', length = 1500, style = {['background-color'] = '#0000ff', ['color'] = '#ffffff' }})
            -- iniciar timeout
            AtivarTimeout()
            -- tempo ate chamar a policia
            Wait(Config.TempoNotificarPolicia)
            -- notificar a policia
            TriggerClientEvent('ghost-jewelryHeist:NotificarPolicia', -1)
        else
            TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'Joalheria está sem stock', length = 1500, style = { ['background-color'] = '#ff0000', ['color'] = '#ffffff' } })
        end
    else
        TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'Joalheria foi assaltada recentemente', length = 1500, style = { ['background-color'] = '#ff0000', ['color'] = '#ffffff' } })
    end
end)

function AtivarTimeout()
    -- assalto está a decorrer / decorreu
    assaltoAtivo = true
    -- esperar o timeout
    Wait(Config.Timeout)
    -- assalto esta disponivel novamente
    assaltoAtivo = false
end

RegisterServerEvent('ghost-jewelryHeist:RoubarItems')
AddEventHandler('ghost-jewelryHeist:RoubarItems', function()
    -- source
    local _source = source
    -- jogador
    local xPlayer = ESX.GetPlayerFromId(_source)
    -- chance de items
    local chance = math.random(0, 100)

    if chance <= 25 then
        -- chance entre anel de ouro e anel de diamante
        local anel = math.random(0, 10)
        -- quantidade de aneis
        local quantidadeAnel = math.random(1, 3)
        if anel <= 6 then
            -- dar ao jogador o anel de ouro e a quantidade
            xPlayer.addInventoryItem('joia_anel_ouro', quantidadeAnel)
        else
            -- dar ao jogador o anel de diamante e a quantidade
            xPlayer.addInventoryItem('joia_anel_diamante', quantidadeAnel)
        end
    elseif chance >= 26 and chance <= 50 then
        -- chance entre brincos de ouro e brincos de diamante
        local brincos = math.random(0, 10)
        -- quantidade de brincos
        local quantidadeBrincos = math.random(1, 3)
        if brincos <= 6 then
            -- dar ao jogador o brincos de ouro e a quantidade
            xPlayer.addInventoryItem('joia_brincos_ouro', quantidadeBrincos)
        else
            -- dar ao jogador o brincos de diamante e a quantidade
            xPlayer.addInventoryItem('joia_brincos_diamante', quantidadeBrincos)
        end
    elseif chance >= 51 and chance <= 75 then
        -- chance entre colar de ouro e colar de diamante
        local colar = math.random(0, 10)
        -- quantidade de colares
        local quantidadeColar = math.random(1, 3)
        if colar <= 6 then
            -- dar ao jogador o colar de ouro e a quantidade
            xPlayer.addInventoryItem('joia_colar_ouro', quantidadeColar)
        else
            -- dar ao jogador o colar de diamante e a quantidade
            xPlayer.addInventoryItem('joia_colar_diamante', quantidadeColar)
        end
    elseif chance >= 76 and chance <= 100 then
        -- chance entre relogios de ouro e relogios de diamante
        local relogio = math.random(0, 10)
        -- quantidade de relogios
        local quantidadeRelogio = math.random(1, 3)
        if relogio <= 6 then
            -- dar ao jogador o relogio de ouro e a quantidade
            xPlayer.addInventoryItem('joia_relogio_ouro', quantidadeRelogio)
        else
            -- dar ao jogador o relogio de diamante e a quantidade
            xPlayer.addInventoryItem('joia_relogio_diamante', quantidadeRelogio)
        end
    end
end)

RegisterServerEvent("ghost-jewelryHeist:DarSaque")
AddEventHandler("ghost-jewelryHeist:DarSaque", function()
    -- source
    local _source = source
    -- jogador
    local xPlayer = ESX.GetPlayerFromId(_source)
    -- quantidade de dinheiro roubado da caixa
    local quantidade = math.random(Config.SaqueMin, Config.SaqueMax)

    -- dar dinheiro ao jogador
    xPlayer.addAccountMoney('black_money', quantidade)
end)