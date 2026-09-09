-------------------------------------------------------
--"自定义帮会职位名称"界面脚本
--create by xindefeng
-------------------------------------------------------

local g_NameCtls = nil	--需要用到的控件表

--标准帮会职位名称
local g_StdPositionName = {
	"帮主",			--9
	"副帮主",		--8
	"内务使",		--7
	"工务使",		--6
	"弘化使",		--5
	"商人",			--4
	"精英",			--3
	"帮众"			--2
}

--Reset按钮是否使用过标志
local g_ResetBtnFlag = {0,0,0,0,0,0,0,0}

local g_SaveForReset = nil --保存打开界面时"自定义职位名称"用于Reset

--事件注册
function ConfraternityCustomPosition_PreLoad()
	this:RegisterEvent("GUILD_SHOW_CUSTOMPOSITION")
	this:RegisterEvent("GUILD_FORCE_CLOSE")	
end

function ConfraternityCustomPosition_OnLoad()	
end

--事件响应
function ConfraternityCustomPosition_OnEvent(event)	
	if( event == "GUILD_SHOW_CUSTOMPOSITION" ) then
		ConfraternityCustomPosition_SetCtls()	--设置控件
		g_ResetBtnFlag = {0,0,0,0,0,0,0,0}
		
		ConfraternityCustomPosition_Clear()
		ConfraternityCustomPosition_Update()
		ConfraternityCustomPosition_Show()
	elseif( event == "GUILD_FORCE_CLOSE" ) then	
		ConfraternityCustomPosition_Close()
	end
end

--设置控件表
function ConfraternityCustomPosition_SetCtls()
	g_NameCtls = nil;
	
	g_NameCtls = {
									oldNames = {
										          	CurCustomPosition1,
										          	CurCustomPosition2,
										          	CurCustomPosition3,
										          	CurCustomPosition4,
										          	CurCustomPosition5,
										          	CurCustomPosition6,
										          	CurCustomPosition7,
										          	CurCustomPosition8,
										         },
									newNames = {
										          	Edit_CustomPosition1,
										          	Edit_CustomPosition2,
										          	Edit_CustomPosition3,
										          	Edit_CustomPosition4,
										          	Edit_CustomPosition5,
										          	Edit_CustomPosition6,
										          	Edit_CustomPosition7,
										          	Edit_CustomPosition8
										         },
									ResetBtn = {
																ConfraternityCustomPosition_Reset_Button1,
																ConfraternityCustomPosition_Reset_Button2,
																ConfraternityCustomPosition_Reset_Button3,
																ConfraternityCustomPosition_Reset_Button4,
																ConfraternityCustomPosition_Reset_Button5,
																ConfraternityCustomPosition_Reset_Button6,
																ConfraternityCustomPosition_Reset_Button7,
																ConfraternityCustomPosition_Reset_Button8
														}
								}
end

--清空界面数据
function ConfraternityCustomPosition_Clear()	
end

--刷新界面显示的数据
function ConfraternityCustomPosition_Update()
	local szMsg = nil
	
	ConfraternityCustomPosition_Title:SetText("#gFF0FA0自定义职位名称")
	
	--显示当前"自定义职位名称"
	for i=1,8 do
		g_NameCtls.ResetBtn[i]:SetText("恢复")		--修改按钮名字
		
		szMsg = Guild:GetCurCustomPositionName(10-i)		
		g_SaveForReset[i] = szMsg	--保存一下,用于比较判断是否改过		
		if((szMsg == "") or (szMsg == g_StdPositionName[i]))then
			szMsg = g_StdPositionName[i]
			g_NameCtls.ResetBtn[i]:Disable()	--从来没有改过,按钮不能使用,灰掉
		else
			szMsg = szMsg.."("..g_StdPositionName[i]..")"
			g_NameCtls.ResetBtn[i]:Enable()						--改过,按钮可以使用			
		end
		
		--设置当前自定义职位名称
		g_NameCtls.oldNames[i]:SetText(szMsg)
		
	end
	
	--将编辑框清空
	for i=1,8 do
		g_NameCtls.newNames[i]:SetText("")
	end	
	
end

--打开界面
function ConfraternityCustomPosition_Show()	
	this:Show()
end

--关闭窗口
function ConfraternityCustomPosition_Close()
	this:Hide()
end

--复位按钮
function ConfraternityCustomPosition_Reset(BtnId)
	g_NameCtls.oldNames[BtnId]:SetText(g_StdPositionName[BtnId])
	g_NameCtls.newNames[BtnId]:SetText("")
		
	g_ResetBtnFlag[BtnId] = 1	--设置使用标志	
	
	g_NameCtls.ResetBtn[BtnId]:SetText("#{INTERFACE_XML_1154}")
	g_NameCtls.ResetBtn[BtnId]:Disable()	--恢复一次就不能再用了，灰掉
end

--确定
function ConfraternityCustomPosition_Ok()
	local szOld = nil
	local szNew = nil
	local bIsChanged = 0	--记录是否有改变
	local bLegal = 1			--是否合法
	local result = 0			--修改结果
	local bTipFlag = 0		--是否需要提示"您的输入当中有转义字符"
	
	--在记录"新修改的帮会自定义职位名称"之前,先清空一下数据结构
	Guild:ClearCustomPositionName()
	
	for i=1,8 do		
		--获取输入
		szNew = g_NameCtls.newNames[i]:GetText()
		
		--检测是否有违法字符，如果检测通过则存储下来
		result = 0	--每次都要设置
		if(g_ResetBtnFlag[i] == 1)then	--使用了相应的Reset按钮,恢复标准职位名字
			bIsChanged = bIsChanged + 1	--发生改变
			result = Guild:AskModifyCustomPositionName(10-i, tostring(g_StdPositionName[i]), 1)	--检测存储
		elseif((szNew ~= "") and (szNew ~= g_SaveForReset[i]))then	--或者自定义了职位名称
			bIsChanged = bIsChanged + 1	--发生改变
			result = Guild:AskModifyCustomPositionName(10-i, tostring(szNew), 0)			--检测存储
		end
		
		--给出违法提示
		if (result == -1) then
			PushDebugMessage("您输入的“"..szNew.."”违法，请注意您的言辞！")	
			bLegal = 0	--标识有违法字符
			
			bIsChanged = bIsChanged - 1	--改变数量减1
		elseif (result == -2) then			
			bTipFlag = 1		--需要提示"您的输入当中有转义字符！"
			bLegal = 0	--标识有违法字符
			
			bIsChanged = bIsChanged - 1	--改变数量减1
		end		
	end
	
	--有不合法字符串直接返回
	if(bLegal == 0) then
		if(bTipFlag == 1)then	--需要提示
			PushDebugMessage("您的输入当中有违法字符！")	--提示："您的输入当中有转义字符！"
		end
		return
	end
	
	--发包
	if(bIsChanged > 0) then	--有改变
		Guild:AskModifyCustomPositionName(0)
	end
	
	--关闭窗口
	this:Hide()	
end

--取消
function ConfraternityCustomPosition_Cancel()
	this:Hide()
end