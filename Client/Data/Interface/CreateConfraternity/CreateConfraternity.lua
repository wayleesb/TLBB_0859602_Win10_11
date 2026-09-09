local objCared = -1;
local MAX_OBJ_DISTANCE = 3.0;

function CreateConfraternity_PreLoad()
	this:RegisterEvent("GUILD_CREATE");
	this:RegisterEvent("OBJECT_CARED_EVENT");
end

function CreateConfraternity_OnLoad()
end

function CreateConfraternity_OnEvent(event)
	if(event == "GUILD_CREATE") then
		objCared = tonumber(arg0);
		this:CareObject(objCared, 1, "GuildCreate");
		CreateConfraternity_InputConfraternityName:SetText("");
		CreateConfraternity_InputTenet:SetText("一个新兴的帮会势力。");
		CreateConfraternity_InputTenet:SetProperty("CaratIndex", 1024);
		CreateConfraternity_InputConfraternityName:SetProperty("DefaultEditBox", "True");
		if( -1 == Player:GetData("GUILD")) then
			this:Show();
		end
	elseif(event == "OBJECT_CARED_EVENT") then
		--AxTrace(0, 0, "arg0:"..arg0.." arg1:"..arg1.." arg2:"..arg2.." objCared:"..objCared);
		if(tonumber(arg0) ~= objCared) then
			return;
		end
		--如果和NPC的距离大于一定距离或者被删除，自动关闭
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			Guild_Create_Close();
		end
	end
end

function Guild_Create_Click()
	local szGuildName = CreateConfraternity_InputConfraternityName:GetText();
	local szGuildDesc = CreateConfraternity_InputTenet:GetText();
	
	if(Guild:CreateGuild(szGuildName, szGuildDesc) > 0) then
		Guild_Create_Close();
	end
end

function Guild_Create_Close()
	this:Hide();
	--AxTrace(0,0,"Guild_Create_Close");
	this:CareObject(objCared, 0, "GuildCreate");
end

function CreateConfraternity_Hidden()
	CreateConfraternity_InputConfraternityName:SetProperty("DefaultEditBox", "False");
	CreateConfraternity_InputTenet:SetProperty("DefaultEditBox", "False");
end