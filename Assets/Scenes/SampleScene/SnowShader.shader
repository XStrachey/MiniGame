Shader "Hidden/SnowImageEffectShader_Simple"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
	}
		SubShader
	{
		// No culling or depth
		Cull Off ZWrite Off ZTest Always

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			v2f vert(appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}

			sampler2D _MainTex;

			sampler2D _CameraDepthNormalsTexture; //深度纹理
			float4x4 _CamToWorld;  //摄像机空间 到 世界空间的变换

			sampler2D _SnowTex;
			half4 _SnowColor;

			fixed _SnowButtom;  // 积雪的阈值设置
			fixed _SnowScale;


			fixed4 frag(v2f i) : SV_Target
			{

				half3 normal;
				float depth;

				float2 uv = float2(i.uv.x, i.uv.y);

				//获取像素的世界坐标空间的法线
				DecodeDepthNormal(tex2D(_CameraDepthNormalsTexture, uv), depth, normal);
				normal = mul((float3x3)_CamToWorld, normal);

				//计算积雪阈值
				half snowAmount = normal.g * _SnowScale;
				if (snowAmount < _SnowButtom)
				{
					snowAmount = 0;
				}

				//原本的贴图采样
				half3 snowColor = tex2D(_SnowTex, uv) * _SnowColor;

				half4 col = tex2D(_MainTex, i.uv);
				return lerp(col,  half4(snowColor,1), snowAmount);

			}
			ENDCG
		}
	}
}