-- Ludum Dare #24 Project
-- Tower Defense
-- Theme: Evolution
-- Author: Mads Clausen
-- Project start: 25/08 - 2012 2:17 PM.
-- Project end: N/A

require "level"
require "castle"
require "player"

local currentLevel = nil

ingame = true
dt = 0
g = 7
debug = false

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
			img = love.graphics.newImage("res/player_01.png")
		})
	})

	love.mouse.setVisible(false)

	print("Controls:\n\tToggle weapon type: t\n\tToggle pistol/machine gun: n")
end

function love.draw()
	if ingame then
		if currentLevel ~= nil and currentLevel.draw ~= nil then
			currentLevel:draw()
		end
	end

	love.graphics.setColor(0, 0, 0, 164)
	local x, y = love.mouse.getPosition()
	love.graphics.line(x - 7, y, x + 7, y)
	love.graphics.line(x, y - 7, x, y + 7)

	if debug then
		love.graphics.setColor(255, 255, 255, 255)
		love.graphics.print("FPS: " .. love.timer.getFPS(), 0, 0)
	end
end

function love.update(_dt)
	dt = _dt

	if ingame then
		if currentLevel ~= nil then
			currentLevel:update(dt)
		end
	end
end

function love.mousereleased(x, y, button)
	currentLevel:mousereleased(x, y, button)
end

function love.mousepressed(x, y, button)
	currentLevel:mousepressed(x, y, button)
end

function love.keypressed(key)
	if key == "t" then
		if currentLevel.player.currentWeapon._type == "bow" then
			currentLevel.player.currentWeapon._type = "gun"
			currentLevel.player.currentWeapon.speed = 3
		else
			currentLevel.player.currentWeapon._type = "bow"
			currentLevel.player.currentWeapon.speed = 25
		end
	elseif key == "n" then
		if currentLevel.player.currentWeapon.subType == "pistol" then
			currentLevel.player.currentWeapon.subType = "machinegun"
			currentLevel.player.currentWeapon.maxAmmo = 30
			currentLevel.player.currentWeapon.ammo = 30
		else
			currentLevel.player.currentWeapon.subType = "pistol"
			currentLevel.player.currentWeapon.maxAmmo = 11
			currentLevel.player.currentWeapon.ammo = 11
		end
	elseif key == "r" then
		currentLevel.player:reload()
	elseif key == "f1" then
		debug = not debug
	end
end