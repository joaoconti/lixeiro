local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")

local coordBlip = Config.blip -- Puxando informação da config.
local coordVeicle = Config.vehicleCoords
local x,y,z = coordBlip.x, coordBlip.y, coordBlip.z -- Puxando informação da config.

conti = Tunnel.getInterface("lixeiro")

local servico
local veiculo

CreateThread(function()
    while true do
        local ped = PlayerPedId() -- Native do fivem para pegar entidade do player.
        local playerCoords = GetEntityCoords(ped) -- Pegar a coordenada de uma entidade.
        local distancia = #(playerCoords - vec3(x,y,z)) -- Calculo para verificar a distancia entre duas coordenadas.
        if distancia < 5 and not servico then
            texto3D() -- Função para aparecer o texto.
            DrawMarker(27, x, y, z-1, 0, 0, 0, 0, 0, 0, 0.5, 0.5, 0.5, 255, 255, 255, 255, false, false, 2, false) -- Criar blip.
            if distancia < 1 then
                if IsControlJustPressed(0, 38) then -- Verificar se o player apertou algum botão.
                    TriggerEvent('Notify', "sucesso", "Você entrou em serviço", 2000) --  Chamando evento de notify.
                    servico = true
                    sairDoServico()
                    spawnarVeiculo()
                    emServico()
                end
            end
        end
        Wait(5)
    end
end)


-- Função para criar um texto 3D
function texto3D()
    local screen,coordX,coordY = GetScreenCoordFromWorldCoord(x,y,z) -- Pegar coordenada da tela e verificar se estou olhando para um coordenada,
    if screen then
        SetTextFont(4) -- Fonte da letra.
        SetTextScale(0.4, 0.4) -- Tamanho da fonte.
        SetTextColour(255, 255, 255, 255) -- Mudar cor rgba do texto.
        SetTextCentre(1) -- Alinhar o texto.
        SetTextEntry("STRING") -- Setar um tipo de valor ao texto.
        AddTextComponentString('[E] Iniciar serviço de - LIXEIRO') -- Mensagem do texto.
        DrawText(coordX,coordY) -- Local aonde o texto irá ficar.
    end
end

-- Função para spawnar o veículo
function spawnarVeiculo()
    local hash = GetHashKey("trash2") -- Pegar a hash de algum objeto ou veículo.
    while not HasModelLoaded(hash) do Wait(10) RequestModel(hash) end -- Verificar se o objeto ou o veículo foi carregado.
    veiculo = CreateVehicle(hash, coordVeicle.x, coordVeicle.y, coordVeicle.z, 162.00, true, true) -- Spawnar o veículo,
    SetVehicleNumberPlateText(veiculo, vRP.getRegistrationNumber()) -- Setar uma placa no veículo.
end

-- Função quando ele entrar em serviço
function emServico()
    CreateThread(function()
        while servico do
            for k, v in pairs(Config.lixeiras) do -- Estamos pegando todas as coordenadas as lixeiras.
                local ped = PlayerPedId()
                local playerCoords = GetEntityCoords(ped) -- Native do fivem para pegar entidade do player. 
                if Config.lixeiras[k] then -- Verificar se a linha existe
                    local coordLixeira = vec3(v.x, v.y, v.z) -- Coordenada da lixeira em vec3.
                    local distancia = #(playerCoords - coordLixeira) -- Pegar a distancia entre o player e a lixeira.
                    if distancia < 10 then
                        DrawMarker(1, coordLixeira.x, coordLixeira.y, coordLixeira.z-1, 0, 0, 0, 0, 0, 0, 0.5, 0.5, 0.5, 0, 255, 0, 255, true, false, 2, false) -- Blip da lixeira.
                        if distancia < 1 then
                            if IsControlJustPressed(0, 38) then 
                                if IsVehicleModel(GetVehiclePedIsIn(ped, true), GetHashKey("trash2")) and not IsPedInAnyVehicle(ped, true) then -- Verificar se o player esta dentro de algum veículo e se o ultimo veículo que ele entrou foi o trash2
                                    conti.pagamentoDinheiro()
                                    Config.lixeiras[k] = nil
                                    SetTimeout(5000, function()
                                        Config.lixeiras[k] = v
                                    end)
                                end
                            end
                        end
                    end
                end
            end
            Wait(5)
        end
    end)
end

function sairDoServico()
    CreateThread(function()
        while servico do
            if IsControlJustPressed(0, 167) then
                servico = false
                DeleteEntity(veiculo)
                TriggerEvent('Notify', 'aviso', 'Você saiu de serviço!')
            end
            Wait(5)
        end
    end)
end