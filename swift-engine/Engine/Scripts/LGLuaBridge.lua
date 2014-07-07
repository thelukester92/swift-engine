--[[
gamelib is defined in C
function game.tween(object, property, value, options)
function game.getEntity(id)
function game.getComponent(object, component)
function game.getPointer(object, property)
function game.getValue(object, property)
function game.setValue(object, property, value)
--]]

entities = {}
entities.mt = {}
setmetatable(entities, entities.mt)

function entities.mt.__index(table, key)
	-- select entity from scene where id = key
	table[key] = Entity:new(game.getEntity(key))
	return table[key]
end

Entity = {}
Entity.mt = {}
setmetatable(Entity, Entity.mt)

function Entity:new(p)
	local o = { pointer = p }
	setmetatable(o, Entity.mt)
	return o
end

function Entity.mt.__tostring(self)
	return "<entity@" .. self.pointer .. ">"
end

function Entity.mt.__index(table, key)
	-- select component from entity where type = key
	table[key] = Component:new(game.getComponent(table.pointer, key))
	return table[key]
end

Component = {}
Component.mt = {}
setmetatable(Component, Component.mt)

function Component:new(p)
	local o = { pointer = p, properties = {} }
	setmetatable(o, Component.mt)
	return o
end

function Component.mt.__tostring(self)
	return "<component@" .. self.pointer .. ">"
end

function Component.mt.__index(table, key)
	-- TODO: figure out when not to cache here...
	-- if table.properties[key] == nil then
		-- select value from component where key = key
		table.properties[key] = game.getValue(table.pointer, key)
	-- end
	return table.properties[key]
end

function Component.mt.__newindex(table, key, value)
	-- update component set value = value where key = key
	table.properties[key] = value
	print("saving " .. key .. " = " .. value)
	game.setValue(table.pointer, key, value)
end