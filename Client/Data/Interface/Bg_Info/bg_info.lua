--===============================================
-- OnLoad()
--===============================================
function bg_info_PreLoad()
    this:RegisterEvent("BGINFO_SHOW")
    this:RegisterEvent("BGINFO_CLOSE")
end

--===============================================
-- OnLoad()
--===============================================
function bg_info_OnLoad()    
end

--===============================================
-- OnEvent()
--===============================================
function bg_info_OnEvent(event)    

    local w,h = GetCurClientSize()
    
    AxTrace( 0, 0, ""..(w)..","..(h).."" )
    
    if ( event == "BGINFO_SHOW" ) then
       --BgInfo_Image:SetProperty( "UnifiedPosition", "{{0.000000,0.000000},{0.000000,0.000000}}" )
       --BgInfo_Image:SetProperty( "UnifiedSize", "{{0.000000,400.000000},{0.000000,300.000000}}" )
       --BgInfo_Image:SetProperty( "AbsolutePosition", "x:0 y:0" );
       --BgInfo_Image:SetProperty( "AbsoluteSize", "w:1280 h:1024" );
       
       local Rate = h / w;
       local PosX = 0
       local PosY = 0
       local Width = 0
       local Heigh = 0
       
       AxTrace( 0, 0, "Rate="..Rate )
       local StdW = 1024
       local StdH = 768
       
       if( Rate == 0.75 ) then    -- 4:3屏
           if( h > StdH ) then   --保持图片居中
               local offsetY = ( h - StdH ) / 2
               local offsetX = ( w - StdW ) / 2
               
               PosX = PosX + offsetX
               PosY = PosY + offsetY
                              
               Width = StdW
               Heigh = StdH
           else                 --否则按高来计算缩放比例
               local hRate = h / StdH
               Width = StdW * hRate
               Heigh = StdH * hRate
               PosX = ( w - Width ) / 2
               PosY = 0
               
           end       
           --Width = w
           --Heigh = h
           --PosX = 0
           --PosY = 0
       elseif( Rate < 0.75 ) then              --宽屏
           if( h > StdH ) then   --保持图片居中
               local offsetY = ( h - StdH ) / 2
               local offsetX = ( w - StdW ) / 2
               
               PosX = PosX + offsetX
               PosY = PosY + offsetY
                              
               Width = StdW
               Heigh = StdH
           else                 --否则按高来计算缩放比例
               local hRate = h / StdH
               Width = StdW * hRate
               Heigh = StdH * hRate
               PosX = ( w - Width ) / 2
               PosY = 0
               
           end
       elseif( Rate > 0.75 ) then              --窄屏(貌似一般情况下不会出现)
           if( w > StdW ) then   --保持图片居中
               local offsetY = ( h - StdH ) / 2
               local offsetX = ( w - StdW ) / 2
               
               PosX = PosX + offsetX
               PosY = PosY + offsetY
               Width = StdW
               Heigh = StdH
                          
           else
               local wRate = w / StdW
               Width = StdW * wRate
               Heigh = StdH * wRate
               PosX = 0
               PosY = ( h - Heigh ) / 2
                          
           end
       else
       end
       
       
       --<Property Name="Image" Value="set:BGLogin_0 image:BGImg" />
       local RandVal = math.random( 0, 9 )
       local strImg = string.format("set:BGLogin_%d image:BGImg", RandVal )
       --BgInfo_Image:SetProperty( "Image", strImg )
       --AxTrace( 0, 0, strImg )
       
       local strImg0 = string.format("set:BGLogin_%d_0 image:BGImg", RandVal )
       local strImg1 = string.format("set:BGLogin_%d_1 image:BGImg", RandVal )
       local strImg2 = string.format("set:BGLogin_%d_2 image:BGImg", RandVal )
       local strImg3 = string.format("set:BGLogin_%d_3 image:BGImg", RandVal )
       BgInfo_Image_0:SetProperty( "Image", strImg0 )
       BgInfo_Image_1:SetProperty( "Image", strImg1 )
       BgInfo_Image_2:SetProperty( "Image", strImg2 )
       BgInfo_Image_3:SetProperty( "Image", strImg3 )
              
       --BgInfo_Image_0:SetProperty( "Image", "set:BGLogin_0_0 image:BGImg" )
       --BgInfo_Image_1:SetProperty( "Image", "set:BGLogin_0_1 image:BGImg" )
       --BgInfo_Image_2:SetProperty( "Image", "set:BGLogin_0_2 image:BGImg" )
       --BgInfo_Image_3:SetProperty( "Image", "set:BGLogin_0_3 image:BGImg" )
       
       local strPos = string.format("x:%f y:%f", PosX, PosY);
       local strSize = string.format("w:%f h:%f", Width, Heigh );
       
       AxTrace( 0, 0, strPos )
       AxTrace( 0, 0, strSize )
              
       BgInfo_Image:SetProperty( "AbsolutePosition", strPos )
       BgInfo_Image:SetProperty( "AbsoluteSize", strSize )
       
       local strTextNum = GetDictionaryString( "LoadingText_0" )
       if nil ~= strTextNum then
           if "" ~= strTextNum then
               local TextNum = tonumber( strTextNum )
               if TextNum > 0 then
                  local RandText = math.random( 1, TextNum )
                  BgInfo_Text:SetText( "#{LoadingText_"..(RandText).."}" )
               end
           else
			   BgInfo_Text:SetText( "" )
           end
       end
       
       this:Show()
    end
    
    if ( event == "BGINFO_CLOSE" ) then
       this:Hide()
    end
         
end