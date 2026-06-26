// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "S_Water"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_Pow("Pow", Range( 0 , 2)) = 0
		_Color0("Color 0", Color) = (0,0.7253882,0.8396226,0)
		_Float0("Float 0", Float) = 2.77
		_Scale("Scale", Range( 0 , 1)) = 0
		_WaveFrequency("WaveFrequency", Float) = 5
		_Bias("Bias", Range( 0 , 1)) = 0
		_Speed("Speed", Float) = 2
		_WaveHeight("WaveHeight", Float) = 0.1
		_WaterLevel("WaterLevel", Range( 0 , 1)) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		ZWrite On
		ZTest LEqual
		Offset  0 , 0
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#include "Tessellation.cginc"
		#pragma target 4.6
		#pragma surface surf Unlit keepalpha noshadow vertex:vertexDataFunc tessellate:tessFunction 
		struct Input
		{
			float2 uv_texcoord;
			float4 screenPos;
		};

		uniform float _WaveFrequency;
		uniform float _Speed;
		uniform float _WaveHeight;
		uniform float4 _Color0;
		uniform float _Float0;
		UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
		uniform float4 _CameraDepthTexture_TexelSize;
		uniform float _Bias;
		uniform float _Scale;
		uniform float _Pow;
		uniform float _WaterLevel;
		uniform float _Cutoff = 0.5;


		float2 voronoihash47( float2 p )
		{
			p = p - 6 * floor( p / 6 );
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi47( float2 v, float time, inout float2 id, inout float2 mr, float smoothness )
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
			 		float2 o = voronoihash47( n + g );
					o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = f - g - o;
					float d = 0.5 * ( abs(r.x) + abs(r.y) );
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


		float4 tessFunction( appdata_full v0, appdata_full v1, appdata_full v2 )
		{
			return UnityEdgeLengthBasedTess (v0.vertex, v1.vertex, v2.vertex, 1.0);
		}

		void vertexDataFunc( inout appdata_full v )
		{
			float3 ase_vertex3Pos = v.vertex.xyz;
			float4 appendResult20 = (float4(0.0 , 0.0 , ( (0.0 + (ase_vertex3Pos.y - -1.0) * (1.0 - 0.0) / (1.0 - -1.0)) * ( sin( ( ( ase_vertex3Pos.x * _WaveFrequency ) + ( _Time.y * _Speed ) ) ) * _WaveHeight ) ) , 0.0));
			v.vertex.xyz += appendResult20.xyz;
			v.vertex.w = 1;
		}

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float time47 = _Time.y;
			float2 coords47 = i.uv_texcoord * _Float0;
			float2 id47 = 0;
			float2 uv47 = 0;
			float fade47 = 0.5;
			float voroi47 = 0;
			float rest47 = 0;
			for( int it47 = 0; it47 <2; it47++ ){
			voroi47 += fade47 * voronoi47( coords47, time47, id47, uv47, 0 );
			rest47 += fade47;
			coords47 *= 2;
			fade47 *= 0.5;
			}//Voronoi47
			voroi47 /= rest47;
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float screenDepth49 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy ));
			float distanceDepth49 = abs( ( screenDepth49 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( 1.0 ) );
			o.Emission = ( ( _Color0 + voroi47 ) + saturate( ( 1.0 - pow( ( ( distanceDepth49 + _Bias ) * _Scale ) , _Pow ) ) ) ).rgb;
			o.Alpha = 1;
			clip( step( i.uv_texcoord.y , _WaterLevel ) - _Cutoff );
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
363;73;1101;564;1214.684;29.91263;1;True;False
Node;AmplifyShaderEditor.CommentaryNode;77;-2019.903,530.5906;Inherit;False;1577.002;606.1657;Wave Movement;13;4;3;1;6;2;5;9;10;12;13;14;20;11;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleTimeNode;4;-1891.904,894.7225;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;1;-1946.903,640.7225;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;6;-1862.904,984.2213;Inherit;False;Property;_Speed;Speed;7;0;Create;True;0;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;3;-1969.903,813.7233;Inherit;False;Property;_WaveFrequency;WaveFrequency;5;0;Create;True;0;0;0;False;0;False;5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;82;-1682.241,-277.9254;Inherit;False;1244.038;402.997;Refraction;9;56;49;51;53;55;57;50;54;52;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;5;-1704.902,953.2214;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;50;-1632.241,-68.82123;Inherit;False;Property;_Bias;Bias;6;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.DepthFade;49;-1602.069,-174.4508;Inherit;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;2;-1747.902,726.723;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;51;-1349.069,-174.4508;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;9;-1532.612,803.832;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;52;-1521.331,9.072077;Inherit;False;Property;_Scale;Scale;4;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;53;-1185.069,-173.4508;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;81;-1353.958,-870.9774;Inherit;False;914.4614;561.2906;Water Colour;6;44;45;46;48;47;73;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;54;-1320.947,-68.98981;Inherit;False;Property;_Pow;Pow;1;0;Create;True;0;0;0;False;0;False;0;0;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;10;-1321.726,804.7955;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;12;-1329.472,1020.756;Inherit;False;Property;_WaveHeight;WaveHeight;8;0;Create;True;0;0;0;False;0;False;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;13;-1539.083,580.5904;Inherit;True;5;0;FLOAT;0;False;1;FLOAT;-1;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;55;-1035.069,-172.4508;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;45;-1289.392,-528.8496;Inherit;False;Property;_Float0;Float 0;3;0;Create;True;0;0;0;False;0;False;2.77;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;-1124.538,803.5087;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;44;-1303.958,-610.9373;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;-907.9693,725.2457;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;57;-867.6429,-171.8759;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;78;-1171.583,161.6088;Inherit;False;732.6104;330.9648;Wave Height;3;40;21;41;;1,1,1,1;0;0
Node;AmplifyShaderEditor.VoronoiNode;47;-1122.756,-635.2427;Inherit;True;0;2;1;0;2;True;6;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.ColorNode;46;-917.6991,-820.9777;Inherit;False;Property;_Color0;Color 0;2;0;Create;True;0;0;0;False;0;False;0,0.7253882,0.8396226,0;0,0.7253882,0.8396226,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;48;-674.4973,-658.1405;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.DynamicAppendNode;20;-681.8996,675.4628;Inherit;True;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SaturateNode;56;-636.2034,-227.9254;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;21;-1121.583,376.5736;Inherit;False;Property;_WaterLevel;WaterLevel;9;0;Create;True;0;0;0;False;0;False;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;40;-1084.11,259.1814;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;73;-936.2196,-563.6871;Inherit;True;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.EdgeLengthTessNode;19;-251.7466,186.2867;Inherit;False;1;0;FLOAT;1;False;1;FLOAT4;0
Node;AmplifyShaderEditor.StepOpNode;41;-826.5482,211.6088;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;87;-316.7662,170.601;Inherit;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleAddOpNode;76;-309.3195,-247.9012;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;72;-41.48838,-190.8726;Float;False;True;-1;6;ASEMaterialInspector;0;0;Unlit;S_Water;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;1;False;-1;3;False;-1;True;0;False;-1;0;False;-1;False;0;Custom;0.5;True;False;0;True;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;5;0;4;0
WireConnection;5;1;6;0
WireConnection;2;0;1;1
WireConnection;2;1;3;0
WireConnection;51;0;49;0
WireConnection;51;1;50;0
WireConnection;9;0;2;0
WireConnection;9;1;5;0
WireConnection;53;0;51;0
WireConnection;53;1;52;0
WireConnection;10;0;9;0
WireConnection;13;0;1;2
WireConnection;55;0;53;0
WireConnection;55;1;54;0
WireConnection;11;0;10;0
WireConnection;11;1;12;0
WireConnection;14;0;13;0
WireConnection;14;1;11;0
WireConnection;57;0;55;0
WireConnection;47;1;44;0
WireConnection;47;2;45;0
WireConnection;48;0;46;0
WireConnection;48;1;47;0
WireConnection;20;2;14;0
WireConnection;56;0;57;0
WireConnection;73;0;47;0
WireConnection;41;0;40;2
WireConnection;41;1;21;0
WireConnection;87;0;20;0
WireConnection;76;0;48;0
WireConnection;76;1;56;0
WireConnection;72;2;76;0
WireConnection;72;10;41;0
WireConnection;72;11;87;0
WireConnection;72;14;19;0
ASEEND*/
//CHKSM=2AC1B13F2F8A5F0414F0680435E646CBBE663F88