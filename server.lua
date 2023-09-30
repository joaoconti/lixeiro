local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")

conti = {}
Tunnel.bindInterface("lixeiro", conti)

function conti.pagamentoItens()
    local source = source
    local user_id = vRP.getUserId(source)
    vRPclient._playAnim(source, false,{{"amb@prop_human_parking_meter@female@idle_a", "idle_a_female"}}, true) -- Fazer uma animação
    SetTimeout(2000, function() -- Tempo de espera
        vRPclient._stopAnim(source, false) -- Parar qualquer animação que o player esteja fazendo.
        for k, v in pairs(Config.itens) do -- Pegando os itens da tabela e quantidade que irá receber.
            local randomQuantidade = math.random(v.quantidade.min, v.quantidade.max) -- Randomizando a quantidade de itens que irá receber
            vRP.giveInventoryItem(user_id, v.item, randomQuantidade) -- Entregando o item.
            TriggerClientEvent('Notify', source, "aviso", "Você recebeu <b>".. v.item .."</b> ".. randomQuantidade .. "x") -- Notificando o item e quantidade que o player recebeu.
        end
    end)
end

function conti.pagamentoDinheiro()
    local source = source
    local user_id = vRP.getUserId(source)
    vRPclient._playAnim(source, false,{{"amb@prop_human_parking_meter@female@idle_a", "idle_a_female"}}, true)-- Fazer uma animação
    SetTimeout(2000, function() -- Tempo de espera
        vRPclient._stopAnim(source, false) -- Parar qualquer animação que o player esteja fazendo.
        local randomPagamento = math.random(Config.pagamento.min, Config.pagamento.max) -- Randomizando a quantidade de dinheiro que o player irá receber.
        --vRP.giveMoney(user_id,randomPagamento) -- Dar dinheiro ao player
        vRP.giveDinheirama(user_id,randomPagamento) -- Função para entregar o dinheiro ao player em forma de item
        TriggerClientEvent('Notify', source, 'aviso', 'Você recebeu R$<b>'.. randomPagamento ..'</b>') -- Noficando quanto que o player ganhou de dinheiro.
    end)
end