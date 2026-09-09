float4 fp_main(
	float4 uv : TEXCOORD0,
	float4 colour : COLOR0,
	uniform sampler2D baseTex) : COLOR
{
	return tex2D(baseTex, uv.xy) * colour;
}
