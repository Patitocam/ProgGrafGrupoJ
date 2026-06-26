using UnityEngine;

[RequireComponent(typeof(Camera))]
public class PostProcessBinoculares : MonoBehaviour
{
    public Shader shader;        // Shader del efecto binocular
    private Material material;

    void Awake()
    {
        material = new Material(shader);   // Crea el material con el shader al iniciar
    }

    // Se llama automáticamente después de renderizar la cámara
    // Aplica el shader como post-proceso sobre la imagen final
    void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        Graphics.Blit(source, destination, material);
    }
}