Shader "MaterialFX/MaterialFX_Glass"{
         Properties {
			[HideInInspector]
			_EditorTab("_EditorTab", INT) = 0
			[HideInInspector]
			_DisplayMode("Display Mode", INT) = 0
			[HideInInspector]
			_TextureWorkflow("Texture Workflow", INT) = 0

			_Opacity("_Opacity",Range(0,1))=1
            _MainTex ("Base (RGB)", 2D) = "white" {}
			_AdditiveMainTex("_AdditiveMainTex",FLOAT)=.25
			_AdditiveGrabTex("_AdditiveGrabTex",FLOAT)=1
			_ShadowAmount("_ShadowAmount",Range(0,1))=1
			[HDR]
			_SpecularColor("_SpecularColor",COLOR)=(1,1,1,1)		
			_SpecularAmount("_SpecularAmount",Range(4,2048))=40
			[Normal]
            _NormalMap ("Normalmap", 2D) = "bump" {}
			_NormalDisplacementAmount("_NormalDisplacementAmount",Range(0,8))=1
			_RimDisplacement("_RimDisplacement",FLOAT)=1
			_NormalAmount("_NormalAmount",FLOAT)=1
			_EmissionMap("_EmissionMap", 2D) = "black" {}
			[HDR]
			_EmissionColor("_EmissionColor",COLOR)=(1,1,1,1)
			_AdvancedPBRMap ("_AdvancedPBRMap", 2D) = "black" {}
			_ThicknessAmount("_ThicknessAmount",Range(0,4))=1
			_ColorTint("_ColorTint",COLOR)=(1,1,1,1)
			_RefractionAmount("_RefractionAmount",FLOAT)=1
			_RefractionRGBSplit("_RefractionRGBSplit",FLOAT)=0.01
			_NormalRGBSplit("_NormalRGBSplit",FLOAT)=1
			[HDR]
			_RimColor("_RimColor",COLOR)=(1,1,1,1)
			_RimPower("_RimPower",FLOAT)=1
			_RimDampenPower("_RimDampenPower",FLOAT)=1
			_RimAlphaPower("_RimAlphaPower",FLOAT)=1
			_RimAlphaAmount("_RimAlphaAmount",FLOAT)=1
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
		 
		
	
        // Grab the screen behind the object into _MyGrabTexture
        GrabPass { "_MyGrabTexture" }
		  Pass {
                 ColorMask 0
             }
	
        CGPROGRAM
        #pragma surface surf SimpleSpecular vertex:vert alpha
	    #pragma target 4.6
        #pragma debug
		sampler2D _AdvancedPBRMap,_DetailNormalMap;
        sampler2D _MainTex,_NormalMap;
        sampler2D _MyGrabTexture;
		float _RefractionAmount,_NormalAmount,_RimPower,_RimDampenPower,_AdditiveMainTex,_DetaiNormalMultiplier,_DetailNormalScale,_RefractionRGBSplit;
		float4 _RimColor,_ColorTint;
		float _ShadowAmount,_SpecularAmount,_NormalDisplacementAmount,_NormalRGBSplit,_RimAlphaPower,_RimAlphaAmount,_RimDisplacement;
		float4 _EmissionColor;
		sampler2D _EmissionMap;
		samplerCUBE _ReflectionProbe;
		float _ReflectionProbeAmount,_ReflectionProbeRim,_Opacity,_AdditiveGrabTex;
        struct Input {
			float2 uv_MainTex;
			float3 worldPos;
            float4 grabUV;		
			float4 grabUVo;	
			float3 viewDir;
			INTERNAL_DATA
			float3 worldRefl;
        };
		float4 _SpecularColor;
		half4 LightingSimpleSpecular (SurfaceOutput s, half3 lightDir, half3 viewDir, half atten) {
        half3 h = normalize (lightDir + viewDir);

        half diff = max (0, dot (s.Normal, lightDir));

        float nh = max (0, dot (s.Normal, h));
        float spec = pow (nh, _SpecularAmount);
		diff = lerp (1,diff,_ShadowAmount);
        half4 c;
        c.rgb = (s.Albedo * _LightColor0.rgb * diff + (_LightColor0.rgb*_SpecularColor) * spec ) * atten;
		
        c.a = s.Alpha;
        return c;
    }
		float _ThicknessAmount;
        void vert (inout appdata_full v, out Input o) {
			UNITY_INITIALIZE_OUTPUT(Input,o);
	
		    float4 thick =  (tex2Dlod(_AdvancedPBRMap,float4(v.texcoord.xy,0,0)).g-0.5) *_ThicknessAmount;
			 float3 normal = (tex2Dlod(_NormalMap,float4(v.texcoord.xy,0,0)));
			float3 viewDir = normalize(ObjSpaceViewDir(v.vertex));
			 float dotProduct = (dot(v.normal, viewDir)-0.5)*_RimDisplacement;

            float4 hpos = UnityObjectToClipPos (v.vertex);
            o.grabUV = ComputeGrabScreenPos(hpos);	
			  o.grabUVo =  o.grabUV;	
			float3 influence = float3(0,0,0);
			//influence += (((normalize(normal)),_NormalDisplacementAmount)) ;
			influence -= normalize(v.normal) * _NormalDisplacementAmount;
			influence += ((thick));
			influence *= dotProduct;
			o.grabUV.xyz -= float3(0.5,0.5,0.5);

			o.grabUV.xyz += (influence * _RefractionAmount);
			o.grabUV.xyz += float3(0.5,0.5,0.5);
		//	o.grabUV.xyz += ((thick)-0.5) * _RefractionAmount;
	
        }

 
        void surf (Input IN, inout SurfaceOutput o) {

				float camDist = clamp(distance(IN.worldPos, _WorldSpaceCameraPos)*0.1,0,1);
				fixed3 normal = UnpackNormal(tex2D(_NormalMap, IN.uv_MainTex)); 
				normal.z = normal.z / _NormalAmount; 

				fixed3 detNorm = UnpackNormal(tex2D(_DetailNormalMap, IN.uv_MainTex * _DetailNormalScale)) ; 
				detNorm.z = detNorm.z / (1+_DetaiNormalMultiplier); 
			IN.grabUV = lerp (IN.grabUVo,IN.grabUV,camDist);
			 float4 thick =  tex2D (_AdvancedPBRMap,IN.uv_MainTex).g *_ThicknessAmount;

			float4 pCoordR = UNITY_PROJ_COORD(IN.grabUV + float4(normal*_NormalRGBSplit*_RefractionRGBSplit* 0.01,thick.r*_RefractionRGBSplit * 0.01)  );
			float4 pCoordG = UNITY_PROJ_COORD(IN.grabUV- float4(normal*_NormalRGBSplit*_RefractionRGBSplit* 0.01,thick.r*_RefractionRGBSplit * 0.01));
			float4 pCoordB = UNITY_PROJ_COORD(IN.grabUV);

			float grabTexR= tex2Dproj( _MyGrabTexture, pCoordR).r;
			float grabTexG= tex2Dproj( _MyGrabTexture, pCoordG).g;
			float grabTexB= tex2Dproj( _MyGrabTexture, pCoordB).b;
			float3 grabTex = float3(grabTexR,grabTexG,grabTexB) * _AdditiveGrabTex;
			float3 mainTex = tex2D (_MainTex,IN.worldRefl).rgb;
			grabTex *= _ColorTint;


				o.Normal = normalize(normal + detNorm);


			half rim = 1.0 - saturate(dot (normalize(IN.viewDir), o.Normal));
			float rimLight = (pow (rim, _RimPower));
			rimLight *= pow(1-rim,_RimDampenPower);
			
			float3 rimCol = ((mainTex*_AdditiveMainTex)+grabTex)*_RimColor;
			o.Emission = tex2D(_EmissionMap,IN.uv_MainTex) * _EmissionColor ;
            o.Albedo = lerp((mainTex*_AdditiveMainTex)+grabTex,rimCol,rimLight) ;
			o.Alpha = clamp(1-(pow(rim,_RimAlphaPower)*_RimAlphaAmount),0,1);
			o.Albedo += texCUBE (_ReflectionProbe,IN.worldRefl) * _ReflectionProbeAmount * pow(rim,_ReflectionProbeRim) ;
			//o.Albedo=thick;
        }
        ENDCG
   
    }
	FallBack "Diffuse"
	CustomEditor "MaterialFX.MaterialFX_Glass_ShaderEditor"
}