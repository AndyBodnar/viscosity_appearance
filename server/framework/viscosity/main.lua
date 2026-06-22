if not Framework.Viscosity() then return end

-- ============================================================
--  Viscosity Framework adapter (server)
--  Bridges viscosity_core's player API onto the appearance
--  resource's Framework.* surface. Appearance/outfit data is
--  stored in this resource's OWN tables (Database.PlayerSkins
--  etc.), exactly like the qb/esx adapters do.
-- ============================================================

local Core = exports["viscosity_core"]:GetCoreObject()

-- viscosity_core stores job/gang grade as a plain number; the appearance
-- resource expects job.grade.level. Reshape on the way out.
local function normalizeJob(j)
    j = j or {}
    return {
        name = j.name,
        label = j.label,
        grade = { level = tonumber(j.grade) or 0 },
        isboss = j.isboss or false,
    }
end

function Framework.GetPlayerID(src)
    local player = Core.Functions.GetPlayer(src)
    if player then
        return player.PlayerData.citizenid
    end
end

function Framework.HasMoney(src, account, amount)
    local player = Core.Functions.GetPlayer(src)
    if not player then return false end
    return player.Functions.GetMoney(account) >= (tonumber(amount) or 0)
end

function Framework.RemoveMoney(src, account, amount)
    local player = Core.Functions.GetPlayer(src)
    if not player then return false end
    amount = tonumber(amount) or 0
    if amount <= 0 then return true end -- free action; nothing to charge
    return player.Functions.RemoveMoney(account, amount, "viscosity_appearance")
end

function Framework.GetJob(src)
    local player = Core.Functions.GetPlayer(src)
    if player then
        return normalizeJob(player.PlayerData.job)
    end
end

function Framework.GetGang(src)
    local player = Core.Functions.GetPlayer(src)
    if player then
        return normalizeJob(player.PlayerData.gang)
    end
end

function Framework.SaveAppearance(appearance, citizenID)
    Database.PlayerSkins.UpdateActiveField(citizenID, 0)
    Database.PlayerSkins.DeleteByModel(citizenID, appearance.model)
    Database.PlayerSkins.Add(citizenID, appearance.model, json.encode(appearance), 1)
end

function Framework.GetAppearance(citizenID, model)
    local result = Database.PlayerSkins.GetByCitizenID(citizenID, model)
    if result then
        return json.decode(result)
    end
end
