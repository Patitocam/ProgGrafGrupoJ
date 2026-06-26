using UnityEngine;

public class SpawnObjetos : MonoBehaviour
{
    public GameObject[] prefabs;    // Lista de prefabs posibles a spawnear
    public Material[] materiales;   // Materiales que se asignan aleatoriamente
    public int cantidad = 50;       // Cantidad de objetos a generar

    private GameObject[] objetos;

    void Start()
    {
        objetos = new GameObject[cantidad];
        Repoblar();   // Genera los objetos al iniciar
    }

    public void Repoblar()
    {
        // Destruye los objetos existentes antes de generar nuevos
        if (objetos != null)
            foreach (var obj in objetos)
                if (obj != null) Destroy(obj);

        objetos = new GameObject[cantidad];

        for (int i = 0; i < cantidad; i++)
        {
            int prefabIndex = Random.Range(0, prefabs.Length);
            objetos[i] = Instantiate(prefabs[prefabIndex]);

            // Posición y escala aleatoria dentro de un rango
            objetos[i].transform.position = new Vector3(Random.Range(-8f, 8f), Random.Range(-4f, 4f), 5f);
            objetos[i].transform.localScale = Vector3.one * Random.Range(0.3f, 1.2f);

            // Material aleatorio
            objetos[i].GetComponent<Renderer>().material = materiales[Random.Range(0, materiales.Length)];
        }
    }

    void Update()
    {
        // Rota todos los objetos continuamente
        foreach (var obj in objetos)
            if (obj != null)
                obj.transform.Rotate(0, 50f * Time.deltaTime, 30f * Time.deltaTime);
    }
}