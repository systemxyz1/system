local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/random%202"))()
local One = library:Window("Grow a garden dupe")


local boxEnabled = false

One:Box("Enable", "Enable", function(state)
    boxEnabled = state
end)


task.spawn(function()
    while task.wait(0.05) do
        if boxEnabled then
            require(game.ReplicatedStorage.Modules.Notification):CreateNotification("DUPED ITEMS DETECTED: Your trading has been disabled. Please contact GAG Support.")
        else
        end
    end
end)
