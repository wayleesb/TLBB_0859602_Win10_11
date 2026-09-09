local	gOpType						= 0; --操作类型
local	gExp							= 0; --最大经验
local	gAssExp						= 0; --可以兑换的最大经验
local	gGBValue					= 0; --最大善恶值
local	gAssGBValue				= 0; --兑换的最大善恶值
local	gGPValue					= 0; --最大帮派贡献度
local	gAssGPValue				= 0; --兑换的最大帮派贡献度
local	gMasterLevel			= 0; --师傅等级
local	gBasePoint				= 0;
local	objCared					= -1;
local	MAX_OBJ_DISTANCE	= 3.0;

--===============================================
-- OnLoad()
--===============================================
function ExpAssign_PreLoad()
	this:RegisterEvent("OPEN_EXP_ASSIGN");
	this:RegisterEvent("OBJECT_CARED_EVENT");
	this:RegisterEvent("UI_COMMAND");
end

function ExpAssign_OnLoad()
end

--===============================================
-- OnEvent()
--===============================================
function ExpAssign_OnEvent(event)
	if( event == "OPEN_EXP_ASSIGN" )then
		ExpAssign_Update();
		this:Show();
		objCared = DataPool : GetNPCIDByServerID( Get_XParam_INT(0) );
		if objCared == -1 then
				PushDebugMessage("server传过来的数据有问题。");
				return;
		end
		this:CareObject(objCared, 1, "ExpAssign");
	elseif (event == "OBJECT_CARED_EVENT" and this:IsVisible()) then
		if(tonumber(arg0) ~= objCared) then
			return
		end
		
		--如果和NPC的距离大于一定距离或者被删除，自动关闭
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			--取消关心
			this:CareObject(objCared, 0, "ExpAssign");
			this:Hide();
			objCared = -1
		end
	end
end

function ExpAssign_Update()

	AxTrace(0,0,tostring(arg0));
	local	str0, str1
	_, _, gExp, gGBValue, gGPValue, gMasterLevel, gOpType	= string.find( arg0, "(%d+),(%d+),(%d+),(%d+),(%d+)" );
	gExp					= tonumber( gExp )
	gGBValue			= tonumber( gGBValue )
	gGPValue			= tonumber( gGPValue )
	gMasterLevel	= tonumber( gMasterLevel )
	gOpType				= tonumber( gOpType )

	AxTrace(0,0,"gExp="..tostring(gExp));
	AxTrace(0,0,"gGBValue="..tostring(gGBValue));
	AxTrace(0,0,"gGPValue="..tostring(gGPValue));
	AxTrace(0,0,"gMasterLevel="..tostring(gMasterLevel));
	AxTrace(0,0,"gOpType="..tostring(gOpType));
	
	--善恶值兑换
	if gOpType == 1 then
		ExpAssign_Info2:SetText("每次最大能兑换的善恶值为5000点。");
		if gMasterLevel == 1 then
			gBasePoint = 30; 		--1级师傅等级
		elseif gMasterLevel == 2 then
			gBasePoint = 35;		--2级师傅等级
		elseif gMasterLevel == 3 then
			gBasePoint = 50;		--3级师傅等级
		elseif gMasterLevel == 4 then
			gBasePoint = 70;		--4级师傅等级
		end
		
		if(gBasePoint ==0)then
			gAssGBValue = 0;
			gAssExp = 0;
		else
			if(gGBValue * gBasePoint>gExp)then
				--玩家善恶点*a大于可兑换经验
				if(gExp >5000 * gBasePoint)then
					gAssGBValue = 5000;
					gAssExp = 5000 * gBasePoint;	
				else
					gAssGBValue = math.ceil( gExp / gBasePoint )	
					gAssExp = gExp;
				end
			else
				if(gGBValue>5000)then
					gAssGBValue = 5000;
					gAssExp = 5000 * gBasePoint;	
				else
					gAssGBValue = gGBValue;
					gAssExp = gGBValue*gBasePoint;
				end
			end
		end
		str0	= "您现在可以提取的经验为"..tostring( gExp )..",您拥有的善恶值为"..tostring( gGBValue )
		str1	= "需要善恶点:0"

	--帮派贡献度兑换
	elseif gOpType == 2 then
		ExpAssign_Info2:SetText("每天用帮贡最多可领取的经验为12万点。");
		if gMasterLevel == 1 then
			gBasePoint = 250;		--1级师傅等级
		elseif gMasterLevel == 2 then
			gBasePoint = 300;		--2级师傅等级
		elseif gMasterLevel == 3 then
			gBasePoint = 400;		--3级师傅等级
		elseif gMasterLevel == 4 then
			gBasePoint = 600;		--4级师傅等级
		end
		gAssGPValue		= gGPValue
		gAssExp				= gGPValue * gBasePoint
		if gAssExp > gExp and gBasePoint ~= 0 then
			gAssExp			= gExp
			gAssGBValue	= math.ceil( gAssExp / gBasePoint )
		end
		str0	= "您现在可以提取的经验为"..tostring( gExp )..",您拥有的帮派贡献度为"..tostring( gGPValue )
		str1	= "需要帮派贡献度:0"

	else
		return
	end

	ExpAssign_Cur_Info:SetText( str0 )
	ExpAssign_Moral_Need:SetText( str1 );
	--文本输入框
	ExpAssign_Moral_Value:SetText( "0" );

end

function ExpAssign_Button_Max_Click()

	AxTrace(0,0,"gBasePoint="..tostring(gBasePoint));
	if gBasePoint == 0 then
		return
	end
	
	local	str
	--善恶值兑换
	if gOpType == 1 then
		str	= "需要善恶点:"..tostring(gAssGBValue)
	--帮派贡献度兑换
	elseif gOpType == 2 then
		str	= "需要帮派贡献度:"..tostring(gAssGPValue)
	else
		return
	end
	ExpAssign_Moral_Need:SetText( str );
	--文本输入框
	ExpAssign_Moral_Value:SetText( tostring(gAssExp) );

end

function ExpAssign_Value_Change()

	if gBasePoint == 0 then
		return
	end
	
	local nCurExp
	local	str
	nCurExp		= tonumber( ExpAssign_Moral_Value:GetText() );
	if nCurExp == nil then
		nCurExp	= 0
	end
	if nCurExp > gAssExp then
		nCurExp	= gAssExp
		ExpAssign_Moral_Value:SetText( nCurExp );
	end
	--善恶值兑换
	if gOpType == 1 then
		str	= "需要善恶点:"..tostring( math.ceil( nCurExp / gBasePoint ) )
	--帮派贡献度兑换
	elseif gOpType == 2 then
		str	= "需要帮派贡献度:"..tostring( math.ceil( nCurExp / gBasePoint ) )
	else
		return
	end
	ExpAssign_Moral_Need:SetText( str );

end

function ExpAssign_Button_Get_Click()
	local nCurExp = tonumber( ExpAssign_Moral_Value:GetText() );
	if nCurExp == nil then
		nCurExp = 0
	end
	if nCurExp > 0 then
		Player:SetExpAssgin( nCurExp, gOpType );
	end
	
	this:Hide();
end

function ExpAssign_Button_Close_Click()
	this:Hide();
end
