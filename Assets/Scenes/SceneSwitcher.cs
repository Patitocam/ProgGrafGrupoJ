using UnityEngine;
using UnityEngine.SceneManagement;

public class SceneSwitcher : MonoBehaviour
{
    private static SceneSwitcher instancia;

    void Awake()
    {
        // Si ya existe uno, este se destruye (evita duplicados al volver a la escena 0)
        if (instancia != null)
        {
            Destroy(gameObject);
            return;
        }

        instancia = this;
        DontDestroyOnLoad(gameObject);
    }

    void Update()
    {
        if (Input.GetKeyDown(KeyCode.P))
            CambiarEscena(1);

        if (Input.GetKeyDown(KeyCode.O))
            CambiarEscena(-1);
    }

    void CambiarEscena(int direccion)
    {
        int total = SceneManager.sceneCountInBuildSettings;
        int actual = SceneManager.GetActiveScene().buildIndex;
        int siguiente = (actual + direccion + total) % total;
        SceneManager.LoadScene(siguiente);
    }
}