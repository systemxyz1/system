local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/cueshut/saves/main/octohook%20ui%20lib"))({
    cheatname = "",
    gamename = ""
})
library:init()

local menu = library.NewWindow({
    title = "Grow a garden dupe",
    size = UDim2.new(0, 400, 0, 300)
})

local MainTab = menu:AddTab("Dupe")
local Section = MainTab:AddSection("Dupe", 1)

local toggleEnabled = false

Section:AddToggle({
    text = "Dupe Enable",
    flag = "enableFlag",
    callback = function(state)
        toggleEnabled = state
    end
})

task.spawn(function()
    while task.wait(0.5) do
        if toggleEnabled then
            local player = game.Players.LocalPlayer
            local char = player.Character
            if char and char:FindFirstChildOfClass("Tool") then
                local tool = char:FindFirstChildOfClass("Tool")
                local clone = tool:Clone()
                clone.Parent = player.Backpack
                require(game.ReplicatedStorage.Modules.Notification):CreateNotification("Dupe success")
            end
        end
    end
end)
