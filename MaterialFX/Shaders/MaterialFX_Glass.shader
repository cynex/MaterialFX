 Shader "MaterialFX/MaterialFX_Glass" {
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

			_GrowthNoiseScale ("_GrowthNoiseScale",FLOAT)=4
			_FXDisplacementMulitplier ("_FXDisplacementMulitplier",FLOAT)=1
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

			_ReflectionAmount("_ReflectionAmount",FLOAT)=0
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



			/**********GLASS*************/

			_GlassShadowAmount("_GlassShadowAmount",Range(0,1))=1
			[HDR]
			_GlassSpecularColor("_GlassSpecularColor",COLOR)=(1,1,1,1)		
			_GlassSpecularAmount("_GlassSpecularAmount",Range(4,2048))=40
			_GlassNormalDisplacementAmount("_GlassNormalDisplacementAmount",Range(0,8))=1
			_GlassRimDisplacement("_GlassRimDisplacement",FLOAT)=1
			_GlassNormalAmount("_GlassNormalAmount",FLOAT)=1
			_GlassThicknessAmount("_GlassThicknessAmount",Range(0,4))=1
			_GlassAdditiveMainTex("_GlassAdditiveMainTex",FLOAT)=.25
			_GlassAdditiveGrabTex("_GlassAdditiveGrabTex",FLOAT)=1
			_GlassColorTintThin("_ColorTintThin",COLOR)=(1,1,1,1)
			_GlassColorTintThick("_ColorTintThick",COLOR)=(1,1,1,1)
			_GlassColorTintThicknessAmount("_ColorTintThicknessAmount",FLOAT)=1
			_GlassCurvatureAmount("_CurvatureAmount",float)=1			
			_GlassRefractionAmount("_RefractionAmount",FLOAT)=1
			_GlassRefractionRGBSplit("_RefractionRGBSplit",FLOAT)=0.01
			_GlassNormalRGBSplit("_NormalRGBSplit",FLOAT)=1

			[HDR]
			_GlassReflectionRimPower("_GlassReflectionRimPower",FLOAT)=1
			_GlassReflectionRimType("_GlassReflectionRimType",FLOAT)=0
			_GlassReflectionRimAmount("_GlassReflectionRimAmount",FLOAT)=0

			_GlassReflectionRimDampenPower("_GlassReflectionRimDampenPower",FLOAT)=1
			_GlassReflectionRimDampenType("_GlassReflectionRimDampenType",FLOAT)=0
			_GlassReflectionRimDampenAmount("_GlassReflectionRimDampenAmount",FLOAT)=0

			_GlassReflectionRimAlphaPower("_GlassReflectionRimAlphaPower",FLOAT)=1
			_GlassReflectionRimAlphaType("_GlassReflectionRimAlphaType",FLOAT)=0
			_GlassReflectionRimAlphaAmount("_GlassReflectionRimAlphaAmount",FLOAT)=0

			_GlassRimColor("_RimColor",COLOR)=(1,1,1,1)
			_GlassRimPower("_RimPower",FLOAT)=1
			_GlassRimDampenPower("_RimDampenPower",FLOAT)=1
			_GlassRimAlphaPower("_RimAlphaPower",FLOAT)=1
			_GlassRimAlphaAmount("_RimAlphaAmount",FLOAT)=1
			_Opacity("_Opacity",Range(0,1))=1



			_CheckerDensity("_CheckerDensity",FLOAT)=20
			_ForceMetallic("_ForceMetallic",RANGE(0,1))=0
			_ForceSmoothness("_ForceSmoothness",RANGE(0,1))=0
        }
	
        SubShader {
			Tags {"Queue"="Transparent" "RenderType"="Transparent+30" "IgnoreProjector" = "True" }
			LOD 300
			Cull Off

			  // Grab the screen behind the object into _GlassGrabTexture
			GrabPass { "_GrabTexture" }
			Pass {
					 ColorMask 0
				 }

            CGPROGRAM
			#pragma surface surf SimpleSpecular vertex:vert alpha
			#pragma target 4.6
			#pragma debug

			float _GlassReflectionRimPower,_GlassReflectionRimType,_GlassReflectionRimAmount;
			float _GlassReflectionRimDampenPower,_GlassReflectionRimDampenType,_GlassReflectionRimDampenAmount;
			float _GlassReflectionRimAlphaPower,_GlassReflectionRimAlphaType,_GlassReflectionRimAlphaAmount;
			/*struct Input {
                float2 uv_MainTex;
				float3 viewDir;
				float3 worldPos;				
				float3 localCoord;
				float3 worldRefl;
				float3 localRefl;  INTERNAL_DATA				 
				float3 worldNorm;
            };*/
			
        struct Input {
			float2 uv_MainTex;
			float3 worldPos;
            float4 grabUV;		
			float4 grabUVo;	
			float3 viewDir;
			INTERNAL_DATA
			float3 worldRefl;
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


			//---------------------------------------------------------
			float4 _GlassColorTintThin,_GlassColorTintThick;
			float _GlassColorTintThicknessAmount;
			float _GlassRefractionAmount,_GlassNormalAmount,_GlassRimPower,_GlassRimDampenPower,_GlassAdditiveMainTex,_GlassRefractionRGBSplit;
			float4 _GlassRimColor,_GlassSpecularColor;
			float _GlassCurvatureAmount,_GlassShadowAmount,_GlassSpecularAmount,_GlassNormalDisplacementAmount,_GlassNormalRGBSplit,_GlassRimAlphaPower,_GlassRimAlphaAmount,_GlassRimDisplacement;
			float _GlassThicknessAmount,_GlassAdditiveGrabTex;

			sampler2D _GrabTexture;
			float _Opacity;

			// Helper functions for multiple shaders
			#include "./MaterialFX_ShaderFunctions.cginc"


			void CopyOutputToMaterialFX (SurfaceOutput o) {
				mfxOut.Albedo = o.Albedo;		
				mfxOut.Normal = o.Normal;		
				mfxOut.Emission = o.Emission;
				mfxOut.Specular = o.Specular;  
				mfxOut.Gloss = o.Gloss;		
				mfxOut.Alpha = o.Alpha;	
			}

			void CopyMaterialFXToOutput (inout SurfaceOutput o) {
				o.Albedo=mfxOut.Albedo;		
				o.Normal=mfxOut.Normal;		
				o.Emission = mfxOut.Emission;
				o.Specular=mfxOut.Specular; 
				o.Gloss=mfxOut.Gloss;		
				o.Alpha=mfxOut.Alpha;		
			}

		
	
			half4 LightingSimpleSpecular (SurfaceOutput s, half3 lightDir, half3 viewDir, half atten) {
				half3 h = normalize (lightDir + viewDir);

				half diff = max (0, dot (s.Normal, lightDir));

				float nh = max (0, dot (s.Normal, h));
				float spec = pow (nh, _GlassSpecularAmount*16);
				diff = lerp (1,diff,_GlassShadowAmount);
				half4 c;
				c.rgb = (s.Albedo * _LightColor0.rgb * diff + (_LightColor0.rgb*_GlassSpecularColor) * spec ) * atten;
		
				c.a = s.Alpha;

				fixed4 pbr = c;
				if (_SSRThickness >= 0) {	//if -1 ignore (passed)
					// SSS Calculations
					float3 light = lightDir;
					float3 viewDirection = viewDir;
					float3 normal = s.Normal;
					float3 H = normalize(light + normal * _SSSDistortion);
					float VdotH = saturate(pow(dot(viewDirection, -H), _SSSPower)) * _SSSScale;
					float3 res =saturate(pow(dot(viewDirection, -H),1));
					float3 I = (res + _SSSAmbient) * _SSRThickness * _SubSurfaceColor * (_SubSurfaceAmount*0.02);											
					pbr.rgb = pbr.rgb + _GlassSpecularColor * atten * I;
				}
				
				return pbr;

			}

		
			void vert (inout appdata_full v, out Input o) {
				UNITY_INITIALIZE_OUTPUT(Input,o);
	
				float4 thick =  (tex2Dlod(_AdvancedPBRMap,float4(v.texcoord.xy,0,0)).g-0.5) *_GlassThicknessAmount;
				float3 normal = (tex2Dlod(_BumpMap,float4(v.texcoord.xy,0,0)));
				float3 viewDir = normalize(ObjSpaceViewDir(v.vertex));
				float dotProduct = (dot(v.normal, viewDir)-0.5)*_GlassRimDisplacement;

				float4 hpos = UnityObjectToClipPos (v.vertex);
				o.grabUV = ComputeGrabScreenPos(hpos);	
				o.grabUVo =  o.grabUV;	
				float3 influence = float3(0,0,0);
				influence -= normalize(v.normal) * _GlassNormalDisplacementAmount;
				influence += ((thick));
				influence *= dotProduct;
				o.grabUV.xyz -= float3(0.5,0.5,0.5);

				o.grabUV.xyz += (influence * _GlassRefractionAmount);
				o.grabUV.xyz += float3(0.5,0.5,0.5);
			}


            void surf (Input IN, inout SurfaceOutput o) {

				
				SetupMaterialFX (IN,o.Normal);
				
				CopyOutputToMaterialFX (o);
					
				float4 mainTexColor =  getUVModeTexture  (_MainTex, _MainTexUVMode, IN.uv_MainTex + parallaxOffset, _MainTexTriplanarScale, IN.worldPos, mfxOut.Normal, _MainTexTriplanarBlend);
				
                half4 colored = lerp(_Color,mainTexColor*_Color,_Colored);
                mfxOut.Albedo = colored.rgb;				

				float4 pbrMap = getUVModeTexture  (_AdvancedPBRMap, _AdvancedPBRMapUVMode, IN.uv_MainTex + parallaxOffset, _AdvancedPBRMapTriplanarScale, IN.worldPos, mfxOut.Normal, _AdvancedPBRMapTriplanarBlend);
                mfxOut.Metallic = pbrMap.r * _Metallic;			
				mfxOut.Smoothness = pbrMap.a * _Smoothness;
				// If substance, use roughness map
				if (_TextureWorkflow == 2) mfxOut.Smoothness = ((1- tex2D(_RoughnessMap,IN.uv_MainTex)) * (1-_Smoothness));

				thick = pbrMap.g * lerp(0,pbrMap.g,_Thickness);
				curve = pbrMap.b * lerp(0,pbrMap.b,_Curvature);
				mfxOut.Occlusion =  lerp(float3(1,1,1),pow(tex2D (_AOMap, IN.uv_MainTex),_AOMutliply+1)-((1-curve) * _AOCurvature) ,_AOAmount);

				// Get Detail Normal / Albedo
				detailAlbedo = tex2D(_DetailAlbedoMap, IN.uv_MainTex *_DetailAlbedoScale)  * _DetailAlbedoMultiplier;  
				detailNormal = UnpackNormal(tex2D(_DetailNormalMap, IN.uv_MainTex *_DetailNormalScale)); 
				detailNormal.z= detailNormal.z / clamp(_DetailNormalMultiplier,0.01,32); 	

				normal = UnpackNormal(getUVModeTexture  (_BumpMap, _BumpMapUVMode, IN.uv_MainTex+parallaxOffset, _BumpMapTriplanarScale, IN.worldPos,mfxOut.Normal, _BumpMapTriplanarBlend));
				normal.z = normal.z / (_NormalAmount*2); 
				// Set Detail Normal
				mfxOut.Normal = lerp(normalize(normal),normalize(normal) + normalize(detailNormal),_BothNormals);

				rim = 1.0 - saturate(dot (normalize(viewDirection), normalize(mfxOut.Normal)));		
				_SSRThickness=((1-thick + (curve * _SubSurfaceCurvatureAmount))/(1.01-(_SubSurfaceRange*0.9))) * mfxOut.Occlusion;
				if (_SubsurfaceRimType <0) {
					_SSRThickness = lerp (_SSRThickness,_SSRThickness*pow(1-rim,_SubSurfacePower+0.001),_SubsurfaceRimType * -1);
				}
				if (_SubsurfaceRimType > 0) {
					_SSRThickness = lerp (_SSRThickness,_SSRThickness*pow(rim,_SubSurfacePower+0.001),_SubsurfaceRimType);
				}

			
				//------------------------------GLASS
				float camDist = clamp(distance(IN.worldPos, _WorldSpaceCameraPos)*0.1,0,1);
				fixed3 gnormal = normal;
				gnormal.z = gnormal.z / _GlassNormalAmount; 


				IN.grabUV = lerp (IN.grabUVo,IN.grabUV,camDist);
				float thick =  tex2D (_AdvancedPBRMap,IN.uv_MainTex).g *_GlassThicknessAmount;
				float curve =  tex2D (_AdvancedPBRMap,IN.uv_MainTex).b *_GlassCurvatureAmount;
				float4 pCoordR = UNITY_PROJ_COORD(IN.grabUV + float4(gnormal*_GlassNormalRGBSplit*_GlassRefractionRGBSplit* 0.01,thick*(curve)*_GlassRefractionRGBSplit * 0.01)  );
				float4 pCoordG = UNITY_PROJ_COORD(IN.grabUV- float4(gnormal*_GlassNormalRGBSplit*_GlassRefractionRGBSplit* 0.01,thick*(curve)*_GlassRefractionRGBSplit * 0.01));
				float4 pCoordB = UNITY_PROJ_COORD(IN.grabUV);

				float grabTexR= tex2Dproj( _GrabTexture, pCoordR).r;
				float grabTexG= tex2Dproj( _GrabTexture, pCoordG).g;
				float grabTexB= tex2Dproj( _GrabTexture, pCoordB).b;
				float3 grabTex = float3(grabTexR,grabTexG,grabTexB) * _GlassAdditiveGrabTex;
				float3 mainTex = tex2D (_MainTex,IN.worldRefl).rgb;
				grabTex *= lerp(_GlassColorTintThin,_GlassColorTintThick,_GlassColorTintThicknessAmount * thick * curve);


				/*half glass_rim = 1.0 - saturate(dot (normalize(IN.viewDir), o.Normal));
				float glass_rimLight = (pow (rim, _GlassRimPower));
				glass_rimLight *= pow(1-glass_rim,_GlassRimDampenPower);
			
				float3 rimCol = ((mainTexColor*_GlassAdditiveMainTex)+grabTex)*_GlassRimColor;

				mfxOut.Albedo = lerp((mainTexColor*_GlassAdditiveMainTex)+grabTex,rimCol,glass_rimLight);*/
				/*float _GlassReflectionRimPower,_GlassReflectionRimType,_GlassReflectionRimAmount;
				float _GlassReflectionRimDampenPower,_GlassReflectionRimDampenType,_GlassReflectionRimDampenAmount;
				float _GlassReflectionRimAlphaPower,_GlassReflectionRimAlphaType,_GlassReflectionRimAlphaAmount;*/

				fixed4 rimCol = float4(grabTex,1)*_GlassRimColor; 
				if (_GlassReflectionRimType <0) {
					rimCol = lerp (rimCol,_GlassRimColor*pow(1-rim,_GlassReflectionRimPower+0.001),_GlassReflectionRimType * -1);
				}
				if (_GlassReflectionRimType > 0) {
					rimCol = lerp (rimCol,_GlassRimColor*pow(rim,_GlassReflectionRimPower+0.001),_GlassReflectionRimType);
				}
				rimCol *=_GlassReflectionRimAmount;

				fixed4 dampener = fixed4(1,1,1,1); 
				if (_GlassReflectionRimDampenType <0) {
					dampener = lerp (dampener,fixed4(1,1,1,1)*pow(1-rim,_GlassReflectionRimDampenPower+0.001),_GlassReflectionRimDampenType * -1);
				}
				if (_EmissionDampenRimType > 0) {
					dampener = lerp (dampener,fixed4(1,1,1,1)*pow(rim,_GlassReflectionRimDampenPower+0.001),_GlassReflectionRimDampenType);
				}
				rimCol = clamp(rimCol * 1-(dampener * (_GlassReflectionRimDampenAmount)),0,1);		

				mfxOut.Alpha=mainTexColor.a*_Opacity;
				fixed4 dampAlpha = mfxOut.Alpha; 
				if (_GlassReflectionRimAlphaType <0) {
					dampAlpha = lerp (_Opacity,mfxOut.Alpha*pow(1-rim,_GlassReflectionRimAlphaPower+0.001),_GlassReflectionRimAlphaType * -1);
				}
				if (_GlassReflectionRimAlphaType > 0) {
					dampAlpha = lerp (_Opacity,mfxOut.Alpha*pow(rim,_GlassReflectionRimAlphaPower+0.001),_GlassReflectionRimAlphaType);
				}
				mfxOut.Alpha = clamp(mfxOut.Alpha * 1-(dampAlpha * (_GlassReflectionRimAlphaAmount)),0,1);	

				mfxOut.Albedo = (mainTexColor*_GlassAdditiveMainTex)+grabTex + rimCol;
				GetEmission(IN);
				//Aquire Effects
			
				if (_DisplayMode != 1) {	
				GetEnvironmentalEffects (IN,fxAmount);
				GetSkyEffect (IN);
				GetCubeEffect (IN);
				GetIridescenceEffect(IN);											
				}
			
				mfxOut.Alpha = lerp (0,mfxOut.Alpha,_Opacity);
				MaterialFXFinalPass ();
				HandleDisplayMode (IN,_DisplayMode,colored,oNormal,grabTex);
				CopyMaterialFXToOutput (o);
            }
            ENDCG
        }
        FallBack "Diffuse"
		CustomEditor "MaterialFX.MaterialFX_Glass_ShaderEditor"
    }