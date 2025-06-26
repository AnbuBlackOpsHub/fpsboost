local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local function optimizeGraphics()
    local camera = Workspace.CurrentCamera
    if camera then
        camera.FieldOfView = 70
    end
    
    settings().Rendering.QualityLevel = 1
    settings().Rendering.MeshPartDetailLevel = Enum.MeshPartDetailLevel.Level04
    settings().Rendering.EnableFRM = false
    settings().Rendering.AutoFRMLevel = 0
end

local function optimizeLighting()
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 9e9
    Lighting.FogStart = 0
    Lighting.Brightness = 2
    Lighting.EnvironmentDiffuseScale = 0.5
    Lighting.EnvironmentSpecularScale = 0.5
    Lighting.OutdoorAmbient = Color3.fromRGB(127, 127, 127)
    Lighting.Ambient = Color3.fromRGB(127, 127, 127)
    
    for _, effect in pairs(Lighting:GetChildren()) do
        if effect:IsA("PostEffect") or effect:IsA("BloomEffect") or effect:IsA("BlurEffect") or 
           effect:IsA("ColorCorrectionEffect") or effect:IsA("SunRaysEffect") or effect:IsA("DepthOfFieldEffect") then
            effect.Enabled = false
        end
    end
end

local function removeGardenElements()
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj.Name and (
            string.find(obj.Name:lower(), "garden") or
            string.find(obj.Name:lower(), "plant") or
            string.find(obj.Name:lower(), "tree") or
            string.find(obj.Name:lower(), "flower") or
            string.find(obj.Name:lower(), "bush") or
            string.find(obj.Name:lower(), "grass") or
            string.find(obj.Name:lower(), "leaf") or
            string.find(obj.Name:lower(), "vine") or
            string.find(obj.Name:lower(), "seed") or
            string.find(obj.Name:lower(), "crop") or
            string.find(obj.Name:lower(), "farm") or
            string.find(obj.Name:lower(), "soil") or
            string.find(obj.Name:lower(), "sprinkler") or
            string.find(obj.Name:lower(), "watering") or
            string.find(obj.Name:lower(), "greenhouse")
        ) then
            obj:Destroy()
        elseif obj:IsA("Model") and obj.Name:lower():find("garden") then
            obj:Destroy()
        elseif obj:IsA("Folder") and obj.Name:lower():find("garden") then
            obj:Destroy()
        end
    end
    
    if Workspace:FindFirstChild("Garden") then
        Workspace.Garden:Destroy()
    end
    if Workspace:FindFirstChild("Gardens") then
        Workspace.Gardens:Destroy()
    end
    if Workspace:FindFirstChild("GardenPlots") then
        Workspace.GardenPlots:Destroy()
    end
end

