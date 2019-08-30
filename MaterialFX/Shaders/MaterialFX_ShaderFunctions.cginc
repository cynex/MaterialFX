//---------------------MaterialFX Variable Groups : Growth, Snow, Wet
	float3 lightDirection,oNormal,viewDirection;
	float2 mfxUV;
	float thick = 1,curve = 1;
	float3 normal = float3(0,0,0),iremissive= float3(0,0,0);
	float4 fxAmount = float4(0,0,0,0);
	half rim=1;
	half3 skyColor = half3(0,0,0) ,cubeColor=half3(0,0,0);
	float2 parallaxOffset = float2(0,0);
	fixed3 detailAlbedo = float3(0,0,0);
	fixed3 detailNormal = float3(0,0,0);

	//for subsurface scattering (if used)
	float _SSRThickness=0.3;
	float _SSSDistortion=1;
	float _SSSPower =1;
	float _SSSScale=1;
	float3 _SSSAmbient=float3(1,1,1);



struct SurfaceOutputMaterialFX
{
	// For Specular + Metallic
    fixed3 Albedo;  // diffuse color
    fixed3 Normal;  // tangent space normal, if written
    fixed3 Emission;
    half Specular;  // specular power in 0..1 range
    fixed Gloss;    // specular intensity
    fixed Alpha;    // alpha for transparencies

	// For Metallic
    half Metallic;      // 0=non-metal, 1=metal
    half Smoothness;    // 0=rough, 1=smooth
    half Occlusion;     // occlusion (default 1)

};

	// These functions are so that we can use MaterialFX functions in multiple workflows
	// 
	SurfaceOutputMaterialFX mfxOut;

/*	void CopyOutputToMaterialFX (SurfaceOutput o) {
		mfxOut.Albedo = o.Albedo;		
		mfxOut.Normal = o.Normal;		
		mfxOut.Emission = o.Emission;
		mfxOut.Specular = o.Specular;  
		mfxOut.Gloss = o.Gloss;		
		mfxOut.Alpha = o.Alpha;	
	}

	void CopyOutputStandardToMaterialFX (SurfaceOutputStandard o) {
		mfxOut.Albedo = o.Albedo;		   
		mfxOut.Normal = o.Normal;		   
		mfxOut.Emission = o.Emission;
		mfxOut.Metallic = o.Metallic;		
		mfxOut.Smoothness = o.Smoothness;	 
		mfxOut.Alpha = o.Alpha;			
		mfxOut.Occlusion = o.Occlusion;   
	}

	void CopyMaterialFXToOutput (inout SurfaceOutput o) {
		o.Albedo=mfxOut.Albedo;		
		o.Normal=mfxOut.Normal;		
		o.Emission = mfxOut.Emission;
	    o.Specular=mfxOut.Specular; 
		o.Gloss=mfxOut.Gloss;		
		o.Alpha=mfxOut.Alpha;		
	}

	void CopyMaterialFXToOutputStandard (inout SurfaceOutputStandard o) {
		o.Albedo=mfxOut.Albedo;		
		o.Normal=mfxOut.Normal;		
		o.Emission = mfxOut.Emission;
		o.Metallic=mfxOut.Metallic;				
		o.Smoothness=mfxOut.Smoothness;		
		o.Alpha=mfxOut.Alpha;		
		o.Occlusion=mfxOut.Occlusion;
	}*/

	float4 _WetTint, _GrowthTint, _SnowTint,_GrowthTint2;
	float _WetSpeedY, _WetSpeedX;
	float _Growth, _Snow,_Wetness;
	sampler2D  _FXTex,_WetNormalTex;	
	float _GrowthNoiseScale;



