using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using System.IO;
namespace MaterialFX
{
    public enum UniformType { UVMODE, PBRMAP, FXMAP, TEXTURE, FLOAT, INT, HDRCOLOR, COLOR, RANGE1, RANGE2, RANGE4, RANGE8, RANGE16, RANGE32, RANGE64, RANGE128, RANGE256, NORMALRANGE, RANGENEG1TO1, TESSRANGE, DISPLACEAMOUNT, RIMSETTING, BLENDMODE }
    public class UniformProperty
    {
        public string displayName;
        public string uniformName;
        public UniformType uniformType;
        public float floatValue;
        public int intValue;

        public UniformProperty(string uName, string dispName, UniformType uType)
        {

            uniformName = uName;
            displayName = dispName;
            uniformType = uType;
        }
    }

    public class TextureProperties
    {
        public string unifromName;
        public string displayName;
        public bool hasTexture;
        public bool isCubeMap;
        public bool hasHelp;
        public string helpText;
        public List<UniformProperty> uniformProperties;

        public TextureProperties()
        {
            hasTexture = true;
            isCubeMap = false;
            hasHelp = false;
            helpText = "";
            uniformProperties = new List<UniformProperty>();
        }
    }

    public static class EditorHelper
    {
        public enum RenderDisplayModes { Material_FX, Unity_Standard, Normal, Metallic, Smoothness, Thickness, Curvature, Emission, Occlussion, Subsurface_Scattering, Environment_FX_Map, Iridescence, Reflection_Probe_Boost, Additional_Cubemap, Checker_Pattern, GrabTexture }
        public enum TextureWorkflow { Material_FX, Unity_Standard, Substance_Texture_Maps }
        public enum TextureChannels { Red, Green, Blue, Alpha, Gray, RGB, RGBA }
        public enum ShaderBlendModes {  Normal, Additive, Subtractive, Multiply, Divide, Overlay, ClipBlack, ClipWhite, Mod, DstAlpha, OneMinusDstAlpha, SrcAlpha, OneMinusSrcAlpha, Mix, MixOverlay, LighterColor, DarkerColor, ColorDodge, ColorBurn }

        public static bool isInitialized = false;

