using UnityEngine;

public class ChangeCanvas : MonoBehaviour
{
    [SerializeField] private GameObject menuCanvas;
    [SerializeField] private GameObject loadingCanvas;

    public void GoToLoading()
    {
        menuCanvas.SetActive(false);
        loadingCanvas.SetActive(true);
    }

    public void GoToMenu()
    {
        loadingCanvas.SetActive(false);
        menuCanvas.SetActive(true);
    }

    private void Update()
    {
        if (loadingCanvas.activeSelf && Input.GetKeyDown(KeyCode.Escape))
        {
            GoToMenu();
        }
    }
}