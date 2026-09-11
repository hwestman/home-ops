{{- if .Node.Data.longhornDisk }}
apiVersion: v1alpha1
kind: UserVolumeConfig
name: longhorn
provisioning:
  diskSelector:
    match: disk.dev_path == "{{ .Node.Data.longhornDisk }}" || "{{ .Node.Data.longhornDisk }}" in disk.symlinks
  minSize: 100GB
{{- end }}
