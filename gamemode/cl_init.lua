local loading_start = SysTime()

include("shared.lua")

print("gframework took " .. math.Round(SysTime() - loading_start, 3) .. " second(s) to initialize.")