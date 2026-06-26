// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "StencilReader"
{
	Properties
	{
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IgnoreProjector" = "True" }
		Cull Back
		ZWrite On
		ZTest LEqual
		Stencil
		{
			Ref 1
			Comp NotEqual
			Pass Keep
			Fail Keep
			ZFail Keep
		}
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			half filler;
		};

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float4 color1 = IsGammaSpace() ? float4(0.9509299,1,0,0) : float4(0.8919831,1,0,0);
			o.Albedo = color1.rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
181;73;1321;510;517.0103;411.3083;1;True;False
Node;AmplifyShaderEditor.ColorNode;1;-25.06221,-242.4452;Inherit;False;Constant;_Color0;Color 0;0;0;Create;True;0;0;0;False;0;False;0.9509299,1,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;182.667,-315.7703;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;StencilReader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;1;False;-1;3;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;True;1;False;-1;255;False;-1;255;False;-1;6;False;-1;1;False;-1;1;False;-1;1;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.CommentaryNode;21;113.0687,-407.2061;Inherit;False;337.006;100;Se renderiza despues / Queue = Geometry;0;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;22;46.89808,-355.149;Inherit;False;471.006;100;Ref 1 / Comp NotEqual = solo dibuja donde no esta la Esfera;0;;1,1,1,1;0;0
WireConnection;0;0;1;0
ASEEND*/
//CHKSM=998B887D53752E12ABDDBD6E35D77A56C797393F