local castle = {
	health = 1000,
	maxHealth = 1000,
	img = nil,
	x = 0,
	y = 0
}
castle.__index = castle
setmetatable(castle, castle)

function newCastle(t)
	setmetatable(t, castle)
	
	return t
end

function castle:update(dt)

end

function castle:draw()
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.draw(self.img, self.x, self.y)
end