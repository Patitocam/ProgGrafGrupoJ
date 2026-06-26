using UnityEngine;

public class Controlador : MonoBehaviour
{
    [SerializeField] private Rigidbody rb;
    [SerializeField] private float speed;

    private float moveX;
    private float moveY;

    void Update()
    {
        // Lee el input del teclado (WASD o flechas)
        moveX = Input.GetAxisRaw("Horizontal");
        moveY = Input.GetAxisRaw("Vertical");
    }

    void FixedUpdate()
    {
        Vector3 movement = new Vector3(moveX, moveY).normalized;

        // Si se mantiene Shift, se mueve al doble de velocidad
        if (Input.GetKey(KeyCode.LeftShift))
            rb.velocity = new Vector3(movement.x * speed * 2, movement.y * speed * 2);
        else
            rb.velocity = new Vector3(movement.x * speed, movement.y * speed);
    }
}