// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Drunk"
{
	Properties
	{
		_MainTex ( "Screen", 2D ) = "black" {}
		_Center("Center", Vector) = (0.5,0.5,0,0)
		_Vector0("Vector 0", Vector) = (0.5,0.5,0,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}

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
					float2 voronoihash89( float2 p )
					{
						
						p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
						return frac( sin( p ) *43758.5453);
					}
			
					float voronoi89( float2 v, float time, inout float2 id, inout float2 mr, float smoothness )
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
						 		float2 o = voronoihash89( n + g );
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
				float2 uv_MainTex = i.uv.xy * _MainTex_ST.xy + _MainTex_ST.zw;
				float2 texCoord1 = i.uv.xy * float2( 1,1 ) + float2( 0,0 );
				float2 break22 = texCoord1;
				float2 appendResult8 = (float2(( break22.x + ( 0.0 + (-0.2 + (sin( _Time.y ) - -1.0) * (0.2 - -0.2) / (1.0 - -1.0)) ) ) , break22.y));
				float2 Drunk132 = appendResult8;
				float4 lerpResult20 = lerp( tex2D( _MainTex, uv_MainTex ) , tex2D( _MainTex, Drunk132 ) , 0.5);
				float2 texCoord25 = i.uv.xy * float2( 1,1 ) + float2( 0,0 );
				float2 break45 = texCoord25;
				float temp_output_24_0 = sin( _Time.y );
				float2 appendResult48 = (float2(( break45.x + (0.2 + (temp_output_24_0 - -1.0) * (-0.2 - 0.2) / (1.0 - -1.0)) ) , ( break45.y + (-0.2 + (temp_output_24_0 - -1.0) * (0.2 - -0.2) / (1.0 - -1.0)) )));
				float2 Drunk233 = appendResult48;
				float4 tex2DNode41 = tex2D( _MainTex, Drunk233 );
				float4 lerpResult37 = lerp( lerpResult20 , tex2DNode41 , 0.5);
				float mulTime85 = _Time.y * 0.5;
				float time89 = sin( mulTime85 );
				float2 texCoord76 = i.uv.xy * float2( 1,1 ) + float2( 0,0 );
				float2 normalizeResult88 = normalize( ( -0.5 + texCoord76 ) );
				float2 coords89 = normalizeResult88 * 5.0;
				float2 id89 = 0;
				float2 uv89 = 0;
				float voroi89 = voronoi89( coords89, time89, id89, uv89, 0 );
				float mulTime99 = _Time.y * 2.0;
				float2 texCoord101 = i.uv.xy * float2( 1,1 ) + float2( 0,0 );
				float smoothstepResult109 = smoothstep( (-1.0 + (sin( mulTime99 ) - -1.0) * (-0.5 - -1.0) / (1.0 - -1.0)) , 1.0 , length( ( texCoord101 - _Vector0 ) ));
				float Vignette2111 = ( 1.0 - smoothstepResult109 );
				float lerpResult96 = lerp( voroi89 , 0.0 , Vignette2111);
				float Lines91 = lerpResult96;
				float4 lerpResult94 = lerp( lerpResult37 , ( 1.0 - tex2DNode41 ) , Lines91);
				float4 FinalDrunk50 = lerpResult94;
				float mulTime57 = _Time.y * 2.0;
				float2 texCoord58 = i.uv.xy * float2( 1,1 ) + float2( 0,0 );
				float smoothstepResult67 = smoothstep( (0.0 + (sin( mulTime57 ) - -1.0) * (0.1 - 0.0) / (1.0 - -1.0)) , (0.6 + (sin( _Time.y ) - -1.0) * (0.7 - 0.6) / (1.0 - -1.0)) , length( ( texCoord58 - _Center ) ));
				float smoothstepResult71 = smoothstep( 0.5 , 1.0 , ( 1.0 - smoothstepResult67 ));
				float Vignette69 = smoothstepResult71;
				float4 lerpResult51 = lerp( FinalDrunk50 , tex2D( _MainTex, uv_MainTex ) , Vignette69);
				

				finalColor = lerpResult51;

				return finalColor;
			} 
			ENDCG 
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18900
210;73;1395;806;3402.89;-3080.027;1.42626;True;False
Node;AmplifyShaderEditor.SimpleTimeNode;2;-3085.798,683.5493;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;13;-2827.472,527.4262;Inherit;True;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;101;-297.9966,3106.417;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;100;-216.1445,3270.039;Inherit;False;Property;_Vector0;Vector 0;1;0;Create;True;0;0;0;False;0;False;0.5,0.5;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleTimeNode;99;-248.2568,3437.812;Inherit;False;1;0;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;23;-1567.219,1253.344;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;1;-3070.65,29.89434;Inherit;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;15;-2609.472,528.4262;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;-1;False;2;FLOAT;1;False;3;FLOAT;-0.2;False;4;FLOAT;0.2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;105;2.729248,3440.44;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;102;180.1194,3398.365;Inherit;False;257;257;Subir el min new para agrandar la apertura del circulo;1;106;Info;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;104;-47.2688,3150.328;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LengthOpNode;108;169.3132,3156.74;Inherit;True;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;106;230.1213,3447.365;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;-1;False;2;FLOAT;1;False;3;FLOAT;-1;False;4;FLOAT;-0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;22;-2755.878,49.62708;Inherit;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SinOpNode;24;-1308.893,1097.221;Inherit;True;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;25;-1552.071,599.689;Inherit;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;14;-2416.472,394.4261;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;109;468.4463,3160.743;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;49;-1106.682,893.9443;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;-1;False;2;FLOAT;1;False;3;FLOAT;0.2;False;4;FLOAT;-0.2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;7;-2387.558,38.22404;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;26;-1090.893,1098.221;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;-1;False;2;FLOAT;1;False;3;FLOAT;-0.2;False;4;FLOAT;0.2;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;45;-1216.549,601.4437;Inherit;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.RangedFloatNode;84;-2925.491,3244.467;Inherit;True;Constant;_Float1;Float 1;1;0;Create;True;0;0;0;False;0;False;-0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;76;-3259.619,3452.654;Inherit;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;29;-958.9564,596.8594;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;85;-2309.764,3897.046;Inherit;False;1;0;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;86;-2585.419,3464.857;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;8;-2141.91,41.31824;Inherit;True;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.OneMinusNode;110;713.6692,3160.197;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;47;-914.0599,719.8705;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;58;-390.6169,2250.134;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NormalizeNode;88;-2341.607,3468.119;Inherit;False;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleTimeNode;57;-340.8772,2581.528;Inherit;False;1;0;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;48;-687.1936,600.0167;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;59;-308.7649,2413.755;Inherit;False;Property;_Center;Center;0;0;Create;True;0;0;0;False;0;False;0.5,0.5;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RegisterLocalVarNode;32;-1812.465,85.66882;Inherit;False;Drunk1;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleTimeNode;56;-352.4153,2814.614;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;111;986.9004,3151.217;Inherit;True;Vignette2;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;87;-2298.598,3828.213;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;34;-3083.547,1838.694;Inherit;False;32;Drunk1;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;97;-1972.719,3788.333;Inherit;False;111;Vignette2;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;60;-78.89111,2831.156;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;61;87.49902,2542.081;Inherit;False;257;257;Subir el min new para agrandar la apertura del circulo;1;65;;1,1,1,1;0;0
Node;AmplifyShaderEditor.TemplateShaderPropertyNode;18;-2917.228,1757.246;Inherit;False;0;0;_MainTex;Shader;False;0;5;SAMPLER2D;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;33;-370.398,608.3401;Inherit;True;Drunk2;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TemplateShaderPropertyNode;16;-2902.556,1540.361;Inherit;False;0;0;_MainTex;Shader;False;0;5;SAMPLER2D;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SinOpNode;63;-89.89111,2584.156;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VoronoiNode;89;-2070.379,3461.467;Inherit;True;0;0;1;0;1;False;1;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;47;False;2;FLOAT;5;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.SimpleSubtractOpNode;62;-139.8892,2294.044;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;40;-2087.57,2043.757;Inherit;False;33;Drunk2;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TFHCRemapNode;64;179.749,2838.173;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;-1;False;2;FLOAT;1;False;3;FLOAT;0.6;False;4;FLOAT;0.7;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;65;137.501,2591.081;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;-1;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;19;-2788.451,1850.028;Inherit;True;Property;_TextureSample1;Texture Sample 1;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LengthOpNode;66;76.69287,2300.457;Inherit;True;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;21;-2423.68,1958.524;Inherit;False;Constant;_Float0;Float 0;0;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;17;-2761.5,1528.318;Inherit;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TemplateShaderPropertyNode;39;-2022.57,1882.757;Inherit;False;0;0;_MainTex;Shader;False;0;5;SAMPLER2D;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;96;-1846.719,3465.333;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;41;-1927.462,2025.556;Inherit;True;Property;_TextureSample2;Texture Sample 2;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;20;-2338.653,1676.592;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SmoothstepOpNode;67;375.8259,2304.459;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;91;-1567.622,3460.498;Inherit;True;Lines;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;92;-1455.345,2018.606;Inherit;False;91;Lines;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;95;-1566.578,1903.807;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;37;-1699.262,1682.81;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;68;621.0488,2303.914;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;94;-1352.345,1685.606;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SmoothstepOpNode;71;822.1001,2301.395;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.5;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateShaderPropertyNode;53;-54.00513,-31.08887;Inherit;False;0;0;_MainTex;Shader;False;0;5;SAMPLER2D;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;50;-1163.092,1678.363;Inherit;False;FinalDrunk;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;69;1061.319,2299.306;Inherit;True;Vignette;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;52;73.99487,-192.0889;Inherit;False;50;FinalDrunk;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;70;470.3876,145.8331;Inherit;False;69;Vignette;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;54;97.99487,14.91113;Inherit;True;Property;_TextureSample3;Texture Sample 3;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;107;272.3694,3694.456;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;-1;False;2;FLOAT;1;False;3;FLOAT;0.6;False;4;FLOAT;0.7;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;51;409.0486,-174.1943;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SinOpNode;103;13.72925,3687.439;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;98;-259.7949,3670.897;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;1132.021,-14.9141;Float;False;True;-1;2;ASEMaterialInspector;0;2;Drunk;c71b220b631b6344493ea3cf87110c93;True;SubShader 0 Pass 0;0;0;SubShader 0 Pass 0;1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;True;7;False;-1;False;True;0;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;0;;0;0;Standard;0;0;1;True;False;;False;0
WireConnection;13;0;2;0
WireConnection;15;0;13;0
WireConnection;105;0;99;0
WireConnection;104;0;101;0
WireConnection;104;1;100;0
WireConnection;108;0;104;0
WireConnection;106;0;105;0
WireConnection;22;0;1;0
WireConnection;24;0;23;0
WireConnection;14;1;15;0
WireConnection;109;0;108;0
WireConnection;109;1;106;0
WireConnection;49;0;24;0
WireConnection;7;0;22;0
WireConnection;7;1;14;0
WireConnection;26;0;24;0
WireConnection;45;0;25;0
WireConnection;29;0;45;0
WireConnection;29;1;49;0
WireConnection;86;0;84;0
WireConnection;86;1;76;0
WireConnection;8;0;7;0
WireConnection;8;1;22;1
WireConnection;110;0;109;0
WireConnection;47;0;45;1
WireConnection;47;1;26;0
WireConnection;88;0;86;0
WireConnection;48;0;29;0
WireConnection;48;1;47;0
WireConnection;32;0;8;0
WireConnection;111;0;110;0
WireConnection;87;0;85;0
WireConnection;60;0;56;0
WireConnection;33;0;48;0
WireConnection;63;0;57;0
WireConnection;89;0;88;0
WireConnection;89;1;87;0
WireConnection;62;0;58;0
WireConnection;62;1;59;0
WireConnection;64;0;60;0
WireConnection;65;0;63;0
WireConnection;19;0;18;0
WireConnection;19;1;34;0
WireConnection;66;0;62;0
WireConnection;17;0;16;0
WireConnection;96;0;89;0
WireConnection;96;2;97;0
WireConnection;41;0;39;0
WireConnection;41;1;40;0
WireConnection;20;0;17;0
WireConnection;20;1;19;0
WireConnection;20;2;21;0
WireConnection;67;0;66;0
WireConnection;67;1;65;0
WireConnection;67;2;64;0
WireConnection;91;0;96;0
WireConnection;95;0;41;0
WireConnection;37;0;20;0
WireConnection;37;1;41;0
WireConnection;37;2;21;0
WireConnection;68;0;67;0
WireConnection;94;0;37;0
WireConnection;94;1;95;0
WireConnection;94;2;92;0
WireConnection;71;0;68;0
WireConnection;50;0;94;0
WireConnection;69;0;71;0
WireConnection;54;0;53;0
WireConnection;107;0;103;0
WireConnection;51;0;52;0
WireConnection;51;1;54;0
WireConnection;51;2;70;0
WireConnection;103;0;98;0
WireConnection;0;0;51;0
ASEEND*/
//CHKSM=E44BC24582AF720E2580BA02CD1092241CAAE7D3