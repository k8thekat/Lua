-- ATM Turtle --
--[[
 
CC BY-SA License
 
Copyright (c) 2020 ipeni
 
reusers may distribute, remix, adapt, and build upon the material in any medium or format, so long as attribution is given to the creator. This license allows for commercial use. If you remix, adapt, or build upon the material, you must license the modified material under identical terms. 
--]]
 
 
modem = nil
modemBlock = nil
monitor = nil
dr = nil
user = nil
userBalance = 0
 
function init()
    if not fs.exists("prices.txt") then
        file = fs.open("prices.txt", "w")
        file.writeLine("{}")
        file.close()
    end
 
    while true do
        if (dr ~= nil) then
		drawer = dr.list()
		if (drawer[2]~=nil) then
		name = drawer[2].name
		amount = drawer[2].count 
        if name ~= nil and user ~= nil then
            pricesFile = fs.open("prices.txt", "r")
            prices = textutils.unserialise(pricesFile.readAll())
            pricesFile.close()
            if prices[name] == nil then
                value = 1
                if name:match("block", 1, true) then
                    value = 9
                end
                prices[name] = value
                balance = prices[name] * amount
                newPrices = textutils.serialise(prices)
                pricesFile = fs.open("prices.txt", "w")
                pricesFile.write(newPrices)
                pricesFile.close()
                print("Credit: "..tonumber(amount) * tonumber(value))
                userBalance = userBalance + balance
                modem.transmit(404,6969,{request = "balance_update", user = user, balance = balance})
                updateMonitor()
            else
                value = prices[name]
                balance = value * amount
                turtle.select(1)
                print("Credit: "..tonumber(amount) * tonumber(value))
                userBalance = userBalance + balance
                modem.transmit(404,6969, {request = "balance_update", user = user, balance = balance})
                updateMonitor()
            end
            for i = 1,(tonumber(amount)/64)+1 do
                turtle.suck(64)
                turtle.dropDown()
                turtle.select(i)
            end
        end
		else 
			amount=0;
		end
		end
        sleep(2)
    end
end
 
function listenForUserChange()
    while true do 
        local e, s, sC, rC, m, dist = os.pullEvent("modem_message")
        if m["request"] == "disk_eject" then
            user = nil
            userBalance = 0
   monitor.setTextScale(0.5)
            monitor.clear()
            monitor.setCursorPos(1,1)
            monitor.write("please insert user card")
            print("User cleared")
        elseif(m["request"] == "user_change") then
            print("User "..m["user"].." logged in") 
             waitingForResponse = true
             user = m["user"]
    while waitingForResponse do
                modem.transmit(404, 6969, { request = "balance_request", user = m["user"]})
                local e, s, sC, rc, m, dist = os.pullEvent("modem_message")
                if m["request"] == "balance_transmission" then
                    userBalance = m["balance"]
                    updateMonitor()
                    waitingForResponse = false
                end
            end
        end
    end
end
 
function updateMonitor()
    monitor.setTextScale(0.5)
    monitor.clear()
    monitor.setCursorPos(1,1)
    monitor.write("Welcome")
    monitor.setCursorPos(1,2)
    monitor.write("Your balance is")
    monitor.setCursorPos(1,3)
    monitor.write(userBalance)
end
 
function initializePeripherals()
    print("Initializing...")
    for k,v in ipairs(peripheral.getNames()) do
        type = peripheral.getType(v)
        if type == "modem" then
            tempModem = peripheral.wrap(v)
            if tempModem.isWireless() then
                modem = peripheral.wrap(v)
                modem.open(6969)
            else
                modemBlock = peripheral.wrap(v)
                modemBlock.open(0)
                modemNames = modemBlock.getNamesRemote()
                for x,y in ipairs(modemNames) do
                    if y:match("monitor",1,true) then
                        monitor = peripheral.wrap(y)
                        break
                    end
                end
            end
        elseif type == "storagedrawers:standard_drawers_1" then
            dr = peripheral.wrap(v)
        end
    end
    if modem == nil or monitor == nil or modemBlock == nil then
        print("please make sure a modem, modemBlock, and monitor are connecting to this turtle, monitor must be connected to the modem block")
        sleep(3)
        initializePeripherals()
    elseif dr == nil then
        print("please place a drawer adjacent to this turtle")
        sleep(3)
        initializePeripherals()
    elseif modem ~= nil and dr ~= nil and modemBlock ~= nil and monitor ~= nil then
        parallel.waitForAny(init, listenForUserChange)
    end
end
 
initializePeripherals()