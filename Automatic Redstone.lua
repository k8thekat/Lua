REFS_TASK = refinedstorage.getTasks()
RS_OUTPUT_LT = redstone.setOutput("left", true)
RS_OUTPUT_LF = redstone.setOutput("left", false)
RS_INPUT_RIGHT = redstone.getInput("right")
X = 0
--pastebin get \"text" \"filename"

-- autocraft function
function Autocraft()
    sleep(1)
    
    -- if redstone signal from right is off, send redstone pulse to the left for refined storage crafter
    if (RS_INPUT_RIGHT == false) then
        redstone.setOutput("left", true)
        sleep(2)
        print("Redstone Pulse for 2 seconds...")
        redstone.setOutput("left", false)

    end
    
    -- if task is in progress.
    if (RS_INPUT_RIGHT == true) then
        print("Waiting for free space...")
        sleep(X)
    end
end

-- main while loop to keep computer on and ready

print("Initializing Autocraft system...")

while(true) do
    REFS_TASK = refinedstorage.getTasks()
    if (#REFS_TASK >= 1) then
        -- adjust sleep timer for Niotic Crystals
        if (REFS_TASK[1].stack.item.displayName == "Niotic Crystal") then
           print("Adjusting sleep timer for Niotic Crystals...")
           X = 4
        end
        -- adjust sleep timer for Spirited Crystals
        if (REFS_TASK[1].stack.item.displayName == "Spirited Crystal") then
           print("Adjusting sleep timer for Spirited Crystals...")
           X = 6
        end
        -- adjust sleep timer for Nitro Crystals
        if (REFS_TASK[1].stack.item.displayName == "Nitro Crystal") then
           print("Adjusting sleep timer for Nitro Crystals...")
           X = 15
        end
        Autocraft()
        X = 2
    end

    -- if no task in que; sleep for 15 seconds.
    if (#REFS_TASK == 0) then
        sleep(15)
        print("Sleeping for 15 seconds.")
    end   
end
