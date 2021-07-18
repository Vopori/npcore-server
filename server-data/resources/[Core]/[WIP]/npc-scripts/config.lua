-- Discord Perms Config
Config = {
	DiscordToken = "ODAyNTkzOTQ1ODI1NDQzODYw.YAxf3A.2bY6KzISij3qXyr5IHqNprzFNuI",
	GuildId = "801687059005308968",

	-- Format: ["Role Nickname"] = "Role ID" You can get role id by doing \@RoleName
	Roles = {
		["TestRole"] = "Some Role ID" -- This would be checked by doing exports.discord_perms:IsRolePresent(user, "TestRole")
	}
}

-- RP Commands Config
Config = {}

-- Scripts (Set to false to disable) --
Config.rpcommands = true -- /twt, /dispatch, /darkweb, /news, /do, /ooc, /me, /show id commands with discord logging
Config.handsup = true -- Press x to put your hands up
Config.tazereffect = true -- Gives you an effect when you get tazed
Config.nogrip = true -- When jumping and running, there is an 90% chance of falling (Customizable)

-- RPCOMMANDS --
-- [!] CHANGE THE DISCORD WEBHOOK IN NPC-SCRIPTS\RPCOMMANDS.LUA AT THE TOP TO LOG THE COMMANDS

-- Note: These commands will not work if rpcommands is set to false.
-- Enable or disable commands
-- Set to false to disable
Config.twitter = true -- /twt command?
Config.dispatch = true -- /dispatch command?
Config.darkweb = true -- /darkweb command?
Config.news = true -- /news command?
Config.doo = true -- /do command?
Config.ooc = true -- /ooc command?
Config.me = true -- /me command?
Config.showid = true -- /showid command?
Config.missingargs = '^1Please provide a message.' -- Send this message when a player does not provide a message.