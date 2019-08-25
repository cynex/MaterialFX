// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

 Shader "MaterialFX/MaterialFX" {
        Properties {
			// Used for Edtor : Current Tab
			[HideInInspector]
			_EditorTab("_EditorTab", INT) = 0
			// Used for Editor : Rendering Mode (for debugging channels)
			[HideInInspector]
			_DisplayMode("Display Mode", INT) = 0
			//Texture Workflow (0=MFX,1=UNITY,2=Substance [only for roughness- TBD : Roughness->Smoothness converter)
			[HideInInspector]
			_TextureWorkflow("Texture Workflow", INT) = 0

			//--------Tessellation			
			_Tess ("Tessellation", Range(1,32)) =1
			_Phong("Phong",Range(0,4))=0
			_TessDistMin("_TessDistMin",Range(.1,50)) = 10.0
			_TessDistMax("_TessDistMax",Range(.1,150)) = 25.0


			//Texture Maps
			_MainTex ("Base (RGB)", 2D) = "white" {}
			_Color ("Color", color) = (1,1,1,0)
			// UVMode = 0=UV, 1= Triplanar
			_MainTexUVMode("_MainTexUVMode",INT)=0
			_MainTexTriplanarScale("_MainTexTriplanarScale",FLOAT)=1
			_MainTexTriplanarBlend("_MainTexTriplanarBlend",FLOAT)=1
			 _RoughnessMap("_RoughnessMap",2D)="white" {} 

			[Normal]
			[NoScaleOffset]
            _BumpMap ("Normalmap", 2D) = "bump" {}
			_BumpMapUVMode("_BumpMapUVMode",INT)=0
			_BumpMapTriplanarScale("_BumpMapTriplanarScale",FLOAT)=1
			_BumpMapTriplanarBlend("_BumpMapTriplanarBlend",FLOAT)=1

			_NormalAmount("_NormalAmount",Range(0.001,4)) =1
			[NoScaleOffset]
			 _AdvancedPBRMap ("_AdvancedPBRMap", 2D) = "white" {}
			 _AdvancedPBRMapUVMode("_AdvancedPBRMapUVMode",INT)=0
			 _AdvancedPBRMapTriplanarScale("_AdvancedPBRMapMapTriplanarScale",FLOAT)=1
			 _AdvancedPBRMapTriplanarBlend("_AdvancedPBRMapTriplanarBlend",FLOAT)=1
			 _FXMap ("_FXMap", 2D) = "white" {}
			
			[NoScaleOffset]
			_AOMap ("AO Texture", 2D) = "white" {}
			_AOAmount ("_AOAmount", Range(0, 1.0)) = 0
			_AOMutliply ("_AOMutliply", Range(0, 2.0)) = 0
			_AOCurvature ("_AOCurvature", Range(0, 1.0)) = 0
			//-------- PBR Mats		
			_Colored("_Colored",Range(0,1))=1
			_BothNormals("_BothNormals",Range(0,1))=1

			_AllEffects("_AllEffects",RANGE(0,1))=1
			_DisplacementLimiter("_DisplacementLimiter",RANGE(0,64))=64
			_Snow("Snow", RANGE(0,1))=0
			_SnowDisplacement("_SnowDisplacement",RANGE(0,1))=.3
			_SnowAddParalax("_SnowAddParalax",RANGE(0,1))=0.3
			_SnowTint("Snow Color", Color) = (.5,.5,.5,1) 
			_SnowNoiseScale("_SnowNoiseScale",FLOAT)=4
			_SnowNoiseAmount("_SnowNoiseAmount",FLOAT)=1
			
			_FXTex("FX Texture", 2D) = "white" {}   

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

			_ReflectionAmount("_ReflectionAmount",FLOAT)=1
			_ReflectionPower("_ReflectionPower",FLOAT)=1
			_ReflectionRimType("_ReflectionRimType",RANGE(-1,1))=1
			_ReflectionTint("_ReflectionTint",color)=(1,1,1,1)
			_ReflectionDampenRimPower("_ReflectionDampenRimPower",FLOAT)=1
			_ReflectionDampenRimType("_ReflectionDampenRimType",FLOAT)=0
			_ReflectionDampenRimAmount("_ReflectionDampenRimAmount",FLOAT)=0

			_ReflectionCube("_ReflectionCube",CUBE) = "black" {}
			_ReflectionCubeTint("_ReflectionCubeTint",color)=(1,1,1,1)
			_ReflectionCubeAmount("_ReflectionCubeAmount",RANGE(0,1))=0
			_ReflectionCubePower("_ReflectionCubePower",RANGE(0,1))=0
			_ReflectionCubeNormalAmount("_ReflectionCubeNormalAmount",RANGE(0,1))=.5

			_IridescenceAmount("_IridescenceAmount",FLOAT)=0
			_IridescenceScale("_IridescenceScale",FLOAT)=1
			_IridescenceSpeed("_IridescenceSpeed",FLOAT)=1
			_IridescenceCurvature("_IridescenceCurvature",FLOAT)=1
			_IridescenceRimPower("_IridescenceRimPower",FLOAT)=1
			_IridescenceRimType("_IridescenceRimType",FLOAT)=0
			_IridescenceTint("_IridescenceTint",color)=(1,1,1,1)		
	
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

		    int _EditorTab,_TextureWorkflow,_DisplayMode;				
					
			float _AllEffects;
			float _SnowAddParalax,_SnowNoiseScale,_SnowNoiseAmount,_DisplacementLimiter;
			float _SnowDisplacement,_GrowthDisplacement,_GrowthNoise,_GrowthNoiseSpeed,_WetTextureScale;
			
			sampler2D _MainTex;
			fixed4 _Color;
			int _MainTexUVMode;
			float _MainTexTriplanarScale,_MainTexTriplanarBlend;

			sampler2D _BumpMap;
			int _BumpMapUVMode;
			float _BumpMapTriplanarScale,_BumpMapTriplanarBlend;

			sampler2D _AdvancedPBRMap;
			int _AdvancedPBRMapUVMode;
			float _AdvancedPBRMapTriplanarScale,_AdvancedPBRMapTriplanarBlend;

			sampler2D _DetailAlbedoMap;
			float _DetailAlbedoMultiplier,_DetailAlbedoScale;

			sampler2D _DetailNormalMap;
			float _DetailNormalMultiplier;

			sampler2D _HeightMap,_FXMap,_RoughnessMap;
			float _SubSurfaceRange;
			float _AOAmount,_AOMutliply,_AOCurvature;
			float _SubSurfaceAmount;
			float _DispScale,_DispPower;
			float4 _EmissionColor,_SubSurfaceColor;
			float _CheckerDensity;

			sampler2D _DispTex;
            float _Displacement,_NormalAmount;

			float _Curvature,_Thickness;
			float _ShowSmoothness,_ShowMetallic;
			float _SubSurfaceNoiseScale,_SubSurfaceNoiseAmount;

			sampler2D _AOMap;              
			float _Metallic,_Smoothness;
			float _DetailNormalScale,_Colored,_BothNormals,_ShowNormals,_ShowHeight;
		
			float _SubSurfacePower,_SubSurfaceCurvatureAmount,_SubsurfaceRimType;

			float _Parallax;
	

		    

			float _ForceSmoothness,_ForceMetallic;
			// ---------------------------------------------------- Subsurface scattering
			// based on Alan Zucconi's tutorial : https://www.alanzucconi.com/2017/08/30/fast-subsurface-scattering-2/
			// with modification to for thickness
			float _SSRThickness=0.3;
			float _SSSDistortion=1;
			float _SSSPower =1;
			float _SSSScale=1;
			float3 _SSSAmbient=float3(1,1,1);
			inline fixed4 LightingStandardDefaultGI(SurfaceOutputStandard s, fixed3 viewDir, UnityGI gi)
			{
				// Original colour
				fixed4 pbr = LightingStandard(s, viewDir, gi);
				if (_SSRThickness >= 0) {
				// SSS Calculations
				float3 light = gi.light.dir;
				float3 viewDirection = viewDir;
				float3 normal = s.Normal;
				float3 H = normalize(light + normal * _SSSDistortion);
				float VdotH = saturate(pow(dot(viewDirection, -H), _SSSPower)) * _SSSScale;
				float3 res =saturate(pow(dot(viewDirection, -H),1));
				float3 I = (res + _SSSAmbient) * _SSRThickness * _SubSurfaceColor * (_SubSurfaceAmount*0.02);											
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
				float growthdisplace = getGrowthAndSnowDisplace(FXTex,v);			
				v.vertex.xyz += (v.normal * clamp(growthdisplace,0,_DisplacementLimiter)*0.3);				
				//Apply Displacement Texture
				float d = tex2Dlod(_DispTex, (float3(v.texcoord.xy * _DispScale,0)).r);			
				v.vertex.xyz += v.normal * pow(d,_DispPower) *  _Displacement;
			}



            void surf (Input IN, inout SurfaceOutputStandard o) {

				float3 lightDirection = (_WorldSpaceLightPos0.xyz);
				float3 oNormal = o.Normal;
				//Needed before for parallax offset
			    fxAmount = getGrowthAmount(IN.uv_MainTex) * _AllEffects;

				//Parallax : from unity
				GetParallax(IN,o);

				float4 mainTexColor =  getUVModeTexture  (_MainTex, _MainTexUVMode, IN.uv_MainTex + parallaxOffset, _MainTexTriplanarScale, IN.worldPos, o.Normal, _MainTexTriplanarBlend);
				
                half4 colored = lerp(_Color,mainTexColor*_Color,_Colored);
                o.Albedo = colored.rgb;				
				float4 pbrMap = getUVModeTexture  (_AdvancedPBRMap, _AdvancedPBRMapUVMode, IN.uv_MainTex + parallaxOffset, _AdvancedPBRMapTriplanarScale, IN.worldPos, o.Normal, _AdvancedPBRMapTriplanarBlend);
                o.Metallic = pbrMap.r * _Metallic;			
				o.Smoothness = pbrMap.a * _Smoothness;

				// If substance, use roughness map
				if (_TextureWorkflow == 2) o.Smoothness = ((1- tex2D(_RoughnessMap,IN.uv_MainTex)) * (1-_Smoothness));

				thick = pbrMap.g * lerp(0,pbrMap.g,_Thickness);
				curve = pbrMap.b * lerp(0,pbrMap.b,_Curvature);
				o.Occlusion =  lerp(float3(1,1,1),pow(tex2D (_AOMap, IN.uv_MainTex),_AOMutliply+1)-((1-curve) * _AOCurvature) ,_AOAmount);

				// Get Detail Normal / Albedo
				fixed3 detAlbedo = tex2D(_DetailAlbedoMap, IN.uv_MainTex *_DetailAlbedoScale)  * _DetailAlbedoMultiplier;  
				fixed3 detNorm = UnpackNormal(tex2D(_DetailNormalMap, IN.uv_MainTex *_DetailNormalScale)); 
				detNorm.z= detNorm.z / clamp(_DetailNormalMultiplier,0.01,32); 	

				normal = UnpackNormal(getUVModeTexture  (_BumpMap, _BumpMapUVMode, IN.uv_MainTex+parallaxOffset, _BumpMapTriplanarScale, IN.worldPos, o.Normal, _BumpMapTriplanarBlend));
				normal.z = normal.z / (_NormalAmount*2); 
				// Set Detail Normal
				o.Normal = lerp(normalize(normal),normalize(normal) + normalize(detNorm),_BothNormals);
				rim = 1.0 - saturate(dot (normalize(IN.viewDir), normalize(o.Normal)));


				GetEmission(IN,o);

				_SSRThickness=((1-thick + (curve * _SubSurfaceCurvatureAmount))/(1.01-(_SubSurfaceRange*0.9))) * o.Occlusion;
				if (_SubsurfaceRimType <0) {
					_SSRThickness = lerp (_SSRThickness,_SSRThickness*pow(1-rim,_SubSurfacePower+0.001),_SubsurfaceRimType * -1);
				}
				if (_SubsurfaceRimType > 0) {
					_SSRThickness = lerp (_SSRThickness,_SSRThickness*pow(rim,_SubSurfacePower+0.001),_SubsurfaceRimType);
				}
				GetEnvironmentalEffects (IN,o,fxAmount);
				GetSkyEffect (IN,o);
				GetCubeEffect (IN,o);
				GetIridescenceEffect(IN,o);

				o.Emission += (skyColor+cubeColor) * (1-  o.Metallic);
				o.Albedo += ((skyColor+cubeColor)) + detAlbedo;

				//Apply Ambient Color for lighting, Also force Material States for debugging
				_SSSAmbient=o.Albedo;
				o.Metallic = lerp(o.Metallic,1,_ForceMetallic);
				o.Smoothness = lerp(o.Smoothness,1,_ForceSmoothness);

				if (_DisplayMode == 1) _SSRThickness=-1;	
				HandleDisplayMode (IN,o,_DisplayMode,colored,oNormal,float3(0,0,0));
			
            }
            ENDCG
        }
        FallBack "Diffuse"
		CustomEditor "MaterialFX.MaterialFX_ShaderEditor"
    }