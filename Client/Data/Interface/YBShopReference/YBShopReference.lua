
function YBShopReference_PreLoad()
	this:RegisterEvent("OPEN_YBSHOPREFERENCE");
end

function YBShopReference_OnLoad()


end

function YBShopReference_OnEvent( event )
	if event == "OPEN_YBSHOPREFERENCE" then
		YBShopReferenceGreeting_Desc:ClearAllElement();
		YBShopReferenceGreeting_Desc:AddTextElement( arg0 );
		this:Show();
	end
end

function YBShopReferenceOption_Clicked()

end