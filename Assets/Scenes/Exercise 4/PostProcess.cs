using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(Camera))]
public class PostProcess : MonoBehaviour
{
    [SerializeField] private Shader takeDamage;
    [SerializeField] private Shader heal;
    private Material healMaterial;
    private Material takeDamageMaterial;
    private Material current;

    float timer = 0.5f;

    private void Awake()
    {
        healMaterial = new Material(heal);
        takeDamageMaterial = new Material(takeDamage);
    }

    private void Update()
    {
        timer -= Time.deltaTime;
        if (timer < 0) 
        {
            current = null;
        }

        if (Input.GetKeyDown(KeyCode.T)) 
        {
            current = takeDamageMaterial;
            timer = 0.5f;
        }
        if (Input.GetKeyDown(KeyCode.H))
        {
            current = healMaterial;
            timer = 0.5f;
        }
    }
    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        if ( current != null)
        {
            Graphics.Blit(source, destination, current);
        }
        else Graphics.Blit(source, destination);
    }
}
