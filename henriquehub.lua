-- SILVA HUB para Steal a Brainrot | Revisado v2
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Replicated = game:GetService("ReplicatedStorage")
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "SilvaHub"

local function getChar() return Player.Character or Player.CharacterAdded:Wait() end
local function getHum() return getChar():WaitForChild("Humanoid") end
local function round(obj, r) local c = Instance.new("UICorner", obj); c.CornerRadius = UDim.new(0, r) end

-- Toggle do Hub
local toggleBtn = Instance.new("TextButton", gui)
toggleBtn.Size = UDim2.new(0,30,0,30); toggleBtn.Position = UDim2.new(0,10,0,10)
toggleBtn.Text = "-"; toggleBtn.BackgroundColor3 = Color3.fromRGB(80,80,80)
toggleBtn.TextColor3 = Color3.new(1,1,1); toggleBtn.Font = Enum.Font.SourceSansBold
toggleBtn.TextSize = 20; toggleBtn.Draggable = true; round(toggleBtn,6)

-- Frame principal
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,300,0,390); frame.Position = UDim2.new(0,100,0,100)
frame.BackgroundColor3 = Color3.fromRGB(30,30,50); frame.Active = true; frame.Draggable = true
round(frame,10)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,40); title.BackgroundColor3 = Color3.fromRGB(40,40,60)
title.Text = "SILVA HUB"; title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.SourceSansBold; title.TextSize = 20; round(title,10)

-- Abas
local function makeTab(t,pos)
    local b=Instance.new("TextButton",frame); b.Size=UDim2.new(0,80,0,30)
    b.Position=pos; b.Text=t; b.BackgroundColor3=Color3.fromRGB(50,50,70)
    b.TextColor3=Color3.new(1,1,1); b.Font=Enum.Font.SourceSansBold; b.TextSize=16
    round(b,6); return b
end
local tPrinc=makeTab("Principal",UDim2.new(0,10,0,45))
local tVisu=makeTab("Visual",UDim2.new(0,105,0,45))
local tOutros=makeTab("Outros",UDim2.new(0,200,0,45))

-- Conteúdo
local cont=Instance.new("Frame",frame)
cont.Size=UDim2.new(1,-20,0,310); cont.Position=UDim2.new(0,10,0,85)
cont.BackgroundTransparency=1
local function clear() for _,v in pairs(cont:GetChildren()) do v:Destroy() end end

-- Botões públicos
local function makeBtn(txt,y,cb)
    local b=Instance.new("TextButton",cont); b.Size=UDim2.new(1,0,0,35)
    b.Position=UDim2.new(0,0,0,y); b.Text=txt
    b.BackgroundColor3=Color3.fromRGB(50,50,70); b.TextColor3=Color3.new(1,1,1)
    b.Font=Enum.Font.SourceSansBold; b.TextSize=16; round(b,8)
    b.MouseButton1Click:Connect(cb); return b
end

-- Estados
local infJump = false
local speedOn = false
local speedValue = 70
local spDef = 16
local espOn = false
local speedBtn

-- Infinite Jump
UIS.JumpRequest:Connect(function()
    if infJump then getHum():ChangeState(Enum.HumanoidStateType.Jumping) end
end)

-- Speed Hack (via loop)
RunService.RenderStepped:Connect(function()
    if speedOn then
        local h = getHum()
        if h then h.WalkSpeed = speedValue end
    end
end)

local function toggleSpeed()
    speedOn = not speedOn
    speedBtn.Text = speedOn and "Speed [ON]" or "Speed [OFF]"
    if not speedOn then getHum().WalkSpeed = spDef end
end

-- ESP
local function toggleESP()
    espOn = not espOn
    for _,p in pairs(Players:GetPlayers()) do
        if p ~= Player and p.Character then
            local hl = p.Character:FindFirstChild("Highlight")
            if espOn and not hl then
                hl = Instance.new("Highlight", p.Character)
                hl.FillColor = Color3.fromRGB(255, 0, 255)
                hl.OutlineColor = hl.FillColor
            elseif not espOn and hl then
                hl:Destroy()
            end
        end
    end
    for _,v in pairs(workspace:GetDescendants()) do
        if v.Name == "Brainrot" and v:IsA("Part") then
            local hl = v:FindFirstChild("Highlight")
            if espOn and not hl then
                hl = Instance.new("Highlight", v)
                hl.FillColor = Color3.fromRGB(0, 255, 0)
                hl.OutlineColor = hl.FillColor
            elseif not espOn and hl then
                hl:Destroy()
            end
        end
    end
end

-- Compra de itens
local function buy(itemName)
    local path1 = Replicated:FindFirstChild(itemName)
    local path2 = Replicated:FindFirstChild("Packages")
    local path3 = path2 and path2:FindFirstChild("Net")
    local evt = path1 or (path3 and path3:FindFirstChild(itemName))
    if evt and evt:IsA("RemoteEvent") then
        evt:FireServer()
    else
        warn("Evento '" .. itemName .. "' não encontrado")
    end
end

-- Tabs
tPrinc.MouseButton1Click:Connect(function()
    clear()
    makeBtn("Infinite Jump",0,function() infJump = not infJump end)
    speedBtn = makeBtn("Speed [OFF]",45,toggleSpeed)
end)

tVisu.MouseButton1Click:Connect(function()
    clear()
    makeBtn("ESP Toggle",0,toggleESP)
end)

tOutros.MouseButton1Click:Connect(function()
    clear()
    makeBtn("Comprar Cabeça da Medusa",0,function() buy("BuyMedusaHead") end)
    makeBtn("Clonador Quântico",45,function() buy("BuyQuantumClone") end)
    makeBtn("Capa da Invisibilidade",90,function() buy("BuyInvisibilityCloak") end)
end)

toggleBtn.MouseButton1Click:Connect(function()
    frame.Visible = not frame.Visible
end)

-- Ativar aba principal
tPrinc:MouseButton1Click()