// Blending and UV Functions designed for VJToolkit

	float2 nullPixel = float2(-999999,-999999);
	
	float4 overlay(float4 a, float4 b)
	{
		float4 retCol = a;
	    if (a.r < 0.5) retCol.r= 2.0*a.r*b.r;
	    else           retCol.r=  1.0 - 2.0*(1.0 - a.r)*(1.0 - b.r);
	     if (a.g < 0.5) retCol.g= 2.0*a.g*b.g;
	    else           retCol.g=  1.0 - 2.0*(1.0 - a.g)*(1.0 - b.g);
	     if (a.b < 0.5) retCol.b= 2.0*a.b*b.b;
	    else           retCol.b=  1.0 - 2.0*(1.0 - a.b)*(1.0 - b.b);
	     if (a.a < 0.5) retCol.a= 2.0*a.a*b.a;
	    else           retCol.a=  1.0 - 2.0*(1.0 - a.a)*(1.0 - b.a);
	    return retCol;
	}

	fixed4 getBlendModePixel (int blendMode, fixed4 src,fixed4 dst, float amount) {
		// Normal, Additive, Subtractive, Multiply, Divide, Overlay, ClipBlack, ClipWhite, Mod, DstAlpha, OneMinusDstAlpha, SrcAlpha, OneMinusSrcAlpha, Mix, MixOverlay, LighterColor, DarkerColor, ColorDodge, ColorBurn
		/*Normal*/		 
		if (blendMode == 0) return ((1.0 - amount) * src) + (amount * dst);	
		/*Mix*/ 		
		if (blendMode == 1) return (src - (src * (dst.a) * amount)) + (dst * (dst.a) * amount); 
		/*MixOverlay*/ 		
		if (blendMode == 2) return (src - (src * (dst.a) * amount)) + ( overlay(src,dst) * (dst.a) * amount); 	
		/*Additive*/ 	 
		if (blendMode == 3) return (src) + (amount * dst);
		/*Subtractive*/  
		if (blendMode == 4) return (src) - (amount * dst);
		/*Multiply*/ 	 
		if (blendMode == 5) return (src) * (amount * dst) + ((1-amount)*src);
		/*Divide*/ 		 
		if (blendMode == 6) return (src) / ((amount * dst)+0.0001);
		/*Overlay*/ 	 
		if (blendMode == 7) return ((1.0 - amount) * src) + (amount * overlay(src,dst));  /*return (src) * (1+(amount * dst));*/
		/*ClipBlack*/ 	
		if (blendMode == 8) 
		{ 
			fixed4 ret = src; 
			if ((ret.r + ret.g + ret.b)*amount > 0.02) 
			ret = dst; 
			return ret; 
		}
		/*ClipWhite*/ 	
		if (blendMode == 9) { 
			fixed4 ret = src; 
			if ((ret.r + ret.g + ret.b)*amount < 0.98) 
			ret = dst; 
			return ret; 
		}
		/*Mod*/ 		
		if (blendMode == 10) return (src) % (amount * dst);
		/*DstAlpha*/ 	
		if (blendMode == 11) return (src) + (dst * dst.a * amount);
		/*OneMinusDstAlpha*/ 
		if (blendMode == 12) return (src) + (dst * (1-dst.a) * amount);
		/*SrcAlpha*/ 		
		if (blendMode == 13) return (src) + (dst * src.a * amount);
		/*OneMinusSrcAlpha*/ 		
		if (blendMode == 14) return (src) + (dst * (1-src.a) * amount);
		/*LighterColor*/		 
		if (blendMode == 15) { 
				fixed4 ret = src; 
				if (dst.r>ret.r)ret.r=dst.r;
				if (dst.g>ret.g)ret.g=dst.g;
				if (dst.b>ret.b)ret.b=dst.b;
				if (dst.a>ret.a)ret.a=dst.a;
				return ret; 
			}
		/*DarkerColor*/ 
		if (blendMode == 16) { 
				fixed4 ret = src; 
				if (dst.r< ret.r)ret.r=dst.r;
				if (dst.g< ret.g)ret.g=dst.g;
				if (dst.b< ret.b)ret.b=dst.b;
				if (dst.a< ret.a)ret.a=dst.a;
				return ret; 
			}
		/*ColorDodge*/ 
		if (blendMode == 17) { return (src) / (1-dst *amount); }
		/*ColorBurn*/ 
		if (blendMode == 18) { return ((1.0 - amount) * src) * (amount * 1-dst);	 }
		if (blendMode == 19) { return abs(src - (dst*amount)); }
		return src;
	}


	float2x2 rotationMatrix(float angle)
	{
		float s = sin(angle);
		float c = cos(angle);
		return float2x2(c,-s,s,c);
	}
	

	float PingPong(float v)
	{
		v = abs(v); 
		float remainder = fmod(floor(v), 2);
		return (remainder==1?1-frac(v):frac(v));
	}

	float2 PingPong2 (float2 v) {	
		return float2(PingPong(v.x),PingPong(v.y));
	}

	float2 getWrappedUV(int mode, float2 uv) {
		//Clamp, Clip, PingPong, Repeat
		if (mode == 0) {
			uv.x = clamp(uv.x,0,1);
			uv.y = clamp(uv.y,0,1);			
		}
		if (mode == 1) {			
			if (uv.x < 0 || uv.x > 1 || uv.y < 0 || uv.y > 1) { uv = nullPixel; }
		}
		if (mode == 2) {			
			uv = PingPong2(uv);
		}
		if (mode == 3) {
			uv = frac(uv);
		}
		return uv;
	}