        public static Color backgroundDefault;
        public static Texture2D materialFXSplash;
        public static string materialFXVersion = "1.0";
        public static Color backgroundColor = new Color(.3f, .3f, .3f, 1);
        public static Color backgroundColorDark = new Color(.1f, .1f, .1f, 1);
        public static Color ButtonBackgroundDefault = new Color(.5f, .5f, .5f, 1);
        public static Color ButtonBackgroundActive = new Color(.2f, .8f, 1f, 1f);
        public static Color ButtonBackgroundDelete = new Color(.8f, .2f, .2f, 1f);
        public static GUIStyle ButtonDisabled, ButtonEnabled, TextHighlight, TextHeading, ButtonHighlight, PopUp, PopUpLabel;
        public static int TextureWidth = 64;
        public static string[] renderModeStrings, textureModeStrings, textureChannelStrings,blendModeStrings;
        public static int aboutTab = 0;
        public static void About ()
        {
            float editorWidth = EditorGUIUtility.currentViewWidth;
            GUILayout.BeginHorizontal();
            GUILayout.Label(materialFXSplash, GUILayout.Width(editorWidth - 40), GUILayout.Height(editorWidth / 2 - 20));
            GUILayout.EndHorizontal();
            GUIStyle style = new GUIStyle();
            style.richText = true;
            style.wordWrap = true;
            style.padding = new RectOffset(5,5,5,5);
            GUILayout.BeginHorizontal("box", GUILayout.Width((editorWidth) - 45));
                GUILayout.BeginHorizontal();
                    GUILayout.BeginVertical();
            GUILayout.Label("<color=white><b>Material FX</b>\n</color>" + "<color=white>Version: " + materialFXVersion + "</color>", style, GUILayout.Width((editorWidth/3*2) - 60));

            aboutTab =  GUILayout.Toolbar(aboutTab, new string[] { "Features", "Vision", "Credits" }, GUILayout.Width((editorWidth / 3 * 2) - 60));
                        if (aboutTab ==0)
                        {
                           GUILayout.Label("<color=silver><b>Material FX Features</b>\n\n- Standard Unity Shader Compliant\n- Subsurface Scattering\n- Tessellation & Displacement\n- Height map(Parallax effect)\n- Rim Emission Effects\n- Iridescence\n- Reflection Probe Boosting\n- Additional Cubemap Reflections\n- FX Map(Growth, Snow, Wetness)\n- Easy to use UI with packaged tools</color>", style, GUILayout.Width((editorWidth / 3 * 2) - 60));
                        }
                        if (aboutTab == 1)
                        {
                            GUILayout.Label("<color=silver><b>Material FX Vision</b>\n\nThis set of shaders and editors came as an offshoot requirement of other projects I have been working on. VJToolkit: (coming soon) which animates materials and objects to sound, and over at RocketChip for use in their Essentials Photogrammetry Assets.\n\nAs these two areas grow, more and more features will be added to MaterialFX, so I enourage users to help support the free growth of this plugin.</color>", style, GUILayout.Width((editorWidth / 3 * 2) - 60));

                            GUILayout.Label("<color=silver><b>VJToolkit:</b> A Unity Toolkit to create stunning visual fx and animations. Inspired by the demo scene.</color>", style, GUILayout.Width((editorWidth / 3 * 2) - 60));
                            if (GUILayout.Button("View VJToolkit videos on Youtube"))
                            {
                                 Application.OpenURL("https://www.youtube.com/watch?v=01W9SP-Hegw&list=PLdY8fx7wDYGe-TODjglTt1CJ_5Mc__rQZ&index=4");
                            }

                            GUILayout.Label("<color=silver><b>RocketChip Essentials: </b>Taking photorealistic scans of real world objects to bring to the digital space. We constantly look at new methods and imrove our workflow. See some of our assets for yourself! They have supported Texture Maps for this plugin.</color>", style, GUILayout.Width((editorWidth / 3 * 2) - 60));
                            if (GUILayout.Button("Checkout Rocketchip Essentials Packs"))
                            {
                                Application.OpenURL("http://beta.rocketchip.ca");
                            }
                        }

                        if (aboutTab == 2)
                        {
                            GUILayout.Label("<color=silver><b>Credits</b>\n\n<b>Developer:</b>\nChris Hodge (Studio Nexus / RocketChip)\n</color>", style, GUILayout.Width((editorWidth / 3 * 2) - 60));
                            if (GUILayout.Button("Email: Chris@studionexus.ca"))
                            {
                                Application.OpenURL("mailto:chris@studionexus.ca");
                            }
                           GUILayout.Label("<color=silver>\n<b>Special Thanks:</b>\nTyler Von Muehlen (RocketChip)\nTroy Woods (RocketChip)\nDavid Boon (KTI)\nAndrija Dimitrijevic (ADPhotografe)\nDan Muirhead (Damien Flame)\nHector Kearns\nSteve Stone\nChristine Fox\nJasmine Dubecki\nDJ DTM\n</color>", style, GUILayout.Width((editorWidth / 3 * 2) - 60));
                            GUILayout.Label("<color=silver><b>Greetz</b>\nJMC / VilleK / Scott / Nucleon (Image-Line)\nInigo Quilez (iq)\nAlan Zucconi</color>", style, GUILayout.Width((editorWidth / 3 * 2) - 60));
            }

            GUILayout.EndVertical();

                    GUILayout.BeginVertical();
                    GUILayout.Space(20);
        
                      GUILayout.Label("Developed by:", GUILayout.Width(-10+ editorWidth / 3));
                    if (GUILayout.Button("StudioNexus.ca", GUILayout.Width(-10 + editorWidth / 3)))
                    {
                        Application.OpenURL("http://studionexus.ca");
                    }

                    GUILayout.Space(10);
                    GUILayout.Label("Model Support from:", GUILayout.Width(-10 + editorWidth / 3));
                    if (GUILayout.Button("Rocketchip.ca", GUILayout.Width(-10 + editorWidth / 3)))
                    {
                        Application.OpenURL("http://beta.rocketchip.ca");
                    }

                    GUILayout.Space(10);
                    GUILayout.Label("Support MaterialFX:", GUILayout.Width(-10 + editorWidth / 3));
                    if (GUILayout.Button("Donate to Developer", GUILayout.Width(-10 + editorWidth / 3)))
                    {
                        Application.OpenURL("https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=48UPKHBTDX2P4&currency_code=CAD&source=url");
                    }
                    GUILayout.Space(10);
                    if (GUILayout.Button("Buy RocketChip Models", GUILayout.Width(-10 + editorWidth / 3)))
                    {
                        Application.OpenURL("https://beta.rockchip.ca");
                    }

                    GUILayout.Space(10);
                    GUILayout.EndVertical();

                GUILayout.EndHorizontal();
            GUILayout.EndHorizontal();
            GUILayout.Space(20);

            GUILayout.BeginHorizontal();
            GUILayout.EndHorizontal();
        }

        public static RenderDisplayModes GetRenderDisplayMode(Material targetMat, EditorHelper.RenderDisplayModes displayMode)
        {
            GUILayout.BeginHorizontal();
            GUILayout.Label("Rendering", EditorHelper.TextHeading);
            EditorHelper.HelpButton("rendering");
            GUILayout.EndHorizontal();
            GUILayout.Space(5);
            displayMode = (EditorHelper.RenderDisplayModes)targetMat.GetInt("_DisplayMode");
            int newDisplayMode = EditorHelper.GUIDropDown((int)displayMode, "Display Mode", 120, EditorHelper.renderModeStrings);
            if (newDisplayMode >= 0)
            {
                displayMode = (EditorHelper.RenderDisplayModes)newDisplayMode;
                targetMat.SetInt("_DisplayMode", (int)displayMode);
            }

            EditorHelper.HelpItem("rendering", "<b>Rendering Display Mode</b><color=silver>\n\n<b>Material FX: </b>Has All Features enabled\n<b>Unity Standard:</b> Used to A / B results\n<b>Normal:</b> Previews the Normal channel\n<b>Metallic:</b> Previews the Metallic channel\n<b>Smoothness:</b> Previews the Smoothness channel\n<b>Thickness:</b> Previews the Thickness channel (MaterialFX)\n<b>Curvature:</b> Previews the Curvature channel (MaterialFX)\n<b>Emission:</b> Previews the Emission channel \nSubsurface Scattering: Previews the Light influence channel \n<b>Environment FX Map:</b> Previews the FX channel used for environemtal effects (snow / growth /wetness). \n<b>Iridescence:</b> Previews the Iridescence channel\n<b>Reflection Probe Boost: </b>Previews the Reflection Boost channel\n<b>Additional Cubemap: </b>Previews the Cubemap Reflection channel\n<b>Checker Pattern: </b>Used to preview texel density on models & uvs.</color>");

            GUILayout.Space(10);
            return displayMode;
        }

