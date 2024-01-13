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

local function trySelectMaterial()
    local selectedItem = turtle.getItemDetail()
    if selectedItem ~= nil and selectedItem["name"] == material then
        return true
    else
        for i = 1, 12 do
            selectedItem = turtle.getItemDetail(i)
            if selectedItem ~= nil and selectedItem["name"] == material then
                turtle.select(i)
                print("Select slot: " .. tostring(i))
                return true
            end
        end
    end
    print("Material not found")
    return false
end

if not trySelectMaterial() then
    return
end

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
local length = 128;
if #tArgs == 4 then
    length = tonumber(tArgs[4])
    if length < 1 then
        print("Tunnel length must be positive")
        return
    end
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
            sleep(0.1)
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
            sleep(0.1)
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
            sleep(0.1)
        else
            return false
        end
    end
    return true
end

local function tryPlace()
    trySelectMaterial()
    return turtle.place()
end

local function tryPlaceUp()
    trySelectMaterial()
    return turtle.placeUp()
end

local function tryPlaceDown()
    trySelectMaterial()
    return turtle.placeDown()
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

local x = 1;
local y = 1;
local z = 1;
local i = 1
local j = 1;
local baseX = 1
local baseY = 1

local function isReverse()
  return (x%2) == 1
end

print("Tunnelling...")

local function tryPlaceShields()
  if x == 1 then
    turtle.turnLeft()
    tryPlace()
    turtle.turnRight()
  end
  if x == width then
    turtle.turnRight()
    tryPlace()
    turtle.turnLeft()
  end

  if y == 1 then
    tryPlaceDown()
  elseif y == height then
    tryPlaceUp()
  end
end


local function tryMoveNextCell()
  if baseX == 1 then
    turtle.turnRight()
    tryForward()
    turtle.turnLeft()
    x = x + 1
  elseif baseX == width then
    turtle.turnLeft()
    tryForward()
    turtle.turnRight()
    x = x -1
  else
    print("Error wrong baseX")
  end 
end

local function tryMoveNextRow()
  if baseY == 1 then
    tryUp()
    y = y + 1
  elseif baseY == height then
    tryDown()
    y = y - 1
  else
    print("Error wrong baseY")
  end
end


local function tryMoveNext()
  local j = i % (width * height)
  if j == 0 then
    tryForward()
    z = z + 1
    baseX = x
    baseY = y
  elseif j % width == 0 then
    tryMoveNextRow()
    baseX = x
  else
    tryMoveNextCell()
  end
end

while z < length do
  tryPlaceShields()
  tryMoveNext()
  i = i + 1
end

print("Tunnel complete.")
print("Mined " .. collected .. " items total.")
