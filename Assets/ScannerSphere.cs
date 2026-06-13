using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ScannerSphere : MonoBehaviour
{
    public float growSpeed = 2f;
    public float maxRadius = 10f;
    private float currentRadius = 0f;
    private bool scanning = false;

    void Update()
    {
        if (Input.GetKeyDown(KeyCode.E)) // activar con una tecla
            scanning = true;

        if (scanning)
        {
            currentRadius += Time.deltaTime * growSpeed;
            transform.localScale = Vector3.one * currentRadius;

            if (currentRadius >= maxRadius)
            {
                currentRadius = 0f;
                scanning = false;
                transform.localScale = Vector3.zero;
            }
        }
    }
}