        public static void Init()
        {
            if (isInitialized) return;
            materialFXSplash = (Texture2D)AssetDatabase.LoadAssetAtPath("Assets/MaterialFX/Resources/MaterialFX_Splash.jpg", typeof(Texture2D));
            backgroundDefault = GUI.backgroundColor;
            renderModeStrings = new string[System.Enum.GetValues(typeof(RenderDisplayModes)).Length];
            for (int i = 0; i < renderModeStrings.Length; i++)
            {
                RenderDisplayModes rend = (RenderDisplayModes)i;
                renderModeStrings[i] = rend.ToString().Replace("_", " ");
            }

            textureModeStrings = new string[System.Enum.GetValues(typeof(TextureWorkflow)).Length];
            for (int i = 0; i < textureModeStrings.Length; i++)
            {
                TextureWorkflow wf = (TextureWorkflow)i;
                textureModeStrings[i] = wf.ToString().Replace("_", " ");
            }
            textureChannelStrings = new string[System.Enum.GetValues(typeof(TextureChannels)).Length];
            for (int i = 0; i < textureChannelStrings.Length; i++)
            {
                TextureChannels tc = (TextureChannels)i;
                textureChannelStrings[i] = tc.ToString().Replace("_", " ");
            }
            blendModeStrings = new string[System.Enum.GetValues(typeof(ShaderBlendModes)).Length];
            for (int i = 0; i < blendModeStrings.Length; i++)
            {
                ShaderBlendModes bm = (ShaderBlendModes)i;
                blendModeStrings[i] = bm.ToString().Replace("_", " ");
            }            

            TextHeading = new GUIStyle(GUI.skin.label)
            {
                padding = new RectOffset(0, 0, 0, 0),
                fontStyle = FontStyle.Bold,
                fontSize = 11
            };
            ButtonHighlight = new GUIStyle(GUI.skin.button)
            {
                margin = new RectOffset(),
                padding = new RectOffset(0, 0, 5, 5),
                fontSize = 10,

            };
            PopUp = new GUIStyle(GUI.skin.GetStyle("popup"))
            {
                margin = new RectOffset(),
                padding = new RectOffset(8, 8, 0, 0),
                fixedHeight = 20,
                fontSize = 11,

            };
            PopUpLabel = new GUIStyle(GUI.skin.label)
            {
                margin = new RectOffset(),
                padding = new RectOffset(2, 0, 5, 0),
                fixedHeight = 20,
                fontSize = 11,
            };
            ButtonDisabled = new GUIStyle(GUI.skin.button)
            {
                margin = new RectOffset(),
                padding = new RectOffset(0, 0, 5, 5),
                fontSize = 10
            };
            ButtonEnabled = new GUIStyle(GUI.skin.label)
            {
                margin = new RectOffset(),
                padding = new RectOffset(),
                fontSize = 10
            };

            isInitialized = true;
        }


        public static int GUIDropDown(int val, string label, int labelWidth, string[] options, bool hasHelp = false, bool isShort = false)
        {
            GUILayout.BeginHorizontal("Label");
            if (labelWidth != 0) GUILayout.Label(label, PopUpLabel, GUILayout.Width(labelWidth));
            GUI.backgroundColor = backgroundDefault;
            int width = 50;
            if (hasHelp) width = 75;
            if (isShort) width += 80;
            int newVal = val;
            newVal = EditorGUILayout.Popup(val, options, PopUp, GUILayout.Width(EditorGUIUtility.currentViewWidth - width - labelWidth));
            GUILayout.EndHorizontal();
            if (val != newVal)
            {
                return newVal;
            }
            else
            {
                return val;
            }
        }


        public static void SaveTexture(Texture2D texture, string filePath)
        {
            byte[] bytes = texture.EncodeToPNG();
            FileStream stream = new FileStream(filePath, FileMode.OpenOrCreate, FileAccess.Write);
            BinaryWriter writer = new BinaryWriter(stream);

            for (int i = 0; i < bytes.Length; i++)
            {
                writer.Write(bytes[i]);
            }

            writer.Close();
            stream.Close();
            //I can't figure out how to import the newly created .png file as a texture
            AssetDatabase.ImportAsset(filePath, ImportAssetOptions.ForceUpdate);
            Texture2D newTexture = (Texture2D)AssetDatabase.LoadAssetAtPath(filePath, typeof(Texture2D));

            if (newTexture == null)
            {
                Debug.Log("Error Importing");
            }
            else
            {
                // Debug.Log("Import Successful");
            }
        }

