-- k8thekat ## https://pastebin.com/u/k8thekat ## --
-- Feed the Craft Community -- Valhelsia 3 Spawn Board Lua Script --

local mon = peripheral.find("monitor")
--local mon = peripheral.wrap("right") -- connects to monitors(alternate way if above variable errors)
mon.setCursorPos(1,1)
mon.setTextScale(1) -- YOU CANNOT CHANGE SCALE DYNAMICALLY; SET ONCE AND LEAVE ALONE!
local width, height = mon.getSize()
local linenum

-- Resets Monitor display for each Body
function MonReset()
  linenum = 1
  mon.clear()
end

-- Centers the message to the currently attached monitor or display.
function CenteredText(msg,linenum)
  local msgl = string.len(msg)
  mon.setCursorPos(1+((width - msgl) / 2),linenum)
  mon.write(msg)
end

-- Pass in message and line number for text to be displayed on monitor at that specified line; unless a message causes word wrap.(No limit to message length)
function PrintMsg(msg,gap)
  -- skip ahead how many lines are needed
  linenum = linenum + gap
  -- width of the line for text display (2 character padding)
  local linewidth = width - 2
  local curpos = 1
  local endpos = curpos
  local msgl = string.len(msg)
  local hasspace = 0

  -- Word Wrap via message length manipluation
  while(curpos < msgl) do
    endpos = curpos + linewidth - 1
    hasspace = 0
    -- if msg is too short
    if endpos >= msgl then
      endpos = msgl
    else
      -- find a space (decimal: 32)
      while(endpos > curpos) do
        if string.byte(msg, endpos, endpos) == 32 then
          endpos = endpos - 1
          hasspace = 1
          break
        end
        endpos = endpos - 1
      end
      -- if we did not find a space then grab linewidth characters
      if endpos <= curpos then
        endpos = endpos + linewidth - 1
      end
    end
    CenteredText(string.sub(msg,curpos,endpos),linenum)
    linenum = linenum + 1
    curpos = endpos + 1 + hasspace
  end
  return linenum
end

function FileOpen()
  -- File list (msg1,msg2,msg3,etc...)
end

function FileParse()
  read_file = function (path)
    local file = io.open(path, "rb") 
    if not file then return nil end
    
    local lines = {}
    
    for line in io.lines(path) do
        local words = {}
        for word in line:gmatch("%w+") do 
            table.insert(words, word) 
        end    
      table.insert(lines, words)
    end
    
    file:close()
    return lines;
    end
end
-- Greetings for Spawn --
function Greetings()
  mon.setTextColor(colors.red)
  PrintMsg("## Welcome to Valhelsia 3! ##", 0)
  mon.setTextColor(colors.white)
  PrintMsg("- Please follow the rules on our Discord server under #rules-expectations",1)
  PrintMsg("- Please keep Minecolonies at least 500 blocks from spawn.",0)
  PrintMsg("- Please keep Mekanism Reactors at least 500 blocks from spawn.",0)
  mon.setTextColor(colors.blue)
  PrintMsg("- Have Suggestions? See #feedback-suggestions on our Discord.",1)
  mon.setTextColor(colors.green)
  PrintMsg("- Need Help? Post in #community-support or #server-issues.",1)
  mon.setTextColor(colors.red)
  PrintMsg("- Stay up to date and check #val3-announcements and #val3-general~",1)
end

-- Free Mekanism Liquid Brine and Lithium via Endertanks --
function MekLiquids()
  mon.setTextColor(colors.red)
  PrintMsg('## Mekanism Reactor Fluids ##', 0)
  mon.setTextColor(colors.white)
  PrintMsg('We offer free liquid Brine and Lithium for your reactor needs via EnderTanks', 2)
  mon.setTextColor(colors.green)
  PrintMsg('## Liquid Brine ##',2)
  mon.setTextColor(colors.white)
  PrintMsg('- Yellow - White - Yellow -',0)
  mon.setTextColor(colors.blue)
  PrintMsg('## Liquid Lithium ##',2)
  mon.setTextColor(colors.white)
  PrintMsg('- Brown - White - Brown -',0)
end

-- Any Upcoming changes to the server/rules/etc.. --
function Updates()
  mon.setTextColor(colors.red)
  PrintMsg('## Announcements for FTC: Valhelsia 3 ##',0)
  mon.setTextColor(colors.blue)
  PrintMsg('- Mekanism Evaporation Towers will become banned on 8/13~',2)
end

-- PvP Event with Staff vs Players Vanilla rules --
function PvPEvent()
  mon.setTextColor(colors.red)
  PrintMsg('Feed the Craft Hosted Vanilla PvP',0)
  mon.setTextColor(colors.blue)
  PrintMsg('STAFF vs PLAYERS',1)
  mon.setTextColor(colors.white)
  PrintMsg('Rules:',1)
  PrintMsg('Vanilla Items only!',0)
  mon.setTextColor(colors.blue)
  PrintMsg('Have fun and Good Luck',4)
end

-- Upcoming BuildEvent for players --
-- Something involving a set size of terrain and theme in spawn (to help decorate)
function BuildEvent()
  mon.setTextColor(colors.blue)
  PrintMsg('## Build Event coming soon(TM) ##', 0)
  mon.setTextColor(colors.white)
  PrintMsg('Prize gets building placed in spawn!',1)
  mon.setTextColor(colors.green)
  PrintMsg('Size limit is one chunk no taller than 25 blocks',2)
  PrintMsg('Must fit the theme of: Rustic/Overgrown',1)
end

function Test()
  PrintMsg(' 6.2 String Manipulation. This library provides generic functions for string manipulation, such as finding and extracting substrings. When indexing a string, the first character has position 1. See Section 8.3 for some examples on string manipulation in Lua. strfind (str, substr, [init, [end]])Receives two string arguments, and returns a number. This number indicates the first position where the second argument appears in the first argument. If the second argument is not a substring of the first one, then strfind returns nil . A third optional numerical argument specifies where to start the search. Another optional numerical argument specifies where to stop it.strlen (s)Receives a string and returns its length.strsub (s, i, [j])Returns another string, which is a substring of s , starting at i and runing until j . If j is absent, it is assumed to be equal to the length of s . Particularly, the call strsub(s,1,j) returns a prefix of s with length j , while the call strsub(s,i) returns a suffix of s , starting at i .strlower (s)Receives a string and returns a copy of that string with all upper case letters changed to lower case. All other characters are left unchangestrupper (s)Receives a string and returns a copy of that string with all lower case letters changed to upper case. All other characters are left unchanged.ascii (s, [i])Returns the ascii code of the character s[i] . If i is absent, it is assumed to be 1.format (formatstring, e1, e2, ...)This function returns a formated version of its variable number of arguments following the description given in its first argument (which must be a string). The format string follows the same rules as the printf family of standard C functions. The only differencies are that the options/modifiers * , l , L , n , p , and h are not supported, and there is an extra option, q . This option formats a string in a form suitable to be safely read back by the Lua interpreter. The string is written between double quotes, and all double quotes, returns and backslashes in the string are correctly escaped when written.The options c , d , E , e , f , g i , o , u , X , and x all expect a number argument, while q and s expects a string........ ',1)
end

function ScreenChange()
  while true do
    -- Arrays need key values {1:Greetings, 2:MekLiquids, 3:...}
    local Ftable = {Greetings, MekLiquids, Updates, BuildEvent, PvPEvent}
    -- for key, value in pairs(table)
    for k,entry in pairs(Ftable) do
      MonReset()
      entry()
      sleep(15)
    end
  end
end

if mon then
  ScreenChange()
end