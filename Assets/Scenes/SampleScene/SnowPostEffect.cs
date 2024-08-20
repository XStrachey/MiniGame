using UnityEngine;
using System.Collections;
[ExecuteInEditMode]
public class SnowPostEffect : PostEffectsBase
{

    public Shader shader;
    private Material _material = null;
    public Material material
    {
        get
        {
            _material = CheckShaderAndCreateMaterial(shader, _material);
            return _material;
        }
    }


    public Texture2D SnowTexture;
    public Color SnowColor = Color.white;


    [Range(0, 1)]
    public float _SnowButtom = 0f;
    [Range(0, 10)]
    public float _SnowScale = 1f;


    void OnEnable()
    {
        GetComponent<Camera>().depthTextureMode |= DepthTextureMode.DepthNormals;
    }


    void OnRenderImage(RenderTexture src, RenderTexture dest)
    {
        if (material != null)
        {

            // set shader properties
            _material.SetMatrix("_CamToWorld", GetComponent<Camera>().cameraToWorldMatrix);
            _material.SetColor("_SnowColor", SnowColor);
            _material.SetFloat("_SnowButtom", _SnowButtom);
            _material.SetFloat("_SnowScale", _SnowScale);
            _material.SetTexture("_SnowTex", SnowTexture);

            Graphics.Blit(src, dest, material);
        }
        else
        {
            Graphics.Blit(src, dest);
        }
    }

}