----------------------------------------------------------------------------------------------------------------
--
-- 全局变量定义
--

-- 每一页中头像的个数.
local g_iFaceCountInPage = 9;

-- 当前选择的性别
local iCurSelSex = 0;			-- 0 : 女
													-- 1 : 男
--脸形控件
local g_FaceSel = {};

--当前选择的页数
local g_FacePageCount = 0;

-- 当前得到脸形的个数
local g_iCurFaceCount = 0;

-- 当前选择的头像的索引
local g_iCurSelFaceIndex = 0;

-- 当前选择的脸形
local g_iCurSelFaceIndex    = 0;
local g_iCurSelFaceIndexOld = 0;

-- 当前选择的发型
local g_iCurSelHairIndex    = 0;
local g_iCurSelHairIndexOld = 0;

-- 当前选择的套装2006-6-2
local g_iCurSelEquipSetIndex    = 0;
local g_iCurSelEquipSetIndexOld = 0;

local MaxEquipIndex = 2

local g_FaceModel = {}
local g_iCurSelectFace = 0

-----------------------------------------------------------------------------------------------------------------
--
-- 函数定义
--

function LoginCreateRole_PreLoad()
	-- 打开界面
	this:RegisterEvent("GAMELOGIN_OPEN_CREATE_CHARACTOR");
	
	-- 关闭界面
	this:RegisterEvent("GAMELOGIN_CLOSE_CREATE_CHARACTOR");
	
	-- 清空创建角色名字。
	this:RegisterEvent("GAMELOGIN_CREATE_CLEAR_NAME");

end

-- 注册onLoad事件
function LoginCreateRole_OnLoad()
	
	CreateRole_SelectSex_Girl:SetText("女");
	CreateRole_SelectSex_Boy:SetText("男");
	
	CreateRole_SelectSex_Girl:SetProperty("CheckMode", "1");	
	CreateRole_SelectSex_Boy:SetProperty("CheckMode", "1");	
	
	-- 头像选择按钮
	g_FaceSel[0] = CreateRole_Select_HeadImage1;
	g_FaceSel[1] = CreateRole_Select_HeadImage2;
	g_FaceSel[2] = CreateRole_Select_HeadImage3;
	g_FaceSel[3] = CreateRole_Select_HeadImage4;
	g_FaceSel[4] = CreateRole_Select_HeadImage5;
	g_FaceSel[5] = CreateRole_Select_HeadImage6;
	g_FaceSel[6] = CreateRole_Select_HeadImage7;
	g_FaceSel[7] = CreateRole_Select_HeadImage8;
	g_FaceSel[8] = CreateRole_Select_HeadImage9;
	
	for i=0, 20  do
		g_FaceModel[i] = -1
	end	
	
	-- 得到脸形信息
	CreateRole_GetFaceModel();
	
	-- 得到发型信息
	CreateRole_GetHairModel();
	
	-- 得到套装信息
	CreateRole_GetNewRoleEquipSet();
	
	-- 随机选择一个新手装。
	local RandVal = math.random( 0, MaxEquipIndex )
  g_iCurSelEquipSetIndex = RandVal
	
	CreateRole_SelEquipSet(g_iCurSelEquipSetIndex);

end

-- OnEvent
function LoginCreateRole_OnEvent(event)

	if( event == "GAMELOGIN_OPEN_CREATE_CHARACTOR" ) then
	
		CreateRole_Name:SetProperty("DefaultEditBox", "True");
		this:Show();
		if(0 == iCurSelSex) then
			-- 选择女主角.
			CreateRole_SelectGirl();
		elseif(1 == iCurSelSex) then
			-- 选择男主角.
			CreateRole_SelectBoy();
		end
		
		-- 显示头像.
		CreateRole_ShowRoleFace(iCurSelSex);
		
		return;
	end
		
	if( event == "GAMELOGIN_CLOSE_CREATE_CHARACTOR") then
		
		CreateRole_Name:SetProperty("DefaultEditBox", "False");
		this:Hide();
		return;
	end
	
	if( event == "GAMELOGIN_CREATE_CLEAR_NAME") then
		
		CreateRole_Name:SetText("");
		return;
	end
	
 		
