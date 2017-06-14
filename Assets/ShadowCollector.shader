﻿Shader "Hidden/Shadow Collector"
{
    SubShader
    {
        ZTest always
        ZWrite off

        Pass
        {
            Tags { "LightMode" = "ForwardBase" }

            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            float4 vert(float4 vertex : POSITION) : SV_POSITION
            {
                return float4(vertex.xy * float2(2, -2), 0, 1);
            }

            fixed4 frag() : SV_Target
            {
                return 0;
            }

            ENDCG

        }

        Pass
        {
            Tags { "LightMode" = "ForwardAdd" }

            Blend One One

            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            #pragma multi_compile_fwdadd_fullshadows
            #pragma skip_variants DIRECTIONAL SHADOWS_SCREEN POINT_COOKIE DIRECTIONAL_COOKIE

            #include "UnityCG.cginc"
            #include "Lighting.cginc"
            #include "AutoLight.cginc"

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float3 worldPos : TEXCOORD0;
            };

            v2f vert(float4 vertex : POSITION)
            {
                v2f o;
                o.vertex = float4(vertex.xy * float2(2, -2), 0, 1);
                o.worldPos = mul(unity_ObjectToWorld, vertex).xyz;
                return o;
            }

            half4 frag(v2f IN) : SV_Target
            {
                UNITY_LIGHT_ATTENUATION(atten, IN, IN.worldPos)
                return half4(_LightColor0.rgb * atten, 1);
            }

            ENDCG
        }
    }
}
