local Players = game:GetService("Players")
local TextChatService = game:GetService("TextChatService")
local Lighting = game:GetService("Lighting")
local CollectionService = game:GetService("CollectionService")

local Util = {}

function Util.findPlayer(name)
    if not name then
        return nil
    end
    local lower = string.lower(name)
    for _, player in ipairs(Players:GetPlayers()) do
        if string.lower(player.Name) == lower or string.sub(string.lower(player.DisplayName), 1, #lower) == lower then
            return player
        end
    end
    return nil
end

function Util.sendSystemMessage(message)
    if TextChatService and TextChatService.TextChannels and TextChatService.TextChannels.RBXGeneral then
        TextChatService.TextChannels.RBXGeneral:SendAsync("[Admin] " .. message)
    end
end

function Util.flash(player, color)
    local character = player.Character
    if not (character and character.PrimaryPart) then
        return
    end
    local highlight = Instance.new("Highlight")
    highlight.Parent = character
    highlight.FillColor = color
    highlight.OutlineColor = color
    task.delay(3, function()
        highlight:Destroy()
    end)
end

function Util.getHumanoid(player)
    local character = player.Character
    if not character then
        return nil
    end
    return character:FindFirstChildOfClass("Humanoid")
end

function Util.applyPresetMotion(player, property, value)
    local humanoid = Util.getHumanoid(player)
    if humanoid then
        humanoid[property] = value
    end
end

function Util.ensureTag(instance, tag)
    if not CollectionService:HasTag(instance, tag) then
        CollectionService:AddTag(instance, tag)
    end
end

function Util.withCharacter(player, callback)
    if player.Character then
        callback(player.Character)
    end
    player.CharacterAdded:Connect(function(character)
        callback(character)
    end)
end

function Util.teleportToCFrame(player, cframe)
    if player.Character and player.Character.PrimaryPart then
        player.Character:SetPrimaryPartCFrame(cframe)
    end
end

function Util.playSound(trackName, soundId)
    local soundService = game:GetService("SoundService")
    local existing = soundService:FindFirstChild(trackName)
    if existing then
        existing:Destroy()
    end
    local sound = Instance.new("Sound")
    sound.Name = trackName
    sound.SoundId = soundId
    sound.Looped = true
    sound.Volume = 0.5
    sound.Parent = soundService
    sound:Play()
end

function Util.stopSound(trackName)
    local soundService = game:GetService("SoundService")
    local existing = soundService:FindFirstChild(trackName)
    if existing then
        existing:Stop()
        existing:Destroy()
    end
end

function Util.colorPreset(name, ambient, outdoor)
    Lighting.Ambient = ambient
    Lighting.OutdoorAmbient = outdoor or ambient
    Util.sendSystemMessage("Lighting preset '" .. name .. "' applied.")
end

return Util
