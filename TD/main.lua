-- Ludum Dare #24 Project
-- Tower Defense
-- Theme: Evolution
-- Author: Mads Clausen
-- Project start: 25/08 - 2012 2:17 PM.
-- Project end: N/A

require "level"
require "castle"
require "player"
require "enemy"

require "button"

local currentLevel = nil
local weaponTypes = {
	bow = {
		speed = 25,
		_type = "bow",
		subType = "bow",
		damage = 75
	},
	pistol = {
		speed = 3,
		_type = "gun",
		subType = "pistol",
		ammo = 11,
		maxAmmo = 11,
		damage = 35
	},
	machinegun = {
		speed = 3,
		_type = "gun",
		subType = "machinegun",
		ammo = 30,
		maxAmmo = 30,
		damage = 35
	}
}

local menus = {
	current = {
		buttons = {}
	},
	main = {
		buttons = {},
		background = {
			86,
			86,
			86,
			255
		}
	}
}

ingame = false
dt = 0
g = 7
debug = true

function love.load()
	currentLevel = newLevel({
		castle = newCastle({
			x = 0,
			y = 0,
			img = love.graphics.newImage("res/castle_01.png")
		}),
		player = newPlayer({
			x = 200,
			y = 385,
			img = love.graphics.newImage("res/player_01.png"),
			bowImg = love.graphics.newImage("res/bow_01.png"),
			pistolImg = love.graphics.newImage("res/pistol_01.png"),
			machinegunImg = love.graphics.newImage("res/machinegun_01.png")
		})
	})

	love.mouse.setVisible(false)

	print("Controls:\n\tToggle weapon type: t\n\tToggle Debug Mode: F1\N\TReload: r")

	for i = 1, 2, .1 do
		table.insert(currentLevel.enemies, newEnemy({
			x = 600 * i,
			y = love.graphics.getHeight() - 48 - 24,
			img = love.graphics.newImage("res/enemy_01.png")
		}))
	end

	local m = {
		buttons = {},
		background = {
			86,
			86,
			86,
			255
		}
	}

	local b = newButton("Start Game", love.graphics.getWidth() / 2 - 100, love.graphics.getHeight() / 2 - 16, 200, 32)
	b.border.enabled = false
	b.color = {
		r = 119,
		g = 119,
		b = 119,
		a = 255
	}
	b.onClick = function()
		ingame = true
	end
	b.onHoverBegin = function()
		b.color = {
			r = 141,
			g = 141,
			b = 141,
			a = 255
		}
	end
	b.onHoverEnd = function()
		b.color = {
			r = 119,
			g = 119,
			b = 119,
			a = 255
		}
	end
	b.text.color = {
		r = 238,
		g = 238,
		b = 60,
		a = 255
	}

	table.insert(m.buttons, b)

	menus.main = m
	menus.current = menus.main
end

function love.draw()
	if ingame then
		if currentLevel ~= nil and currentLevel.draw ~= nil then
			currentLevel:draw()
		end
	else
		love.graphics.setColor(menus.current.background[1], menus.current.background[2], menus.current.background[3], menus.current.background[4])
		love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

		for _, b in pairs(menus.current.buttons) do
			if b.visible then
				if b.border.enabled then
					love.graphics.setColor(b.border.color.r, b.border.color.g, b.border.color.b, b.border.color.a)
					
					love.graphics.setLineWidth(1)
					love.graphics.line(b.x - 1, b.y - 1, b.x - 1, b.y + b.height + 1)
					love.graphics.line(b.x - 1, b.y + b.height + 1, b.x + b.width + 1, b.y + b.height + 1)
					love.graphics.line(b.x + b.width + 1, b.y + b.height + 1, b.x + b.width + 1, b.y - 1)
					love.graphics.line(b.x + b.width + 1, b.y - 1, b.x - 1, b.y -1)
					love.graphics.line(b.x - 1, b.y - 1, b.x - 1, b.y + b.height + 1)
					love.graphics.line(b.x - 1, b.y + b.height + 1, b.x + b.width + 1, b.y + b.height + 1)
					love.graphics.line(b.x + b.width + 1, b.y + b.height + 1, b.x + b.width + 1, b.y - 1)
					love.graphics.line(b.x + b.width + 1, b.y - 1, b.x - 1, b.y -1)
				end

				love.graphics.setColor(b.color.r, b.color.g, b.color.b, b.color.a)
				love.graphics.rectangle("fill", b.x, b.y, b.width, b.height)

				love.graphics.setColor(b.text.color.r, b.text.color.g, b.text.color.b, b.text.color.a)
				love.graphics.setFont(b.text.font)
				love.graphics.print(b.text.data, b.x + b.width / 2 - b.text.font:getWidth(b.text.data) / 2, b.y + b.height / 2 - b.text.font:getHeight() / 2)
			end
		end
	end

	love.graphics.setColor(0, 0, 0, 164)
	local x, y = love.mouse.getPosition()
	love.graphics.line(x - 7, y, x + 7, y)
	love.graphics.line(x, y - 7, x, y + 7)

	if debug then
		love.graphics.setColor(0, 0, 0, 255)
		love.graphics.print("FPS: " .. love.timer.getFPS(), 0, 0)
	end
end

function love.update(_dt)
	dt = _dt

	if ingame then
		if currentLevel ~= nil then
			currentLevel:update(dt)
		end
	else
		for _, b in pairs(menus.current.buttons) do
			local x, y = love.mouse.getX(), love.mouse.getY()

			if x > b.x and x < b.x + b.width and y > b.y and y < b.y + b.height then
				if not b.hover then
					b.hover = true
					b.onHoverBegin()
				end
			else
				if b.hover then
					b.hover = false
					b.onHoverEnd()
				end
			end
		end
	end
end

function love.mousereleased(x, y, button)
	if ingame then 
		currentLevel:mousereleased(x, y, button)
	end
end

function love.mousepressed(x, y, button)
	if ingame then
		currentLevel:mousepressed(x, y, button)
	else
		for _, b in pairs(menus.current.buttons) do
			if b ~= nil and b.visible then
				b:mousepressed(x, y, button)
			end
		end
	end
end

function love.keypressed(key)
	if ingame then
		if key == "t" then
			--[[
			if currentLevel.player.currentWeapon._type == "bow" then
				currentLevel.player.currentWeapon = weaponTypes.pistol
			else
				if currentLevel.player.currentWeapon.subType == "machinegun" then
					currentLevel.player.currentWeapon = weaponTypes.bow
				else
					currentLevel.player.currentWeapon = weaponTypes.machinegun
				end
			end --]]

			if currentLevel.player.currentWeapon.subType == "machinegun" then
				currentLevel.player.currentWeapon = weaponTypes.pistol
			else
				currentLevel.player.currentWeapon = weaponTypes.machinegun
			end
		elseif key == "r" then
			currentLevel.player:reload()
		elseif key == "f1" then
			debug = not debug
		elseif key == "escape" then
			ingame = false
		end
	end
end