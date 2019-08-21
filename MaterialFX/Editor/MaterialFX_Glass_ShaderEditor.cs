using UnityEngine;
using UnityEditor;
using System.Collections.Generic;
using System.IO;
namespace MaterialFX
{

    public class MaterialFX_Glass_ShaderEditor : ShaderGUI
    {

        EditorHelper.RenderDisplayModes displayMode;
        EditorHelper.TextureWorkflow textureWorkflow;

        int editorTab = 0;
        MaterialEditor editor;
        MaterialProperty[] properties;
        Material targetMat;
        TextureProperties tempProp;

        public override void OnGUI(MaterialEditor editor, MaterialProperty[] properties)
        {
            if (EditorHelper.isInitialized == false) EditorHelper.Init();

            targetMat = editor.target as Material;
            //editorTab = targetMat.GetInt("_EditorTab");
            displayMode = EditorHelper.GetRenderDisplayMode(targetMat, displayMode);

            //editorTab = GUILayout.Toolbar(editorTab, new string[] { "Surface", "Detail", "Lighting", "Environment", "About" }, GUILayout.Width(EditorGUIUtility.currentViewWidth - 45));
            GUILayout.Space(10);
            GUILayout.Label("Not yet completed. showing std unity inpector");
            base.OnGUI(editor, properties);
            /*if (editorTab == 0) ShowTextureArea();
            if (editorTab == 1) ShowDetailArea();
            if (editorTab == 2) ShowLightingArea();
            if (editorTab == 3) ShowEnvironmentalArea();
            if (editorTab == 4)
            {
                EditorHelper.About();
            }*/
            targetMat.SetInt("_EditorTab", editorTab);            
        }

        void ShowLightingArea()
        {
/*
            tempProp = new TextureProperties();
            tempProp.unifromName = "";
            tempProp.hasTexture = false;
            tempProp.displayName = "Sub Surface Scattering";
            tempProp.uniformProperties.Add(new UniformProperty("_SubSurfaceAmount", "Subsurface Amount", UniformType.RANGE1));
            tempProp.uniformProperties.Add(new UniformProperty("_SubSurfaceColor", "Subsurface Color", UniformType.HDRCOLOR));
            tempProp.uniformProperties.Add(new UniformProperty("_SubSurfaceCurvatureAmount", "Curvature Amount", UniformType.RANGE1));
            tempProp.uniformProperties.Add(new UniformProperty("_SubSurfaceRange", "Subsurface Range", UniformType.RANGE1));
            tempProp.uniformProperties.Add(new UniformProperty("_SubsurfaceRimType", "Subsurface Rim Type", UniformType.RIMSETTING));
            tempProp.uniformProperties.Add(new UniformProperty("_SubSurfacePower", "Subsurface Rim Power", UniformType.RANGE32));
            EditorHelper.ShowTextureUniforms(targetMat,tempProp);

            tempProp = new TextureProperties();
            tempProp.unifromName = "_EmissionMap";
            tempProp.displayName = "Emission Map";
            tempProp.uniformProperties.Add(new UniformProperty("_EmissionAmount", "Emission Amount", UniformType.RANGE1));
            tempProp.uniformProperties.Add(new UniformProperty("_EmissionColor", "Color (Tint)", UniformType.HDRCOLOR));
            tempProp.uniformProperties.Add(new UniformProperty("_EmissionBoostColor", "Boost Color", UniformType.HDRCOLOR));
            tempProp.uniformProperties.Add(new UniformProperty("_EmissionBoostRimType", "Boost Rim Type", UniformType.RIMSETTING));
            tempProp.uniformProperties.Add(new UniformProperty("_EmissionBoostRimPower", "Boost Rim Power", UniformType.RANGE32));
            tempProp.uniformProperties.Add(new UniformProperty("_EmissionDampenRimAmount", "Dampen Rim Amount", UniformType.RANGE1));
            tempProp.uniformProperties.Add(new UniformProperty("_EmissionDampenRimType", "Dampen Rim Type", UniformType.RIMSETTING));
            tempProp.uniformProperties.Add(new UniformProperty("_EmissionDampenRimPower", "Dampen Rim Power", UniformType.RANGE32));
            EditorHelper.ShowTextureUniforms(targetMat, tempProp);


            tempProp = new TextureProperties();
            tempProp.unifromName = "";
            tempProp.displayName = "Iridescence";
            tempProp.hasTexture = false;
            tempProp.uniformProperties.Add(new UniformProperty("_IridescenceRimAmount", "Iridescence Amount", UniformType.RANGE1));
            tempProp.uniformProperties.Add(new UniformProperty("_IridescenceScale", "Iridescence Scale", UniformType.RANGE4));
            tempProp.uniformProperties.Add(new UniformProperty("_IridescenceSpeed", "Iridescence Speed", UniformType.RANGE4));
            tempProp.uniformProperties.Add(new UniformProperty("_IridescenceCurvature", "Curvature Amount", UniformType.RANGE1));
            tempProp.uniformProperties.Add(new UniformProperty("_IridescenceTint", "Color (Tint)", UniformType.HDRCOLOR));
            tempProp.uniformProperties.Add(new UniformProperty("_IridescenceRimType", "Rim Type", UniformType.RIMSETTING));
            tempProp.uniformProperties.Add(new UniformProperty("_IridescenceRimPower", "Rim Power", UniformType.RANGE32));
            EditorHelper.ShowTextureUniforms(targetMat, tempProp);

            tempProp = new TextureProperties();
            tempProp.unifromName = "";
            tempProp.displayName = "Reflection Probe Boost";
            tempProp.hasTexture = false;
            tempProp.uniformProperties.Add(new UniformProperty("_ReflectionAmount", "Boost Amount", UniformType.RANGE8));
            tempProp.uniformProperties.Add(new UniformProperty("_ReflectionTint", "Reflection Tint", UniformType.HDRCOLOR));
            tempProp.uniformProperties.Add(new UniformProperty("_ReflectionRimType", "Reflection Rim Type", UniformType.RIMSETTING));
            tempProp.uniformProperties.Add(new UniformProperty("_ReflectionPower", "Reflection Power", UniformType.RANGE32));

            tempProp.uniformProperties.Add(new UniformProperty("_ReflectionDampenRimAmount", "Dampen Rim Amount", UniformType.RANGE1));
            tempProp.uniformProperties.Add(new UniformProperty("_ReflectionDampenRimType", "Dampen Rim Type", UniformType.RIMSETTING));
            tempProp.uniformProperties.Add(new UniformProperty("_ReflectionDampenRimPower", "Dampen Rim Power", UniformType.RANGE32));
            EditorHelper.ShowTextureUniforms(targetMat, tempProp);

            tempProp = new TextureProperties();
            tempProp.unifromName = "_ReflectionCube";
            tempProp.displayName = "Additional Relfection Cubemap";
            tempProp.uniformProperties.Add(new UniformProperty("_ReflectionCubeAmount", "Emission Amount", UniformType.RANGE8));
            tempProp.uniformProperties.Add(new UniformProperty("_ReflectionCubeTint", "Reflection Tint", UniformType.HDRCOLOR));
            tempProp.uniformProperties.Add(new UniformProperty("_ReflectionCubePower", "Reflection Power", UniformType.RANGE32));
            tempProp.uniformProperties.Add(new UniformProperty("_ReflectionCubeNormalAmount", "Normal Amount", UniformType.RANGE1));
            EditorHelper.ShowTextureUniforms(targetMat, tempProp);*/
        }

