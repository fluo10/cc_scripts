if not turtle then
    printError("Requires a Turtle")
    return
end

local tArgs = { ... }
if #tArgs < 3  or #tArgs > 4 then
    local programName = arg[0] or fs.getName(shell.getRunningProgram())
    print("Usage: " .. programName .. " <material> <width> <height> [<length>]")
    return
end

local material = tostring(tArgs[1])

local width = tonumber(tArgs[2])
if width < 1 then
    print("Tunnel width must be positive")
    return
end

local height = tonumber(tArgs[3])
if height < 1 then
    print("Tunnel height must be positive")
    return
end
local length = 0;
if #tArgs == 4 then
    length = tonumber(tArgs[1])
    if length < 1 then
    print("Tunnel length must be positive")
    return
end

local collected = 0

local function collect()
    collected = collected + 1
    if math.fmod(collected, 25) == 0 then
        print("Mined " .. collected .. " items.")
    end
end

local function tryDig()
    while turtle.detect() do
        if turtle.dig() then
            collect()
            sleep(0.5)
        else
            return false
        end
    end
    return true
end

local function tryDigUp()
    while turtle.detectUp() do
        if turtle.digUp() then
            collect()
            sleep(0.5)
        else
            return false
        end
    end
    return true
end

local function tryDigDown()
    while turtle.detectDown() do
        if turtle.digDown() then
            collect()
            sleep(0.5)
        else
            return false
        end
    end
    return true
end

local function tryPlace()

end

local function tryPlaceUp()
end

local function tryPlaceDown()
end

local function tryMoveDiagnally(is_returning)
    for x = 1, width, do
        local isUpping = 

end

local function refuel()
    local fuelLevel = turtle.getFuelLevel()
    if fuelLevel == "unlimited" or fuelLevel > 0 then
        return
    end

    local function tryRefuel()
        for n = 1, 16 do
            if turtle.getItemCount(n) > 0 then
                turtle.select(n)
                if turtle.refuel(1) then
                    turtle.select(1)
                    return true
                end
            end
        end
        turtle.select(1)
        return false
    end

    if not tryRefuel() then
        print("Add more fuel to continue.")
        while not tryRefuel() do
            os.pullEvent("turtle_inventory")
        end
        print("Resuming Tunnel.")
    end
end

local function tryUp()
    refuel()
    while not turtle.up() do
        if turtle.detectUp() then
            if not tryDigUp() then
                return false
            end
        elseif turtle.attackUp() then
            collect()
        else
            sleep(0.5)
        end
    end
    return true
end

local function tryDown()
    refuel()
    while not turtle.down() do
        if turtle.detectDown() then
            if not tryDigDown() then
                return false
            end
        elseif turtle.attackDown() then
            collect()
        else
            sleep(0.5)
        end
    end
    return true
end

local function tryForward()
    refuel()
    while not turtle.forward() do
        if turtle.detect() then
            if not tryDig() then
                return false
            end
        elseif turtle.attack() then
            collect()
        else
            sleep(0.5)
        end
    end
    return true
end

local function tryColumnUp()
end

local function tryColumnDown()
end

print("Tunnelling...")

for n = 1, length do
    tryForward()

    for x = 1, width do
        for y = 1, height do

for n = 1, length do
    tryForward()

    if n < length then
        tryDig()
        if not tryForward() then
            print("Aborting Tunnel.")
            break
        end
    else
        print("Tunnel complete.")
    end

    

end

--[[
print( "Returning to start..." )

-- Return to where we started
turtle.turnLeft()
turtle.turnLeft()
while depth > 0 do
    if turtle.forward() then
        depth = depth - 1
    else
        turtle.dig()
    end
end
turtle.turnRight()
turtle.turnRight()
]]

print("Tunnel complete.")
print("Mined " .. collected .. " items total.")
