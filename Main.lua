local Array = require "Array"

local _Array = Array:array()

_Array:pop()
_Array:output()

_Array:push(1)
_Array:output()

_Array:push(2)
_Array:output()

_Array = Array:array()
_Array:output()

_Array:insert(100, 3)
_Array:output()

_Array:insert(1, 3)
_Array:output()

_Array:push(1)
_Array:output()

_Array:push(2)
_Array:output()

_Array:remove(100)
_Array:output()

_Array:remove(1)
_Array:output()

_Array:pop()
_Array:output()

_Array:clear()
_Array:output()