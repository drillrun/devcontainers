
# easy-container-hooks (easy-container-hooks)

Shell runner that executes hooks in your .devcontainer/hooks/ directory.

## Example Usage

```json
"features": {
    "ghcr.io/drillrun/devcontainers/features/easy-container-hooks:1": {}
}
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| hooksDir | - | string | .devcontainer/hooks |
| onCreateHookPath | - | string | on-create |
| postAttachHookPath | - | string | post-attach |
| postCreateHookPath | - | string | post-create |
| postStartHookPath | - | string | post-start |
| updateContentHookPath | - | string | update-content |
| recurseWorkspaceFolderHooks | Run hooks from other repositories in the workspace folder. | string | true |



---

_Note: This file was auto-generated from the [devcontainer-feature.json](https://github.com/drillrun/devcontainers/blob/main/features/src//easy-container-hooks/devcontainer-feature.json).  Add additional notes to a `NOTES.md`._
