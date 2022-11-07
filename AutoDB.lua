AutoDB_AutoexecCommandsSet = AutoDB_AutoexecCommandsSet or {["/db chests"] = true, ["/db rares"] = true}

AutoDB = CreateFrame("Frame")
AutoDB.version = "2.0"

local function ExecuteSlashCommand(command)
	AutoDB.info("Executing [%s]", command)
	DEFAULT_CHAT_FRAME.editBox:SetText(command)
	ChatEdit_SendText(DEFAULT_CHAT_FRAME.editBox, 0)
end

local function GetEnabledSortedAutoexecCommands()
	local result = {}
	for _, command in ipairs(AutoDB.sortedkeys(AutoDB_AutoexecCommandsSet)) do
		if AutoDB_AutoexecCommandsSet[command] then
			table.insert(result, command)
		end
	end
	return result
end

local commandsByName = {}

local function HandleHelpCommand()
	AutoDB.info("AutoDB v%s", AutoDB.version)
	for _, command in ipairs(AutoDB.sortedkeys(commandsByName)) do
		local _, _, help = unpack(commandsByName[command])
		local arguments, description = unpack(help)
		AutoDB.info("%s %s - %s",
			AutoDB.color("/autodb", "33ffcc"),
			AutoDB.color(command .. (arguments ~= "" and (" " .. arguments) or ""), "ffffff"),
			AutoDB.color(description, "cccccc"))
	end
end

local function HandlePrintCommand()
	local commands = GetEnabledSortedAutoexecCommands()
	if getn(commands) == 0 then
		AutoDB.info("AutoDB autoexec is empty")
		return
	end
	AutoDB.info("AutoDB autoexec commands:")
	for _, command in ipairs(commands) do
		AutoDB.info(command)
	end
end

local function HandleAddCommand(command)
	AutoDB.info("Adding [%s] to autoexec", command)
	AutoDB_AutoexecCommandsSet[command] = true
	ExecuteSlashCommand(command)
end

local function HandleRemoveCommand(command)
	if AutoDB_AutoexecCommandsSet[command] == nil then
		AutoDB.error("Unable to find [%s] in autoexec", command)
		return
	end
	AutoDB.info("Removing [%s] from autoexec", command)
	AutoDB_AutoexecCommandsSet[command] = nil
end

commandsByName = {
	["help"] = {
		HandleHelpCommand,
		false,
		{"", "print this help"},
	},
	["list"] = {
		HandlePrintCommand,
		false,
		{"", "print autoexec content"},
	},
	["add"] = {
		HandleAddCommand,
		true,
		{"<command>", "add new command to autoexec (e.g. /autodb add mines auto)"},
	},
	["remove"] = {
		HandleRemoveCommand,
		true,
		{"<command>", "removes command from autoexec (e.g. /autodb remove chests)"},
	},
}

local function DispatchCommand(input)
	local command, arguments = AutoDB.strsplit(AutoDB.strtrim(input), 2)
	if arguments ~= nil then
		arguments = format("/db %s", strlower(arguments))
	end

	local handle, requiresArguments = unpack(commandsByName[command] or {})
	if handle == nil or requiresArguments ~= (arguments ~= nil) then
		handle = HandleHelpCommand
	end

	handle(arguments)
end

local function RunAutoexec()
	if (IsAddOnLoaded("pfQuest")) then
		for _, command in ipairs(GetEnabledSortedAutoexecCommands()) do
			ExecuteSlashCommand(command)
		end
	end
end

SLASH_AUTODB1 = "/autodb"
SlashCmdList["AUTODB"] = DispatchCommand

AutoDB:RegisterEvent("VARIABLES_LOADED")
AutoDB:SetScript("OnEvent", RunAutoexec)