end


---------------------------------------------------------------------------------------------------------
--
-- 更多脸形
--
function CreateRole_BnClickMoreFace()
			
end			

---------------------------------------------------------------------------------------------------------
--
-- 创建角色
--
function CreateRole_BnClickCreateRole()

	local szName = CreateRole_Name:GetText();
	GameProduceLogin:CreateRole(szName, iCurSelSex);
end


---------------------------------------------------------------------------------------------------------
--
-- 回到人物选择界面
--
function CreateRole_BnClickReturnSelectRole()

	-- 从人物创建界面返回到人物选择界面.
	GameProduceLogin:ChangeToSelectRoleDlgFromCreateRole();
end


---------------------------------------------------------------------------------------------------------
--
-- 选择女
--
function CreateRole_SelectGirl()

	CreateRole_Model:SetFakeObject("");
	CreateRole_Model:SetFakeObject("CreateRole_Woman");
	CreateRole_SelectSex_Girl:SetCheck(1);
	
	-- 选择女
	iCurSelSex = 0;
	
	-- 显示第一页
	g_FacePageCount = 0;
	
	-- 显示头像.
	CreateRole_ShowRoleFace(iCurSelSex);
	
	-- 选择第一个脸形
	CreateRole_BnSelFace1();
	
	-- 设置头像按钮状态
	CreateRole_SetFacePageStatus();
	
	-- 显示脸形模型
	CreateRole_GetFaceModel();
	
	-- 得到发型信息
	CreateRole_GetHairModel();
	
	-- 当前选择的脸形
	g_iCurSelFaceIndex = 0;

	-- 当前选择的发型
	g_iCurSelHairIndex = 0;
	
	-- 选择第一个发型
	CreateRole_SelHairModel(g_iCurSelHairIndex);
	
	-- 界面选择一个下拉列表
	CreateRole_SelectFace:SetCurrentSelect(0);
	-- 选择第一个脸形
	CreateRole_SelFaceModel(g_FaceModel[0]);
	
	-- 改变新手装
	
	-- 随机选择一个新手装。
	local RandVal = math.random( 0, MaxEquipIndex )
  g_iCurSelEquipSetIndex = RandVal
	
	CreateRole_SelEquipSet(g_iCurSelEquipSetIndex);	
	
	GameProduceLogin:ChangeNewRoleEquipSet(iCurSelSex, g_iCurSelEquipSetIndex);
	
end


---------------------------------------------------------------------------------------------------------
--
-- 选择男
--			
function CreateRole_SelectBoy()

	CreateRole_Model:SetFakeObject("");
	CreateRole_Model:SetFakeObject("CreateRole_Man");
	CreateRole_SelectSex_Boy:SetCheck(1);
	
	-- 选择男
	iCurSelSex = 1;
	
	-- 显示第一页
	g_FacePageCount = 0;
	
	-- 显示头像.
	CreateRole_ShowRoleFace(iCurSelSex);
	
	-- 选择第一个脸形
	CreateRole_BnSelFace1();
	
	-- 设置头像按钮状态
	CreateRole_SetFacePageStatus();
	
	-- 显示脸形模型
	CreateRole_GetFaceModel();
	
	-- 得到发型信息
	CreateRole_GetHairModel();
	
	-- 当前选择的脸形
	g_iCurSelFaceIndex = 0;

	-- 当前选择的发型
	g_iCurSelHairIndex = 0;
	
	-- 选择第一个发型
	CreateRole_SelHairModel(g_iCurSelHairIndex);
	
	CreateRole_SelectFace:SetCurrentSelect(0);
	-- 选择第一个脸形
	CreateRole_SelFaceModel(g_FaceModel[0]);
	
	-- 改变新手装
	-- 随机选择一个新手装。
	local RandVal = math.random( 0, MaxEquipIndex )
  g_iCurSelEquipSetIndex = RandVal
	
	CreateRole_SelEquipSet(g_iCurSelEquipSetIndex);	
		
	GameProduceLogin:ChangeNewRoleEquipSet(iCurSelSex, g_iCurSelEquipSetIndex);

end