// Noise functions used from :
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

///---------------------------------- Triplanar function

float4 texTriplanar(sampler2D tex, float3 pos, float MapScale, float3 nrm, float blend)
{

	float3 bf = normalize(max(abs(nrm),-.25 + blend * .5));
	float2 tx = pos.yz * MapScale;
	float2 ty = pos.zx * MapScale;
	float2 tz = pos.xy * MapScale;

	half4 cx = tex2D(tex, tx) * bf.x;
	half4 cy = tex2D(tex, ty) * bf.y;
	half4 cz = tex2D(tex, tz) * bf.z;
	return (cx + cy + cz);
}

//------------------------------------------------------MaterialFX 

float4 getGrowthAmount(float2 uv)
{
	float4 FXTex = tex2Dlod(_FXTex, float4(uv, 0, 0));
	float CTex = tex2Dlod(_AdvancedPBRMap, float4(uv, 0, 0)).g;
	return float4(FXTex.r * _Snow, FXTex.g * _Growth, FXTex.b * _Wetness, CTex)* _AllEffects;
}


float _FXDisplacementMulitplier=26;

float getGrowthAndSnowDisplace (float4 FXTex, appdata v) {
	float growthdisplace = 0;
	//Growth
	_GrowthNoiseScale=1+_GrowthNoiseScale;
	_SnowNoiseScale=1+_SnowNoiseScale;
	if (FXTex.g - (1 - _Growth) > 0)
	{
		growthdisplace += ((_Growth * 0.5) * lerp(0,(fractalNoise(v.vertex.xy*1000 * _GrowthNoiseScale))*128*_FXDisplacementMulitplier,FXTex.g - (1 - _Growth))*FXTex.a)*_GrowthDisplacement;
		// Growth + noise (after a certain level)
		if (FXTex.g - (1 - _Growth) >_GrowthNoise-.75)
		{
		growthdisplace += (fractalNoise(_GrowthNoiseSpeed * _Time.y + v.vertex.xy*100 * _GrowthNoiseScale)*0.2*_FXDisplacementMulitplier)*_GrowthNoise*_GrowthDisplacement;
		}
	}
	//Snow
	if (FXTex.r - (1 - _Snow) > 0)
	{
		growthdisplace += clamp((_Snow * 0.5)*  lerp(0,(hashNoise(v.vertex.xy*_SnowNoiseScale*13)),(FXTex.r - (1 - _Growth)))*FXTex.a,0,1)*_SnowDisplacement*_SnowNoiseAmount;					
		growthdisplace += (fractalNoise(v.vertex.xy*_SnowNoiseScale*8)*0.5)*_SnowDisplacement*_SnowNoiseAmount;				
	}
	if (_AllEffects==0) growthdisplace=0;
	return growthdisplace;
}
						
float4 getUVModeTexture (sampler2D tex, float mode, float2 uv, float scale, float3 worldPos, float3 normal, float blend) {
	float4 texColor =  float4(0,0,0,0);
	if (mode==0) { texColor=tex2D (tex, uv);}
	if (mode==1) { texColor=texTriplanar (tex, worldPos,scale,normal,blend);}
	return texColor;
}