        public static Texture2D LoadTexture(string filePath)
        {
            Texture2D tex = null;
            byte[] fileData;

            if (File.Exists(filePath))
            {
                fileData = File.ReadAllBytes(filePath);
                tex = new Texture2D(2, 2);
                tex.LoadImage(fileData); //..this will auto-resize the texture dimensions.
            }
            return tex;
        }

        public static bool longerUI = false;
        public static void Slider(Material targetMat, string title, string prop, float min, float max)
        {
            float thisValue = targetMat.GetFloat(prop);
            EditorGUILayout.BeginHorizontal();
            GUILayout.Label(title, GUILayout.Width(140));
            float sliderValue = EditorGUILayout.Slider("", thisValue, min, max, GUILayout.Width(EditorGUIUtility.currentViewWidth - ((longerUI) ? 193 : 260)));

            if (sliderValue != thisValue)
            {
                targetMat.SetFloat(prop, sliderValue);
            }
            EditorGUILayout.EndHorizontal();
        }

        public static void RimSetting(Material targetMat, string title, string prop)
        {
            float thisValue = targetMat.GetFloat(prop);
            bool inverted = false;
            if (thisValue < 0) { inverted = true; thisValue = Mathf.Abs(thisValue); }
            Color highlightColor = new Color(0, .6f, .4f);

            EditorGUILayout.BeginHorizontal();
            GUILayout.Label(title, GUILayout.Width(125));


            if (!inverted) GUI.backgroundColor = highlightColor;
            if (GUILayout.Button("Outer", GUILayout.Width(42))) { inverted = false; }
            GUI.backgroundColor = EditorHelper.backgroundDefault;
            if (inverted) GUI.backgroundColor = highlightColor;
            if (GUILayout.Button("Inner", GUILayout.Width(42))) { inverted = true; }
            GUI.backgroundColor = EditorHelper.backgroundDefault;
            GUILayout.Space(5);
            float sliderValue = EditorGUILayout.Slider("", thisValue, 0.001f, 1, GUILayout.Width(EditorGUIUtility.currentViewWidth - ((EditorHelper.longerUI) ? 275 : 342)));

            targetMat.SetFloat(prop, (inverted) ? -sliderValue : sliderValue);
            EditorGUILayout.EndHorizontal();
        }
        public static void UColor(Material targetMat, string title, string prop, bool hdr)
        {
            Color c = targetMat.GetColor(prop);
            // public static Color ColorField(GUIContent label, Color value, bool showEyedropper, bool showAlpha, bool hdr, params GUILayoutOption[] options);
            EditorGUILayout.BeginHorizontal();
            GUILayout.Label(title);
            Color c2 = EditorGUILayout.ColorField(new GUIContent(""), c, true, true, hdr, GUILayout.Width(50));
            if (c != c2)
            {
                targetMat.SetColor(prop, c2);
            }
            EditorGUILayout.EndHorizontal();
            GUILayout.Space(3);
        }
        public static void SubTexture(Material targetMat, string title, string prop)
        {
            Texture tex = targetMat.GetTexture(prop);
            Texture CheckTexture = (Texture)EditorGUILayout.ObjectField(title, tex, typeof(Texture), false);
            if (CheckTexture != tex) { targetMat.SetTexture(prop, CheckTexture); }
        }

        public static void UVMode(Material targetMat, string title, string prop)
        {
            GUILayout.BeginHorizontal();
            int val = targetMat.GetInt(prop + "UVMode");
            int val2 = EditorHelper.GUIDropDown(val, title, 140, new string[] { "UV", "Triplanar" }, false, true);
            if (val2 >= 0)
            {
                if (val != val2) { targetMat.SetInt(prop + "UVMode", val2); }
            }
            GUILayout.EndHorizontal();
            if (val == 1)
            {
                GUILayout.BeginHorizontal();
                GUILayout.BeginVertical();
                GUILayout.Space(5);
                EditorHelper.Slider(targetMat, "Triplanar Scale", prop + "TriplanarScale", .0001f, 4f);
                EditorHelper.Slider(targetMat, "Triplanar Blend", prop + "TriplanarBlend", .0001f, 1f);
                GUILayout.EndVertical();
                GUILayout.EndHorizontal();
            }
        }


