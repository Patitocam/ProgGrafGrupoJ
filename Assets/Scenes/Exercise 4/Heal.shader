// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "HEal"
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
			
			uniform float2 _Center;
			uniform float2 _Vector0;
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
			
			//https://www.shadertoy.com/view/XdXGW8
			float2 GradientNoiseDir( float2 x )
			{
				const float2 k = float2( 0.3183099, 0.3678794 );
				x = x * k + k.yx;
				return -1.0 + 2.0 * frac( 16.0 * k * frac( x.x * x.y * ( x.x + x.y ) ) );
			}
			
			float GradientNoise( float2 UV, float Scale )
			{
				float2 p = UV * Scale;
				float2 i = floor( p );
				float2 f = frac( p );
				float2 u = f * f * ( 3.0 - 2.0 * f );
				return lerp( lerp( dot( GradientNoiseDir( i + float2( 0.0, 0.0 ) ), f - float2( 0.0, 0.0 ) ),
						dot( GradientNoiseDir( i + float2( 1.0, 0.0 ) ), f - float2( 1.0, 0.0 ) ), u.x ),
						lerp( dot( GradientNoiseDir( i + float2( 0.0, 1.0 ) ), f - float2( 0.0, 1.0 ) ),
						dot( GradientNoiseDir( i + float2( 1.0, 1.0 ) ), f - float2( 1.0, 1.0 ) ), u.x ), u.y );
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
				float4 color208 = IsGammaSpace() ? float4(0.1094863,0.5176471,0.02745099,0) : float4(0.0115586,0.2307401,0.002124689,0);
				float mulTime26 = _Time.y * 2.0;
				float2 texCoord58 = i.uv.xy * float2( 1,1 ) + float2( 0,0 );
				float smoothstepResult16 = smoothstep( (0.4 + (sin( mulTime26 ) - -1.0) * (0.5 - 0.4) / (1.0 - -1.0)) , (0.6 + (sin( _Time.y ) - -1.0) * (0.7 - 0.6) / (1.0 - -1.0)) , length( ( texCoord58 - _Center ) ));
				float Vignette57 = ( 1.0 - smoothstepResult16 );
				float4 lerpResult207 = lerp( Screen107 , color208 , ( 1.0 - Vignette57 ));
				float4 color111 = IsGammaSpace() ? float4(0.1034772,0.3301887,0.06074227,0) : float4(0.01057096,0.08908623,0.0049725,0);
				float4 color117 = IsGammaSpace() ? float4(0.4461636,0.7843137,0.2313725,1) : float4(0.1675502,0.5775805,0.04373502,1);
				float2 texCoord112 = i.uv.xy * float2( 1,1 ) + float2( 0,0 );
				float4 lerpResult116 = lerp( color111 , color117 , ( 1.0 - length( ( texCoord112 - _Vector0 ) ) ));
				float4 color119 = lerpResult116;
				float mulTime73 = _Time.y * 2.0;
				float time66 = sin( mulTime73 );
				float2 texCoord175 = i.uv.xy * float2( 1,1 ) + float2( 0,0 );
				float2 break179 = texCoord175;
				float mulTime176 = _Time.y * 0.5;
				float2 temp_cast_0 = (break179.y).xx;
				float2 panner177 = ( mulTime176 * float2( 0.5,0.5 ) + temp_cast_0);
				float gradientNoise178 = GradientNoise(panner177,10.0);
				gradientNoise178 = gradientNoise178*0.5 + 0.5;
				float2 appendResult181 = (float2(( break179.x + ( gradientNoise178 - 0.5 ) ) , break179.y));
				float2 normalizeResult65 = normalize( ( -0.5 + appendResult181 ) );
				float2 coords66 = normalizeResult65 * 5.0;
				float2 id66 = 0;
				float2 uv66 = 0;
				float voroi66 = voronoi66( coords66, time66, id66, uv66, 0 );
				float Lines70 = step( voroi66 , 0.03 );
				float4 lerpResult187 = lerp( lerpResult207 , color119 , Lines70);
				float4 color191 = IsGammaSpace() ? float4(0.1704752,0.5019608,0.0627451,0) : float4(0.02463946,0.2158605,0.005181517,0);
				float time130 = sin( _Time.y );
				float2 texCoord122 = i.uv.xy * float2( 1,1 ) + float2( 0,0 );
				float2 break172 = texCoord122;
				float mulTime166 = _Time.y * 0.5;
				float2 temp_cast_1 = (break172.y).xx;
				float2 panner165 = ( mulTime166 * float2( 0.5,0.5 ) + temp_cast_1);
				float gradientNoise167 = GradientNoise(panner165,10.0);
				gradientNoise167 = gradientNoise167*0.5 + 0.5;
				float2 appendResult174 = (float2(( break172.x + ( gradientNoise167 - 0.5 ) ) , break172.y));
				float2 normalizeResult127 = normalize( ( -0.5 + appendResult174 ) );
				float2 coords130 = normalizeResult127 * 6.0;
				float2 id130 = 0;
				float2 uv130 = 0;
				float voroi130 = voronoi130( coords130, time130, id130, uv130, 0 );
				float Lines2131 = step( voroi130 , 0.03 );
				float4 lerpResult190 = lerp( lerpResult187 , color191 , Lines2131);
				float lerpResult152 = lerp( ( ( ( 1.0 - Vignette57 ) + ( ( 1.0 - Vignette57 ) * -0.5 ) ) + Lines70 + Lines2131 ) , 0.0 , Vignette57);
				float FinalMask151 = lerpResult152;
				float4 lerpResult204 = lerp( Screen107 , lerpResult190 , FinalMask151);
				float4 FinalColor202 = lerpResult204;
				

				finalColor = FinalColor202;

				return finalColor;
			} 
			ENDCG 
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18900
210;73;1395;806;1296.529;2191.114;1;True;False
Node;AmplifyShaderEditor.CommentaryNode;214;-4347.462,2261.247;Inherit;False;2527.882;726.9138;;16;122;172;166;165;167;182;173;174;123;124;125;126;127;130;128;131;Lines2;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;213;-4332.524,1167.447;Inherit;False;2934.594;1003.008;;16;175;176;179;177;178;183;180;181;62;73;63;72;65;66;81;70;Lines1;1,1,1,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;122;-4297.462,2402.402;Inherit;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;175;-4238.377,1357.8;Inherit;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;166;-4180.616,2877.161;Inherit;False;1;0;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;172;-4061.272,2401.929;Inherit;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.BreakToComponentsNode;179;-3899.263,1357.326;Inherit;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleTimeNode;176;-4282.524,2059.455;Inherit;False;1;0;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;212;-4343.234,177.6155;Inherit;False;1731.897;885.022;;13;13;26;23;58;14;29;49;30;15;43;16;19;57;Vignette;1,1,1,1;0;0
Node;AmplifyShaderEditor.PannerNode;165;-4166.85,2662.94;Inherit;True;3;0;FLOAT2;0,0;False;2;FLOAT2;0.5,0.5;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;177;-4014.723,1818.953;Inherit;True;3;0;FLOAT2;0,0;False;2;FLOAT2;0.5,0.5;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;167;-3884.764,2627.56;Inherit;False;Gradient;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;10;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;23;-4255.032,792.0953;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;26;-4243.494,559.0101;Inherit;False;1;0;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;13;-4211.382,391.2373;Inherit;False;Property;_Center;Center;0;0;Create;True;0;0;0;False;0;False;0.5,0.5;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;58;-4293.234,227.6155;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NoiseGeneratorNode;178;-3691.027,1809.854;Inherit;True;Gradient;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;10;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;183;-3415.944,1729.935;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;49;-3815.118,519.5632;Inherit;False;257;257;Subir el min new para agrandar la apertura del circulo;1;42;Info;1,1,1,1;0;0
Node;AmplifyShaderEditor.SinOpNode;30;-3981.508,808.6375;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;14;-4042.506,271.5262;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SinOpNode;29;-3992.508,561.6382;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;182;-3581.447,2618.234;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;173;-3415.582,2362.919;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;180;-3558.419,1371.353;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;42;-3765.116,568.5632;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;-1;False;2;FLOAT;1;False;3;FLOAT;0.4;False;4;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;43;-3722.868,815.6544;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;-1;False;2;FLOAT;1;False;3;FLOAT;0.6;False;4;FLOAT;0.7;False;1;FLOAT;0
Node;AmplifyShaderEditor.LengthOpNode;15;-3825.924,277.9384;Inherit;True;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;62;-2947.799,1217.447;Inherit;True;Constant;_Float0;Float 0;1;0;Create;True;0;0;0;False;0;False;-0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;174;-3235.692,2418.36;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;123;-3252.333,2311.247;Inherit;False;Constant;_Float1;Float 1;1;0;Create;True;0;0;0;False;0;False;-0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;181;-3309.636,1369.224;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SmoothstepOpNode;16;-3526.791,281.9412;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;217;-3973.937,-1539.621;Inherit;False;1457.382;803.8314;;9;112;113;114;115;111;118;117;116;119;Color;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleAddOpNode;124;-3030.883,2317.354;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleTimeNode;73;-2332.072,1870.026;Inherit;False;1;0;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;125;-2462.728,2744.342;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;19;-3281.568,281.3953;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;63;-2607.727,1437.837;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;112;-3923.937,-1063.411;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;57;-2835.337,265.4152;Inherit;True;Vignette;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;126;-2451.562,2675.509;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalizeNode;65;-2363.915,1441.099;Inherit;True;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.NormalizeNode;127;-2787.071,2320.615;Inherit;True;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;215;-916.0083,190.7153;Inherit;False;1870.629;627.0396;;12;160;147;159;161;150;149;148;162;153;146;152;151;FinalMask;1,1,1,1;0;0
Node;AmplifyShaderEditor.Vector2Node;113;-3842.084,-899.7896;Inherit;False;Property;_Vector0;Vector 0;1;0;Create;True;0;0;0;False;0;False;0.5,0.5;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SinOpNode;72;-2320.906,1801.193;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VoronoiNode;66;-2071.687,1441.447;Inherit;True;0;0;1;0;1;False;1;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;47;False;2;FLOAT;5;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.CommentaryNode;216;-3544.507,-321.0577;Inherit;False;1076.215;346.4459;;4;10;12;11;107;Screen;1,1,1,1;0;0
Node;AmplifyShaderEditor.VoronoiNode;130;-2493.843,2320.963;Inherit;True;0;0;1;0;1;False;1;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;47;False;2;FLOAT;6;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.GetLocalVarNode;160;-866.0083,512.9884;Inherit;False;57;Vignette;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;114;-3673.208,-1019.501;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.StepOpNode;81;-1866.54,1440.338;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0.03;False;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateShaderPropertyNode;10;-3262.694,-271.0577;Inherit;False;0;0;_MainTex;Shader;False;0;5;SAMPLER2D;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;147;-552.715,240.7153;Inherit;False;57;Vignette;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;159;-670.5832,520.5212;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;128;-2289.696,2319.854;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0.03;False;1;FLOAT;0
Node;AmplifyShaderEditor.LengthOpNode;115;-3456.627,-1013.089;Inherit;True;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;12;-3494.507,-133.6118;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;11;-3003.221,-206.7301;Inherit;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;111;-3398.479,-1489.621;Inherit;False;Constant;_Color1;Color 1;1;0;Create;True;0;0;0;False;0;False;0.1034772,0.3301887,0.06074227,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;118;-3240.906,-1038.446;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;218;-899.3202,-2192.679;Inherit;False;2677.424;649.681;;15;211;210;209;208;184;189;207;187;186;191;190;205;206;204;202;Final Color;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;70;-1621.93,1435.478;Inherit;False;Lines;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;150;-357.2899,248.2482;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;161;-473.2957,563.7549;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;-0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;131;-2043.58,2340.158;Inherit;False;Lines2;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;117;-3473.833,-1249.079;Inherit;False;Constant;_Color0;Color 0;1;0;Create;True;0;0;0;False;0;False;0.4461636,0.7843137,0.2313725,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;107;-2692.292,-154.3904;Inherit;False;Screen;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;162;-125.2957,251.7549;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;149;-27.28986,408.2482;Inherit;False;70;Lines;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;211;-821.54,-1658.998;Inherit;False;57;Vignette;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;116;-3027.844,-1355.267;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;148;6.710144,512.2482;Inherit;False;131;Lines2;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;210;-816.5479,-1731.533;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;153;276.562,633.1561;Inherit;False;57;Vignette;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;209;-839.228,-2142.679;Inherit;False;107;Screen;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;146;248.6465,294.5819;Inherit;True;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;119;-2740.555,-1308.517;Inherit;False;color;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;208;-849.3202,-1972.796;Inherit;False;Constant;_Color3;Color 3;2;0;Create;True;0;0;0;False;0;False;0.1094863,0.5176471,0.02745099,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;207;-566.7432,-2046.804;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;189;-278.0746,-1947.65;Inherit;False;119;color;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;152;487.562,293.1561;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;184;-284.5746,-1809.849;Inherit;False;70;Lines;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;187;38.22086,-2041.546;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;186;407.9498,-1882.658;Inherit;False;131;Lines2;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;151;730.6204,285.4803;Inherit;False;FinalMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;191;79.71233,-1888.651;Inherit;False;Constant;_Color2;Color 2;2;0;Create;True;0;0;0;False;0;False;0.1704752,0.5019608,0.0627451,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;205;658.7667,-2141.298;Inherit;False;107;Screen;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;206;677.9924,-1847.179;Inherit;False;151;FinalMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;190;406.7172,-2015.007;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;204;885.1583,-1990.91;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;202;1554.104,-2031.974;Inherit;True;FinalColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;203;1302.378,-590.2991;Inherit;False;202;FinalColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;1647.521,-578.4664;Float;False;True;-1;2;ASEMaterialInspector;0;2;HEal;c71b220b631b6344493ea3cf87110c93;True;SubShader 0 Pass 0;0;0;SubShader 0 Pass 0;1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;True;7;False;-1;False;True;0;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;0;;0;0;Standard;0;0;1;True;False;;False;0
WireConnection;172;0;122;0
WireConnection;179;0;175;0
WireConnection;165;0;172;1
WireConnection;165;1;166;0
WireConnection;177;0;179;1
WireConnection;177;1;176;0
WireConnection;167;0;165;0
WireConnection;178;0;177;0
WireConnection;183;0;178;0
WireConnection;30;0;23;0
WireConnection;14;0;58;0
WireConnection;14;1;13;0
WireConnection;29;0;26;0
WireConnection;182;0;167;0
WireConnection;173;0;172;0
WireConnection;173;1;182;0
WireConnection;180;0;179;0
WireConnection;180;1;183;0
WireConnection;42;0;29;0
WireConnection;43;0;30;0
WireConnection;15;0;14;0
WireConnection;174;0;173;0
WireConnection;174;1;172;1
WireConnection;181;0;180;0
WireConnection;181;1;179;1
WireConnection;16;0;15;0
WireConnection;16;1;42;0
WireConnection;16;2;43;0
WireConnection;124;0;123;0
WireConnection;124;1;174;0
WireConnection;19;0;16;0
WireConnection;63;0;62;0
WireConnection;63;1;181;0
WireConnection;57;0;19;0
WireConnection;126;0;125;0
WireConnection;65;0;63;0
WireConnection;127;0;124;0
WireConnection;72;0;73;0
WireConnection;66;0;65;0
WireConnection;66;1;72;0
WireConnection;130;0;127;0
WireConnection;130;1;126;0
WireConnection;114;0;112;0
WireConnection;114;1;113;0
WireConnection;81;0;66;0
WireConnection;159;0;160;0
WireConnection;128;0;130;0
WireConnection;115;0;114;0
WireConnection;11;0;10;0
WireConnection;11;1;12;0
WireConnection;118;0;115;0
WireConnection;70;0;81;0
WireConnection;150;0;147;0
WireConnection;161;0;159;0
WireConnection;131;0;128;0
WireConnection;107;0;11;0
WireConnection;162;0;150;0
WireConnection;162;1;161;0
WireConnection;116;0;111;0
WireConnection;116;1;117;0
WireConnection;116;2;118;0
WireConnection;210;0;211;0
WireConnection;146;0;162;0
WireConnection;146;1;149;0
WireConnection;146;2;148;0
WireConnection;119;0;116;0
WireConnection;207;0;209;0
WireConnection;207;1;208;0
WireConnection;207;2;210;0
WireConnection;152;0;146;0
WireConnection;152;2;153;0
WireConnection;187;0;207;0
WireConnection;187;1;189;0
WireConnection;187;2;184;0
WireConnection;151;0;152;0
WireConnection;190;0;187;0
WireConnection;190;1;191;0
WireConnection;190;2;186;0
WireConnection;204;0;205;0
WireConnection;204;1;190;0
WireConnection;204;2;206;0
WireConnection;202;0;204;0
WireConnection;0;0;203;0
ASEEND*/
//CHKSM=4B9A17A78E76EC8B07D1C66ECE505414EA6EAF4E