        void ShowDetailArea()
        {
            /*
            tempProp = new TextureProperties();
            tempProp.unifromName = "";
            tempProp.displayName = "Tessellation";
            tempProp.hasTexture = false;
            tempProp.uniformProperties.Add(new UniformProperty("_Tess", "Tessellation Amount", UniformType.TESSRANGE));
            tempProp.uniformProperties.Add(new UniformProperty("_TessDistMin", "Tess Distance Min", UniformType.RANGE256));
            tempProp.uniformProperties.Add(new UniformProperty("_TessDistMax", "Tess Distance Max", UniformType.RANGE256));
            tempProp.uniformProperties.Add(new UniformProperty("_Phong", "Phong Amount", UniformType.RANGE8));
            EditorHelper.ShowTextureUniforms(targetMat, tempProp);

            tempProp = new TextureProperties();
            tempProp.unifromName = "_HeightMap";
            tempProp.displayName = "Height Map";
            tempProp.uniformProperties.Add(new UniformProperty("_Parallax", "Height (Parallax)", UniformType.RANGE1));
            EditorHelper.ShowTextureUniforms(targetMat, tempProp);


            tempProp = new TextureProperties();
            tempProp.unifromName = "_DispTex";
            tempProp.displayName = "Displacement Map";
            tempProp.uniformProperties.Add(new UniformProperty("_Displacement", "Displacement Amount", UniformType.DISPLACEAMOUNT));
            tempProp.uniformProperties.Add(new UniformProperty("_DispScale", "Displacement Scale", UniformType.RANGE32));
            EditorHelper.ShowTextureUniforms(targetMat, tempProp);

            tempProp = new TextureProperties();
            tempProp.unifromName = "_DetailAlbedoMap";
            tempProp.displayName = "Detail Albedo";
            tempProp.uniformProperties.Add(new UniformProperty("_DetailAlbedoMultiplier", "Detail Albedo Amount", UniformType.RANGE1));
            tempProp.uniformProperties.Add(new UniformProperty("_DetailAlbedoScale", "Detail Albedo Scale", UniformType.RANGE256));
            //tempProp.uniformProperties.Add(new UniformProperty("_Displacement", "Displacement Amount", UniformType.DISPLACEAMOUNT));
            EditorHelper.ShowTextureUniforms(targetMat, tempProp);

            tempProp = new TextureProperties();
            tempProp.unifromName = "_DetailNormalMap";
            tempProp.displayName = "Detail Normal";
            tempProp.uniformProperties.Add(new UniformProperty("_DetailNormalMultiplier", "Detail Normal Amount", UniformType.RANGE16));
            tempProp.uniformProperties.Add(new UniformProperty("_DetailNormalScale", "Detail Normal Scale", UniformType.RANGE64));
            tempProp.uniformProperties.Add(new UniformProperty("_BothNormals", "Normal Blend", UniformType.RANGE1));
            EditorHelper.ShowTextureUniforms(targetMat, tempProp);

    */
        }

