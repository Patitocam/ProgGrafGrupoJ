using UnityEngine;
using System.Collections;

public class GranadaScanner : MonoBehaviour
{
    [SerializeField] float growSpeed = 6f;
    [SerializeField] float maxRadius = 40f;
    [SerializeField] float delayAfterLanding = 2f;

    bool expanding = false;
    bool landed = false;
    float currentRadius = 0f;
    Rigidbody rb;
    SphereCollider col;

    void Start()
    {
        rb = GetComponent<Rigidbody>();
        col = GetComponent<SphereCollider>();
        transform.localScale = Vector3.one * 0.4f; // visible mientras vuela
    }

    void OnCollisionEnter(Collision other)
    {
        if (landed) return;
        landed = true;
        StartCoroutine(EsperarYExpandir());
    }

    IEnumerator EsperarYExpandir()
    {
        yield return new WaitForSeconds(delayAfterLanding); // rebota 2 segundos

        rb.velocity = Vector3.zero;
        rb.angularVelocity = Vector3.zero;
        rb.isKinematic = true;
        col.isTrigger = true;

        expanding = true;
        currentRadius = 0f;
    }

    void OnTriggerEnter(Collider other)
    {
        if (!expanding || !other.CompareTag("Enemigo")) return;

        Transform efecto = other.transform.Find("DetectionEffect");
        if (efecto != null)
            StartCoroutine(MarcarEnemigo(efecto.gameObject));
    }

    IEnumerator MarcarEnemigo(GameObject efecto)
    {
        efecto.SetActive(true);
        yield return new WaitForSeconds(30f);
        efecto.SetActive(false);
    }

    void Update()
    {
        if (!expanding) return;

        currentRadius += Time.deltaTime * growSpeed;
        transform.localScale = Vector3.one * currentRadius;

        if (currentRadius >= maxRadius)
        {
            expanding = false;
            Destroy(gameObject);
        }
    }
}