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
}