void GetEnvironmentalEffects (Input IN, float4 fxAmount) 
{
	//--------------------------Environment Effects
	float4 wp=float4(IN.worldPos,1);

	float4 wpWater = (wp*2) + float4(0,_Time.y * _WetSpeedY / 5,0,0);
	float4 wpWater2 = (wp*4) + float4(0,_Time.y * _WetSpeedY,0,0);

	//FXTex.r += fractalNoise(wp.xz) * 0.5 + 0.5; //wp.xz ?
	float otherFX = clamp(pow((fxAmount.g * _Growth) + (fxAmount.r * _Snow), 2), 0, 1);
	float wet = clamp(fxAmount.b - (1 - _Wetness), 0, 0.9) * (1 - otherFX);
				
	float3 detNormWet = UnpackNormal(texTriplanar(_WetNormalTex, wpWater,_WetTextureScale, normal,1)+texTriplanar(_WetNormalTex, wpWater2,_WetTextureScale*3, normal,1));
			
	// Apply Wetness				
		mfxOut.Smoothness = clamp(mfxOut.Smoothness + (clamp(fxAmount.b * _Wetness,0,0.75)), 0, 1);
	
		float wetAlpha = wet * _WetTint.a;
		mfxOut.Albedo = ((1 - wetAlpha) *  mfxOut.Albedo) + (wetAlpha *  mfxOut.Albedo *_WetTint.rgb);
		// Apply Snow
		float snowValue = fxAmount.r - (1 - _Snow);
		float growthValue = fxAmount.g - (1 - _Growth);
	if (snowValue > 0)
	{
		float c = clamp(snowValue, 0, 1);
		float3 sCol = lerp (_SnowTint,_SnowTint*2,curve);
		mfxOut.Albedo = (clamp(mfxOut.Albedo,0,1) * (1 - c)) + (sCol * c);	
		if (snowValue > 0.2) {
			mfxOut.Smoothness *= clamp(c,0,.75);
		}
	}
	// Apply Growth
		if (growthValue > 0)
	{
		float c = clamp((fxAmount.g - (1 - _Growth)), 0, 1);
		float3 gCol = lerp (_GrowthTint,_GrowthTint2, c*(1-curve));				
		mfxOut.Albedo = lerp(mfxOut.Albedo,(gCol),c);	
		if (growthValue > 0.2) {
		mfxOut.Smoothness *= lerp(0,mfxOut.Smoothness,c*(1-curve));
		}
	}

	// Apply Wetness
	float3 wNormal = mfxOut.Normal;
	detNormWet=detNormWet;
	wNormal.x += detNormWet.x;
	wNormal.y += detNormWet.y;
	wNormal.z += detNormWet.z;
	mfxOut.Gloss =mfxOut.Smoothness;
	mfxOut.Normal = lerp(mfxOut.Normal,wNormal,wet*_AllEffects);
}

