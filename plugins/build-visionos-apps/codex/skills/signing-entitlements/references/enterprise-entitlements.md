# Enterprise Entitlements

Use this file when the app depends on managed ARKit capabilities.

Enterprise ARKit APIs require a managed entitlement issued by Apple. A build
can still succeed without them, but the provider will fail authorization at
runtime.

Confirm the entitlement is present in the provisioning profile, not only in the
project capability pane.

- `com.apple.developer.arkit.main-camera-access.allow`
- `com.apple.developer.arkit.object-tracking-parameter-adjustment.allow`
- `com.apple.developer.arkit.scene-understanding.allow`
- `com.apple.developer.arkit.barcode-detection.allow`
