Shader "MaterialFX/MaterialFX_Glass_old"{
         Properties {
			[HideInInspector]
			_EditorTab("_EditorTab", INT) = 0
			[HideInInspector]
			_DisplayMode("Display Mode", INT) = 0
			[HideInInspector]
			_TextureWorkflow("Texture Workflow", INT) = 0

			_Opacity("_Opacity",Range(0,1))=1
            _MainTex ("Base (RGB)", 2D) = "white" {}

			_GlassShadowAmount("_GlassShadowAmount",Range(0,1))=1
			[HDR]
			_GlassSpecularColor("_GlassSpecularColor",COLOR)=(1,1,1,1)		
			_GlassSpecularAmount("_GlassSpecularAmount",Range(4,2048))=40
			[Normal]
            _NormalMap ("Normalmap", 2D) = "bump" {}
			_GlassNormalDisplacementAmount("_GlassNormalDisplacementAmount",Range(0,8))=1
			_GlassRimDisplacement("_GlassRimDisplacement",FLOAT)=1
			_GlassNormalAmount("_GlassNormalAmount",FLOAT)=1
			_EmissionMap("_EmissionMap", 2D) = "black" {}
			[HDR]
			_EmissionColor("_EmissionColor",COLOR)=(1,1,1,1)
			_AdvancedPBRMap ("_AdvancedPBRMap", 2D) = "black" {}

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
			_GlassRimColor("_RimColor",COLOR)=(1,1,1,1)
			_GlassRimPower("_RimPower",FLOAT)=1
			_GlassRimDampenPower("_RimDampenPower",FLOAT)=1
			_GlassRimAlphaPower("_RimAlphaPower",FLOAT)=1
			_GlassRimAlphaAmount("_RimAlphaAmount",FLOAT)=1
			_DetailNormalMap("Detail Normal Map", 2D) = "bump" {}
            _DetaiNormalMultiplier("Detail Normal Multiplier",FLOAT) = 0.2          
			_DetailNormalScale("Detail Normal Scale",Range(0.1,32.0)) = 4  
			_ReflectionProbe("_ReflectionProbe",CUBE) = "black" {}
			_ReflectionProbeAmount("_ReflectionProbeAmount",FLOAT)=0
			_ReflectionProbeRim("_ReflectionProbeRim",FLOAT)=0
        }

    SubShader {
        // Draw ourselves after all opaque geometry
          Tags {"Queue"="Transparent" "RenderType"="Transparent+30" "IgnoreProjector" = "True" }
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

		sampler2D _AdvancedPBRMap,_DetailNormalMap;
        sampler2D _MainTex,_NormalMap;

        sampler2D _GrabTexture;

		float4 _GlassColorTintThin,_GlassColorTintThick;
		float _GlassColorTintThicknessAmount;
		float _GlassRefractionAmount,_GlassNormalAmount,_GlassRimPower,_GlassRimDampenPower,_GlassAdditiveMainTex,_GlassRefractionRGBSplit;
		float4 _GlassRimColor,_GlassSpecularColor;
		float _GlassCurvatureAmount,_GlassShadowAmount,_GlassSpecularAmount,_GlassNormalDisplacementAmount,_GlassNormalRGBSplit,_GlassRimAlphaPower,_GlassRimAlphaAmount,_GlassRimDisplacement;
		
		
		float _DetaiNormalMultiplier,_DetailNormalScale;
		float4 _EmissionColor;
		sampler2D _EmissionMap;
		samplerCUBE _ReflectionProbe;

		float _ReflectionProbeAmount,_ReflectionProbeRim,_Opacity,_GlassAdditiveGrabTex;
	

        struct Input {
			float2 uv_MainTex;
			float3 worldPos;
            float4 grabUV;		
			float4 grabUVo;	
			float3 viewDir;
			INTERNAL_DATA
			float3 worldRefl;
        };
		
		half4 LightingSimpleSpecular (SurfaceOutput s, half3 lightDir, half3 viewDir, half atten) {
        half3 h = normalize (lightDir + viewDir);

        half diff = max (0, dot (s.Normal, lightDir));

        float nh = max (0, dot (s.Normal, h));
        float spec = pow (nh, _GlassSpecularAmount);
		diff = lerp (1,diff,_GlassShadowAmount);
        half4 c;
        c.rgb = (s.Albedo * _LightColor0.rgb * diff + (_LightColor0.rgb*_GlassSpecularColor) * spec ) * atten;
		
        c.a = s.Alpha;
        return c;
    }
		float _GlassThicknessAmount;
        void vert (inout appdata_full v, out Input o) {
			UNITY_INITIALIZE_OUTPUT(Input,o);
	
		    float4 thick =  (tex2Dlod(_AdvancedPBRMap,float4(v.texcoord.xy,0,0)).g-0.5) *_GlassThicknessAmount;
			float3 normal = (tex2Dlod(_NormalMap,float4(v.texcoord.xy,0,0)));
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

			float camDist = clamp(distance(IN.worldPos, _WorldSpaceCameraPos)*0.1,0,1);
			fixed3 normal = UnpackNormal(tex2D(_NormalMap, IN.uv_MainTex)); 
			normal.z = normal.z / _GlassNormalAmount; 

			fixed3 detNorm = UnpackNormal(tex2D(_DetailNormalMap, IN.uv_MainTex * _DetailNormalScale)) ; 
			detNorm.z = detNorm.z / (1+_DetaiNormalMultiplier); 
			IN.grabUV = lerp (IN.grabUVo,IN.grabUV,camDist);
			float4 thick =  tex2D (_AdvancedPBRMap,IN.uv_MainTex).g *_GlassThicknessAmount;
			float4 curve =  tex2D (_AdvancedPBRMap,IN.uv_MainTex).b *_GlassCurvatureAmount;
			float4 pCoordR = UNITY_PROJ_COORD(IN.grabUV + float4(normal*_GlassNormalRGBSplit*_GlassRefractionRGBSplit* 0.01,thick.r*_GlassRefractionRGBSplit * 0.01)  );
			float4 pCoordG = UNITY_PROJ_COORD(IN.grabUV- float4(normal*_GlassNormalRGBSplit*_GlassRefractionRGBSplit* 0.01,thick.r*_GlassRefractionRGBSplit * 0.01));
			float4 pCoordB = UNITY_PROJ_COORD(IN.grabUV);

			float grabTexR= tex2Dproj( _GrabTexture, pCoordR).r;
			float grabTexG= tex2Dproj( _GrabTexture, pCoordG).g;
			float grabTexB= tex2Dproj( _GrabTexture, pCoordB).b;
			float3 grabTex = float3(grabTexR,grabTexG,grabTexB) * _GlassAdditiveGrabTex;
			float3 mainTex = tex2D (_MainTex,IN.worldRefl).rgb;
			grabTex *= lerp(_GlassColorTintThin,_GlassColorTintThick,_GlassColorTintThicknessAmount * thick * curve);


			o.Normal = normalize(normal + detNorm);

			half rim = 1.0 - saturate(dot (normalize(IN.viewDir), o.Normal));
			float rimLight = (pow (rim, _GlassRimPower));
			rimLight *= pow(1-rim,_GlassRimDampenPower);
			
			float3 rimCol = ((mainTex*_GlassAdditiveMainTex)+grabTex)*_GlassRimColor;
			o.Emission = tex2D(_EmissionMap,IN.uv_MainTex) * _EmissionColor ;
            o.Albedo = lerp((mainTex*_GlassAdditiveMainTex)+grabTex,rimCol,rimLight);
			o.Alpha = clamp(1-(pow(rim,_GlassRimAlphaPower)*_GlassRimAlphaAmount),0,1);
			o.Albedo += texCUBE (_ReflectionProbe,IN.worldRefl) * _ReflectionProbeAmount * pow(rim,_ReflectionProbeRim) ;

			o.Alpha = lerp (0,o.Alpha,_Opacity);
			//o.Albedo=thick;
        }
        ENDCG
   
    }
	FallBack "Diffuse"

}