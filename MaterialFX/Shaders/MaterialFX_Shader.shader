// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

 Shader "MaterialFX/MaterialFX" {
        Properties {
			[HideInInspector]
			_EditorTab("_EditorTab", INT) = 0
			[HideInInspector]
			_DisplayMode("Display Mode", INT) = 0
			[HideInInspector]
			_TextureWorkflow("Texture Workflow", INT) = 0

			//--------Tessellation			
			_Tess ("Tessellation", Range(1,32)) =1
			_Phong("Phong",Range(0,4))=0
			_TessDistMin("_TessDistMin",Range(.1,50)) = 10.0
			_TessDistMax("_TessDistMax",Range(.1,150)) = 25.0

			//-------- PBR Mats		
			_Colored("_Colored",Range(0,1))=1
			_BothNormals("_BothNormals",Range(0,1))=1
			_ReflectionAmount("_ReflectionAmount",FLOAT)=1
			_ReflectionPower("_ReflectionPower",FLOAT)=1

            
			_FXTex("FX Texture", 2D) = "white" {}    
			_AllEffects("_AllEffects",RANGE(0,1))=1
			_DisplacementLimiter("_DisplacementLimiter",RANGE(0,64))=64
			_Snow("Snow", RANGE(0,1))=0
			_SnowDisplacement("_SnowDisplacement",RANGE(0,1))=.3
			_SnowAddParalax("_SnowAddParalax",RANGE(0,1))=0.3
			_SnowTint("Snow Color", Color) = (.5,.5,.5,1) 
			_SnowNoiseScale("_SnowNoiseScale",FLOAT)=4
			_SnowNoiseAmount("_SnowNoiseAmount",FLOAT)=1
			
		
			_Growth("Growth", RANGE(0,1))=0
			_GrowthNoise("_GrowthNoise",RANGE(0,1))=.3
			_GrowthNoiseSpeed("_GrowthNoiseSpeed",FLOAT)=.3
			_GrowthDisplacement("_GrowthDisplacement",RANGE(0,1))=.3
			_GrowthTint("Growth Color", Color) = (.5,.5,.5,1)    
			_GrowthTint2("_GrowthTint2",Color) = (.5,.5,.5,1)    
			_GrowthTex("Growth Texture", 2D) = "green" {}     
			_GrowthBump("Growth Normal", 2D) = "bump" {}     
			
			_WetTint("Wetness Color", Color) = (.5,.5,.5,1)    
			_Wetness("Wetness", RANGE(0,1))=0
			_WetSpeedX("WetnessSpeedX", FLOAT)=0
			_WetSpeedY("WetnessSpeedY", FLOAT)=0
			_WetTextureScale("_WetTextureScale",FLOAT)=1
			[Normal]
			_WetNormalTex("Wetness Normal Texture", 2D) = "bump" {}    


			 _Metallic("_Metallic",Range(0,1)) = 1
			 _Smoothness("_Smoothness",Range(0,1)) = 1
			 _Thickness("_Thickness",Range(0,1)) = 1
			 _Curvature("_Curvature",Range(0,1)) = 1

		
            _MainTex ("Base (RGB)", 2D) = "white" {}

			_MainTexUVMode("_MainTexUVMode",INT)=0
			_MainTexTriplanarScale("_MainTexTriplanarScale",FLOAT)=1
			_MainTexTriplanarBlend("_MainTexTriplanarBlend",FLOAT)=1
			
			[Normal]
			[NoScaleOffset]
            _BumpMap ("Normalmap", 2D) = "bump" {}
			_NormalAmount("_NormalAmount",Range(0.001,4)) =1
			[NoScaleOffset]
			 _AdvancedPBRMap ("_AdvancedPBRMap", 2D) = "white" {}
			 _FXMap ("_FXMap", 2D) = "white" {}
			 _RoughnessMap("_RoughnessMap",2D)="white" {}
			[HDR]
			_SubSurfaceColor ("_SubSurfaceColor", color) = (1,1,1,0)		
			_SubSurfaceAmount ("_SubSurfaceAmount",Range(0,1)) = 0
			_SubSurfacePower("_SubSurfacePower", Range(1,16)) = 1
			_SubsurfaceRimType("_SubsurfaceRimType",FLOAT)=0
			_SubSurfaceRange("_SubSurfaceRange",Range(0,1))=0.5
			_SubSurfaceCurvatureAmount("_SubSurfaceCurvatureAmount",Range(0,2))=.3
			_SubSurfaceNoiseScale("_SubSurfaceNoiseScale",FLOAT)=3
			_SubSurfaceNoiseAmount("_SubSurfaceNoiseAmount",Range(0,100))=0.5
			[NoScaleOffset]
			_DispTex ("Disp Texture", 2D) = "black" {}
			_HeightMap ("Height Texture", 2D) = "black" {}
			_Parallax("_Parallax",Range(-1,1))=0
			_Displacement ("Displacement", Range(-4, 4.0)) = 0
			_DispScale("Disp Scale",Range(0.1,32.0)) = 4       
			_DispPower("Disp Power",Range(0.1,4.0)) = 1   
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

			_ReflectionTint("_ReflectionTint",color)=(1,1,1,1)
			_ReflectionDampenRimPower("_ReflectionDampenRimPower",FLOAT)=1
			_ReflectionDampenRimType("_ReflectionDampenRimType",FLOAT)=0
			_ReflectionDampenRimAmount("_ReflectionDampenRimAmount",FLOAT)=0
			
			_IridescenceRimAmount("_IridescenceRimAmount",FLOAT)=0
			_IridescenceScale("_IridescenceScale",FLOAT)=1
			_IridescenceSpeed("_IridescenceSpeed",FLOAT)=1
			_IridescenceCurvature("_IridescenceCurvature",FLOAT)=1
			_IridescenceRimPower("_IridescenceRimPower",FLOAT)=1
			_IridescenceRimType("_IridescenceRimType",FLOAT)=0
			_IridescenceTint("_IridescenceTint",color)=(1,1,1,1)
			[NoScaleOffset]
			_AOMap ("AO Texture", 2D) = "white" {}
			_AOAmount ("_AOAmount", Range(0, 2.0)) = 0
            
            _Color ("Color", color) = (1,1,1,0)
	
			[Normal]
			[NoScaleOffset]
			_DetailNormalMap("Detail Normal Map", 2D) = "bump" {}
			_DetailAlbedoMap("DetailAlbedoMap",2D)="black" {}
			_DetailAlbedoMultiplier("Detail Normal Multiplier",Range(0.0,32.0)) = 0.2          
			_DetailAlbedoScale("Detail Normal Scale",Range(0.1,32.0)) = 4        

            _DetailNormalMultiplier("Detail Normal Multiplier",Range(0.0,32.0)) = 0.2          
			_DetailNormalScale("Detail Normal Scale",Range(0.1,32.0)) = 4        
			_TessellationUniform("Tessellation Uniform", Range(1, 64)) = 1

			_CheckerDensity("_CheckerDensity",FLOAT)=20
			_ReflectionCube("_ReflectionCube",CUBE) = "black" {}
			_ReflectionCubeTint("_ReflectionCubeTint",color)=(1,1,1,1)
			_ReflectionCubeAmount("_ReflectionCubeAmount",RANGE(0,1))=0
			_ReflectionCubePower("_ReflectionCubePower",RANGE(0,1))=0
			_ReflectionCubeNormalAmount("_ReflectionCubeNormalAmount",RANGE(0,1))=.5
			_ReflectionRotationAmount("_ReflectionRotationAmount",Range(0,1))=0
			_ReflectionRimType("_ReflectionRimType",RANGE(-1,1))=1

			_ForceMetallic("_ForceMetallic",RANGE(0,1))=0
			_ForceSmoothness("_ForceSmoothness",RANGE(0,1))=0
        }
	
        SubShader {
            Tags { "RenderType"="Opaque" }
            LOD 300
			Cull Off
            CGPROGRAM
			#pragma surface surf StandardDefaultGI addshadow fullforwardshadows vertex:disp tessellate:tessDistance nolightmap tessphong:_Phong 
            #pragma target 4.6

			#include "Tessellation.cginc"
			#include "UnityPBSLighting.cginc"

			struct Input {
                float2 uv_MainTex;
				float3 viewDir;
				float3 worldPos;				
				float3 localCoord;
				float3 worldRefl;
				float3 localRefl;  INTERNAL_DATA				 
				float3 worldNorm;
            };
			struct appdata {
                float4 vertex : POSITION;
                float4 tangent : TANGENT;
                float3 normal : NORMAL;
                float2 texcoord : TEXCOORD0;
            };
			float _SnowAddParalax,	_SnowNoiseScale,_SnowNoiseAmount,_AllEffects,_DisplacementLimiter;
			float4 _ReflectionTint,_ReflectionCubeTint;
			float _ReflectionDampenRimPower,_ReflectionDampenRimType,_ReflectionDampenRimAmount;
			float _ForceSmoothness,_ForceMetallic;
			float _DetailAlbedoMultiplier,_DetailAlbedoScale;
			float _ReflectionCubeNormalAmount;
			float _SSRThickness=0.3;
			float _Distortion=1;
			float _Power =1;
			float _Scale=1;
			float _Attenuation=1;
			float3 _Ambient=float3(1,1,1);
			sampler2D _AdvancedPBRMap,_HeightMap,_FXMap,_RoughnessMap,DetailAlbedoMap;
			float _SubSurfaceRange;
			float _AOAmount;
			float _SubSurfaceAmount;
			float _DispScale,_DispPower;
			float4 _EmissionColor,_SubSurfaceColor;
			float _CheckerDensity;
			float _Curvature,_Thickness;
			int _TextureWorkflow;
			sampler2D _DispTex,_DetailNormalMap,_DetailAlbedoMap;
            float _Displacement,_NormalAmount;
	        float _DetailNormalMultiplier;
			float _ShowSmoothness,_ShowMetallic;
			float _SubSurfaceNoiseScale,_SubSurfaceNoiseAmount,_EmissionAmount;
			sampler2D _AOMap;
            sampler2D _MainTex;
            sampler2D _BumpMap;
            fixed4 _Color;
			float _Metallic,_Smoothness;
			float _DetailNormalScale,_Colored,_BothNormals,_ShowNormals,_ShowHeight;
			sampler2D _EmissionMap;
			float _SubSurfacePower;
			float _SubsurfaceRimType;
			float _Parallax;
			float _DisplayMode;
			float _SubSurfaceCurvatureAmount;
			float _ReflectionAmount,_ReflectionPower,_ReflectionRimType;
			float3 _EmissionBoostColor;
			float _EmissionBoostRimPower;
			float _EmissionBoostRimType;
			samplerCUBE _ReflectionCube;
			int _EditorTab;
			float _ReflectionCubeAmount;
			float _ReflectionRotationAmount;
			float _ReflectionCubePower;
			float _SnowDisplacement,_GrowthDisplacement,_GrowthNoise,_GrowthNoiseSpeed;
			float _EmissionDampenRimPower,_EmissionDampenRimType,_EmissionDampenRimAmount;
			float _WetTextureScale;
			float _IridescenceRimAmount,_IridescenceRimPower,_IridescenceRimType,_IridescenceScale,_IridescenceSpeed,_IridescenceCurvature;
			float4 _IridescenceTint;

			int _MainTexUVMode;
			float _MainTexTriplanarScale,_MainTexTriplanarBlend;


			inline fixed4 LightingStandardDefaultGI(SurfaceOutputStandard s, fixed3 viewDir, UnityGI gi)
			{
				// Original colour
				fixed4 pbr = LightingStandard(s, viewDir, gi);
					
				// --- Translucency ---
				float3 L = gi.light.dir;
				float3 V = viewDir;
				float3 N = s.Normal;
					
				if (_SSRThickness >= 0) {
				float3 H = normalize(L + N * _Distortion);
				float VdotH = saturate(pow(dot(V, -H), _Power)) * _Scale;
				float3 res =saturate(pow(dot(V, -H),1));
				float3 I = (res + _Ambient) * _SSRThickness * _SubSurfaceColor * (_SubSurfaceAmount*0.02) * _Attenuation;											
				pbr.rgb = pbr.rgb + gi.light.color * I;
				}
				
				return pbr;
			}

			 inline void LightingStandardDefaultGI_GI(
                SurfaceOutputStandard s,
                UnityGIInput data,
                inout UnityGI gi)
            {
				
                LightingStandard_GI(s, data, gi);
            }

			///--------------------------------------------- Tessellation : From Unity Docs

			float _Phong;	
			float _Tess,_TessDistMin,_TessDistMax;

			float4 tessDistance (appdata v0, appdata v1, appdata v2) {
				float minDist =_TessDistMin;
				float maxDist = _TessDistMax;
				return UnityDistanceBasedTess(v0.vertex, v1.vertex, v2.vertex, minDist, maxDist, _Tess);
			}




			// Helper functions for noise / triplanar functions
			#include "./MaterialFX_ShaderFunctions.cginc"
			
            void disp (inout appdata v)
		  {
			   float4 FXTex = getGrowthAmount(v.texcoord.xy);
				float gr = 0;
				float amount = sin(_Time.y) * 0.1 + 0.12;
				float3 fxdisplacement = v.vertex.xyz;
				if (FXTex.g - (1 - _Growth) > 0)
				{
					gr += ((_Growth * 0.5) * lerp(0,(fractalNoise(v.vertex.xy*100))*128,FXTex.g - (1 - _Growth))*FXTex.a)*_GrowthDisplacement;
					if (FXTex.g - (1 - _Growth) >_GrowthNoise-.75)
					{
					gr += (v.normal * fractalNoise(_GrowthNoiseSpeed * _Time.y + v.vertex.xy*100)*0.2)*_GrowthNoise;
					}
				}

				if (FXTex.r - (1 - _Snow) > 0)
				{
					gr += clamp((_Snow * 0.5)*  lerp(0,(hashNoise(v.vertex.xy*.2))*50,(FXTex.r - (1 - _Growth)))*FXTex.a,0,1)*_SnowDisplacement;
				
					gr += (v.normal * fractalNoise(v.vertex.xy*_SnowNoiseScale)*0.5)*_SnowNoiseAmount;
				
				}
				if (_AllEffects==0) gr=0;
				v.vertex.xyz += (v.normal * clamp(gr,0,_DisplacementLimiter)*0.3);
		
			
                float d = tex2Dlod(_DispTex, (float3(v.texcoord.xy * _DispScale,0)).r);			
	            v.vertex.xyz += v.normal * pow(d,_DispPower) *  _Displacement;
            }




            void surf (Input IN, inout SurfaceOutputStandard o) {

			    float4 fxAmount = getGrowthAmount(IN.uv_MainTex);
					if (fxAmount.r - (1 - _Snow) > 0)
				{
					float c = clamp(fxAmount.r - (1 - _Snow), 0, 1);
					float addParallax = -lerp(0,1-c,_SnowAddParalax);
				}

					half h = tex2D (_HeightMap, IN.uv_MainTex).r;
					float2 offset = ParallaxOffset (h, _Parallax+_SnowAddParalax, IN.viewDir);
					
				if (offset.x >=0) {
					offset.x *= offset;
				}else {
					offset.x *= -1*offset;
				}
					if (offset.y >=0) {
					offset.y *= offset;
				}else {
					offset.y *= -1*offset;
				}
				float3 lightDirection = (_WorldSpaceLightPos0.xyz);
				_Attenuation=1;//clamp(pow(distance(IN.worldPos,_WorldSpaceLightPos0.xyz),20),0,1);

				IN.uv_MainTex += offset;	

				float3 oNormal = o.Normal;
				float4 mainTexColor =  float4(0,0,0,0);
				if (_MainTexUVMode==0) { mainTexColor=tex2D (_MainTex, IN.uv_MainTex+offset);}
				if (_MainTexUVMode==1) { mainTexColor=texTriplanar (_MainTex, IN.worldPos,_MainTexTriplanarScale,o.Normal,_MainTexTriplanarBlend);}
                half4 c = lerp(_Color,mainTexColor,_Colored);
                o.Albedo = c.rgb;
				float4 pbrMap = tex2D(_AdvancedPBRMap,IN.uv_MainTex);
                o.Metallic = pbrMap.r * _Metallic;			
				o.Smoothness = pbrMap.a * _Smoothness;


				if (_TextureWorkflow == 2) o.Smoothness = ((1- tex2D(_RoughnessMap,IN.uv_MainTex)) * (1-_Smoothness));


				pbrMap.g *= _Thickness;
				pbrMap.b *= _Curvature;
				o.Occlusion =  lerp(float3(1,1,1),tex2D (_AOMap, IN.uv_MainTex),_AOAmount);
                float thick = pbrMap.g;
				float curve = pbrMap.b;
				


				fixed3 detAlbedo = tex2D(_DetailAlbedoMap, IN.uv_MainTex *_DetailAlbedoScale)  * _DetailAlbedoMultiplier;  
				fixed3 detNorm = UnpackNormal(tex2D(_DetailNormalMap, IN.uv_MainTex *_DetailNormalScale)); 
				detNorm.z= detNorm.z / clamp(_DetailNormalMultiplier,0.01,32); 			
				fixed3 normal = UnpackNormal(tex2D(_BumpMap, IN.uv_MainTex)); 
				normal.z = normal.z / (_NormalAmount*2); 
		
				
			
				o.Normal = lerp(oNormal,normalize(normal) + normalize(detNorm),_BothNormals);

				half rim = 1.0 - saturate(dot (normalize(IN.viewDir), normalize(o.Normal)));
				o.Albedo = lerp (o.Albedo,o.Normal,_ShowNormals);

				o.Emission = (tex2D(_EmissionMap,IN.uv_MainTex) * _EmissionColor * _EmissionAmount);
				float3 emissive = _EmissionBoostColor; 
				if (_EmissionBoostRimType <0) {
					emissive = lerp (emissive,_EmissionBoostColor*pow(1-rim,_EmissionBoostRimPower+0.001),_EmissionBoostRimType * -1);
				}
				if (_EmissionBoostRimType > 0) {
					emissive = lerp (emissive,_EmissionBoostColor*pow(rim,_EmissionBoostRimPower+0.001),_EmissionBoostRimType);
				}
				o.Emission += emissive * _EmissionAmount;

				float3 dampener = float3(1,1,1); 
				if (_EmissionDampenRimType <0) {
					dampener = lerp (dampener,float3(1,1,1)*pow(1-rim,_EmissionDampenRimPower+0.001),_EmissionDampenRimType * -1);
				}
				if (_EmissionDampenRimType > 0) {
					dampener = lerp (dampener,float3(1,1,1)*pow(rim,_EmissionDampenRimPower+0.001),_EmissionDampenRimType);
				}
				o.Emission *= 1-(dampener * (_EmissionDampenRimAmount));
			
				_SSRThickness=((1-thick + (curve * _SubSurfaceCurvatureAmount))/(1.01-(_SubSurfaceRange*0.9))) * o.Occlusion;

				if (_SubsurfaceRimType <0) {
					_SSRThickness = lerp (_AllEffects,_AllEffects*pow(1-rim,_SubSurfacePower+0.001),_SubsurfaceRimType * -1);
				}
				if (_SubsurfaceRimType > 0) {
					_SSRThickness = lerp (_AllEffects,_AllEffects*pow(rim,_SubSurfacePower+0.001),_SubsurfaceRimType);
				}
				if (_DisplayMode == 1) _SSRThickness=-1;								

				//--------------------------Environment Effects
				float4 wp=float4(IN.worldPos,1);

				float4 wpWater = (wp*2) + float4(0,_Time.y * _WetSpeedY / 5,0,0);
				float4 wpWater2 = (wp*4) + float4(0,_Time.y * _WetSpeedY,0,0);
				fixed4 FXTex = tex2D(_FXTex, IN.uv_MainTex);

				//FXTex.r += fractalNoise(wp.xz) * 0.5 + 0.5; //wp.xz ?
				float otherFX = clamp(pow((FXTex.g * _Growth) + (FXTex.r * _Snow), 2), 0, 1);
				float wet = clamp(fxAmount.b - (1 - _Wetness), 0, 0.9) * (1 - otherFX);

				
				float3 detNormWet = UnpackNormal(texTriplanar(_WetNormalTex, wpWater,_WetTextureScale, normal,1)+texTriplanar(_WetNormalTex, wpWater2,_WetTextureScale*3, normal,1));
			//	detNormWet += texTriplanar(_WetNormalTex, wpWater,8, normal)*20;
			

		
		

				// Apply Wetness
				
				 o.Smoothness = clamp( o.Smoothness + (clamp(FXTex.b * _Wetness,0,0.75)), 0, 1);
				 float wetAlpha = wet * _WetTint.a;
				 o.Albedo = ((1 - wetAlpha) *  o.Albedo) + (wetAlpha *  o.Albedo *_WetTint.rgb);
				 // Apply Snow
				if (fxAmount.r - (1 - _Snow) > 0)
				{
					float c = clamp(fxAmount.r - (1 - _Snow), 0, 1);
					float3 sCol = lerp (_SnowTint,_SnowTint*2,curve);
					o.Albedo = (o.Albedo * (1 - c)) + (sCol * c);	
					o.Smoothness *= clamp(c,0,.75);
				}
				// Apply Growth
				 if (fxAmount.g - (1 - _Growth) > 0)
				{
					float c = clamp((fxAmount.g - (1 - _Growth)), 0, 1);
					float3 gCol = lerp (_GrowthTint,_GrowthTint2, c*(1-curve));

					float3 detNormGR = UnpackNormal(texTriplanar(_WetNormalTex, (wp),80, normal,1));
					o.Albedo = (o.Albedo * (1 - c)) + (gCol * c);	
				//	o.Albedo=c;
					o.Smoothness *= lerp(0,o.Smoothness,c*(1-curve));
					
			
					
					//o.Normal = lerp(o.Normal,normalize(detNormGR),c);
				}
				float3 wNormal = o.Normal;
				detNormWet=detNormWet;
				wNormal.x += detNormWet.x;
				wNormal.y += detNormWet.y;
				wNormal.z += detNormWet.z;
				o.Normal = lerp(o.Normal,wNormal,wet*_AllEffects);


			
				half3 skyColor=half3(0,0,0);
				 if (_ReflectionAmount > 0) {
					half3 worldViewDir = normalize(UnityWorldSpaceViewDir(IN.worldPos));
					half3 worldRefl = reflect(-IN.viewDir, o.Normal);
					half4 skyData = UNITY_SAMPLE_TEXCUBE(unity_SpecCube0, normal);
					skyColor = DecodeHDR (skyData, unity_SpecCube0_HDR);
					float3 reflNormal = lerp(oNormal,normalize(normal),_ReflectionCubeNormalAmount + 0.01);
					half3 worldRefl2 = reflect(-worldRefl, o.Normal);
					// same as in previous shader
					
					
					//skyColor =lerp (half3(0,0,0),skyColor*_ReflectionAmount,clamp(pow(rim,_ReflectionPower+0.001),0,1));
					float3 reflectionAdd = skyColor; 
					if (_ReflectionRimType <0) {
						reflectionAdd = lerp (reflectionAdd,skyColor*pow(1-rim,_ReflectionPower+0.001),_ReflectionRimType * -1);
					}
					if (_ReflectionRimType > 0) {
						reflectionAdd = lerp (reflectionAdd,skyColor*pow(rim,_ReflectionPower+0.001),_ReflectionRimType);
					}
					skyColor=reflectionAdd * _ReflectionAmount * _ReflectionTint;

						
					dampener = float3(1,1,1); 
					if (_ReflectionDampenRimType <0) {
						dampener = lerp (dampener,float3(1,1,1)*pow(1-rim,_ReflectionDampenRimPower+0.001),_ReflectionDampenRimType * -1);
					}
					if (_ReflectionDampenRimType > 0) {
						dampener = lerp (dampener,float3(1,1,1)*pow(rim,_ReflectionDampenRimPower+0.001),_ReflectionDampenRimType);
					}
					skyColor *= 1-(dampener * (_ReflectionDampenRimAmount));



				}
				half3 cubeColor=half3(0,0,0);
				if (_ReflectionCubeAmount >0) {
					cubeColor =  (texCUBE (_ReflectionCube,(-IN.worldRefl*(1+o.Normal*0.6)))) * _ReflectionCubeTint;
					cubeColor*= _ReflectionCubeAmount * clamp(pow(rim,_ReflectionCubePower+0.001),0,1);
				}
			

				


			    float3 iremissive = 0; 
				if (_IridescenceRimAmount>0) {
					half irim = 1.0 - saturate(dot (normalize(IN.viewDir*o.Normal), normalize(o.Normal)));
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
					iremissive *= _IridescenceTint * _IridescenceRimAmount*8;
					o.Albedo += iremissive;
				}
				//o.Albedo += clamp(SSLight,0,1);
				//  [KeywordEnum(Default, NoColor, Normal, Metallic, Smoothness, Thickness, Curvature, AdvancedPBR, SSDebug)]

				
				o.Emission += (skyColor+cubeColor) * (1-  o.Metallic);
				o.Albedo += ((skyColor+cubeColor)) + detAlbedo;
				_Ambient=o.Albedo;//c.rgb;
				o.Metallic = lerp(o.Metallic,1,_ForceMetallic);
				o.Smoothness = lerp(o.Smoothness,1,_ForceSmoothness);
				if (_DisplayMode > 0) {
					if (_DisplayMode == 1) { o.Albedo=c.rgb; _SSRThickness=-1; } 
					if (_DisplayMode == 2) { o.Albedo=0; o.Emission=normalize(o.Normal); _SSRThickness=-1; o.Smoothness=0; o.Metallic=0;} 
					if (_DisplayMode == 3) { o.Emission=o.Albedo;  o.Albedo=0; _SSRThickness=-1; o.Smoothness=0; o.Metallic=0;} 
					if (_DisplayMode == 4) { o.Albedo=0; o.Emission=o.Smoothness; _SSRThickness=-1; o.Smoothness=0; o.Metallic=0;} 
					if (_DisplayMode == 5) { o.Albedo=0; o.Emission=pbrMap.g; _SSRThickness=-1; o.Smoothness=0; o.Metallic=0;} 
					if (_DisplayMode == 6) { o.Albedo=0; o.Emission=pbrMap.b; _SSRThickness=-1; o.Smoothness=0; o.Metallic=0;} 
			
					if (_DisplayMode == 7) { o.Albedo=o.Emission; o.Emission=0; } 
					if (_DisplayMode == 8) { o.Albedo=float3(0,0,0); o.Metallic=0; o.Smoothness=0; } 
					if (_DisplayMode == 9) { o.Albedo=0; o.Emission=fxAmount; _SSRThickness=-1; o.Smoothness=0; o.Metallic=0;} 
					if (_DisplayMode == 10) { o.Albedo=0; o.Emission=iremissive; _SSRThickness=-1; o.Smoothness=0; o.Metallic=0;} 
					if (_DisplayMode == 11) { o.Albedo=0; o.Emission=skyColor; _SSRThickness=-1; o.Smoothness=0; o.Metallic=0;} 
					if (_DisplayMode == 12) { o.Albedo=0; o.Emission=cubeColor; _SSRThickness=-1; o.Smoothness=0; o.Metallic=0;} 
					if (_DisplayMode == 13) {
						float2 chk = floor(IN.uv_MainTex*_CheckerDensity) / 2;
						float checker = frac(chk.x + chk.y) *2; 
						o.Normal = oNormal;
						o.Albedo=checker; 
						o.Emission=checker; 
						o.Metallic=0; 
						o.Smoothness=0;
						_SSRThickness=-1;
					}
				}
		
            }
            ENDCG
        }
        FallBack "Diffuse"
		CustomEditor "MaterialFX.MaterialFX_ShaderEditor"
    }