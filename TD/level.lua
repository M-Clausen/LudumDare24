local level = {
	background = {
		isImage = false,
		img = nil,
		color = {
			64,
			224,
			224,
			255
		}
	},
	foreground = {
		isImage = false,
		img = nil,
		color = {
			64,
			224,
			224,
			0
		}
	},
	player = "NONE_YET" ,
	castle = "NONE_YET" ,
	enemies = {}
}
level.__index = level
setmetatable(level, level)

function newLevel(t)
	setmetatable(t, level)
	
	return t
end

function level:update(dt)
	if self.player ~= "NONE_YET" then
		self.player:update(dt)
	end
	
	if self.castle ~= "NONE_YET"  then
		self.castle:update(dt)
	end

	for _, enemy in pairs(self.enemies) do
		if enemy  ~= nil and enemy.update ~= nil and enemy.visible then
			enemy:update(dt, {
				x = self.castle.x, 
				width = self.castle.img:getWidth()
			})

			if enemy.x + enemy.img:getWidth() > self.castle.x and enemy.x + enemy.img:getWidth() < self.castle.x + self.castle.img:getWidth() - 30 then
				self.castle.health = self.castle.health - enemy.damPerSec * dt
			end

			for _, pro in pairs(self.player.projectiles) do
				if pro ~= nil and pro.visible then
					if pro.firedBy == "bow" then	
						local x = pro.p_x - pro.prev_x
						local y = pro.p_y - pro.prev_y
						local len = math.sqrt(x ^ 2 + y ^ 2)
						local stepX = x / len
						local stepY = y / len 

						x = pro.prev_x
						y = pro.prev_y

						for i = 0, len do
							if x > enemy.x and x < enemy.x + enemy.img:getWidth() and y > enemy.y and y < enemy.y + enemy.img:getHeight() then
								print("Collision: " .. enemy.health - 20)
								enemy.health = enemy.health - self.player.currentWeapon.damage
								pro.visible = false
								break
							end
						end
					else 	
						if pro.p_x > enemy.x and pro.p_x < enemy.x + enemy.img:getWidth() and pro.p_y > enemy.y and pro.p_y < enemy.y + enemy.img:getHeight() then
							print("Collision: " .. enemy.health - 20)
							enemy.health = enemy.health - self.player.currentWeapon.damage
							pro.visible = false
						end
					end
				end
			end
		end
	end
end

function level:draw()
	love.graphics.setColor(self.background.color[1], self.background.color[3], self.background.color[2], self.background.color[4])
	if self.background.isImage then
		love.graphics.setColor(255, 255, 255, 255)
		love.graphics.draw(self.background.img, 0, 0)
	else
		love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
	end

	if self.castle ~= "NONE_YET"  then
		self.castle:draw()
	end

	if self.player ~= "NONE_YET"  then
		self.player:draw()
	end

	for _, enemy in pairs(self.enemies) do
		if enemy ~= nil and enemy.draw ~= nil then
			enemy:draw()
		end
	end
	
	love.graphics.setColor(self.foreground.color[1], self.foreground.color[3], self.foreground.color[2], self.foreground.color[4])
	if self.foreground.isImage then
		love.graphics.setColor(255, 255, 255, 255)
		love.graphics.draw(self.foreground.img, 0, 0)
	else
		love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
	end

	if debug then
		love.graphics.setColor(0, 0, 0, 255)
		love.graphics.print("Castle Health: " .. self.castle.health, 400, 0)
	end
end

function level:mousereleased(x, y, button)
	if self.player ~= "NONE_YET" then
		self.player:mousereleased(button)
	end
end

function level:mousepressed(x, y, button)
	if self.player ~= "NONE_YET" then
		self.player:mousepressed(x, y, button)
	end
end