void HandleDisplayMode (Input IN, int DISPLAYMODE, float3 originalColor, float3 oNormal,float3 grabTex) {
		if (_DisplayMode == 1) _SSRThickness=-1;
		if (DISPLAYMODE > 0) {
		if (DISPLAYMODE == 1) { mfxOut.Albedo=originalColor; _SSRThickness=-1; } 
		if (DISPLAYMODE == 2) { mfxOut.Albedo=0; mfxOut.Emission=normalize(mfxOut.Normal); _SSRThickness=-1; mfxOut.Smoothness=0; mfxOut.Metallic=0;} 
		if (DISPLAYMODE == 3) { mfxOut.Emission=mfxOut.Albedo;  mfxOut.Albedo=0; _SSRThickness=-1; mfxOut.Smoothness=0; mfxOut.Metallic=0;} 
		if (DISPLAYMODE == 4) { mfxOut.Albedo=0; mfxOut.Emission=mfxOut.Smoothness; _SSRThickness=-1; mfxOut.Smoothness=0; mfxOut.Metallic=0;} 
		if (DISPLAYMODE == 5) { mfxOut.Albedo=0; mfxOut.Emission=thick; _SSRThickness=-1; mfxOut.Smoothness=0; mfxOut.Metallic=0;} 
		if (DISPLAYMODE == 6) { mfxOut.Albedo=0; mfxOut.Emission=curve; _SSRThickness=-1; mfxOut.Smoothness=0; mfxOut.Metallic=0;} 
			
		if (DISPLAYMODE == 7) { mfxOut.Albedo=0; } 
		if (DISPLAYMODE == 8) { mfxOut.Albedo=0; mfxOut.Emission=mfxOut.Occlusion; _SSRThickness=-1; mfxOut.Smoothness=0; mfxOut.Metallic=0;} 
		if (DISPLAYMODE == 9) { mfxOut.Albedo=float3(0,0,0); mfxOut.Metallic=0; mfxOut.Smoothness=0; } 
		if (DISPLAYMODE == 10) { mfxOut.Albedo=0; mfxOut.Emission=fxAmount; _SSRThickness=-1; mfxOut.Smoothness=0; mfxOut.Metallic=0;} 
		if (DISPLAYMODE == 11) { mfxOut.Albedo=0; mfxOut.Emission=iremissive; _SSRThickness=-1; mfxOut.Smoothness=0; mfxOut.Metallic=0;} 
		if (DISPLAYMODE == 12) { mfxOut.Albedo=0; mfxOut.Emission=skyColor; _SSRThickness=-1; mfxOut.Smoothness=0; mfxOut.Metallic=0;} 
		if (DISPLAYMODE == 13) { mfxOut.Albedo=0; mfxOut.Emission=cubeColor; _SSRThickness=-1; mfxOut.Smoothness=0; mfxOut.Metallic=0;} 
		if (DISPLAYMODE == 14) {
			float2 chk = floor(IN.uv_MainTex*_CheckerDensity) / 2;
			float checker = frac(chk.x + chk.y) *2; 
			mfxOut.Normal = oNormal;
			mfxOut.Albedo=checker; 
			mfxOut.Emission=checker; 
			mfxOut.Metallic=0; 
			mfxOut.Smoothness=0;
			_SSRThickness=-1;
		}
		if (DISPLAYMODE == 15) { mfxOut.Albedo=0; mfxOut.Emission=grabTex; _SSRThickness=-1; mfxOut.Smoothness=0; mfxOut.Metallic=0;} 
	}
		
}

/*			
_ReflectionAmount("_ReflectionAmount",FLOAT)=1
_ReflectionPower("_ReflectionPower",FLOAT)=1
_ReflectionRimType("_ReflectionRimType",RANGE(-1,1))=1
_ReflectionTint("_ReflectionTint",color)=(1,1,1,1)
_ReflectionDampenRimPower("_ReflectionDampenRimPower",FLOAT)=1
_ReflectionDampenRimType("_ReflectionDampenRimType",FLOAT)=0
_ReflectionDampenRimAmount("_ReflectionDampenRimAmount",FLOAT)=0
*/
uniform float4 _ReflectionTint;
float _ReflectionDampenRimPower,_ReflectionDampenRimType,_ReflectionDampenRimAmount;
float _ReflectionAmount,_ReflectionPower,_ReflectionRimType;

void GetSkyEffect (Input IN) {
		skyColor=half3(0,0,0);
		if (_ReflectionAmount > 0) {
		half3 worldViewDir = normalize(UnityWorldSpaceViewDir(IN.worldPos));
		half3 worldRefl = reflect(-IN.viewDir, mfxOut.Normal);
		half4 skyData = UNITY_SAMPLE_TEXCUBE(unity_SpecCube0, normal);
		skyColor = DecodeHDR (skyData, unity_SpecCube0_HDR);
		

		float3 reflectionAdd = skyColor; 
		if (_ReflectionRimType <0) {
			reflectionAdd = lerp (reflectionAdd,skyColor*pow(1-rim,_ReflectionPower+0.001),_ReflectionRimType * -1);
		}
		if (_ReflectionRimType > 0) {
			reflectionAdd = lerp (reflectionAdd,skyColor*pow(rim,_ReflectionPower+0.001),_ReflectionRimType);
		}
		skyColor=reflectionAdd * _ReflectionAmount * _ReflectionTint;
						
		float3 dampener = float3(1,1,1); 
		if (_ReflectionDampenRimType <0) {
			dampener = lerp (dampener,float3(1,1,1)*pow(1-rim,_ReflectionDampenRimPower+0.001),_ReflectionDampenRimType * -1);
		}
		if (_ReflectionDampenRimType > 0) {
			dampener = lerp (dampener,float3(1,1,1)*pow(rim,_ReflectionDampenRimPower+0.001),_ReflectionDampenRimType);
		}
		skyColor *= 1-(dampener * (_ReflectionDampenRimAmount));
	}
}

