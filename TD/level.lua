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
		if enemy  ~= nil and enemy.update ~= nil then
			enemy:update(dt)
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