local g_petNum = -1;
function PetAgname_PreLoad()
	this:RegisterEvent("OPEN_PET_AGNAME");
	this:RegisterEvent("CLOSE_PET_AGNAME");
	this:RegisterEvent("PET_CHANGE");
end

function PetAgname_OnLoad()
end

-- OnEvent
function PetAgname_OnEvent(event)
	if ( event == "OPEN_PET_AGNAME" ) then
		g_petNum = tonumber(arg0);
		if(g_petNum<0)then
			return
		end
		this:TogleShow();
		PetAgname_UpdateFrame();
	end
	
	if ( event == "CLOSE_PET_AGNAME" ) then
		this:Hide();
	end
	if ( event == "PET_CHANGE" and this:IsVisible()) then
		if(g_petNum ~= tonumber(arg0)) then
			g_petNum = tonumber(arg0)
			if(g_petNum<0)then
				this:Hide();
				return
			end
			PetAgname_UpdateFrame();
		end
	end
end

function PetAgname_UpdateFrame()
	--清空
	PetAgname_Listbox:ClearListBox();

	--加入所有称号名
	local nAgnameNum = Pet:GetTitleNum(g_petNum);
	
	local i;
	for i=1, nAgnameNum do
		local szAgnameName = Pet:EnumTitleByIdx(g_petNum, i-1,"name");
		PetAgname_Listbox:AddItem(szAgnameName, i);	
	end
	
	--当前显示称号
	PetAgname_Currently:SetText( "" .. Pet:GetCurrentTitle(g_petNum,"name") );
	PetAgname_Explain:SetText( "".. Pet:GetCurrentTitle(g_petNum,"desc"));
end


function PetAgnameListBox_Selected()
	local nSelIndex = PetAgname_Listbox:GetFirstSelectItem();
	local nAgnameNum = Pet:GetTitleNum(g_petNum);
	
	if(nSelIndex-1 < 0 or nSelIndex-1 >= nAgnameNum) then 
		return;
	end
	
	--设置当前称号的解释
	PetAgname_Explain:SetText( Pet:EnumTitleByIdx(g_petNum,nSelIndex-1,"desc"));

end

function PetAgname_ChangeBtn_Clicked()
	local nSelIndex = PetAgname_Listbox:GetFirstSelectItem();
	local nAgnameNum = Pet:GetTitleNum(g_petNum);
	
	if(nSelIndex-1 < 0 or nSelIndex-1 >= nAgnameNum) then 
		return;
	end

	Pet:PetAskChangeCurrentTitle(g_petNum,nSelIndex-1);
	this:Hide();
end

function PetAgname_HideTitle_Clicked()

	PetAgname_Currently:SetText( "");
	Pet:SetNullCurTitle(g_petNum);
end