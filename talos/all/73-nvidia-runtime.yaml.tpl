{{- if .Node.Data.kernelModules }}
apiVersion: v1alpha1
kind: CRICustomizationConfig
name: nvidia-runtime
content: |
  [plugins."io.containerd.cri.v1.runtime".containerd]
    default_runtime_name = "nvidia"
{{- end }}