        void ShowEnvironmentalArea()
        {
          /*  tempProp = new TextureProperties();
            tempProp.unifromName = "_FXTex";
            tempProp.displayName = "Environemnt FX Map";
            tempProp.uniformProperties.Add(new UniformProperty("_AllEffects", "All Effect Blend", UniformType.RANGE1));
            tempProp.uniformProperties.Add(new UniformProperty("_DisplacementLimiter", "Displacement Limiter", UniformType.RANGE64));
            tempProp.uniformProperties.Add(new UniformProperty("_Snow", "Snow Amount", UniformType.RANGE1));
            tempProp.uniformProperties.Add(new UniformProperty("_SnowDisplacement", "Snow Displacement", UniformType.RANGE1));
            tempProp.uniformProperties.Add(new UniformProperty("_SnowNoiseAmount", "Snow Noise Amount", UniformType.RANGE1));
            tempProp.uniformProperties.Add(new UniformProperty("_SnowNoiseScale", "Snow Noise Scale", UniformType.RANGE8));

            tempProp.uniformProperties.Add(new UniformProperty("_SnowAddParalax", "Snow Add Height", UniformType.RANGE1));
            tempProp.uniformProperties.Add(new UniformProperty("_SnowTint", "Snow Color (Tint)", UniformType.HDRCOLOR));

            tempProp.uniformProperties.Add(new UniformProperty("_Growth", "Growth Amount", UniformType.RANGE1));
            tempProp.uniformProperties.Add(new UniformProperty("_GrowthDisplacement", "Growth Displacement", UniformType.RANGE1));
            tempProp.uniformProperties.Add(new UniformProperty("_GrowthNoise", "Growth Noise", UniformType.RANGE1));
            tempProp.uniformProperties.Add(new UniformProperty("_GrowthNoiseSpeed", "Growth Noise Speed", UniformType.RANGE4));

            tempProp.uniformProperties.Add(new UniformProperty("_GrowthTint", "Growth Color Low (Tint)", UniformType.HDRCOLOR));
            tempProp.uniformProperties.Add(new UniformProperty("_GrowthTint2", "Growth Color High (Tint)", UniformType.HDRCOLOR));

            tempProp.uniformProperties.Add(new UniformProperty("_Wetness", "Wetness Amount", UniformType.RANGE1));

            tempProp.uniformProperties.Add(new UniformProperty("_WetNormalTex", "Wetness Normal Map", UniformType.TEXTURE));
            tempProp.uniformProperties.Add(new UniformProperty("_WetTextureScale", "Wetness Scale", UniformType.RANGE32));
            tempProp.uniformProperties.Add(new UniformProperty("_WetTint", "Wetness Color (Tint)", UniformType.HDRCOLOR));
            tempProp.uniformProperties.Add(new UniformProperty("_WetSpeedY", "Wetness Gravity", UniformType.RANGE1));
            tempProp.uniformProperties.Add(new UniformProperty("_FXMap", "Generate FX Map", UniformType.FXMAP));
            EditorHelper.ShowTextureUniforms(targetMat, tempProp);
            */

        }