        public static void GenerateRepackedTexture(Material targetMat, Texture2D textureA, EditorHelper.TextureChannels channelA,
                                    Texture2D textureB, EditorHelper.TextureChannels channelB,
                                    Texture2D textureC, EditorHelper.TextureChannels channelC,
                                    Texture2D textureD, EditorHelper.TextureChannels channelD, string filename, int resolution, int format, string MatTex)
        {
            int res = 256;
            if (resolution == 1) res = 512;
            if (resolution == 2) res = 1024;
            if (resolution == 3) res = 2048;
            if (resolution == 4) res = 4096;
            if (resolution == 5) res = 8192;

            Texture2D emptyTex = new Texture2D(1, 1, TextureFormat.ARGB32, false);
            emptyTex.SetPixel(0, 0, new Color(0, 0, 0, 0));
            int width = res;
            int height = res;
            string path = Path.GetDirectoryName(AssetDatabase.GetAssetPath(targetMat));
            string file = path + "/" + filename + ".";
            if (format == 0) file += "png";
            if (format == 1) file += "jpg";

            Texture2D generatedTexture = new Texture2D(width, height, TextureFormat.ARGB32, false);
            Color[] outputColors = new Color[width * height];
            Color blankColor = new Color(0, 0, 0, 0);
            for (int i = 0; i < width * height; i++)
            {
                outputColors[i] = blankColor;
            }
            RenderTexture previous = RenderTexture.active;
            for (int i = 0; i < 4; i++)
            {
                Texture2D targetTex = textureA;
                EditorHelper.TextureChannels channel = channelA;
                if (i == 1) { targetTex = textureB; channel = channelB; }
                if (i == 2) { targetTex = textureC; channel = channelC; }
                if (i == 3) { targetTex = textureD; channel = channelD; }
                if (targetTex == null) targetTex = emptyTex;
                int srcWidth = targetTex.width;
                int srcHeight = targetTex.height;


                RenderTexture tmp = RenderTexture.GetTemporary(
                srcWidth,
                srcHeight,
                0,
                RenderTextureFormat.Default,
                RenderTextureReadWrite.Linear);

                Graphics.Blit(targetTex, tmp);
                RenderTexture.active = tmp;
                Texture2D readableTex = new Texture2D(srcWidth, srcHeight);
                readableTex.ReadPixels(new Rect(0, 0, tmp.width, tmp.height), 0, 0);
                readableTex.Apply();
                Color[] channelColors = readableTex.GetPixels();


                for (int x = 0; x < width; x++)
                {
                    for (int y = 0; y < height; y++)
                    {
                        int sx = Mathf.FloorToInt((x * 1.0f) / (width * 1.0f) * (srcWidth * 1.0f));
                        int sy = Mathf.FloorToInt((y * 1.0f) / (height * 1.0f) * (srcHeight * 1.0f));
                        float chVal = 0;
                        if (channel == EditorHelper.TextureChannels.Red) { chVal += channelColors[sy * srcWidth + sx].r; }
                        if (channel == EditorHelper.TextureChannels.Green) { chVal += channelColors[sy * srcWidth + sx].g; }
                        if (channel == EditorHelper.TextureChannels.Blue) { chVal += channelColors[sy * srcWidth + sx].b; }
                        if (channel == EditorHelper.TextureChannels.Alpha) { chVal += channelColors[sy * srcWidth + sx].a; }
                        if (channel == EditorHelper.TextureChannels.RGB || channel == EditorHelper.TextureChannels.Gray) { chVal += (channelColors[sy * srcWidth + sx].r + channelColors[sy * srcWidth + sx].g + channelColors[sy * srcWidth + sx].b) / 3f; }
                        if (channel == EditorHelper.TextureChannels.RGBA) { chVal += (channelColors[sy * srcWidth + sx].r + channelColors[sy * srcWidth + sx].g + channelColors[sy * srcWidth + sx].b + channelColors[sy * srcWidth + sx].a) / 4f; }

                        if (i == 0) outputColors[y * width + x].r = chVal;
                        if (i == 1) outputColors[y * width + x].g = chVal;
                        if (i == 2) outputColors[y * width + x].b = chVal;
                        if (i == 3) outputColors[y * width + x].a = chVal;
                    }
                }
                RenderTexture.active = previous;
                RenderTexture.ReleaseTemporary(tmp);
            }

            generatedTexture.SetPixels(outputColors);
            SaveTexture(generatedTexture, file);
            Texture2D t = (Texture2D)AssetDatabase.LoadAssetAtPath(file, typeof(Texture2D));
            targetMat.SetTexture(MatTex, t);
        }

        static Dictionary<string, bool> HelpToggles = new Dictionary<string, bool>();
        public static void HelpButton(string key)
        {
            Color bgColor = GUI.backgroundColor;
            GUI.backgroundColor = EditorHelper.backgroundColorDark;
            if (HelpToggles.ContainsKey(key))
            {
                if (HelpToggles[key]) GUI.backgroundColor = EditorHelper.ButtonBackgroundActive;
            }

            if (GUILayout.Button("?", GUILayout.Width(20)))
            {
                if (HelpToggles.ContainsKey(key))
                {
                    HelpToggles[key] = !HelpToggles[key];
                }
                else
                {
                    HelpToggles.Add(key, true);
                }
            }
            GUI.backgroundColor = bgColor;
            GUILayout.Space(10);
        }

        public static void HelpItem(string key, string text)
        {
            if (HelpToggles.ContainsKey(key))
            {
                if (HelpToggles[key])
                {
                    GUILayout.Space(5);
                    GUI.backgroundColor = EditorHelper.ButtonBackgroundActive;
                    GUILayout.Space(1);
                    GUILayout.BeginHorizontal("box", GUILayout.Width(EditorGUIUtility.currentViewWidth - 50));
                    GUI.backgroundColor = new Color(0, 0, 0, .8f);
                    GUILayout.BeginHorizontal("box", GUILayout.Width(EditorGUIUtility.currentViewWidth - 60));
                    GUIStyle style = new GUIStyle();
                    style.richText = true;

                    style.wordWrap = true;// = EditorGUIUtility.currentViewWidth - 80;
                    GUILayout.Label("<color=white>" + text + "</color>", style, GUILayout.Width(EditorGUIUtility.currentViewWidth - 80));
                    GUILayout.EndHorizontal();
                    GUILayout.EndHorizontal();
                    GUI.backgroundColor = EditorHelper.backgroundDefault;
                }
            }
        }

