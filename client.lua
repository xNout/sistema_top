local topRows = { }
local x, y   = guiGetScreenSize( )
local sx, sy = 1280, 600
function renderTOP()
	dxDrawRectangle(( 496 / sx )  * x, ( 105 / sy ) * y, 289, 67 + ( 16 * #topRows ), tocolor(config.windowColor1.r, config.windowColor1.g, config.windowColor1.b, config.windowColor1.alpha), false)
	dxDrawRectangle(( 496 / sx )  * x, ( 105 / sy ) * y, 289, 39, tocolor(config.windowColor2.r, config.windowColor2.g, config.windowColor2.b, config.windowColor2.alpha), false)
	
	dxDrawText(config.title, ( 548 / sx ) * x, ( 111 / sy ) * y, 734, 138,  tocolor(config.titleColor.r, config.titleColor.g, config.titleColor.b, config.titleColor.alpha), 1.00, "bankgothic", "left", "top", false, false, false, false, false)
	dxDrawText(config.colum1, ( 506 / sx ) * x, ( 148 / sy ) * y, 657, 162, tocolor(config.columnColor.r, config.columnColor.g, config.columnColor.b, config.columnColor.alpha), 1.00, "default-bold", "left", "top", false, false, false, false, false)
	dxDrawText(config.colum2, ( 715 / sx ) * x, ( 148 / sy ) * y, 764, 162, tocolor(config.columnColor.r, config.columnColor.g, config.columnColor.b, config.columnColor.alpha), 1.00, "default-bold", "left", "top", false, false, false, false, false)

	for i, v in ipairs(topRows) do

		local str;

		if ( i < 10 ) then
			str = string.format("[%s]   %s", i, v[1] )
		else
			str = string.format("[%s] %s", i, v[1] )
		end
		dxDrawText(str, ( 506 / sx ) * x, ( ( 152 + ( 16 * i ) ) / sy ) * y, 688, 180, tocolor(config.rowsColor.r, config.rowsColor.g, config.rowsColor.b, config.rowsColor.alpha), 1.00, "default-bold", "left", "top", false, false, false, true, false)
		dxDrawText(v[2], ( 725 / sx ) * x, ( ( 152 + ( 16 * i ) ) / sy ) * y, 764, 180, tocolor(config.rowsColor.r, config.rowsColor.g, config.rowsColor.b, config.rowsColor.alpha), 1.00, "default-bold", "left", "top", false, false, false, false, false)
	end

end

local bool = false
function openClose( )
	if( not bool ) then
		removeEventHandler("onClientRender", root, renderTOP )
		addEventHandler("onClientRender", root, renderTOP )
	else
		removeEventHandler("onClientRender", root, renderTOP )
	end
	showCursor( not bool )
	bool = not bool;
end
bindKey("F5", "down", openClose )



function updateRows( killsTable )
	topRows = {}
	for i,v in ipairs( killsTable ) do
		local name    = v["player_name"];
		local murders = v["kills"];
		table.insert( topRows, { name, murders } );
	end
end
addEvent("updateCTable", true)
addEventHandler("updateCTable", getLocalPlayer(), updateRows )