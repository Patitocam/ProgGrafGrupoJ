// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "TakeDamage"
{
	Properties
	{
		_MainTex ( "Screen", 2D ) = "black" {}
		_Center("Center", Vector) = (0.5,0.5,0,0)
		_Vector0("Vector 0", Vector) = (0.5,0.5,0,0)

	}

	SubShader
	{
		LOD 0

		
		
		ZTest Always
		Cull Off
		ZWrite Off

		
		Pass
		{ 
			CGPROGRAM 

			

			#pragma vertex vert_img_custom 
			#pragma fragment frag
			#pragma target 3.0
			#include "UnityCG.cginc"
			#include "UnityShaderVariables.cginc"


			struct appdata_img_custom
			{
				float4 vertex : POSITION;
				half2 texcoord : TEXCOORD0;
				
			};

			struct v2f_img_custom
			{
				float4 pos : SV_POSITION;
				half2 uv   : TEXCOORD0;
				half2 stereoUV : TEXCOORD2;
		#if UNITY_UV_STARTS_AT_TOP
				half4 uv2 : TEXCOORD1;
				half4 stereoUV2 : TEXCOORD3;
		#endif
				
			};

			uniform sampler2D _MainTex;
			uniform half4 _MainTex_TexelSize;
			uniform half4 _MainTex_ST;
			
			uniform float2 _Vector0;
			uniform float2 _Center;
					float2 voronoihash66( float2 p )
					{
						
						p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
						return frac( sin( p ) *43758.5453);
					}
			
					float voronoi66( float2 v, float time, inout float2 id, inout float2 mr, float smoothness )
					{
						float2 n = floor( v );
						float2 f = frac( v );
						float F1 = 8.0;
						float F2 = 8.0; float2 mg = 0;
						for ( int j = -1; j <= 1; j++ )
						{
							for ( int i = -1; i <= 1; i++ )
						 	{
						 		float2 g = float2( i, j );
						 		float2 o = voronoihash66( n + g );
								o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = f - g - o;
								float d = 0.5 * dot( r, r );
						 		if( d<F1 ) {
						 			F2 = F1;
						 			F1 = d; mg = g; mr = r; id = o;
						 		} else if( d<F2 ) {
						 			F2 = d;
						 		}
						 	}
						}
						return F1;
					}
			
					float2 voronoihash130( float2 p )
					{
						
						p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
						return frac( sin( p ) *43758.5453);
					}
			
					float voronoi130( float2 v, float time, inout float2 id, inout float2 mr, float smoothness )
					{
						float2 n = floor( v );
						float2 f = frac( v );
						float F1 = 8.0;
						float F2 = 8.0; float2 mg = 0;
						for ( int j = -1; j <= 1; j++ )
						{
							for ( int i = -1; i <= 1; i++ )
						 	{
						 		float2 g = float2( i, j );
						 		float2 o = voronoihash130( n + g );
								o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = f - g - o;
								float d = 0.5 * dot( r, r );
						 		if( d<F1 ) {
						 			F2 = F1;
						 			F1 = d; mg = g; mr = r; id = o;
						 		} else if( d<F2 ) {
						 			F2 = d;
						 		}
						 	}
						}
						return F1;
					}
			


			v2f_img_custom vert_img_custom ( appdata_img_custom v  )
			{
				v2f_img_custom o;
				
				o.pos = UnityObjectToClipPos( v.vertex );
				o.uv = float4( v.texcoord.xy, 1, 1 );

				#if UNITY_UV_STARTS_AT_TOP
					o.uv2 = float4( v.texcoord.xy, 1, 1 );
					o.stereoUV2 = UnityStereoScreenSpaceUVAdjust ( o.uv2, _MainTex_ST );

					if ( _MainTex_TexelSize.y < 0.0 )
						o.uv.y = 1.0 - o.uv.y;
				#endif
				o.stereoUV = UnityStereoScreenSpaceUVAdjust ( o.uv, _MainTex_ST );
				return o;
			}

			half4 frag ( v2f_img_custom i ) : SV_Target
			{
				#ifdef UNITY_UV_STARTS_AT_TOP
					half2 uv = i.uv2;
					half2 stereoUV = i.stereoUV2;
				#else
					half2 uv = i.uv;
					half2 stereoUV = i.stereoUV;
				#endif	
				
				half4 finalColor;

				// ase common template code
				float2 texCoord12 = i.uv.xy * float2( 1,1 ) + float2( 0,0 );
				float4 Screen107 = tex2D( _MainTex, texCoord12 );
				float4 color111 = IsGammaSpace() ? float4(0.2924528,0,0,0) : float4(0.06955753,0,0,0);
				float4 color117 = IsGammaSpace() ? float4(1,0,0,1) : float4(1,0,0,1);
				float2 texCoord112 = i.uv.xy * float2( 1,1 ) + float2( 0,0 );
				float4 lerpResult116 = lerp( color111 , color117 , ( 1.0 - length( ( texCoord112 - _Vector0 ) ) ));
				float4 color119 = lerpResult116;
				float mulTime26 = _Time.y * 2.0;
				float2 texCoord58 = i.uv.xy * float2( 1,1 ) + float2( 0,0 );
				float smoothstepResult16 = smoothstep( (0.2 + (sin( mulTime26 ) - -1.0) * (0.5 - 0.2) / (1.0 - -1.0)) , (0.6 + (sin( _Time.y ) - -1.0) * (0.7 - 0.6) / (1.0 - -1.0)) , length( ( texCoord58 - _Center ) ));
				float Vignette57 = ( 1.0 - smoothstepResult16 );
				float mulTime73 = _Time.y * 9.0;
				float time66 = sin( mulTime73 );
				float2 texCoord61 = i.uv.xy * float2( 1,1 ) + float2( 0,0 );
				float2 normalizeResult65 = normalize( ( -0.5 + texCoord61 ) );
				float2 coords66 = normalizeResult65 * 5.0;
				float2 id66 = 0;
				float2 uv66 = 0;
				float voroi66 = voronoi66( coords66, time66, id66, uv66, 0 );
				float Lines70 = step( voroi66 , 0.03 );
				float mulTime125 = _Time.y * 7.0;
				float time130 = sin( mulTime125 );
				float2 texCoord122 = i.uv.xy * float2( 1,1 ) + float2( 0,0 );
				float2 normalizeResult127 = normalize( ( -0.5 + texCoord122 ) );
				float2 coords130 = normalizeResult127 * 6.0;
				float2 id130 = 0;
				float2 uv130 = 0;
				float voroi130 = voronoi130( coords130, time130, id130, uv130, 0 );
				float Lines2131 = step( voroi130 , 0.03 );
				float lerpResult152 = lerp( ( ( ( 1.0 - Vignette57 ) + ( ( 1.0 - Vignette57 ) * -0.5 ) ) + Lines70 + Lines2131 ) , 0.0 , Vignette57);
				float FinalMask151 = lerpResult152;
				float4 lerpResult155 = lerp( Screen107 , color119 , FinalMask151);
				

				finalColor = lerpResult155;

				return finalColor;
			} 
			ENDCG 
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18900
115;73;1231;637;2889.955;-420.1925;1;True;True
Node;AmplifyShaderEditor.SimpleTimeNode;23;-2847.399,1035.49;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;26;-2835.86,802.4049;Inherit;False;1;0;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;58;-2885.601,471.0101;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;13;-2803.749,634.632;Inherit;False;Property;_Center;Center;0;0;Create;True;0;0;0;False;0;False;0.5,0.5;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SinOpNode;29;-2584.875,805.033;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;49;-2407.486,762.958;Inherit;False;257;257;Subir el min new para agrandar la apertura del circulo;1;42;Info;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;14;-2634.873,514.9209;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SinOpNode;30;-2573.875,1052.032;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;43;-2315.238,1059.049;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;-1;False;2;FLOAT;1;False;3;FLOAT;0.6;False;4;FLOAT;0.7;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;42;-2357.486,811.958;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;-1;False;2;FLOAT;1;False;3;FLOAT;0.2;False;4;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.LengthOpNode;15;-2418.292,521.333;Inherit;True;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;16;-2119.161,525.3359;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;123;-3347.738,2318.586;Inherit;False;Constant;_Float1;Float 1;1;0;Create;True;0;0;0;False;0;False;-0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;62;-2924.582,1439.07;Inherit;False;Constant;_Float0;Float 0;1;0;Create;True;0;0;0;False;0;False;-0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;122;-3554.877,2432.677;Inherit;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;61;-3131.721,1553.161;Inherit;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;19;-1873.938,524.7899;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;124;-3030.883,2317.354;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleTimeNode;73;-2332.072,1870.026;Inherit;False;1;0;FLOAT;9;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;125;-2755.228,2749.542;Inherit;False;1;0;FLOAT;7;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;63;-2607.727,1437.837;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.NormalizeNode;127;-2787.071,2320.615;Inherit;True;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.NormalizeNode;65;-2363.915,1441.099;Inherit;True;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;57;-1427.707,508.8099;Inherit;True;Vignette;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;72;-2320.906,1801.193;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;126;-2744.062,2680.709;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VoronoiNode;130;-2493.843,2320.963;Inherit;True;0;0;1;0;1;False;1;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;47;False;2;FLOAT;6;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.VoronoiNode;66;-2071.687,1441.447;Inherit;True;0;0;1;0;1;False;1;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;47;False;2;FLOAT;5;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.GetLocalVarNode;160;-866.0083,512.9884;Inherit;False;57;Vignette;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;128;-2289.696,2319.854;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0.03;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;113;-3842.084,-899.7896;Inherit;False;Property;_Vector0;Vector 0;1;0;Create;True;0;0;0;False;0;False;0.5,0.5;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.StepOpNode;81;-1866.54,1440.338;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0.03;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;147;-552.715,240.7153;Inherit;False;57;Vignette;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;159;-670.5832,520.5212;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;112;-3923.937,-1063.411;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;161;-470.4402,546.6215;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;-0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;70;-1621.93,1435.478;Inherit;False;Lines;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;131;-2043.58,2340.158;Inherit;False;Lines2;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;114;-3673.208,-1019.501;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.OneMinusNode;150;-357.2899,248.2482;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;149;-27.28986,408.2482;Inherit;False;70;Lines;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LengthOpNode;115;-3456.627,-1013.089;Inherit;True;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;148;6.710144,512.2482;Inherit;False;131;Lines2;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;162;-125.2957,251.7549;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;117;-3473.833,-1249.079;Inherit;False;Constant;_Color0;Color 0;1;0;Create;True;0;0;0;False;0;False;1,0,0,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;12;-3494.507,-133.6118;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;118;-3240.906,-1038.446;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateShaderPropertyNode;10;-3262.694,-271.0577;Inherit;False;0;0;_MainTex;Shader;False;0;5;SAMPLER2D;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;111;-3398.479,-1489.621;Inherit;False;Constant;_Color1;Color 1;1;0;Create;True;0;0;0;False;0;False;0.2924528,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;153;276.562,633.1561;Inherit;False;57;Vignette;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;146;248.6465,294.5819;Inherit;True;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;11;-3003.221,-206.7301;Inherit;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;116;-3027.844,-1355.267;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;152;487.562,293.1561;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;107;-2692.292,-154.3904;Inherit;False;Screen;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;151;730.6204,285.4803;Inherit;False;FinalMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;119;-2740.555,-1308.517;Inherit;False;color;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;154;548.7042,-46.36295;Inherit;False;151;FinalMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;158;555.9678,-136.9375;Inherit;False;119;color;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;156;733.8437,-514.5949;Inherit;False;107;Screen;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;155;915.8437,-343.5949;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;1290.25,-415.2054;Float;False;True;-1;2;ASEMaterialInspector;0;2;TakeDamage;c71b220b631b6344493ea3cf87110c93;True;SubShader 0 Pass 0;0;0;SubShader 0 Pass 0;1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;True;7;False;-1;False;True;0;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;0;;0;0;Standard;0;0;1;True;False;;False;0
WireConnection;29;0;26;0
WireConnection;14;0;58;0
WireConnection;14;1;13;0
WireConnection;30;0;23;0
WireConnection;43;0;30;0
WireConnection;42;0;29;0
WireConnection;15;0;14;0
WireConnection;16;0;15;0
WireConnection;16;1;42;0
WireConnection;16;2;43;0
WireConnection;19;0;16;0
WireConnection;124;0;123;0
WireConnection;124;1;122;0
WireConnection;63;0;62;0
WireConnection;63;1;61;0
WireConnection;127;0;124;0
WireConnection;65;0;63;0
WireConnection;57;0;19;0
WireConnection;72;0;73;0
WireConnection;126;0;125;0
WireConnection;130;0;127;0
WireConnection;130;1;126;0
WireConnection;66;0;65;0
WireConnection;66;1;72;0
WireConnection;128;0;130;0
WireConnection;81;0;66;0
WireConnection;159;0;160;0
WireConnection;161;0;159;0
WireConnection;70;0;81;0
WireConnection;131;0;128;0
WireConnection;114;0;112;0
WireConnection;114;1;113;0
WireConnection;150;0;147;0
WireConnection;115;0;114;0
WireConnection;162;0;150;0
WireConnection;162;1;161;0
WireConnection;118;0;115;0
WireConnection;146;0;162;0
WireConnection;146;1;149;0
WireConnection;146;2;148;0
WireConnection;11;0;10;0
WireConnection;11;1;12;0
WireConnection;116;0;111;0
WireConnection;116;1;117;0
WireConnection;116;2;118;0
WireConnection;152;0;146;0
WireConnection;152;2;153;0
WireConnection;107;0;11;0
WireConnection;151;0;152;0
WireConnection;119;0;116;0
WireConnection;155;0;156;0
WireConnection;155;1;158;0
WireConnection;155;2;154;0
WireConnection;0;0;155;0
ASEEND*/
//CHKSM=03D6BB85CF4159A5EAA8AD1C2198EFD8C76A4845