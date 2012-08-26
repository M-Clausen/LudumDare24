local enemy = {
	x = 0,
	y = 0,
	img = "NONE_YET",
	damPerSec = 10,
	health = 100,
	speed = 30,
	visible = true
}
enemy.__index = enemy
setmetatable(enemy, enemy)

function newEnemy(t)
	setmetatable(t, enemy)

	return t
end

function enemy:update(dt, castle)
	if self.visible then
		if self.x + self.img:getWidth() > castle.x and self.x + self.img:getWidth() < castle.x + castle.width - 30 then else
			self.x = self.x - self.speed * dt * 2
		end
		
		if self.health <= 0 then
			self.visible = false
		end
	end
end

function enemy:draw()
	if self.visible then 
		love.graphics.setColor(255, 255, 255, 255)
		love.graphics.draw(self.img, self.x, self.y)
	end
end