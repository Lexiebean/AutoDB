AutoDB.enumerate = function (iterator)
	local next = function(iter, i)
		local value = iter()
		if value == nil then
			return nil
		end
		return i + 1, value
	end
	return next, iterator, 0
end

AutoDB.strgfind = string.gmatch or string.gfind

AutoDB.strtrim = function(s)
	return string.gsub(s, "^%s*(.-)%s*$", "%1")
end

AutoDB.strsplit = function(s, n)
	local tokens = {}
	for i, token in AutoDB.enumerate(AutoDB.strgfind(s, "%S+")) do
		i = math.min(i, n or i)
		tokens[i] = (tokens[i] and (tokens[i] .. " ") or "") .. token
	end
	return unpack(tokens)
end

AutoDB.sortedkeys = function(t)
	local result = {}
	for key in pairs(t) do
		table.insert(result, key)
	end
	table.sort(result)
	return result
end

AutoDB.color = function(s, rgbs)
	return format("|cff%s%s", rgbs, s or "nil")
end

local print = function(rgbs, s, ...)
	DEFAULT_CHAT_FRAME:AddMessage(format(AutoDB.color(s or "nil", rgbs), unpack(arg)))
end

AutoDB.info = function (s, ...)
	print("ffff00", s, unpack(arg))
end

AutoDB.error = function (s, ...)
	print("ff0000", s, unpack(arg))
end
