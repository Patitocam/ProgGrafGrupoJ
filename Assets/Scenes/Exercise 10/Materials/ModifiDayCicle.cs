using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ModifiDayCicle : MonoBehaviour
{
    public enum SpinAxis { Horizontal, Vertical }

    [SerializeField] private GameObject directionalLight;
    [SerializeField] private Projector projector;

    [SerializeField] private float currentRotation;
    [SerializeField] private Material windowMaterial;

    [SerializeField] private Color lightColor;
    [SerializeField] private Color darkColor;

    [SerializeField] private float rotationSpeed = 10f;
    public SpinAxis spinAxis = SpinAxis.Vertical;

    private float currentAngle = 0f;
    private Quaternion baseRotation;

    void Awake()
    {
        baseRotation = projector.transform.localRotation;
    }

    void Update()
    {
        currentAngle += rotationSpeed * Time.deltaTime;

        if (currentAngle >= 360f)
        {
            currentAngle -= 360f;
        }

        Vector3 axis = (spinAxis == SpinAxis.Vertical) ? Vector3.right : Vector3.up;

        projector.transform.localRotation = baseRotation * Quaternion.AngleAxis(currentAngle, axis);
        directionalLight.transform.localRotation = baseRotation * Quaternion.AngleAxis(currentAngle, axis);

        float t = Mathf.PingPong(currentAngle, 180f) / 180f;

        Color blended = Color.Lerp(lightColor, darkColor, t);

        if (windowMaterial != null)
            windowMaterial.SetColor("_LightColor", blended);

        if (projector != null)
            projector.material = windowMaterial;
    }

    public Color GetColorForAngle(float angleDegrees)
    {
        float normalizedAngle = Mathf.Repeat(angleDegrees, 360f);
        float t = Mathf.PingPong(normalizedAngle, 180f) / 180f;
        return Color.Lerp(lightColor, darkColor, t);
    }
        
}
