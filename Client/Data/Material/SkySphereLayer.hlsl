#ifndef BLEND_TEXTURE_NUM
    #define BLEND_TEXTURE_NUM 1
#endif

//最多支持3层纹理混合
//blendFactor[0],blendFactor[1],blendFactor[2]代表三层纹理的权重
//blendFactor[3]保存最终混合后的透明值

void blend_vp(
    in float4 pos : POSITION,
    in float4 tex : TEXCOORD0,
    uniform float4 texUWrap,
    uniform float4 texVWrap,
    uniform float4x4 WVPMatrix,
    out float4 oPosition : POSITION,
    out float4 oTexcoords[BLEND_TEXTURE_NUM] : TEXCOORD0
)
{
    oPosition = mul(WVPMatrix, pos);
    oPosition.z = oPosition.w * 0.999999;
    for(int i = 0; i < BLEND_TEXTURE_NUM; ++i)
    {
        oTexcoords[i] = float4(tex.x*texUWrap[i], tex.y*texVWrap[i], tex.zw);
    }
}

void blend_fp(
    float4 oPosition : POSITION,
    in float4 uv[BLEND_TEXTURE_NUM] : TEXCOORD0,
    uniform float4 blendFactor,
    uniform float4 blendColour,
    uniform sampler2D skyTexture[BLEND_TEXTURE_NUM],
    out float4 oColour : COLOR
)
{
    float4 outColour = float4(0, 0, 0, 0);
    float totalWeight = 0.0;
    for(int i = 0; i < BLEND_TEXTURE_NUM; ++i)
    {
        float4 texColour = tex2D(skyTexture[i], uv[i].xy);
        float pixelBlendFactor = texColour.w * blendFactor[i];
        totalWeight = totalWeight + pixelBlendFactor;
        outColour = outColour + texColour * blendFactor[i];
    }
    outColour.xyz = outColour.xyz * blendColour.xyz;
    oColour = float4(outColour.xyz, totalWeight);
}