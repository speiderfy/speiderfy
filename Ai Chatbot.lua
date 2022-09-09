local events = game:GetService("ReplicatedStorage"):WaitForChild("DefaultChatSystemChatEvents")
local messageDoneFiltering = events:WaitForChild("OnMessageDoneFiltering")
local players = game:GetService("Players")

getgenv().distanceCheck = 15 -- Responds to people with x studs of you

function respondTo(text)
    content = syn.request(
        {
            Url = "https://api.affiliateplus.xyz/api/chatbot?message=" .. text,  
            Method = "GET"
        }
    )
    content = content.Body
    content = game:GetService("HttpService"):JSONDecode(content)
    response = content["message"]
    return response
end

function distanceTo(part)
    return (game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position - part.Position).magnitude
end

messageDoneFiltering.OnClientEvent:Connect(function(message)
    local player = players:FindFirstChild(message.FromSpeaker)
    local message = message.Message or ""
    
    if player and player ~= game:GetService("Players").LocalPlayer and distanceTo(player.Character.HumanoidRootPart) < distanceCheck then
        game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(respondTo(message), "All")
    end
end)
