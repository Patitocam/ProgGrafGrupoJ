using UnityEngine;
using System.Collections;
using System.Collections.Generic;

[RequireComponent(typeof(Camera))]
public class PostProcess : MonoBehaviour
{
    [SerializeField] private Shader takeDamage;
    [SerializeField] private Shader heal;
    [SerializeField] private Shader drunk;

    private Material healMaterial;
    private Material takeDamageMaterial;
    private Material drunkMaterial;
    private Material current;

    float timer = 0.5f;

    [SerializeField] private float drunkDuration = 10f;
    private Coroutine drunkRoutine;
    private static readonly int VignetteProgressID = Shader.PropertyToID("_VignetteProgress");

    private void Awake()
    {
        healMaterial = new Material(heal);
        takeDamageMaterial = new Material(takeDamage);
        drunkMaterial = new Material(drunk);
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
            timer = 0.2f;
        }
        if (Input.GetKeyDown(KeyCode.H))
        {
            current = healMaterial;
            timer = 2f;
        }
        if (Input.GetKeyDown(KeyCode.D))
        {
            current = drunkMaterial;
            timer = drunkDuration;

            if (drunkRoutine != null) StopCoroutine(drunkRoutine);
            drunkRoutine = StartCoroutine(AnimateVignette());
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


    private IEnumerator AnimateVignette()
    {
        drunkMaterial.SetFloat(VignetteProgressID, 0f);

        float openDuration = 1f; 
        float elapsed = 0f;

        while (elapsed < openDuration)
        {
            elapsed += Time.deltaTime;
            float t = Mathf.Clamp01(elapsed / openDuration);
            drunkMaterial.SetFloat(VignetteProgressID, t);
            yield return null;
        }

        drunkMaterial.SetFloat(VignetteProgressID, 1f);
    }
}
