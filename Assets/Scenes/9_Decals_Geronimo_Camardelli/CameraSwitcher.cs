using UnityEngine;

public class CameraSwitcher : MonoBehaviour
{
    public GameObject camara1;
    public GameObject camara2;

    void Start()
    {
        camara1.SetActive(true);
        camara2.SetActive(false);
    }

    void Update()
    {
        if (Input.GetKeyDown(KeyCode.Alpha1))
        {
            camara1.SetActive(true);
            camara2.SetActive(false);
        }

        if (Input.GetKeyDown(KeyCode.Alpha2))
        {
            camara1.SetActive(false);
            camara2.SetActive(true);
        }
    }
}