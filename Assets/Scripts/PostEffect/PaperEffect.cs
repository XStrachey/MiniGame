using UnityEngine;
using System.Collections;

public class PaperEffect : PostEffectsBase
{

    public Shader paperShader;
    private Material paperMaterial;
    public Material material
    {
        get
        {
            paperMaterial = CheckShaderAndCreateMaterial(paperShader, paperMaterial);
            return paperMaterial;
        }
    }

    public Material material2
    {
        get
        {
            paperMaterial = CheckShaderAndCreateMaterial(paperShader, paperMaterial);
            return paperMaterial;
        }
    }

    public Texture2D blendTex;
    public Texture2D blendTex2;
    [Range(0.0f, 1.0f)]
    public float mixed = 0.6f;

    void OnRenderImage(RenderTexture src, RenderTexture dest)
    {
        if (material != null)
        {
            material.SetTexture("_BlendTex", blendTex);
            material.SetFloat("_Mixed", mixed);
            material2.SetTexture("_BlendTex2", blendTex2);
            Graphics.Blit(src, dest, material);
        }
        else
        {
            Graphics.Blit(src, dest);
        }
    }
}
