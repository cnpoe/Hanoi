#Torres de Hanoi

require 'gosu'

NDISC = 7
CONST = 14
ANCHOW = 600
LARGOW = 1024
ANCHOD = 20.0

$ori = Array.new()
$des = Array.new()
$torre1 = Array.new()
$torre2 = Array.new()
$torre3 = Array.new()
$torres = [$torre1, $torre2, $torre3]

def hanoi(n,desde,hacia,temp)
	if n==1
		$ori.unshift(desde)
		$des.unshift(hacia)
	else
		hanoi(n-1,desde,temp,hacia)
		hanoi(1,desde,hacia,temp)
		hanoi(n-1,temp,hacia,desde)
	end
end

$colores = [
	0xff000000,
	0xff808080,
	0xffffffff,
	0xff00ffff,
	0xffff0000,
	0xff00ff00,
	0xff0000ff,
	0xffffff00,
	0xffff00ff,
	0xff00ffff,
	0xff000000,
	0xff808080,
	0xffffffff,
	0xff00ffff,
	0xffff0000,
	0xff00ff00,
	0xff0000ff,
	0xffffff00,
	0xffff00ff,
	0xff00ffff,
	0xff000000
]

class TorresHanoi < Gosu::Window
	def initialize(nd)
		super(LARGOW, ANCHOW, false)
		self.caption = "Torres de Hanoi"
		@background = Gosu::Image.new(self,"fondo.jpg", true)
		@pointer = Gosu::Image.new(self,"cursor.png",true)
		@px = @py = 0
		@nDiscos = nd
		@movimientos = calculaMovimientos
		i = -1
		maxsize = 320.0
		@x = 16.0
		@y = 500.0
		nd.times do
			$torre1.push(Disco.new(maxsize, i = i.next, @x, @y))
			maxsize = maxsize - CONST
			@x = @x + CONST / 2
			@y = @y - ANCHOD
		@band = false
		end
	end
	
	def button_down(id)
		if id == Gosu::MsLeft and $tmpManual.nil?
			puts @px
			@px = @px.to_i
			case @px
				when 0..342 then $origen = 0
				when 343..708 then $origen = 1 
				when 709..1024 then $origen = 2
				else $origen = nil
			end
			puts $origen
			
		elsif id == Gosu::MsRight
			puts @px
			@px = @px.to_i
			case(@px)
				when 0..342 then $destino = 0
				when 343..708 then $destino = 1 
				when 709..1024 then $destino = 2
				else $destino = nil
			end
			puts $destino
			if $tmpManual.nil? and !$origen.nil?
				$tmpManual = $torres[$origen].pop
			
			if $torres[$destino].size == 0
				$posible = true
			elsif $tmpManual.getIcolor > $torres[$destino][$torres[$destino].size - 1].getIcolor
				$posible = true
			else 
				$posible = false
			end
			end			
			if !$tmpManual.nil? and !$destino.nil? and !$origen.nil? and $posible	
				
				c = (320 - $tmpManual.getLargo) / 2
				
				case($destino)
					when 0 then newx = 16.0 + c
					when 1 then newx = 352.0 + c
					when 2 then newx = 688.0 + c
				end 
				
				newy = 500 - $torres[$destino].size * ANCHOD
			
				$tmpManual.setX(newx)
				$tmpManual.setY(newy)
			
				p newx
				p newy
				
				$torres[$destino].push($tmpManual)
				
				$origen = nil
				$destino = nil
				$tmpManual = nil
				$posible = false
			end
		end 
	end
	
	def calculaMovimientos
		return 2**@nDiscos
	end
	
	def update
		@px = mouse_x 
		@py = mouse_y 
	end
	
	def draw
		
		@background.draw(0,0,0)

		if @movimientos > 0
			if @band
				tmp1 = $des.pop
				tmp2 = $ori.pop

				tmp3 = $torres[tmp2].pop
				
				c = (320 - tmp3.getLargo) / 2
				
				case(tmp1)
					when 0 then newx = 16.0 + c
					when 1 then newx = 352.0 + c
					when 2 then newx = 688.0 + c
				end 
				
				newy = 500 - $torres[tmp1].size * ANCHOD
				
				tmp3.setX(newx)
				tmp3.setY(newy)
				
				$torres[tmp1].push(tmp3)

			end
		end
	
		@movimientos = @movimientos - 1
		
		@band = true

		for torre in $torres
			for disco in torre
				
				x = disco.getX()
				y = disco.getY()
				c = $colores[disco.getIcolor]
				l = disco.getLargo
				draw_quad( x, y, c, x + l, y, c, x, y + ANCHOD, c, x + l, y + ANCHOD, c, 0)
						
			end
		end
		
		@pointer.draw(@px,@py,0)
		sleep 0.1
		
	end
end

class Disco
	def initialize(large,iColor,x,y)
		@largo = large
		@color = iColor
		@x = x
		@y = y
	end
	def getLargo
		return @largo
	end
	def getIcolor
		return @color
	end
	def setX(x)
		@x = x
	end
	def setY(y)
		@y = y
	end
	def getX
		return @x
	end
	def getY
		return @y
	end
	def to_s
		"#{@color} "
	end
end

th = TorresHanoi.new(NDISC)
hanoi(NDISC,0,2,1)
$tmpManual = nil
th.show