---------------------------------------------------------------------------------------------------------
--
-- 显示主角头像
--			
function CreateRole_ShowRoleFace(iType)

	-- 清空头像数据.
	CreateRole_ClearImageData();
	if(0 == iType) then
	
		g_iCurFaceCount = GameProduceLogin:GetWomanFaceCount();
	elseif(1 == iType) then
	
		g_iCurFaceCount = GameProduceLogin:GetManFaceCount();
	end
	
	-- 刷新当前页
	CreateRole_RefreshCurShowFacePage();
	
		CreateRole_SetFacePageStatus();
	
	-- 当前开始显示头像的位置
	--local iCurStart = g_FacePageCount * g_iFaceCountInPage;
	
	-- 当前显示头像结束的位置
	--local iCurEnd   = iCurStart + g_iFaceCountInPage;
	--if(iCurEnd > g_iCurFaceCount) then
	
	--	iCurEnd = g_iCurFaceCount);
	--end;
	
	--local strImageName = "";
	--for index = iCurStart, iCurEnd - 1 do
	 		
	--	strImageName = GameProduceLogin:GetFaceName(iType, index);
	--	g_FaceSel[index]:SetProperty("Image", strImageName);
	--end
	
end

---------------------------------------------------------------------------------------------------------
--
-- 显示主角头像
--			
function CreateRole_ClearImageData()

	CreateRole_PageUp:Disable();
	CreateRole_PageDown:Disable();
	
	local strImageName = "";
	for index = 0, 8 do
	 		
		g_FaceSel[index]:SetProperty("Image", strImageName);
	end
	
end


---------------------------------------------------------------------------------------------------------
--
-- 刷新当前显示的头像页
--
function CreateRole_RefreshCurShowFacePage()

	-- 清空图像数据
	CreateRole_ClearImageData();
	
	-- 当前开始显示头像的位置
	local iCurStart = g_FacePageCount * g_iFaceCountInPage;
	
	-- 当前显示头像结束的位置
	local iCurEnd   = iCurStart + g_iFaceCountInPage;
	if(iCurEnd > g_iCurFaceCount) then
	
		iCurEnd = g_iCurFaceCount;
	end;
	
	
	local strImageName = "";
	for index = iCurStart, iCurEnd - 1 do
	 		
		strImageName = GameProduceLogin:GetFaceName(iCurSelSex, index);
		g_FaceSel[index - iCurStart]:SetProperty("Image", strImageName);
	end
end

---------------------------------------------------------------------------------------------------------
--
-- 主角头像上翻一页
--
function CreateRole_BnClickFacePageUp()
	
	
	
	g_FacePageCount = g_FacePageCount - 1;
	
	if(g_FacePageCount < 0) then
	
		g_FacePageCount = 0;
		return;
	end
	
	-- 刷新当前显示的face页
	CreateRole_RefreshCurShowFacePage();
	
	-- 设置头像按钮状态
	CreateRole_SetFacePageStatus();
	
end


---------------------------------------------------------------------------------------------------------
--
-- 主角头像下翻一页
--
function CreateRole_BnClickFacePageDown()
	
	
	
	g_FacePageCount = g_FacePageCount + 1;
	
	if(g_FacePageCount * g_iFaceCountInPage >= g_iCurFaceCount) then
	
		g_FacePageCount = g_FacePageCount - 1;
		return;
	end;
	
	-- 刷新当前显示的face页
	CreateRole_RefreshCurShowFacePage();
	
	-- 设置头像按钮状态
	CreateRole_SetFacePageStatus();
	
end


---------------------------------------------------------------------------------------------------------
--
-- 选择头像1
--
function CreateRole_BnSelFace1()

	g_iCurSelFaceIndex = g_FacePageCount * g_iFaceCountInPage;
	if(g_iCurSelFaceIndex >= g_iCurFaceCount) then
	
		g_iCurSelFaceIndex = -1;
		return;
	end;
	
	-- 通过性别和索引设置头像id
	GameProduceLogin:SetFaceId(iCurSelSex, g_iCurSelFaceIndex);
end