local function reduceGroundElements()
    if Workspace:FindFirstChild("Terrain") then
        local terrain = Workspace.Terrain
        terrain.WaterWaveSize = 0
        terrain.WaterWaveSpeed = 0
        terrain.WaterReflectance = 0
        terrain.WaterTransparency = 1
        terrain.Decoration = false
        
        pcall(function()
            terrain:FillRegion(Region3.new(Vector3.new(-2048, -2048, -2048), Vector3.new(2048, 2048, 2048)), 4, Enum.Material.Air)
        end)
    end
    
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("Part") or obj:IsA("MeshPart") or obj:IsA("UnionOperation") then
            local shouldOptimize = false
            
            if obj.Name and (
                string.find(obj.Name:lower(), "ground") or
                string.find(obj.Name:lower(), "floor") or
                string.find(obj.Name:lower(), "terrain") or
                string.find(obj.Name:lower(), "dirt") or
                string.find(obj.Name:lower(), "sand") or
                string.find(obj.Name:lower(), "stone") or
                string.find(obj.Name:lower(), "rock") or
                string.find(obj.Name:lower(), "tile") or
                string.find(obj.Name:lower(), "road") or
                string.find(obj.Name:lower(), "path") or
                string.find(obj.Name:lower(), "sidewalk") or
                string.find(obj.Name:lower(), "pavement") or
                string.find(obj.Name:lower(), "grass") or
                string.find(obj.Name:lower(), "base") or
                string.find(obj.Name:lower(), "platform")
            ) then
                shouldOptimize = true
            elseif obj.Position.Y < 10 and (obj.Size.X > 30 or obj.Size.Z > 30) then
                shouldOptimize = true
            elseif obj.Color == Color3.fromRGB(75, 151, 75) or obj.Color == Color3.fromRGB(106, 212, 106) then
                shouldOptimize = true
            end
            
            if shouldOptimize then
                obj.Transparency = 0.95
                obj.Material = Enum.Material.Plastic
                obj.Reflectance = 0
                obj.CanCollide = true
                if obj:IsA("MeshPart") then
                    obj.TextureID = ""
                end
                for _, child in pairs(obj:GetChildren()) do
                    if child:IsA("SurfaceGui") or child:IsA("Decal") or child:IsA("Texture") then
                        child:Destroy()
                    end
                end
            end
        end
    end
    
    local function findAndOptimizeMap()
        for _, obj in pairs(Workspace:GetChildren()) do
            if obj:IsA("Model") and (obj.Name:lower():find("map") or obj.Name:lower():find("world")) then
                for _, part in pairs(obj:GetDescendants()) do
                    if part:IsA("Part") or part:IsA("MeshPart") then
                        if part.Position.Y < 10 then
                            part.Transparency = 0.9
                            part.Material = Enum.Material.Plastic
                            if part:IsA("MeshPart") then
                                part.TextureID = ""
                            end
                        end
                    end
                end
            end
        end
    end
    
    findAndOptimizeMap()
end

local function removeParticles()
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Smoke") or 
           obj:IsA("Fire") or obj:IsA("Sparkles") or obj:IsA("SpecialMesh") then
            obj:Destroy()
        elseif obj:IsA("Explosion") then
            obj.Visible = false
        elseif obj:IsA("MeshPart") and obj.TextureID ~= "" then
            obj.TextureID = ""
        elseif obj:IsA("Part") or obj:IsA("UnionOperation") then
            obj.Material = Enum.Material.Plastic
            obj.Reflectance = 0
        elseif obj:IsA("Decal") or obj:IsA("Texture") then
            obj.Transparency = 1
        end
    end
end

local function optimizeWorkspace()
    Workspace.StreamingEnabled = true
    if Workspace:FindFirstChild("Terrain") then
        Workspace.Terrain.WaterWaveSize = 0
        Workspace.Terrain.WaterWaveSpeed = 0
        Workspace.Terrain.WaterReflectance = 0
        Workspace.Terrain.WaterTransparency = 0.5
        settings().Rendering.ShowBoundingBoxes = false
    end
end

local function disableAnimations()
    for _, player in pairs(Players:GetPlayers()) do
        if player.Character then
            local humanoid = player.Character:FindFirstChild("Humanoid")
            if humanoid then
                for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do
                    track:Stop()
                end
            end
        end
    end
end

local function optimizeAudio()
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("Sound") then
            obj.Volume = 0
            obj:Stop()
        end
    end
    
    for _, obj in pairs(game:GetService("SoundService"):GetDescendants()) do
        if obj:IsA("Sound") then
            obj.Volume = 0
            obj:Stop()
        end
    end
end

local function removeUnnecessaryGUI()
    local success, playerGui = pcall(function()
        if not LocalPlayer then
            LocalPlayer = Players.LocalPlayer or Players:WaitForChild("LocalPlayer", 10)
        end
        if not LocalPlayer then return nil end
        return LocalPlayer:WaitForChild("PlayerGui", 10)
    end)
    
    if not success or not playerGui then
        warn("Could not access PlayerGui, skipping GUI optimization")
        return
    end
    
    for _, gui in pairs(playerGui:GetChildren()) do
        if gui.Name ~= "Chat" and gui.Name ~= "PlayerList" and gui.Name ~= "Backpack" and 
           gui.Name ~= "Health" and gui.Name ~= "TopbarPlus" then
            for _, frame in pairs(gui:GetDescendants()) do
                if frame:IsA("ImageLabel") or frame:IsA("ImageButton") then
                    frame.Image = ""
                    frame.ImageTransparency = 1
                elseif frame:IsA("TextLabel") or frame:IsA("TextButton") then
                    frame.TextStrokeTransparency = 1
                end
            end
        end
    end
