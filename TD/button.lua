local button = {
	x = 0,
	y = 0,
	width = 0,
	height = 0,
	color = {
		r = 87,
		g = 181,
		b = 203,
		a = 255
	},
	border = {
		enabled = true,
		color = {
			r = 0,
			g = 0,
			b = 0,
			a = 255
		}
	},
	text = {
		data = "",
		font = nil
	},
	hover = false,
	onHoverBegin = function() end,
	onHoverEnd = function() end,
	onClick = function() end,
	visible = true,
	autoRegulateTextSize = true
}
button.__index = button
setmetatable(button, button)

function newButton(text, x, y, width, height)
	local b = {
		text = {
			color = {
				r = 255,
				g = 255,
				b = 255,
				a = 255
			}
		}
	}
	b.x = x
	b.y = y
	b.width = width
	b.height = height
	b.text.data = text

	local fontGood = false
	local textSize = height - 6

	while not fontGood do
		local font = love.graphics.newFont("res/georgia.ttf", textSize)
		love.graphics.setFont(font)

		if font:getWidth(b.text.data) < width - 6 then
			fontGood = true
			b.text.font = font
		end

		textSize = textSize - 1
	end

	setmetatable(b, button)

	return b
end

function button:setText(text, path)
	if self.autoRegulateTextSize then
		local fontGood = false
		local textSize = self.height - 6

		path = path or "res/georgia.ttf"

		while not fontGood do
			local font = love.graphics.newFont(path, textSize)

			love.graphics.setFont(font)

			if font:getWidth(text) < self.width - 6 then
				fontGood = true
				self.text.font = font
			end

			textSize = textSize - 1
		end
	end

	self.text.data = text
end

function button:mousepressed(x, y, button)
	if x > self.x and x < self.x + self.width and y > self.y and y < self.y + self.height then
		self.onClick(x, y, button)
	end
end