        static bool PBRMapEnabled = false;
        static Texture2D tempMetallic, tempCurve, tempThick, tempSmooth;
        static EditorHelper.TextureChannels tempMetallicChannel = EditorHelper.TextureChannels.Red;
        static EditorHelper.TextureChannels tempThickChannel = EditorHelper.TextureChannels.Gray;
        static EditorHelper.TextureChannels tempCurveChannel = EditorHelper.TextureChannels.Gray;
        static EditorHelper.TextureChannels tempSmoothChannel = EditorHelper.TextureChannels.Alpha;
        static int tempResolution = 0;
        static int tempFormat = 0;
        public static void GeneratePBRMap(Material targetMat, string title, string prop)
        {
            GUI.backgroundColor = EditorHelper.ButtonBackgroundActive;

            string buttonString = "Repack Textures into MaterialFX PBR Map";
            if (PBRMapEnabled) { GUI.backgroundColor = EditorHelper.ButtonBackgroundDelete; buttonString = "Cancel"; }

            if (GUILayout.Button(buttonString))
            {
                PBRMapEnabled = !PBRMapEnabled;
            }
            GUI.backgroundColor = EditorHelper.backgroundDefault;
            if (PBRMapEnabled == true)
            {
                GUILayout.BeginHorizontal("BOX");
                Texture2D CheckTexture;
                GUILayout.BeginVertical();
                GUILayout.Label("Metallic");
                CheckTexture = (Texture2D)EditorGUILayout.ObjectField("", tempMetallic, typeof(Texture2D), false, GUILayout.Width(EditorHelper.TextureWidth));
                if (CheckTexture != tempMetallic) { tempMetallic = CheckTexture; }

                tempMetallicChannel = (EditorHelper.TextureChannels)EditorGUILayout.Popup((int)tempMetallicChannel, EditorHelper.textureChannelStrings, EditorHelper.PopUp, GUILayout.Width(70));
                GUILayout.Space(5);
                GUILayout.EndVertical();
                GUILayout.BeginVertical();
                GUILayout.Label("Thickness");
                CheckTexture = (Texture2D)EditorGUILayout.ObjectField("", tempThick, typeof(Texture2D), false, GUILayout.Width(EditorHelper.TextureWidth));
                if (CheckTexture != tempThick) { tempThick = CheckTexture; }
                tempThickChannel = (EditorHelper.TextureChannels)EditorGUILayout.Popup((int)tempThickChannel, EditorHelper.textureChannelStrings, EditorHelper.PopUp, GUILayout.Width(70));
                GUILayout.Space(5);
                GUILayout.EndVertical();
                GUILayout.BeginVertical();
                GUILayout.Label("Curvature");
                CheckTexture = (Texture2D)EditorGUILayout.ObjectField("", tempCurve, typeof(Texture2D), false, GUILayout.Width(EditorHelper.TextureWidth));
                if (CheckTexture != tempCurve) { tempCurve = CheckTexture; }
                tempCurveChannel = (EditorHelper.TextureChannels)EditorGUILayout.Popup((int)tempCurveChannel, EditorHelper.textureChannelStrings, EditorHelper.PopUp, GUILayout.Width(70));
                GUILayout.Space(5);
                GUILayout.EndVertical();
                GUILayout.BeginVertical();
                GUILayout.Label("Smoothness");
                CheckTexture = (Texture2D)EditorGUILayout.ObjectField("", tempSmooth, typeof(Texture2D), false, GUILayout.Width(EditorHelper.TextureWidth));
                if (CheckTexture != tempSmooth) { tempSmooth = CheckTexture; }
                tempSmoothChannel = (EditorHelper.TextureChannels)EditorGUILayout.Popup((int)tempSmoothChannel, EditorHelper.textureChannelStrings, EditorHelper.PopUp, GUILayout.Width(70));
                GUILayout.Space(5);
                GUILayout.EndVertical();
                GUILayout.EndHorizontal();
                GUILayout.BeginHorizontal();
                GUILayout.Label("Output size :", GUILayout.Width(75));
                tempResolution = EditorGUILayout.Popup(tempResolution, new string[] { "256 x 256", "512 x 512", "1024 x 1024", "2048 x 2048", "4096 x 4096", "8192 x 8192" }, EditorHelper.PopUp, GUILayout.Width(100));
                GUILayout.Label("Format :", GUILayout.Width(55));
                tempFormat = EditorGUILayout.Popup(tempFormat, new string[] { "PNG", "JPEG" }, EditorHelper.PopUp, GUILayout.Width(80));
                GUILayout.Space(5);
                GUILayout.EndHorizontal();
                GUILayout.Space(5);
                if (GUILayout.Button("Generate " + targetMat.name + "_MaterialFX_PBRMap"))
                {
                    GenerateRepackedTexture(targetMat, tempMetallic, tempMetallicChannel,
                        tempThick, tempThickChannel,
                        tempCurve, tempCurveChannel,
                        tempSmooth, tempSmoothChannel,
                        targetMat.name + "_MaterialFX_PBRMap", tempResolution, tempFormat, "_AdvancedPBRMap");
                    PBRMapEnabled = false;
                }
            }

        }

