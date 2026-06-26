using UnityEngine;
using UnityEngine.UI;
using System.Collections;

public class Captura : MonoBehaviour
{
    public RenderTexture rt;       // Textura donde se guarda la captura
    public RawImage rawImage;      // Imagen UI que muestra la captura
    public SpawnObjetos spawner;   // Referencia al spawner para repoblar objetos
    public Canvas canva;           // Canvas que se oculta al sacar la captura

    void Start()
    {
        LimpiarRenderTexture();    // Limpia la textura al iniciar
    }

    void Update()
    {
        // Al presionar Space, oculta el canvas y saca la captura
        if (Input.GetKeyDown(KeyCode.Space))
        {
            canva.gameObject.SetActive(false);
            StartCoroutine(HacerCaptura());
        }
    }

    IEnumerator HacerCaptura()
    {
        yield return new WaitForEndOfFrame();              // Espera a que el frame termine de renderizar
        ScreenCapture.CaptureScreenshotIntoRenderTexture(rt); // Captura la pantalla en la RenderTexture
        rawImage.uvRect = new Rect(0, 1, 1, -1);          // Corrige la imagen que sale invertida verticalmente
        spawner.Repoblar();                                // Genera nuevos objetos en la escena
        canva.gameObject.SetActive(true);                  // Vuelve a mostrar el canvas
    }

    public void LimpiarRenderTexture()
    {
        RenderTexture prev = RenderTexture.active;
        RenderTexture.active = rt;
        GL.Clear(true, true, Color.clear);                 // Limpia la textura para que no quede la imagen anterior
        RenderTexture.active = prev;
        rawImage.uvRect = new Rect(0, 0, 1, 1);           // Resetea el UV a normal
    }
}