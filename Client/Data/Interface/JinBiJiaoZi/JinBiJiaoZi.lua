
local ShowConfirmBox = 0
local NpcServerId = 0

function JinBiJiaoZi_PreLoad( )

	this:RegisterEvent( "UI_COMMAND" )
	
end

function JinBiJiaoZi_OnLoad( )
	
end

function JinBiJiaoZi_OnEvent( event )

	if event == "UI_COMMAND" then
		JinBiJiaoZi_OnUICommand( arg0 )
	end

end

function JinBiJiaoZi_OnUICommand( arg0 )
	
	local op = tonumber( arg0 )
	
	if op == 800119 then
		this : Show( )
		
		NpcServerId = Get_XParam_INT( 0 )
		
		local npcClientId = DataPool : GetNPCIDByServerID( NpcServerId )
		if npcClientId ~= -1 then
			this:CareObject( npcClientId, 1, "JinBiJiaoZi" )
		end
	end
	
end

function JinBiJiaoZi_OnShown( )

	JinBiJiaoZi_Clear( )
	
	-- 设置焦点
	JinBiJiaoZi_Gold : SetProperty( "DefaultEditBox", "True" )
	
	-- 打开的同时开启物品栏
	OpenWindow( "Packet" )
end

function JinBiJiaoZi_Clear( )
	
	ShowConfirmBox = 0
	JinBiJiaoZi_Gold : SetProperty( "Text", "" )
	JinBiJiaoZi_Silver : SetProperty( "Text", "" )
	JinBiJiaoZi_CopperCoin : SetProperty( "Text", "" )
	
	JinBiJiaoZi_Accept_Button : Disable( )
	
end

function JinBiJiaoZi_Hide( )

	-- 关闭窗口
	this : Hide( )

end

function JinBiJiaoZi_OnHidden( )
		
	-- 取消NPC关心
	local npcClientId = DataPool : GetNPCIDByServerID( NpcServerId )
	if npcClientId ~= -1 then
		this : CareObject( npcClientId, 0, "JinBiJiaoZi")
	end
	
end


function JinBiJiaoZiAccept_Clicked( )
	
	-- 如果没输入过二级密码则输入一次，注意：Player:IsLocked( ) == 0表示锁定
	if Player:IsHavePassword( ) == 1 and Player:IsLocked( ) == 0 then
		OpenUnLockeMinorPasswordDlg( )
		return
	end
	
	-- 是否过了安全时间....
	if( tonumber(DataPool:GetLeftProtectTime( ) ) > 0 ) then
		PushDebugMessage( "#{OR_PILFER_LOCK_FLAG}" )
		return
	end
	
	-- 输入合法相关检查
	local jin = JinBiJiaoZi_Gold : GetProperty( "Text" )
	local yin = JinBiJiaoZi_Silver : GetProperty( "Text" )
	local tong = JinBiJiaoZi_CopperCoin : GetProperty( "Text" )
	
	-- 一定不能直接在脚本里加，9999金99银99铜以后就不精确了
	local bAvailability, money = Bank : GetInputMoney( jin , yin, tong )
	
	-- 玩家输入0，直接关闭
	if money == 0 then
		JinBiJiaoZi_Hide( )
		return
	end
		
	-- 输入金币超过本身携带的数量
	local holdMoney = Player:GetData( "MONEY" )
	if holdMoney < money then
		PushDebugMessage( "#{JBJZ_090407_5}" )
		return
	end
	
	-- 超过交子携带上限
	local holdJZ = Player:GetData( "MONEY_JZ" )
	if DataPool : ScriptPlus( holdJZ, money ) > 144000000 then
		PushDebugMessage( "#{JBJZ_090407_6}" )
		return	
	end
	
	-- 弹出确定窗口
	if ShowConfirmBox == 0 then
		local msgMoney = ""
		local msgJZ = ""
		if jin ~= "" and jin ~= "0" then
			msgMoney = msgMoney..jin.."#-02"
			msgJZ = msgJZ..jin.."#-14 "
		end
		if yin ~= "" and yin ~= "0" then
			msgMoney = msgMoney..yin.."#-03"
			msgJZ = msgJZ..yin.."#-15 "
		end
		if tong ~= "" and tong ~= "0" then
			msgMoney = msgMoney..tong.."#-04"
			msgJZ = msgJZ..tong.."#-16"
		end
		local msg = "#{JBJZ_090407_7}"..msgMoney.."#{JBJZ_090407_8}"..msgJZ.."#{JBJZ_090407_9}"
		GameProduceLogin : ShowMessageBox( msg, "Close", "-1")
		ShowConfirmBox = 1
		return
	end
	
	-- 给服务器端发送脚本执行命令
	Clear_XSCRIPT( )
		Set_XSCRIPT_Function_Name( "DoMoneyToJiaozi" )
		Set_XSCRIPT_ScriptID( 800119 )
		Set_XSCRIPT_Parameter( 0, money )
		Set_XSCRIPT_ParamCount( 1 )
	Send_XSCRIPT( )
	
	
	-- 都执行完了关闭窗口（操作成功由服务器端提示）
	JinBiJiaoZi_Hide( )
end

function JinBiJiaoZi_ChangeMoney( )
	
	ShowConfirmBox = 0
	
	local jin = JinBiJiaoZi_Gold : GetProperty( "Text" )
	local yin = JinBiJiaoZi_Silver : GetProperty( "Text" )
	local tong = JinBiJiaoZi_CopperCoin : GetProperty( "Text" )
	
	if jin ~= "" and jin ~= "0" then
		JinBiJiaoZi_Gold : SetTextOriginal( ""..tonumber(jin) )
	end
	
	if yin ~= "" and yin ~= "0" then
		JinBiJiaoZi_Silver : SetTextOriginal( ""..tonumber(yin) )
	end
	
	if tong ~= "" and tong ~= "0" then
		JinBiJiaoZi_CopperCoin : SetTextOriginal( ""..tonumber(tong) )
	end
	
	-- 一定不能直接在脚本里加，9999金99银99铜以后就不精确了
	local bAvailability, money = Bank : GetInputMoney( jin , yin, tong )
	
	if money > 0 then
		JinBiJiaoZi_Accept_Button : Enable( )
	else
		JinBiJiaoZi_Accept_Button : Disable( )
	end
	
end