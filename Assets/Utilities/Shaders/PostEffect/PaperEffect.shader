// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Unity Shaders Book/PaperEffect" {
	Properties{
		_MainTex("Base (RGB)", 2D) = "white" {}
		_BlendTex("Blend (RGB)", 2D) = "white" {}
		_BlendTex2("Blend2 (RGB)", 2D) = "white" {}
		_Mixed("Mixed", Float) = 1
	}
		SubShader{
			Pass {
				ZTest Always Cull Off ZWrite Off

				CGPROGRAM
				#pragma vertex vert  
				#pragma fragment frag  

				#include "UnityCG.cginc"  

				sampler2D _MainTex;
				sampler2D _BlendTex;
				sampler2D _BlendTex2;
				half _Mixed;

				struct v2f {
					float4 pos : SV_POSITION;
					half2 uv: TEXCOORD0;
				};

				v2f vert(appdata_img v) {
					v2f o;

					o.pos = UnityObjectToClipPos(v.vertex);

					o.uv = v.texcoord;

					return o;
				}

				fixed4 frag(v2f i) : SV_Target {
					fixed4 renderTex = tex2D(_MainTex, i.uv);
					fixed4 blendTex = tex2D(_BlendTex, i.uv);
					fixed4 blendTex2 = tex2D(_BlendTex2, i.uv);
				// Apply brightness
				//fixed3 finalColor = renderTex.rgb * blendTex.rgb;
				fixed3 tempColor = renderTex.rgb * blendTex.rgb;
				fixed3 finalColor = tempColor.rgb * _Mixed + blendTex2.rgb * (1 - _Mixed);


				return fixed4(finalColor, renderTex.a);
			}

			ENDCG
		}
		}

			Fallback Off
}