---------------------------------------------------------------------------------------------------------
--
-- 选择头像2
--
function CreateRole_BnSelFace2()

	g_iCurSelFaceIndex = g_FacePageCount * g_iFaceCountInPage + 1;
	if(g_iCurSelFaceIndex >= g_iCurFaceCount) then
	
		g_iCurSelFaceIndex = -1;
		return;
	end;
	
	-- 通过性别和索引设置头像id
	GameProduceLogin:SetFaceId(iCurSelSex, g_iCurSelFaceIndex);
end


---------------------------------------------------------------------------------------------------------
--
-- 选择头像3
--
function CreateRole_BnSelFace3()

	g_iCurSelFaceIndex = g_FacePageCount * g_iFaceCountInPage + 2;
	if(g_iCurSelFaceIndex >= g_iCurFaceCount) then
	
		g_iCurSelFaceIndex = -1;
		return;
	end;
	
	-- 通过性别和索引设置头像id
	GameProduceLogin:SetFaceId(iCurSelSex, g_iCurSelFaceIndex);
end

---------------------------------------------------------------------------------------------------------
--
-- 选择头像4
--
function CreateRole_BnSelFace4()

	g_iCurSelFaceIndex = g_FacePageCount * g_iFaceCountInPage + 3;
	if(g_iCurSelFaceIndex >= g_iCurFaceCount) then
	
		g_iCurSelFaceIndex = -1;
		return;
	end;
	
	-- 通过性别和索引设置头像id
	GameProduceLogin:SetFaceId(iCurSelSex, g_iCurSelFaceIndex);
end

---------------------------------------------------------------------------------------------------------
--
-- 选择头像5
--
function CreateRole_BnSelFace5()

	g_iCurSelFaceIndex = g_FacePageCount * g_iFaceCountInPage + 4;
	if(g_iCurSelFaceIndex >= g_iCurFaceCount) then
	
		g_iCurSelFaceIndex = -1;
		return;
	end;
	
	-- 通过性别和索引设置头像id
	GameProduceLogin:SetFaceId(iCurSelSex, g_iCurSelFaceIndex);
end

---------------------------------------------------------------------------------------------------------
--
-- 选择头像6
--
function CreateRole_BnSelFace6()

	g_iCurSelFaceIndex = g_FacePageCount * g_iFaceCountInPage + 5;
	if(g_iCurSelFaceIndex >= g_iCurFaceCount) then
	
		g_iCurSelFaceIndex = -1;
		return;
	end;
	
	-- 通过性别和索引设置头像id
	GameProduceLogin:SetFaceId(iCurSelSex, g_iCurSelFaceIndex);
end

---------------------------------------------------------------------------------------------------------
--
-- 选择头像7
--
function CreateRole_BnSelFace7()
	
	g_iCurSelFaceIndex = g_FacePageCount * g_iFaceCountInPage + 6;
	if(g_iCurSelFaceIndex >= g_iCurFaceCount) then
	
		g_iCurSelFaceIndex = -1;
		return;
	end;
	
	-- 通过性别和索引设置头像id
	GameProduceLogin:SetFaceId(iCurSelSex, g_iCurSelFaceIndex);
end

---------------------------------------------------------------------------------------------------------
--
-- 选择头像8
--
function CreateRole_BnSelFace8()

	g_iCurSelFaceIndex = g_FacePageCount * g_iFaceCountInPage + 7;
	if(g_iCurSelFaceIndex >= g_iCurFaceCount) then
	
		g_iCurSelFaceIndex = -1;
		return;
	end;
	
	-- 通过性别和索引设置头像id
	GameProduceLogin:SetFaceId(iCurSelSex, g_iCurSelFaceIndex);
end

---------------------------------------------------------------------------------------------------------
--
-- 选择头像9
--
function CreateRole_BnSelFace9()

	g_iCurSelFaceIndex = g_FacePageCount * g_iFaceCountInPage + 8;
	if(g_iCurSelFaceIndex >= g_iCurFaceCount) then
	
		g_iCurSelFaceIndex = -1;
		return;
	end;
	
	-- 通过性别和索引设置头像id
	GameProduceLogin:SetFaceId(iCurSelSex, g_iCurSelFaceIndex);