        void ShowTextureArea()
        {
            /*GUILayout.BeginHorizontal();
            int workflow = EditorHelper.GUIDropDown((int)textureWorkflow, "Texture Workflow", 120, EditorHelper.textureModeStrings, true);
            if (workflow >= 0)
            {
                textureWorkflow = (EditorHelper.TextureWorkflow)workflow;
                targetMat.SetInt("_TextureWorkflow", workflow);
            }
            EditorHelper.HelpButton("workflow");
            GUILayout.EndHorizontal();
            EditorHelper.HelpItem("workflow", "<b>Texture Workflow</b>\n\n<b>Material FX</b> (Preferred)\n<color=silver>Adds new effects to your material, but has a rquired PBR map to use, which we are calling the advancedPBR Map here, however, it's essenailly a Metallic(r) Smoothnes(a) teture, with the green channel being used to inclue thickness, and blue for curvature.  The benefit here is this texture can work with Unity\ndefault shader so you can mix and match shaders as needed, and can even extend your ability to make your own custom effects / surface shaders.\n\n</color><b>Unity Standard</b>\n<color=silver>Uses Unity native Metallic Smoothnes Map. Primarily used for A-B Comparisn.\n\n</color><b>Substance Texture Maps</b><color=silver>\nAdds a roughness channel.\n\n<i>In Developemnt : A way to repack the AdvancedPBR map texture using an inline image conversion / channel repack.</i></color>");
            GUILayout.Space(10);

            string albedoTitle = "Albedo";
            if (textureWorkflow == EditorHelper.TextureWorkflow.Substance_Texture_Maps) { albedoTitle = "Base Color"; }

            tempProp = new TextureProperties();
            tempProp.unifromName = "_MainTex";
            tempProp.displayName = albedoTitle;
            tempProp.uniformProperties.Add(new UniformProperty("_Color", "Color (Tint)", UniformType.COLOR));
            tempProp.uniformProperties.Add(new UniformProperty("_Colored", albedoTitle + " Amount", UniformType.RANGE1));
            tempProp.uniformProperties.Add(new UniformProperty("_MainTex", "Texturing Mode", UniformType.UVMODE));
            EditorHelper.ShowTextureUniforms(targetMat, tempProp);

            if (textureWorkflow == EditorHelper.TextureWorkflow.Material_FX || textureWorkflow == EditorHelper.TextureWorkflow.Unity_Standard)
            {
                tempProp = new TextureProperties();
                tempProp.unifromName = "_AdvancedPBRMap";
                tempProp.displayName = "Metallic Smoothness";
                tempProp.uniformProperties.Add(new UniformProperty("_Metallic", "Metailic", UniformType.RANGE1));
                tempProp.uniformProperties.Add(new UniformProperty("_Smoothness", "Smoothness", UniformType.RANGE1));
                if (textureWorkflow == EditorHelper.TextureWorkflow.Material_FX)
                {
                    tempProp.displayName = "MaterialFX PBR Map";
                    tempProp.uniformProperties.Add(new UniformProperty("_Thickness", "Thickness", UniformType.RANGE1));
                    tempProp.uniformProperties.Add(new UniformProperty("_Curvature", "Curvature", UniformType.RANGE1));
                }
                tempProp.uniformProperties.Add(new UniformProperty("_AdvancedPBRMap", "Generate PBR Map", UniformType.PBRMAP));
                EditorHelper.ShowTextureUniforms(targetMat, tempProp);
            }

            if (textureWorkflow == EditorHelper.TextureWorkflow.Substance_Texture_Maps)
            {
                tempProp = new TextureProperties();
                tempProp.unifromName = "_AdvancedPBRMap";
                tempProp.displayName = "Metallic";
                tempProp.uniformProperties.Add(new UniformProperty("_Metallic", "Metailic", UniformType.RANGE1));
                EditorHelper.ShowTextureUniforms(targetMat, tempProp);
                tempProp = new TextureProperties();
                tempProp.unifromName = "_RoughnessMap";
                tempProp.displayName = "Roughness";
                tempProp.uniformProperties.Add(new UniformProperty("_Smoothness", "Roughness", UniformType.RANGE1));
                EditorHelper.ShowTextureUniforms(targetMat, tempProp);
            }

            tempProp = new TextureProperties();
            tempProp.unifromName = "_BumpMap";
            tempProp.displayName = "Normal Map";
            tempProp.uniformProperties.Add(new UniformProperty("_NormalAmount", "Normal Amount", UniformType.NORMALRANGE));
            EditorHelper.ShowTextureUniforms(targetMat, tempProp);

            tempProp = new TextureProperties();
            tempProp.unifromName = "_AOMap";
            tempProp.displayName = "Ambient Occlusion Map";
            tempProp.uniformProperties.Add(new UniformProperty("_AOAmount", "AO Amount", UniformType.RANGE1));
            EditorHelper.ShowTextureUniforms(targetMat, tempProp);

            tempProp = new TextureProperties();
            tempProp.unifromName = "";
            tempProp.displayName = "Material Overrides";
            tempProp.hasTexture = false;
            tempProp.uniformProperties.Add(new UniformProperty("_ForceMetallic", "Force Metallic", UniformType.RANGE1));
            tempProp.uniformProperties.Add(new UniformProperty("_ForceSmoothness", "Force Smoothness", UniformType.RANGE1));
            EditorHelper.ShowTextureUniforms(targetMat, tempProp);*/
        }

    }

}