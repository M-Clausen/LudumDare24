local player = {
	x = 0,
	y = 0,
	shootingAngle = 0,
	shootingPower = 0,
	img = "NONE_YET",
	bowImg = "NONE_YET",
	pistolImg = "NONE_YET",
	machinegunImg = "NONE_YET",
	isShooting = false,
	t = 0,
	velX = 0,
	velY = 0,
	len = 0,
	projectiles = {},
	currentWeapon = {
		_type = "gun",
		subType = "pistol",
		speed = 3,
		ammo = 11,
		maxAmmo = 11,
		damage = 35
	},
	waitTime = 0,
	maxWaitTime = .15
}
player.__index = player
setmetatable(player, player)

function player:shoot(mx, my)
	if self.currentWeapon._type == "bow" then 
		local speed = 20

		speed = self.currentWeapon.speed

		local t = {
			speed = speed,
			p_y = 0,
			p_x = 0,
			velX = self.velX * (self.len / speed),
			velY = self.velY,
			t = 0,
			firedBy = "bow",
			visible = true,
			prev_x = 0,
			prev_y = 0
		}

		table.insert(self.projectiles, t)
	elseif self.currentWeapon._type == "gun" then
		if self.currentWeapon.ammo > 0 then 
			if self.currentWeapon.subType == "pistol" then 
				self.x = self.x + 24
				self.y = self.y + 20
			end

			local x = mx - self.x
			local y = my - self.y
			local len = math.sqrt(x ^ 2 + y ^ 2)

			local t = {
				speed = self.currentWeapon.speed,
				p_x = self.x,
				p_y = self.y,
				stepX = x / len,
				stepY = y / len,
				firedBy = "gun",
				visible = true
			}

			table.insert(self.projectiles, t)
		
			if self.currentWeapon.subType == "pistol" then 
				self.x = self.x - 24
				self.y = self.y - 20
			end

			self.currentWeapon.ammo = self.currentWeapon.ammo - 1
		end
	end
end

function player:reload()
	self.currentWeapon.ammo = self.currentWeapon.maxAmmo
end

function newPlayer(t) 
	setmetatable(t, player)

	return t
end

function player:update()

end

function player:draw()
	local mx, my = love.mouse.getPosition()
	
	love.graphics.setPointSize(3)
	love.graphics.setColor(255, 255, 255, 255)
	if self.img ~= "NONE_YET" then
		love.graphics.draw(self.img, self.x, self.y)
	else
		love.graphics.point(self, x, self.y)
	end

	self.x = self.x + 24
	self.y = self.y + 20

	if self.currentWeapon._type == "bow" then
		if love.mouse.isDown("l") then
			self.isShooting = false

			love.graphics.setColor(0, 0, 0, 128)
			love.graphics.setLineWidth(1)
			love.graphics.line(self.x - (self.x - mx), self.y - (self.y - my), self.x + (self.x - mx) / 3, self.y + (self.y - my) / 3)
		
			local x = self.x - mx
			local y = self.y - my

			local len = math.sqrt(x ^ 2 + y ^ 2)
			self.shootingAngle = math.acos(x / len)
			self.velX = x / len
			self.len = len 
			
			if not self.isShooting then
				self.velY = y / len * (len / 2)
			end 

			if my < self.y then
				self.shootingAngle = 2 * math.pi - self.shootingAngle
			end
		else
			local x = self.x - mx
			local y = self.y - my

			local len = math.sqrt(x ^ 2 + y ^ 2)
			self.shootingAngle = math.acos(x / len)

			if my < self.y then
				self.shootingAngle = 2 * math.pi - self.shootingAngle
			end
		end

		if self.bowImg ~= "NONE_YET" then
			love.graphics.setColor(255, 255, 255, 255)
			love.graphics.draw(self.bowImg, self.x, self.y, 2 * math.pi - self.shootingAngle, 1, 1, 0, 12)
		end
	elseif self.currentWeapon._type == "gun" then
		love.graphics.setColor(0, 0, 0, 164)
		love.graphics.circle("line", love.mouse.getX(), love.mouse.getY(), 5)

		local x = mx - self.x 
		local y = my - self.y

		local len = math.sqrt(x ^ 2 + y ^ 2)
		self.shootingAngle = math.acos(x / len)

		if self.y < my then
			self.shootingAngle = 2 * math.pi - self.shootingAngle
		end

		if self.currentWeapon.subType == "machinegun" then
			if self.waitTime >= self.maxWaitTime and love.mouse.isDown("l") then
				self.waitTime = 0
				self:shoot(mx, my)
			end

			self.waitTime = self.waitTime + dt

			if self.machinegunImg ~= "NONE_YET" then
				love.graphics.setColor(255, 255, 255, 255)
				love.graphics.draw(self.machinegunImg, self.x, self.y, 2 * math.pi - self.shootingAngle, 1, 1, 0, 8)
			end
		else
			if self.pistolImg ~= "NONE_YET" then
				love.graphics.setColor(255, 255, 255, 255)
				love.graphics.draw(self.pistolImg, self.x, self.y, 2 * math.pi - self.shootingAngle, 1, 1, 0, 8)
			end
		end
	end

	for _, pro in pairs(self.projectiles) do
		if pro ~= nil and pro.visible then
			if pro.firedBy == "bow" then 
				pro.velY = pro.velY + g * pro.t / 3

				pro.p_x = pro.p_x + pro.velX / 2
				pro.p_y = pro.p_y + pro.velY / 2

				love.graphics.setColor(0, 0, 0, 255)	
				love.graphics.point(math.floor(pro.p_x + .5) + self.x, math.floor(pro.p_y / 10 + .5) + self.y)

				pro.t = pro.t + dt
			elseif pro.firedBy == "gun" then
				love.graphics.setColor(0, 0, 0, 255)
				love.graphics.point(pro.p_x, pro.p_y)

				pro.p_x = pro.p_x + pro.stepX * pro.speed
				pro.p_y = pro.p_y + pro.stepY * pro.speed
			end

			if pro.p_x < 0 or pro.p_x > love.graphics.getWidth() or pro.p_y < 0 or pro.p_y > love.graphics.getHeight() then
				pro.visible = false
			end
		end
	end

	self.x = self.x - 24
	self.y = self.y - 20

	if debug and self.currentWeapon._type == "gun" then
		love.graphics.setColor(0, 0, 0, 255)
		love.graphics.print("Ammo: " .. self.currentWeapon.ammo, 500, love.graphics.getHeight() - 32)
	end
end

function player:mousereleased(button)
	if button == "l" and self.currentWeapon._type == "bow" then
		self:shoot()
	end
end

function player:mousepressed(x, y, button)
	if button == "l" and self.currentWeapon._type == "gun" and self.currentWeapon.subType == "pistol" then
		self:shoot(x, y)
	end
end