end


---------------------------------------------------------------------------------------------------------
--
-- 设置头像按钮的状态
--
function CreateRole_SetFacePageStatus()

	-- 头像向上翻页按钮
	local PageCount = g_FacePageCount;
	PageCount = PageCount - 1;
	if(PageCount < 0) then
	
		CreateRole_PageUp:Disable();
	else
	
		CreateRole_PageUp:Enable();
	end
	
	
	PageCount = g_FacePageCount;
	-- 头像向下翻页按钮
	PageCount = PageCount + 1;
	if(PageCount * g_iFaceCountInPage >= g_iCurFaceCount) then
	
		CreateRole_PageDown:Disable();
	else
		CreateRole_PageDown:Enable();
	end;
	
end


-----------------------------------------------------------------------------------------------------------
--
-- 选择新的发型
--
function CreateRole_ComboListSelectHairChanged()

  local strMeshName = "";
  strMeshName
	,g_iCurSelHairIndex = CreateRole_SelectHair:GetCurrentSelect();
	
	--AxTrace( 0,0, "==选择发型索引"..tostring(g_iCurSelHairIndex));
	--if(g_iCurSelHairIndexOld == g_iCurSelHairIndex) then
		
	--	return;
	--end
	g_iCurSelHairIndexOld = g_iCurSelHairIndex;

	CreateRole_SelHairModel(g_iCurSelHairIndex);
	
end
	
-----------------------------------------------------------------------------------------------------------
--
-- 选择新的脸型
--	
function CreateRole_ComboListSelectFaceChanged()
	
	local strMeshName = "";
	 
	strMeshName
	,g_iCurSelectFace = CreateRole_SelectFace:GetCurrentSelect();
	--AxTrace( 0,0, "==选择脸型索引"..tostring(g_iCurSelFaceIndex));
	
	--if(g_iCurSelFaceIndexOld == g_iCurSelFaceIndex) then
		
	--	return;
	--end
	--g_iCurSelFaceIndexOld = g_iCurSelFaceIndex;
	
	CreateRole_SelFaceModel(g_FaceModel[g_iCurSelectFace]);
	
end


-----------------------------------------------------------------------------------------------------------
--
-- 得到脸形数据
--	
function CreateRole_GetFaceModel()
	
	-- 清空数据
	CreateRole_SelectFace:ResetList();
	
	local iFaceCount = GameProduceLogin:GetFaceModelCount(iCurSelSex);
	local strFaceModelName = "";

	local j=0
	for index = 0, iFaceCount - 1 do
		if GameProduceLogin:GetFaceModelInfo(iCurSelSex, index) == 3  or
		   GameProduceLogin:GetFaceModelInfo(iCurSelSex, index) == 1  then
			strFaceModelName = GameProduceLogin:GetFaceModelName(iCurSelSex, index);
			CreateRole_SelectFace:ComboBoxAddItem(strFaceModelName, j);
			g_FaceModel[j] = index
			j = j+1
		end
	end;

end


-----------------------------------------------------------------------------------------------------------
--
-- 得到发形数据
--	
function CreateRole_GetHairModel()
	
	-- 清空数据
	CreateRole_SelectHair:ResetList();
	
	local iHairCount = GameProduceLogin:GetHairModelCount(iCurSelSex);
	local strHairModelName = "";

	for index = 0, iHairCount - 1 do
	
		strHairModelName = GameProduceLogin:GetHairModelName(iCurSelSex, index);
		CreateRole_SelectHair:ComboBoxAddItem(strHairModelName, index);
	end;

end


-----------------------------------------------------------------------------------------------------------
--
-- 选择发型
--	
function CreateRole_SelHairModel(index)
	
	--AxTrace( 0,0, "==选择发型"..tostring(index));
	CreateRole_SelectHair:SetCurrentSelect(index);
	GameProduceLogin:SetHairModelId(iCurSelSex, index);

end


-----------------------------------------------------------------------------------------------------------
--
-- 选择脸形
--	
function CreateRole_SelFaceModel(index)
	
	--AxTrace( 0,0, "==选择脸形"..tostring(index));
	--CreateRole_SelectFace:SetCurrentSelect(index);
	GameProduceLogin:SetFaceModelId(iCurSelSex, index);

