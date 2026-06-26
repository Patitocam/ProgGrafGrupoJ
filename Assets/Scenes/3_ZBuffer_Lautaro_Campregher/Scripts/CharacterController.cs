using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CharacterController : MonoBehaviour
{
    private Rigidbody rb;

    private float x;
    private float z;

    public float speed = 5f;

    private void Start()
    {
        rb = GetComponent<Rigidbody>();
    }

    private void Update()
    {
        x = Input.GetAxisRaw("Horizontal");
        z = Input.GetAxisRaw("Vertical");

    }

    private void FixedUpdate()
    {
        rb.velocity = new Vector3(x, rb.velocity.y, z).normalized * speed;        
    }
}
