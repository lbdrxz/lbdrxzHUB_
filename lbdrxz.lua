using UnityEngine;

public class TeleportToBase : MonoBehaviour
{
[Tooltip("Base location in world space")]
public Transform baseTransform; // assign a GameObject representing the base in the Inspector

[Tooltip("Seconds between teleports")]
public float cooldown = 5f;

private float lastTeleportTime = -999f;
private CharacterController cc;
private Rigidbody rb;

void Start()
{
cc = GetComponent<CharacterController>();
rb = GetComponent<Rigidbody>();
if (baseTransform == null)
Debug.LogWarning("Base Transform not assigned. Use SetBase() or assign in Inspector.");
}

public void SetBase(Vector3 position, Quaternion rotation)
{
if (baseTransform == null)
{
GameObject go = new GameObject("PlayerBase");
baseTransform = go.transform;
}
baseTransform.position = position;
baseTransform.rotation = rotation;
}

public bool CanTeleport()
{
return Time.time - lastTeleportTime >= cooldown;
}

public void TeleportToBase()
{
if (baseTransform == null)
{
Debug.LogWarning("No base set. Teleport cancelled.");
return;
}
if (!CanTeleport()) return;

lastTeleportTime = Time.time;

// If using CharacterController, disable before moving to avoid unwanted physics jumps
if (cc != null)
{
cc.enabled = false;
transform.position = baseTransform.position;
transform.rotation = baseTransform.rotation;
cc.enabled = true;
}
else if (rb != null)
{
rb.velocity = Vector3.zero;
rb.angularVelocity = Vector3.zero;
rb.position = baseTransform.position;
rb.rotation = baseTransform.rotation;
}
else
{
transform.position = baseTransform.position;
transform.rotation = baseTransform.rotation;
}

// Optional: effects, sounds, camera shake, etc.
}

// Example: press B to teleport
void Update()
{
if (Input.GetKeyDown(KeyCode.B))
{
TeleportToBase();
}
}
}