        public static void BlendMode(Material targetMat, string title, string prop)
        {
            GUILayout.BeginHorizontal();
            int val = targetMat.GetInt(prop);
            int val2 = EditorHelper.GUIDropDown(val, title, 140, blendModeStrings, false, true);
            if (val2 >= 0)
            {
                if (val != val2) { targetMat.SetInt(prop, val2); }
            }
            GUILayout.EndHorizontal();
        }

        static bool FXMapEnabled = false;
        public static void GenerateFXMap(Material targetMat, string title, string prop)
        {
            GUI.backgroundColor = EditorHelper.ButtonBackgroundActive;

            string buttonString = "Repack Textures into MaterialFX FX Map";
            if (FXMapEnabled) { GUI.backgroundColor = EditorHelper.ButtonBackgroundDelete; buttonString = "Cancel"; }
            GUILayout.BeginHorizontal();
            if (GUILayout.Button(buttonString))
            {
                FXMapEnabled = !FXMapEnabled;
            }
            EditorHelper.HelpButton("prop" + "_help");
            GUILayout.EndHorizontal();
            GUILayout.BeginHorizontal();
            EditorHelper.HelpItem("prop" + "_help", "Text");
            GUILayout.EndHorizontal();

            GUI.backgroundColor = EditorHelper.backgroundDefault;
            if (FXMapEnabled == true)
            {
                GUILayout.BeginHorizontal("BOX");
                Texture2D CheckTexture;
                GUILayout.BeginVertical();
                GUILayout.Label("Snow");
                CheckTexture = (Texture2D)EditorGUILayout.ObjectField("", tempMetallic, typeof(Texture2D), false, GUILayout.Width(EditorHelper.TextureWidth));
                if (CheckTexture != tempMetallic) { tempMetallic = CheckTexture; }

                tempMetallicChannel = (EditorHelper.TextureChannels)EditorGUILayout.Popup((int)tempMetallicChannel, EditorHelper.textureChannelStrings, EditorHelper.PopUp, GUILayout.Width(70));
                GUILayout.Space(5);
                GUILayout.EndVertical();
                GUILayout.BeginVertical();
                GUILayout.Label("Growth");
                CheckTexture = (Texture2D)EditorGUILayout.ObjectField("", tempThick, typeof(Texture2D), false, GUILayout.Width(EditorHelper.TextureWidth));
                if (CheckTexture != tempThick) { tempThick = CheckTexture; }
                tempThickChannel = (EditorHelper.TextureChannels)EditorGUILayout.Popup((int)tempThickChannel, EditorHelper.textureChannelStrings, EditorHelper.PopUp, GUILayout.Width(70));
                GUILayout.Space(5);
                GUILayout.EndVertical();
                GUILayout.BeginVertical();
                GUILayout.Label("Wetness");
                CheckTexture = (Texture2D)EditorGUILayout.ObjectField("", tempCurve, typeof(Texture2D), false, GUILayout.Width(EditorHelper.TextureWidth));
                if (CheckTexture != tempCurve) { tempCurve = CheckTexture; }
                tempCurveChannel = (EditorHelper.TextureChannels)EditorGUILayout.Popup((int)tempCurveChannel, EditorHelper.textureChannelStrings, EditorHelper.PopUp, GUILayout.Width(70));
                GUILayout.Space(5);
                GUILayout.EndVertical();
                GUILayout.BeginVertical();
                GUILayout.Label("Unused");
                CheckTexture = (Texture2D)EditorGUILayout.ObjectField("", tempSmooth, typeof(Texture2D), false, GUILayout.Width(EditorHelper.TextureWidth));
                if (CheckTexture != tempSmooth) { tempSmooth = CheckTexture; }
                tempSmoothChannel = (EditorHelper.TextureChannels)EditorGUILayout.Popup((int)tempSmoothChannel, EditorHelper.textureChannelStrings, EditorHelper.PopUp, GUILayout.Width(70));
                GUILayout.Space(5);
                GUILayout.EndVertical();
                GUILayout.EndHorizontal();
                GUILayout.BeginHorizontal();
                GUILayout.Label("Output size :", GUILayout.Width(75));
                tempResolution = EditorGUILayout.Popup(tempResolution, new string[] { "256 x 256", "512 x 512", "1024 x 1024", "2048 x 2048", "4096 x 4096", "8192 x 8192" }, EditorHelper.PopUp, GUILayout.Width(100));
                GUILayout.Label("Format :", GUILayout.Width(55));
                tempFormat = EditorGUILayout.Popup(tempFormat, new string[] { "PNG", "JPEG" }, EditorHelper.PopUp, GUILayout.Width(80));
                GUILayout.Space(5);
                GUILayout.EndHorizontal();
                GUILayout.Space(5);
                if (GUILayout.Button("Generate " + targetMat.name + "_MaterialFX_FXMap"))
                {
                    GenerateRepackedTexture(targetMat, tempMetallic, tempMetallicChannel,
                        tempThick, tempThickChannel,
                        tempCurve, tempCurveChannel,
                        tempSmooth, tempSmoothChannel,
                        targetMat.name + "_MaterialFX_FXMap", tempResolution, tempFormat, "_FXTex");
                    FXMapEnabled = false;
                }
            }

        }

