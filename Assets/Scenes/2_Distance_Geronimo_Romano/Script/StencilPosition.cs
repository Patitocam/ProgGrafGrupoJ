using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class StencilPosition : MonoBehaviour
{
    public Material matReader;

    void Update()
    {
        float velocidad = 5f;

        // Lee el input de movimiento
        float x = Input.GetAxis("Horizontal");

        // Mueve el objeto en el plano X
        transform.position += new Vector3(x, 0, 0) * velocidad * Time.deltaTime;

        
    }
}