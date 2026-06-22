if not Framework.Viscosity() then return end

-- ============================================================
--  Viscosity Framework adapter (client)
--  Mirrors viscosity_core's synced PlayerData onto the
--  appearance resource's client.* / Framework.* surface.
-- ============================================================

local client = client
local PlayerData = exports["viscosity_core"]:GetPlayerData() or {}

-- viscosity_core grade is a number; appearance code reads job.grade.level.
local function normalizeJob(j)
    j = j or {}
    return {
        name = j.name,
        label = j.label,
        grade = { level = tonumber(j.grade) or 0 },
        isboss = j.isboss or false,
        onduty = j.onduty,
    }
end

local function setClientParams()
    client.job = normalizeJob(PlayerData.job)
    client.gang = normalizeJob(PlayerData.gang)
    client.citizenid = PlayerData.citizenid
end

function Framework.GetPlayerGender()
    local gender = PlayerData.charinfo and PlayerData.charinfo.gender
    if gender == "female" or gender == "f" or gender == 1 then
        return "Female"
    end
    return "Male"
end

function Framework.UpdatePlayerData()
    PlayerData = exports["viscosity_core"]:GetPlayerData() or {}
    setClientParams()
end

function Framework.HasTracker()
    return PlayerData.metadata and PlayerData.metadata.tracker
end

function Framework.CheckPlayerMeta()
    local m = PlayerData.metadata or {}
    return m.isdead or m.inlaststand or m.ishandcuffed
end

function Framework.IsPlayerAllowed(citizenid)
    return citizenid == PlayerData.citizenid
end

-- viscosity_core doesn't expose its Jobs registry to other resources, so we
-- offer the player's current grades (0..current) as selectable rank values.
-- Only used by the boss-managed-outfit flow.
function Framework.GetRankInputValues(type)
    local data = type == "gang" and client.gang or client.job
    local level = data and data.grade and data.grade.level or 0
    local values = {}
    for i = 0, level do
        values[#values + 1] = { label = "Grade " .. i, value = tostring(i) }
    end
    return values
end

function Framework.GetJobGrade()
    return client.job.grade.level
end

function Framework.GetGangGrade()
    return client.gang.grade.level
end

function Framework.CachePed()
    return nil
end

function Framework.RestorePlayerArmour()
    Framework.UpdatePlayerData()
    local armour = PlayerData.metadata and PlayerData.metadata.armor
    if armour then
        Wait(1000)
        SetPedArmour(cache.ped, armour)
    end
end

-- viscosity_core pushes the full PlayerData on load and on every change.
RegisterNetEvent("viscosity_core:client:onPlayerLoaded", function(data)
    PlayerData = data or {}
    setClientParams()
    InitAppearance()
end)

RegisterNetEvent("viscosity_core:client:setPlayerData", function(data)
    PlayerData = data or {}
    setClientParams()
    if ResetBlips then ResetBlips() end
end)
