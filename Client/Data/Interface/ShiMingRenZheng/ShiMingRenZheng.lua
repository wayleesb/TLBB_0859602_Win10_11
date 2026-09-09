function ShiMingRenZheng_PreLoad()
	this:RegisterEvent("OPEN_SHIMINGRENZHENG_DLG");
end

function ShiMingRenZheng_OnLoad()
end

-- OnEvent
function ShiMingRenZheng_OnEvent(event)
	if( event == "OPEN_SHIMINGRENZHENG_DLG" ) then
		local haveShiming = tonumber(arg0);
		if(haveShiming == 1)then
			--Y您现在的游戏时间已超过3小时健康时间，在游戏中所获得的收益将会减少甚至无法获得收益，请您前往官网防沉迷信息认证页面中填写实名认证信息，验证已满18岁后，将不会被纳入#cff0000防沉迷系统#Y。否则，你的游戏收益在超过#cff00003小时#Y健康游戏时间后，会因#cff0000防沉迷系统#Y时间的限制而减少（#cff00003小时后收益减一半，6小时后完全没有收益#Y）。
			ShiMingRenZheng_WarningText : SetText("#{Interface_ShiMingRenZheng_txt4}")
		else
			--#Y尚未填写防沉迷实名认证信息的玩家，请您前往官方网站防沉迷信息认证页面中填写实名认证信息，验证已满18岁后，将不会被纳入#cff0000防沉迷系统#Y。否则，你的游戏收益在超过#cff00003小时#Y健康游戏时间后，会因#cff0000防沉迷系统#Y时间的限制而减少（#cff00003小时后收益减一半，6小时后完全没有收益#Y）。
			ShiMingRenZheng_WarningText : SetText("#{Interface_ShiMingRenZheng_txt3}")
		end
		ShiMingRenZheng_Init();
		this : Show()
	end

end

function ShiMingRenZheng_Init()

end

--去实名认证网站
function ShiMingRenZheng_Info_Clicked()
	if(Variable:GetVariable("System_CodePage") == "1258") then
		--do nothing
	else
		GameProduceLogin:OpenURL( "http://sde.game.sohu.com/fangchenmi/submitlogin.jsp" )
	end
end

function ShiMingRenZheng_Close_Clicked()
	--TO Do...
end