        public static void ShowTextureUniforms(Material targetMat, TextureProperties props)
        {

            GUILayout.BeginHorizontal("box");
            GUILayout.BeginVertical();
          
            if (!props.hasHelp) { 
            GUILayout.Label(props.displayName, EditorHelper.TextHeading);
            } else  {
                GUILayout.BeginHorizontal();
                GUILayout.Label(props.displayName, EditorHelper.TextHeading);
                HelpButton(props.displayName + "_help");

                GUILayout.EndHorizontal();
            }
            HelpItem(props.displayName + "_help", props.helpText);
            GUILayout.Space(5);
            GUILayout.BeginHorizontal();
            if (props.hasTexture)
            {
                Texture tex = targetMat.GetTexture(props.unifromName);
                Texture CheckTexture = (Texture)EditorGUILayout.ObjectField("", tex, typeof(Texture), false, GUILayout.Width(EditorHelper.TextureWidth));
                if (CheckTexture != tex) { targetMat.SetTexture(props.unifromName, CheckTexture); }
                EditorHelper.longerUI = false;
            }
            else
            {
                EditorHelper.longerUI = true;
            }
            GUILayout.Space(5);
            GUILayout.BeginVertical();
            GUILayout.Space(5);

            foreach (UniformProperty p in props.uniformProperties)
            {
                if (p.uniformType == UniformType.COLOR) { EditorHelper.UColor(targetMat, p.displayName, p.uniformName, false); }
                if (p.uniformType == UniformType.HDRCOLOR) { EditorHelper.UColor(targetMat, p.displayName, p.uniformName, true); }
                if (p.uniformType == UniformType.RANGE1) { EditorHelper.Slider(targetMat, p.displayName, p.uniformName, 0, 1); }
                if (p.uniformType == UniformType.RANGE2) { EditorHelper.Slider(targetMat, p.displayName, p.uniformName, 0, 2); }
                if (p.uniformType == UniformType.RANGE4) { EditorHelper.Slider(targetMat, p.displayName, p.uniformName, 0, 4); }
                if (p.uniformType == UniformType.RANGE8) { EditorHelper.Slider(targetMat, p.displayName, p.uniformName, 0, 8); }
                if (p.uniformType == UniformType.TESSRANGE) { EditorHelper.Slider(targetMat, p.displayName, p.uniformName, 1, 32); }
                if (p.uniformType == UniformType.DISPLACEAMOUNT) { EditorHelper.Slider(targetMat, p.displayName, p.uniformName, -4, 4); }
                if (p.uniformType == UniformType.RANGE16) { EditorHelper.Slider(targetMat, p.displayName, p.uniformName, 0, 16); }
                if (p.uniformType == UniformType.RANGE32) { EditorHelper.Slider(targetMat, p.displayName, p.uniformName, 0, 32); }
                if (p.uniformType == UniformType.RANGE64) { EditorHelper.Slider(targetMat, p.displayName, p.uniformName, 0, 64); }
                if (p.uniformType == UniformType.RANGE128) { EditorHelper.Slider(targetMat, p.displayName, p.uniformName, 0, 128); }
                if (p.uniformType == UniformType.RANGE256) { EditorHelper.Slider(targetMat, p.displayName, p.uniformName, 0, 256); }
                if (p.uniformType == UniformType.NORMALRANGE) { EditorHelper.Slider(targetMat, p.displayName, p.uniformName, 0.001f, 1); }
                if (p.uniformType == UniformType.RANGENEG1TO1) { EditorHelper.Slider(targetMat, p.displayName, p.uniformName, -1, 1); }
                if (p.uniformType == UniformType.TEXTURE) { EditorHelper.SubTexture(targetMat, p.displayName, p.uniformName); }
                if (p.uniformType == UniformType.RIMSETTING) { EditorHelper.RimSetting(targetMat, p.displayName, p.uniformName); }
                if (p.uniformType == UniformType.UVMODE) { EditorHelper.UVMode(targetMat, p.displayName, p.uniformName); }
                if (p.uniformType == UniformType.PBRMAP) { GeneratePBRMap(targetMat, p.displayName, p.uniformName); }
                if (p.uniformType == UniformType.FXMAP) { GenerateFXMap(targetMat, p.displayName, p.uniformName); }
                if (p.uniformType == UniformType.BLENDMODE) { BlendMode (targetMat, p.displayName, p.uniformName); }

            }
            GUILayout.EndVertical();

            GUILayout.EndHorizontal();
            GUILayout.Space(5);
            GUILayout.EndVertical();

            GUILayout.EndHorizontal();
            GUILayout.Space(5);
        }

    }
}