/*
_ReflectionCube("_ReflectionCube",CUBE) = "black" {}
_ReflectionCubeTint("_ReflectionCubeTint",color)=(1,1,1,1)
_ReflectionCubeAmount("_ReflectionCubeAmount",RANGE(0,1))=0
_ReflectionCubePower("_ReflectionCubePower",RANGE(0,1))=0
_ReflectionCubeNormalAmount("_ReflectionCubeNormalAmount",RANGE(0,1))=.5
*/

float4 _ReflectionCubeTint;
samplerCUBE _ReflectionCube;
float _ReflectionCubeAmount,_ReflectionCubePower,_ReflectionCubeNormalAmount;

void GetCubeEffect (Input IN) {		
	cubeColor=half3(0,0,0);
	if (_ReflectionCubeAmount >0) {
		cubeColor =  (texCUBE (_ReflectionCube,(-IN.worldRefl*(1+mfxOut.Normal*0.6)))) * _ReflectionCubeTint;
		cubeColor*= _ReflectionCubeAmount * clamp(pow(rim,_ReflectionCubePower+0.001),0,1);
	}
}

/*
_IridescenceAmount("_IridescenceAmount",FLOAT)=0
_IridescenceScale("_IridescenceScale",FLOAT)=1
_IridescenceSpeed("_IridescenceSpeed",FLOAT)=1
_IridescenceCurvature("_IridescenceCurvature",FLOAT)=1
_IridescenceRimPower("_IridescenceRimPower",FLOAT)=1
_IridescenceRimType("_IridescenceRimType",FLOAT)=0
_IridescenceTint("_IridescenceTint",color)=(1,1,1,1)
*/
float _IridescenceAmount,_IridescenceRimPower,_IridescenceRimType,_IridescenceScale,_IridescenceSpeed,_IridescenceCurvature;
float4 _IridescenceTint;			

void GetIridescenceEffect (Input IN) {					
	iremissive = 0; 
	if (_IridescenceAmount>0) {
		half irim = 1.0 - saturate(dot (normalize(IN.viewDir*mfxOut.Normal), normalize(mfxOut.Normal)));
		float3 irColor = abs(float3(fractalNoise(_IridescenceScale*IN.viewDir*IN.worldPos.xyz + (_IridescenceSpeed*_Time.x *2)),fractalNoise(_IridescenceScale*IN.viewDir*IN.worldPos.xzy + (_IridescenceSpeed*_Time.x *.3)),fractalNoise(_IridescenceScale*IN.viewDir*IN.worldPos.zxy + (_IridescenceSpeed*_Time.x *1.23))));
		irColor *= abs(float3(fractalNoise(_IridescenceScale*IN.viewDir*IN.worldPos.yzx*.4 + (_IridescenceSpeed*_Time.x *2)),fractalNoise(_IridescenceScale*IN.viewDir*IN.worldPos.zyx*.5 + (_IridescenceSpeed*_Time.x *.2)),fractalNoise(_IridescenceScale*IN.viewDir*IN.worldPos.yxz*.6 + (_IridescenceSpeed*_Time.x *0.321))));
		irColor = lerp(irColor,irColor*curve,_IridescenceCurvature);
		iremissive = irColor; 
		if (_IridescenceRimType <0) {
			iremissive = lerp (iremissive,irColor*pow(1-irim,_IridescenceRimPower+0.001),_IridescenceRimType * -1);
		}
		if (_IridescenceRimType > 0) {
			iremissive = lerp (iremissive,irColor*pow(irim,_IridescenceRimPower+0.001),_IridescenceRimType);
		}
		iremissive *= _IridescenceTint * _IridescenceAmount;				
		mfxOut.Albedo += iremissive;
				
	}
}

