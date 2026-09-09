local curHistroyPointer = 0;
local maxHistroyNumber = 0;
local curFriendGroup = 0;
local curFriendIndex = 0;
local numberPerPage = 10;
--===============================================
-- OnLoad()
--===============================================
function HistoryCorrespondence_PreLoad()

	this:RegisterEvent("OPEN_HISTROY");
	this:RegisterEvent("OPEN_SYSTEMINFO");
end

function HistoryCorrespondence_OnLoad()
end

--===============================================
-- OnEvent()
--===============================================
function HistoryCorrespondence_OnEvent(event)
	
	if ( event == "OPEN_HISTROY" ) then
		HistoryCorrespondence_Show( arg0, arg1 );
	elseif( event == "OPEN_SYSTEMINFO" ) then
		HistoryCorrespondence_System_Show();
	end
end
function HistoryCorrespondence_System_Show()
	this:Show();
	HistoryCorrespondence_Log:ClearListBox();
	HistoryCorrespondence_PageHeader:SetText( "#gFF0FA0系统信息" );
	HistoryCorrespondence_PageDown:Disable();
	HistoryCorrespondence_PageUp:Disable();
	local nNumber = DataPool:GetSystemHistroyNumber();
	local nIndex = nNumber - 10;
	if( nIndex < 0 ) then
		nIndex = 0;
	end
	local i = nNumber - 1;
	while i >= nIndex do 
		str = DataPool:GetSystemHistroy( tonumber( i ), "TIME" );
		str = str.."#r";
		str = str..DataPool:GetSystemHistroy( tonumber( i ), "CONTEX" );
		HistoryCorrespondence_Log:AddItem( str, i, "FFFFFFFF", 4 );
		i = i - 1;
	end
end
function HistoryCorrespondence_Show( nChannel, nIndex )
	
	maxHistroyNumber = Friend:GetHistroyNumber( tonumber( nChannel ), tonumber( nIndex ) );
	curHistroyPointer = maxHistroyNumber;
	curFriendGroup = nChannel;
	curFriendIndex = nIndex;
	HistoryCorrespondence_Update();
	HistoryCorrespondence_PageHeader:SetText( "#gFF0FA0历史信息" );
	this:Show();
end

function HistoryCorrespondence_Update()
	local curPageStriing;
	local i = curHistroyPointer -1 ;
	local minHistroyPointer = curHistroyPointer - numberPerPage;
	if( minHistroyPointer < 0 ) then 
		minHistroyPointer = 0;
	end
	if( minHistroyPointer == 0 ) then
		HistoryCorrespondence_PageDown:Disable();
	else
		HistoryCorrespondence_PageDown:Enable();
	end
	if( curHistroyPointer == maxHistroyNumber ) then
		HistoryCorrespondence_PageUp:Disable();
	else
		HistoryCorrespondence_PageUp:Enable();
	end
	HistoryCorrespondence_Log:ClearListBox();
	local str = ""; 
	while i >= minHistroyPointer do 
		str = Friend:GetHistroyData( tonumber( curFriendGroup ), tonumber( curFriendIndex ), tonumber(i), "TIME" );
		str = str..Friend:GetHistroyData( tonumber( curFriendGroup ), tonumber( curFriendIndex ), tonumber(i), "SENDER" );
		str = str.."#r";
		str = str..Friend:GetHistroyData( tonumber( curFriendGroup ), tonumber( curFriendIndex ), tonumber(i), "CONTEX" )
		HistoryCorrespondence_Log:AddItem( str, i, "FFFFFFFF", 4 );
		i = i - 1;
	end
	
end

function HistoryCorrespondence_OnPageDown()
	curHistroyPointer = curHistroyPointer - numberPerPage;
	if( curHistroyPointer < 0 ) then
		curHistroyPointer = 0;
	end
	HistoryCorrespondence_Update();
end

function HistoryCorrespondence_OnPageUp()
	curHistroyPointer = curHistroyPointer + numberPerPage;
	if( curHistroyPointer > maxHistroyNumber ) then
		curHistroyPointer = maxHistroyNumber;
	end
	HistoryCorrespondence_Update();
end

function HistoryCorrespondence_OnHelp()
	
end

function HistoryCorrespondence_OnClose()
	this:Hide();
end