-- local Array = require ("Array")
local String = require("String")

-- local _Array = Array:array()

-- _Array:pop()
-- _Array:output()

-- _Array:push(1)
-- _Array:output()

-- _Array:push(2)
-- _Array:output()

-- _Array = Array:array()
-- _Array:output()

-- _Array:insert(100, 3)
-- _Array:output()

-- _Array:insert(1, 3)
-- _Array:output()

-- _Array:push(1)
-- _Array:output()

-- _Array:push(2)
-- _Array:output()

-- _Array:remove(100)
-- _Array:output()

-- _Array:remove(1)
-- _Array:output()

-- _Array:pop()
-- _Array:output()

-- _Array:clear()
-- _Array:output()

local str_Test1 = String:string("test1")
str_Test1:output()

local str_Test2 = String:string("test2")
str_Test2:output()

str_Test1:reset("new test string")
str_Test1:output()

local int_Len = str_Test1:len()
print(int_Len)

local str_Sub = str_Test1:sub(1, 2)
print(str_Sub)

str_Test1:append("append string")
str_Test1:output()

local bool_Equal = str_Test1:equal(str_Test2)
print(bool_Equal)