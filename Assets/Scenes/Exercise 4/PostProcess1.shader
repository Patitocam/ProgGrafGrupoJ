// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "PostProcess1"
{
	Properties
	{
		_MainTex ( "Screen", 2D ) = "black" {}
		_Center("Center", Vector) = (0.5,0.5,0,0)

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
					float2 voronoihash50( float2 p )
					{
						
						p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
						return frac( sin( p ) *43758.5453);
					}
			
					float voronoi50( float2 v, float time, inout float2 id, inout float2 mr, float smoothness )
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
						 		float2 o = voronoihash50( n + g );
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
				float4 color45 = IsGammaSpace() ? float4(1,1,1,1) : float4(1,1,1,1);
				float mulTime53 = _Time.y * 2.0;
				float time50 = sin( mulTime53 );
				float2 coords50 = i.uv.xy * 25.43;
				float2 id50 = 0;
				float2 uv50 = 0;
				float voroi50 = voronoi50( coords50, time50, id50, uv50, 0 );
				float2 texCoord12 = i.uv.xy * float2( 1,1 ) + float2( 0,0 );
				float4 tex2DNode11 = tex2D( _MainTex, texCoord12 );
				float4 lerpResult55 = lerp( ( color45 * voroi50 ) , tex2DNode11 , ( 1.0 - voroi50 ));
				float mulTime26 = _Time.y * 2.0;
				float2 texCoord58 = i.uv.xy * float2( 1,1 ) + float2( 0,0 );
				float smoothstepResult16 = smoothstep( (0.4 + (sin( mulTime26 ) - -1.0) * (0.5 - 0.4) / (1.0 - -1.0)) , (0.6 + (sin( _Time.y ) - -1.0) * (0.7 - 0.6) / (1.0 - -1.0)) , length( ( texCoord58 - _Center ) ));
				float Vignette57 = (0.6 + (( 1.0 - smoothstepResult16 ) - 0.0) * (1.0 - 0.6) / (1.0 - 0.0));
				float4 lerpResult44 = lerp( lerpResult55 , tex2DNode11 , Vignette57);
				

				finalColor = lerpResult44;

				return finalColor;
			} 
			ENDCG 
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18900
100;73;1132;818;3270.727;1148.424;3.544284;True;False
Node;AmplifyShaderEditor.SimpleTimeNode;23;-3137.35,1703.993;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;13;-3093.7,1303.135;Inherit;False;Property;_Center;Center;0;0;Create;True;0;0;0;False;0;False;0.5,0.5;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleTimeNode;26;-3125.811,1470.908;Inherit;False;1;0;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;58;-3360.019,1201.004;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SinOpNode;29;-2874.826,1473.536;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;14;-2924.824,1183.424;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SinOpNode;30;-2863.826,1720.535;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;49;-2697.437,1431.461;Inherit;False;257;257;Subir el min new para agrandar la apertura del circulo;1;42;Info;1,1,1,1;0;0
Node;AmplifyShaderEditor.TFHCRemapNode;43;-2605.189,1727.552;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;-1;False;2;FLOAT;1;False;3;FLOAT;0.6;False;4;FLOAT;0.7;False;1;FLOAT;0
Node;AmplifyShaderEditor.LengthOpNode;15;-2708.244,1189.836;Inherit;True;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;42;-2647.437,1480.461;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;-1;False;2;FLOAT;1;False;3;FLOAT;0.4;False;4;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;53;-1810.99,-489.1865;Inherit;False;1;0;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;16;-2409.112,1193.839;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;19;-2163.89,1193.293;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;54;-1560.005,-486.5589;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;48;-1957.611,1183.689;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0.6;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;45;-1218.59,-651.5325;Inherit;False;Constant;_Color0;Color 0;1;0;Create;True;0;0;0;False;0;False;1,1,1,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VoronoiNode;50;-1235.433,-446.1121;Inherit;True;0;0;1;0;1;False;1;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;1;False;2;FLOAT;25.43;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;12;-1796.336,-26.55394;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TemplateShaderPropertyNode;10;-1564.523,-163.9999;Inherit;False;0;0;_MainTex;Shader;False;0;5;SAMPLER2D;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;56;-885.5306,-324.29;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;52;-931.7848,-625.3247;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;11;-1305.05,-99.67229;Inherit;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;57;-1663.659,1198.313;Inherit;False;Vignette;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;55;-646.6073,-290.6581;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;59;-557.0099,34.65269;Inherit;False;57;Vignette;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;44;-269.3687,-105.2928;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;89.84463,-87.5144;Float;False;True;-1;2;ASEMaterialInspector;0;2;PostProcess1;c71b220b631b6344493ea3cf87110c93;True;SubShader 0 Pass 0;0;0;SubShader 0 Pass 0;1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;True;7;False;-1;False;True;0;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;0;;0;0;Standard;0;0;1;True;False;;False;0
WireConnection;29;0;26;0
WireConnection;14;0;58;0
WireConnection;14;1;13;0
WireConnection;30;0;23;0
WireConnection;43;0;30;0
WireConnection;15;0;14;0
WireConnection;42;0;29;0
WireConnection;16;0;15;0
WireConnection;16;1;42;0
WireConnection;16;2;43;0
WireConnection;19;0;16;0
WireConnection;54;0;53;0
WireConnection;48;0;19;0
WireConnection;50;1;54;0
WireConnection;56;0;50;0
WireConnection;52;0;45;0
WireConnection;52;1;50;0
WireConnection;11;0;10;0
WireConnection;11;1;12;0
WireConnection;57;0;48;0
WireConnection;55;0;52;0
WireConnection;55;1;11;0
WireConnection;55;2;56;0
WireConnection;44;0;55;0
WireConnection;44;1;11;0
WireConnection;44;2;59;0
WireConnection;0;0;44;0
ASEEND*/
//CHKSM=FA4F52022DA23182E7283050A2CA5EFEE7705034