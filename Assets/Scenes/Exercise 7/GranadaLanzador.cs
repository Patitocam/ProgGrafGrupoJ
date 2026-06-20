using UnityEngine;

public class GranadaLanzador : MonoBehaviour
{
    [SerializeField] GameObject granadaPrefab;
    [SerializeField] float throwForce = 8f;

    void Update()
    {
        if (Input.GetKeyDown(KeyCode.E))
            Lanzar();
    }

    void Lanzar()
    {
        // Spawnea levemente adelante y arriba del player
        Vector3 spawnPos = transform.position + transform.forward * 0.5f + Vector3.up * 1.2f;
        GameObject g = Instantiate(granadaPrefab, spawnPos, Quaternion.identity);

        // Evita colisionar con el propio player
        Physics.IgnoreCollision(g.GetComponent<Collider>(), GetComponent<Collider>());

        // Lanzar hacia adelante con arco hacia arriba
        Vector3 dir = (transform.forward + Vector3.up * 0.5f).normalized;
        g.GetComponent<Rigidbody>().velocity = dir * throwForce;
    }
}