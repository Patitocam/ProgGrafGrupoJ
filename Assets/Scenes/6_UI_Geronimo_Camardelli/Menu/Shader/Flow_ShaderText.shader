// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Flow_ShaderText"
{
	Properties
	{
		[PerRendererData] _MainTex ("Sprite Texture", 2D) = "white" {}
		_Color ("Tint", Color) = (1,1,1,1)
		
		_StencilComp ("Stencil Comparison", Float) = 8
		_Stencil ("Stencil ID", Float) = 0
		_StencilOp ("Stencil Operation", Float) = 0
		_StencilWriteMask ("Stencil Write Mask", Float) = 255
		_StencilReadMask ("Stencil Read Mask", Float) = 255

		_ColorMask ("Color Mask", Float) = 15

		[Toggle(UNITY_UI_ALPHACLIP)] _UseUIAlphaClip ("Use Alpha Clip", Float) = 0
		_Speed("Speed", Float) = 1
		_MaxAngle("MaxAngle", Float) = 0.1
		_ColorTime("ColorTime", Float) = 1
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_BW_Map("BW_Map", 2D) = "white" {}
		_Ramp("Ramp", 2D) = "white" {}
		_FlowMap("FlowMap", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}

	}

	SubShader
	{
		LOD 0

		Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" "PreviewType"="Plane" "CanUseSpriteAtlas"="True" }
		
		Stencil
		{
			Ref [_Stencil]
			ReadMask [_StencilReadMask]
			WriteMask [_StencilWriteMask]
			CompFront [_StencilComp]
			PassFront [_StencilOp]
			FailFront Keep
			ZFailFront Keep
			CompBack Always
			PassBack Keep
			FailBack Keep
			ZFailBack Keep
		}


		Cull Off
		Lighting Off
		ZWrite Off
		ZTest [unity_GUIZTestMode]
		Blend SrcAlpha OneMinusSrcAlpha
		ColorMask [_ColorMask]

		
		Pass
		{
			Name "Default"
		CGPROGRAM
			
			#ifndef UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX
			#define UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input)
			#endif
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0

			#include "UnityCG.cginc"
			#include "UnityUI.cginc"

			#pragma multi_compile __ UNITY_UI_CLIP_RECT
			#pragma multi_compile __ UNITY_UI_ALPHACLIP
			
			#include "UnityShaderVariables.cginc"
			#define ASE_NEEDS_VERT_POSITION

			
			struct appdata_t
			{
				float4 vertex   : POSITION;
				float4 color    : COLOR;
				float2 texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				
			};

			struct v2f
			{
				float4 vertex   : SV_POSITION;
				fixed4 color    : COLOR;
				half2 texcoord  : TEXCOORD0;
				float4 worldPosition : TEXCOORD1;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
				
			};
			
			uniform fixed4 _Color;
			uniform fixed4 _TextureSampleAdd;
			uniform float4 _ClipRect;
			uniform sampler2D _MainTex;
			uniform float _Speed;
			uniform float _MaxAngle;
			uniform sampler2D _TextureSample0;
			uniform float4 _TextureSample0_ST;
			uniform sampler2D _Ramp;
			uniform sampler2D _FlowMap;
			uniform float4 _FlowMap_ST;
			uniform float _ColorTime;
			uniform sampler2D _BW_Map;
			uniform float4 _BW_Map_ST;

			
			v2f vert( appdata_t IN  )
			{
				v2f OUT;
				UNITY_SETUP_INSTANCE_ID( IN );
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(OUT);
				UNITY_TRANSFER_INSTANCE_ID(IN, OUT);
				OUT.worldPosition = IN.vertex;
				float temp_output_14_0 = ( sin( ( _Time.y * _Speed ) ) * _MaxAngle );
				float temp_output_38_0 = cos( temp_output_14_0 );
				float temp_output_39_0 = sin( temp_output_14_0 );
				float2 appendResult15 = (float2(( ( IN.vertex.xyz.x * temp_output_38_0 ) - ( temp_output_39_0 * IN.vertex.xyz.y ) ) , ( ( IN.vertex.xyz.x * temp_output_39_0 ) + ( IN.vertex.xyz.y * temp_output_38_0 ) )));
				
				
				OUT.worldPosition.xyz += ( float3( appendResult15 ,  0.0 ) - IN.vertex.xyz );
				OUT.vertex = UnityObjectToClipPos(OUT.worldPosition);

				OUT.texcoord = IN.texcoord;
				
				OUT.color = IN.color * _Color;
				return OUT;
			}

			fixed4 frag(v2f IN  ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( IN );

				float2 uv_TextureSample0 = IN.texcoord.xy * _TextureSample0_ST.xy + _TextureSample0_ST.zw;
				float4 tex2DNode8 = tex2D( _TextureSample0, uv_TextureSample0 );
				float2 uv_FlowMap = IN.texcoord.xy * _FlowMap_ST.xy + _FlowMap_ST.zw;
				float4 tex2DNode14_g4 = tex2D( _FlowMap, uv_FlowMap );
				float2 appendResult20_g4 = (float2(tex2DNode14_g4.r , tex2DNode14_g4.g));
				float TimeVar197_g4 = ( _Time.y * _ColorTime );
				float2 temp_cast_0 = (TimeVar197_g4).xx;
				float2 temp_output_18_0_g4 = ( appendResult20_g4 - temp_cast_0 );
				float4 tex2DNode72_g4 = tex2D( _Ramp, temp_output_18_0_g4 );
				float2 uv_BW_Map = IN.texcoord.xy * _BW_Map_ST.xy + _BW_Map_ST.zw;
				float4 lerpResult61 = lerp( tex2DNode8 , ( ( tex2DNode72_g4 * tex2DNode14_g4.a ) * tex2DNode8 ) , tex2D( _BW_Map, uv_BW_Map ));
				
				half4 color = lerpResult61;
				
				#ifdef UNITY_UI_CLIP_RECT
                color.a *= UnityGet2DClipping(IN.worldPosition.xy, _ClipRect);
                #endif
				
				#ifdef UNITY_UI_ALPHACLIP
				clip (color.a - 0.001);
				#endif

				return color;
			}
		ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18900
270;73;1218;606;974.9578;901.2296;1;True;False
Node;AmplifyShaderEditor.CommentaryNode;59;-1520.146,129.2903;Inherit;False;2147.228;680.1716;Movimiento del texto (similar a una balanza);19;55;19;20;12;13;37;14;57;40;39;38;52;53;42;43;54;51;56;15;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;20;-1446.146,514.4999;Inherit;False;Property;_Speed;Speed;7;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;19;-1470.146,414.4994;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;12;-1272.848,440.8773;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;37;-1051.291,558.7425;Inherit;False;Property;_MaxAngle;MaxAngle;8;0;Create;True;0;0;0;False;0;False;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;13;-1043.264,441.4207;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;-886.8843,438.375;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;63;-1029.259,-833.8325;Inherit;False;1120.216;894.9359;Color;9;27;28;1;29;3;8;4;62;61;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CosOpNode;38;-737.3667,340.2146;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;40;-734.406,490.1874;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SinOpNode;39;-739.8069,653.5549;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;57;-747.111,179.2903;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;28;-947.1566,-158.5267;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;27;-930.7352,-54.89658;Inherit;False;Property;_ColorTime;ColorTime;9;0;Create;True;0;0;0;False;0;False;1;0.83;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;52;-401.8571,633.1107;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;53;-389.8571,314.1106;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;42;-394.1014,201.2072;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;43;-389.3123,514.1525;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;1;-964.0334,-381.8904;Inherit;True;Property;_FlowMap;FlowMap;13;0;Create;True;0;0;0;False;0;False;358a547339ec90444baecb6dcd1c4f75;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;29;-766.2769,-185.5084;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;8;-979.2586,-783.8325;Inherit;True;Property;_TextureSample0;Texture Sample 0;10;0;Create;True;0;0;0;False;0;False;-1;99d47e0230e574a42a6ae83d706a68d9;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;3;-943.4515,-583.811;Inherit;True;Property;_Ramp;Ramp;12;0;Create;True;0;0;0;False;0;False;None;16a16e8c784df874eb0f86adf02f3896;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SimpleAddOpNode;54;8.915463,623.7297;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;51;-21.47512,203.5262;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;62;-579.1838,-660.1462;Inherit;True;Property;_BW_Map;BW_Map;11;0;Create;True;0;0;0;False;0;False;-1;0ee6cc6b5427f404ca07785715b81915;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;4;-594.1326,-406.6431;Inherit;True;UI-Sprite Effect Layer;0;;4;789bf62641c5cfe4ab7126850acc22b8;18,74,1,204,1,191,1,225,0,242,0,237,0,249,0,186,0,177,0,182,0,229,0,92,1,98,0,234,0,126,0,129,1,130,0,31,0;18;192;COLOR;1,1,1,1;False;39;COLOR;1,1,1,1;False;37;SAMPLER2D;;False;218;FLOAT2;0,0;False;239;FLOAT2;0,0;False;181;FLOAT2;0,0;False;75;SAMPLER2D;;False;80;FLOAT;1;False;183;FLOAT2;0,0;False;188;SAMPLER2D;;False;33;SAMPLER2D;;False;248;FLOAT2;0,0;False;233;SAMPLER2D;;False;101;SAMPLER2D;;False;57;FLOAT4;0,0,0,0;False;40;FLOAT;0;False;231;FLOAT;1;False;30;FLOAT;1;False;2;COLOR;0;FLOAT2;172
Node;AmplifyShaderEditor.PosVertexDataNode;56;233.1216,626.462;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;15;227.2578,404.6925;Inherit;True;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LerpOp;61;-174.0424,-781.8188;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;55;461.0816,504.2683;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;274.208,-782.4862;Float;False;True;-1;2;ASEMaterialInspector;0;4;Flow_ShaderText;5056123faa0c79b47ab6ad7e8bf059a4;True;Default;0;0;Default;2;False;True;2;5;False;-1;10;False;-1;0;1;False;-1;0;False;-1;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;True;True;True;True;True;0;True;-9;False;False;False;False;False;False;False;True;True;0;True;-5;255;True;-8;255;True;-7;0;True;-4;0;True;-6;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;False;True;2;False;-1;True;0;True;-11;False;True;5;Queue=Transparent=Queue=0;IgnoreProjector=True;RenderType=Transparent=RenderType;PreviewType=Plane;CanUseSpriteAtlas=True;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;0;;0;0;Standard;0;0;1;True;False;;False;0
WireConnection;12;0;19;0
WireConnection;12;1;20;0
WireConnection;13;0;12;0
WireConnection;14;0;13;0
WireConnection;14;1;37;0
WireConnection;38;0;14;0
WireConnection;39;0;14;0
WireConnection;52;0;40;1
WireConnection;52;1;39;0
WireConnection;53;0;57;2
WireConnection;53;1;38;0
WireConnection;42;0;57;1
WireConnection;42;1;38;0
WireConnection;43;0;39;0
WireConnection;43;1;40;2
WireConnection;29;0;28;0
WireConnection;29;1;27;0
WireConnection;54;0;52;0
WireConnection;54;1;53;0
WireConnection;51;0;42;0
WireConnection;51;1;43;0
WireConnection;4;39;8;0
WireConnection;4;37;3;0
WireConnection;4;33;1;0
WireConnection;4;40;29;0
WireConnection;15;0;51;0
WireConnection;15;1;54;0
WireConnection;61;0;8;0
WireConnection;61;1;4;0
WireConnection;61;2;62;0
WireConnection;55;0;15;0
WireConnection;55;1;56;0
WireConnection;0;0;61;0
WireConnection;0;1;55;0
ASEEND*/
//CHKSM=984E2FBE8F11C6554CE780BFF8BF33BF570A7080