void GetParallax (Input IN) {
	if (fxAmount.r - (1 - _Snow) > 0)
	{
		float c = clamp(fxAmount.r - (1 - _Snow), 0, 1);
		float addParallax = -lerp(0,1-c,_SnowAddParalax);
	}
	half h = tex2D (_HeightMap, IN.uv_MainTex).r;
	parallaxOffset = ParallaxOffset (h, _Parallax+(_SnowAddParalax*_AllEffects), IN.viewDir);
					
	if (parallaxOffset.x >=0) { parallaxOffset.x *= parallaxOffset;	} else {	parallaxOffset.x *= -1*parallaxOffset; }
	if (parallaxOffset.y >=0) {	parallaxOffset.y *= parallaxOffset;	} else {	parallaxOffset.y *= -1*parallaxOffset; }
}

/*
[NoScaleOffset]
_EmissionMap("_EmissionMap", 2D) = "black" {}
[HDR]
_EmissionBoostColor("_EmissionBoostColor",COLOR)=(0,0,0,0)
_EmissionBoostRimPower("_EmissionBoostRimPower",FLOAT)=1
_EmissionBoostRimType("_EmissionBoostRimType",FLOAT)=0
_EmissionColor("_EmissionColor",COLOR)=(1,1,1,1)
_EmissionAmount("_EmissionAmount",FLOAT)=0
_EmissionDampenRimPower("_EmissionDampenRimPower",FLOAT)=1
_EmissionDampenRimType("_EmissionDampenRimType",FLOAT)=0
_EmissionDampenRimAmount("_EmissionDampenRimAmount",FLOAT)=0
*/
sampler2D _EmissionMap;
float4 _EmissionBoostColor;
float _EmissionBoostRimPower,_EmissionAmount,_EmissionBoostRimType,_EmissionDampenRimPower,_EmissionDampenRimType,_EmissionDampenRimAmount;

void GetEmission (Input IN){
				
			
	fixed4 src = (tex2D(_EmissionMap,IN.uv_MainTex) * _EmissionColor * _EmissionAmount);
	fixed4 dst=src;
	fixed4 emissive = _EmissionBoostColor; 
	if (_EmissionBoostRimType <0) {
		emissive = lerp (emissive,_EmissionBoostColor*pow(1-rim,_EmissionBoostRimPower+0.001),_EmissionBoostRimType * -1);
	}
	if (_EmissionBoostRimType > 0) {
		emissive = lerp (emissive,_EmissionBoostColor*pow(rim,_EmissionBoostRimPower+0.001),_EmissionBoostRimType);
	}
	dst += emissive * _EmissionAmount;

	fixed4 dampener = fixed4(1,1,1,1); 
	if (_EmissionDampenRimType <0) {
		dampener = lerp (dampener,fixed4(1,1,1,1)*pow(1-rim,_EmissionDampenRimPower+0.001),_EmissionDampenRimType * -1);
	}
	if (_EmissionDampenRimType > 0) {
		dampener = lerp (dampener,fixed4(1,1,1,1)*pow(rim,_EmissionDampenRimPower+0.001),_EmissionDampenRimType);
	}
	dst = dst * 1-(dampener * (_EmissionDampenRimAmount));					
	mfxOut.Emission = dst.rgb;				
}

void SetupMaterialFX (Input IN,float3 originalNormal) {
				lightDirection = (_WorldSpaceLightPos0.xyz);
				oNormal = originalNormal;
				viewDirection=IN.viewDir;
				mfxUV = IN.uv_MainTex;
				//Needed before for parallax offset
			    fxAmount = getGrowthAmount(IN.uv_MainTex) * _AllEffects;
				GetParallax(IN);
			}

		
			void MaterialFXFinalPass () {
				//Apply Emission Values
				mfxOut.Emission += (skyColor+cubeColor) * (1-  mfxOut.Metallic);
				mfxOut.Albedo += ((skyColor+cubeColor)) + detailAlbedo;
				//Apply Ambient Color for lighting, Also force Material States for debugging
				_SSSAmbient=mfxOut.Albedo;
				mfxOut.Metallic = lerp(mfxOut.Metallic,1,_ForceMetallic);
				mfxOut.Smoothness = lerp(mfxOut.Smoothness,1,_ForceSmoothness);
			}