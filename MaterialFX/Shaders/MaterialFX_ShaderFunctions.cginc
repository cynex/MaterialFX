// Value Noise by Inigo Quilez - iq/2013
// https://www.shadertoy.com/view/lsf3WH
float noisePhase = 0;
float2 random2(float2 st)
{
	st = float2(dot(st, float2(127.1, 311.7)),
			  dot(st, float2(269.5, 183.3) + float2(noisePhase, noisePhase)));
	return -1.0 + 2.0 * frac(sin(st) * 43758.5453123);
}

float noise(float2 st)
{
	float2 i = floor(st);
	float2 f = frac(st);

	float2 u = f * f * (3.0 - 2.0 * f);

	return lerp(lerp(dot(random2(i + float2(0.0, 0.0)), f - float2(0.0, 0.0)),
					 dot(random2(i + float2(1.0, 0.0)), f - float2(1.0, 0.0)), u.x),
				lerp(dot(random2(i + float2(0.0, 1.0)), f - float2(0.0, 1.0)),
					 dot(random2(i + float2(1.0, 1.0)), f - float2(1.0, 1.0)), u.x), u.y);
}

float hash(float2 p)
{
	p = 50.0 * frac(p * 0.3183099 + float2(0.71, 0.113));
	p += sin(noisePhase);
	return -1.0 + 2.0 * frac(p.x * p.y * (p.x + p.y));
}

float hashNoise(float2 p)
{
	float2 i = floor(p);
	float2 f = frac(p);

	float2 u = f * f * (3.0 - 2.0 * f);

	return lerp(lerp(hash(i + float2(0.0, 0.0)),
					 hash(i + float2(1.0, 0.0)), u.x),
				lerp(hash(i + float2(0.0, 1.0)),
					 hash(i + float2(1.0, 1.0)), u.x), u.y);
}


float fractalNoise(float2 p)
{
	float f = 0;
	float2 uv = p;
	p *= 8.0;
	float2x2 m = float2x2(1.6, 1.2, -1.2, 1.6);
	f = 0.5000 * hashNoise(uv); uv = mul(m, uv);
	f += 0.2500 * hashNoise(uv); uv = mul(m, uv);
	f += 0.1250 * hashNoise(uv); uv = mul(m, uv);
	f += 0.0625 * hashNoise(uv); uv = mul(m, uv);

	return f;
}

///----------------------------------



float4 texTriplanar(sampler2D tex, float3 pos, float MapScale, float3 nrm, float blend)
{
//	float3 worldNormal = mul ((float4x4)unity_ObjectToWorld, normal );
	float3 bf = normalize(max(abs(nrm),-.25 + blend * .5));
	//bf /= dot(bf, (float3)1);
	float2 tx = pos.yz * MapScale;
	float2 ty = pos.zx * MapScale;
	float2 tz = pos.xy * MapScale;

	half4 cx = tex2D(tex, tx) * bf.x;
	half4 cy = tex2D(tex, ty) * bf.y;
	half4 cz = tex2D(tex, tz) * bf.z;
	return (cx + cy + cz);
}

			sampler2D _SnowBump,_GrowthBump;
			float4 _WetTint, _GrowthTint, _SnowTint,_GrowthTint2;
			float _WetSpeedY, _WetSpeedX;
			float _Growth, _Snow;
			float _Wetness;
			sampler2D  _FXTex;

			sampler2D _GrowthTex, _WetNormalTex, _SnowTex;
			float4 getGrowthAmount(float2 uv)
			{
				float4 FXTex = tex2Dlod(_FXTex, float4(uv, 0, 0));
				float CTex = tex2Dlod(_AdvancedPBRMap, float4(uv, 0, 0)).g;
				return float4(FXTex.r * _Snow, FXTex.g * _Growth, FXTex.b * _Wetness, CTex)* _AllEffects;
			}
