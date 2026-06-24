using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.UI;

public class HoverBalanceo : MonoBehaviour, IPointerEnterHandler, IPointerExitHandler
{
    [SerializeField] private float anguloHover = 0.2f;   // cuánto se inclina en hover (radianes)
    [SerializeField] private float suavidad = 8f;        // velocidad de entrada/salida

    private Material mat;
    private float target = 0f;
    private static readonly int AngleID = Shader.PropertyToID("_MaxAngle");

    void Awake()
    {
        var img = GetComponent<Image>();
        mat = Instantiate(img.material);   // copia propia
        img.material = mat;
        mat.SetFloat(AngleID, 0f);         // arranca derecho
    }

    public void OnPointerEnter(PointerEventData e) => target = anguloHover;
    public void OnPointerExit(PointerEventData e)  => target = 0f;

    void Update()
    {
        float actual = mat.GetFloat(AngleID);
        mat.SetFloat(AngleID, Mathf.Lerp(actual, target, Time.deltaTime * suavidad));
    }
}