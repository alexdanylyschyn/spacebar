-- Simplify requiring spacebar from ~/hammerspoon/init.lua

package.path = os.getenv'HOME' ..'/.hammerspoon/spacebar/?.lua;' .. package.path
return require 'spacebar.spacebar'
