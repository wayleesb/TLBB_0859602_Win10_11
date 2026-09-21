////////////////////////////////////////////
//hlsl file for generating FixStar
////////////////////////////////////////////

//input information of vertex programe
struct a2v
{
  float4 Position  : POSITION;
  float4 ColAndMag : COLOR;
};


//output information of vertex programe and input information of pixel programe
//QuadPos是纹理坐标，0，0——1，1，由vertex programe过程自动生成
struct v2f
{
  float4 Position  : POSITION;
  float2 QuadPos   : TEXCOORD;
  float4 Color     : COLOR;
  float  PSize     : PSIZE;
};


//output information of pixel programe
struct pixout
{
  float4 Color  : COLOR0;
};



float GetFlickerAmount(in float3 pos, in float4 StarSize)
{
  const float2 tab[8] = 
  {
		float2(0.897907815,-0.347608525),	float2(0.550299290, 0.273586675), float2(0.823885965, 0.098853070), float2(0.922739035,-0.122108860),
		float2(0.800630175,-0.088956800), float2(0.711673375, 0.158864420), float2(0.870537795, 0.085484560), float2(0.956022355,-0.058114540)
	};

	float2 hash = frac(pos.xy * 256);  
  float index = frac(hash.x + (hash.y + 1) * StarSize.w);
  index *= 8;
  
  float f = frac(index);
  int i = (int) index;
  return tab[i].x + f * tab[i].y;
}


v2f StarsVS(a2v IN,
uniform float4x4 worldViewProj,
uniform float4 StarSize )
{
  //初始化
  v2f OUT = (v2f)0;

  float4 pos = IN.Position;
  OUT.Position = mul(worldViewProj, IN.Position);
  OUT.Position.z = OUT.Position.w; 
    
  // On DX9 OUT.QuadPos will be filled by GPU after point sprite expansion

	//IN.ColAndMag.w是星星的随机亮度，他决定了星星的大小
	float appMag = 6.5 + IN.ColAndMag.w * (-1.44 - 6.5);
	
	//计算顶点亮度，每一帧StarSize的最后一个数会变化，使星星产生闪烁
	float brightness = GetFlickerAmount(pos, StarSize) * pow(5.0, (-appMag - 1.44) / 2.5);
	
	float4 Color = IN.ColAndMag;
	
	OUT.Color = float4(brightness * Color.xyz, brightness);
  OUT.PSize = StarSize.xy;
     
  return OUT; 
} 


pixout StarsPS(v2f IN,
uniform float2 StarParams)
{
  pixout OUT;
	float StarIntensity = StarParams.x;
	float StarTransparent = StarParams.y;
	//计算当前像素点到点精灵中心位置的距离，3.5为调整参数，以指数级衰减
	float2 distCenter = 3.5 * IN.QuadPos.xy - 3.5 * float2(0.5, 0.5);
	float scale = exp(-dot(distCenter, distCenter));

	float3 colCool = IN.Color.xyz;
	float3 colHot = IN.Color.w;
	
	//最终颜色是亮度*（衰减后的颜色 + 亮度参数），IN.Color.w是vertex programe时计算的顶点亮度
	float3 colFinal = StarIntensity * (colCool * scale + 5 * colHot * pow(scale, 10));
	OUT.Color.xyz = colFinal;
	OUT.Color.w = IN.Color.w * StarTransparent;
  return OUT;
}