end


function CreateRole_Name_MouseEnter()

	CreateRole_Info:SetText("输入一个角色名字");

end

function CreateRole_MouseLeave()

	CreateRole_Info:SetText("");
end

function CreateRole_SelectHair_MouseEnter()
	
	--AxTrace( 0,0, "<==?选择发型");
	CreateRole_Info:SetText("为你选择角色发型");
end


function CreateRole_SelectFace_MouseEnter()
	
	--AxTrace( 0,0, "<==?选择脸形");
	CreateRole_Info:SetText("为你选择角色脸形");
end

function CreateRole_SelectRace_MouseEnter()

	CreateRole_Info:SetText("为你选择角色性别");
end

function CreateRole_SelectHead_MouseEnter()

	CreateRole_Info:SetText("为你选择角色头像");
end

function CreateRole_CreateRole_MouseEnter()

	CreateRole_Info:SetText("创建角色");
end

function CreateRole_Last_MouseEnter()

	CreateRole_Info:SetText("返回到角色选择界面");
end

----------------------------------------------------------------------------------
--
-- 旋转人物模型（向左)
--
function CreateRole_Modle_TurnLeft(start)
	--向左旋转开始
	if(start == 1) then
		--CreateRole_Model:RotateBegin(-0.3);
                GameProduceLogin:ModelRotBegin(-1.0)
	--向左旋转结束
	else
		--CreateRole_Model:ModelRotEnd( 0 );
                GameProduceLogin:ModelRotEnd( 0.0 )
	end
end

----------------------------------------------------------------------------------
--
--旋转人物模型（向右)
--
function CreateRole_Modle_TurnRight(start)
	--向右旋转开始
	if(start == 1) then
		--CreateRole_Model:RotateBegin(0.3);
                GameProduceLogin:ModelRotBegin(1.0)
	--向右旋转结束
	else
		--CreateRole_Model:RotateEnd();
                GameProduceLogin:ModelRotEnd( 0.0 )
	end
end



-----------------------------------------------------------------------------------------------------------
--
-- 得到套装数据
--	
function CreateRole_GetNewRoleEquipSet()
	
	-- 清空数据
	CreateRole_SelectClothin:ResetList();
	
	local iCount = GameProduceLogin:GetEquipSetCount();
	--AxTrace( 0,0, "得到套装个数 ＝ "..tostring(iCount));
	
	local strShowName = "";
	for index = 0, iCount - 1 do
	
		strShowName = GameProduceLogin:GetEquipSetName(index);
		--AxTrace( 0,0, "得到套装名字 ＝ "..tostring(strShowName));
		CreateRole_SelectClothin:ComboBoxAddItem(strShowName, index);
	end;

end


-----------------------------------------------------------------------------------------------------------
--
-- 选择发型
--	
function CreateRole_SelEquipSet(index)
	
	CreateRole_SelectClothin:SetCurrentSelect(index);

end


function CreateRole_ComboListSelectClothin()

	local strMeshName = "";
		 
	strMeshName
	,g_iCurSelEquipSetIndex = CreateRole_SelectClothin:GetCurrentSelect();
	
	g_iCurSelEquipSetIndexOld = g_iCurSelEquipSetIndex;
	
	--AxTrace( 0,0, "选择套装 ＝ "..tostring(g_iCurSelEquipSetIndex));
	CreateRole_SelEquipSet(g_iCurSelEquipSetIndex);
	
	-- 改变新手装
	GameProduceLogin:ChangeNewRoleEquipSet(iCurSelSex, g_iCurSelEquipSetIndex);

end;

function CreateRole_Modle_ZoomOut( start )
	if(start == 1) then
	    GameProduceLogin:ModelZoom( -1.0 )
	else
	    GameProduceLogin:ModelZoom( 0.0 )
	end
	
end

function CreateRole_Modle_ZoomIn( start )
    if(start == 1) then
         GameProduceLogin:ModelZoom( 1.0 )
	else
	     GameProduceLogin:ModelZoom( 0.0 )
	end
	
end