end

local function monitorPerformance()
    local connection
    connection = RunService.Heartbeat:Connect(function()
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) and UserInputService:IsKeyDown(Enum.KeyCode.F) then
            local fps = math.floor(1 / RunService.Heartbeat:Wait())
            print("Current FPS: " .. fps)
        end
    end)
    
    return connection
end

local function startOptimization()
    pcall(optimizeGraphics)
    pcall(optimizeLighting)
    pcall(removeGardenElements)
    pcall(reduceGroundElements)
    pcall(removeParticles)
    pcall(optimizeWorkspace)
    pcall(disableAnimations)
    pcall(optimizeAudio)
    pcall(removeUnnecessaryGUI)
    
    local performanceMonitor = monitorPerformance()
    
    Workspace.DescendantAdded:Connect(function(obj)
        task.wait(0.1)
        if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Smoke") or 
           obj:IsA("Fire") or obj:IsA("Sparkles") then
            obj:Destroy()
        elseif obj:IsA("Sound") then
            obj.Volume = 0
            obj:Stop()
        elseif obj:IsA("Part") or obj:IsA("UnionOperation") then
            obj.Material = Enum.Material.Plastic
            obj.Reflectance = 0
        elseif obj:IsA("MeshPart") and obj.TextureID ~= "" then
            obj.TextureID = ""
        elseif obj:IsA("Decal") or obj:IsA("Texture") then
            obj.Transparency = 1
        elseif obj.Name and (
            string.find(obj.Name:lower(), "garden") or
            string.find(obj.Name:lower(), "plant") or
            string.find(obj.Name:lower(), "tree") or
            string.find(obj.Name:lower(), "flower") or
            string.find(obj.Name:lower(), "bush")
        ) then
            obj:Destroy()
        elseif (obj:IsA("Part") or obj:IsA("MeshPart") or obj:IsA("UnionOperation")) and (
            (obj.Name and (
                string.find(obj.Name:lower(), "ground") or
                string.find(obj.Name:lower(), "terrain") or
                string.find(obj.Name:lower(), "dirt") or
                string.find(obj.Name:lower(), "sand") or
                string.find(obj.Name:lower(), "grass") or
                string.find(obj.Name:lower(), "base") or
                string.find(obj.Name:lower(), "platform")
            )) or
            (obj.Position.Y < 10 and (obj.Size.X > 30 or obj.Size.Z > 30)) or
            (obj.Color == Color3.fromRGB(75, 151, 75) or obj.Color == Color3.fromRGB(106, 212, 106))
        ) then
            obj.Transparency = 0.95
            obj.Material = Enum.Material.Plastic
            obj.Reflectance = 0
            if obj:IsA("MeshPart") then
                obj.TextureID = ""
            end
        end
    end)
    
    Players.PlayerAdded:Connect(function(player)
        player.CharacterAdded:Connect(function(character)
            task.wait(2)
            local humanoid = character:FindFirstChild("Humanoid")
            if humanoid then
                for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do
                    track:Stop()
                end
            end
        end)
    end)
    
    print("FPS Boost with Garden Removal activated!")
    print("Press Left Shift + F to check current FPS.")
    return true
end

local function setupAutoQueue()
    queue_on_teleport([=[
task.wait(3)
repeat task.wait(0.5) until game:IsLoaded() and game.Players.LocalPlayer and game.Players.LocalPlayer.Character
task.wait(2)
pcall(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/AnbuBlackOpsHub/fpsboost/refs/heads/main/fpsboost.lua"))()
end)
]=])
end

setupAutoQueue()

local result = startOptimization()

setupAutoQueue()

return result 
