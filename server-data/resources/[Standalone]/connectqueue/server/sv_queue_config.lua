Config = {}

-- priority list can be any identifier. (hex steamid, steamid34, ip) Integer = power over other people with priority
-- a lot of the steamid converting websites are broken rn and give you the wrong steamid. I use https://steamid.xyz/ with no problems.
-- you can also give priority through the API, read the examples/readme.
Config.Priority = {
    -- High Staff 100--
    ["steam:110000117ccac15"] = 100,	-- Example Player
    ["steam:110000114e35069"] = 99, 	-- Example Player 
		
    -- Low Staff 90 --	
    ["steam:11000010643eaac"] = 90, 	-- Example Player
    ["steam:110000102b93502"] = 90, 	-- Example Player
    ["steam:110000114d7a231"] = 90, 	-- Example Player 
    ["steam:1100001015437ae"] = 90, 	-- Example Player
    ["steam:110000109a898de"] = 90, 	-- Example Player
	
    -- Superior? --	
    ["steam:110000114df296d"] = 89, 	-- Example Player
	
    -- High 80 --	
    ["steam:11000011c796c28"] = 80, 	-- Example Player
	
    -- Low 60 --	
    ["steam:110000109b18046"] = 60, 	-- Example Player
}

-- Require people to run steam.
Config.RequireSteam = true

-- "Whitelist" only server.
Config.PriorityOnly = false

-- Disables hardcap, should keep this true.
Config.DisableHardCap = true

-- Will remove players from connecting if they don't load within: __ seconds; May need to increase this if you have a lot of downloads.
-- I have yet to find an easy way to determine whether they are still connecting and downloading content or are hanging in the loadscreen.
-- This may cause session provider errors if it is too low because the removed player may still be connecting, and will let the next person through...
-- even if the server is full. 10 minutes should be enough.
Config.ConnectTimeOut = 600

-- Will remove players from queue if the server doesn't recieve a message from them within: __ seconds.
Config.QueueTimeOut = 120

-- Will give players temporary priority when they disconnect and when they start loading in.
Config.EnableGrace = true

-- How much priority power grace time will give.
Config.GracePower = 85

-- How long grace time lasts in seconds.
Config.GraceTime = 120

-- On resource start, players can join the queue but will not let them join for __ milliseconds
-- this will let the queue settle and lets other resources finish initializing.
Config.JoinDelay = 60000

-- Will show how many people have temporary priority in the connection message.
Config.ShowTemp = false

-- Simple localization.
Config.Language = {
    joining = "\xF0\x9F\x8E\x89Joining NPCore...",
    connecting = "\xE2\x8F\xB3Connecting to NPCore...",
    idrr = "\xE2\x9D\x97[NPCore Queue] Error: Couldn't retrieve any of your ID's, try restarting.",
    err = "\xE2\x9D\x97[NPCore Queue] There was an error...",
    pos = "\xF0\x9F\x90\x8CYou are %d/%d in queue \xF0\x9F\x95\x9C%s",
    connectingerr = "\xE2\x9D\x97[NPCore Queue] Error adding you to connecting list.",
    timedout = "\xE2\x9D\x97[NPCore Queue] Error timed out?",
    wlonly = "\xE2\x9D\x97[NPCore Queue] You must be whitelisted to join this server. To apply, head to: https://discord.gg/9XfXH2zwf9",
    steam = "\xE2\x9D\x97 [NPCore Queue] Error: Steam must be running!"
}



