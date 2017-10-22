version: '2'
services:
  mysql-data:
    image: busybox
    labels:
      io.rancher.container.start_once: true
{{- if ne .Values.host_affinity ""}}
      io.rancher.scheduler.affinity:host_label: ${host_affinity}
{{- end}}
    volumes:
{{- if ne .Values.data_dir ""}}
      - ${data_dir}:/var/lib/mysql
{{- else }}
      - /var/lib/mysql
{{- end}}

  mysql:
    image: ${mysql_image}
    environment:
{{- if eq .Values.mysql_allow_empty_password "yes"}}
      MYSQL_ALLOW_EMPTY_PASSWORD: ${mysql_allow_empty_password}
{{- end}}
{{- if (.Values.mysql_database)}}
      MYSQL_DATABASE: ${mysql_database}
{{- end}}
{{- if eq .Values.mysql_onetime_password "yes"}}
      MYSQL_ONETIME_PASSWORD: ${mysql_onetime_password}
{{- end}}
{{- if (.Values.mysql_password)}}
      MYSQL_PASSWORD: ${mysql_password}
{{- end}}
{{- if eq .Values.mysql_random_root_password "yes"}}
      MYSQL_RANDOM_ROOT_PASSWORD: ${mysql_random_root_password}
{{- end}}
      MYSQL_ROOT_PASSWORD: ${mysql_root_password}
{{- if (.Values.mysql_user)}}
      MYSQL_USER: ${mysql_user}
{{- end}}
    tty: true
    stdin_open: true
    labels:
      io.rancher.sidekicks: mysql-data
{{- if ne .Values.host_affinity ""}}
      io.rancher.scheduler.affinity:host_label: ${host_affinity}
{{- end}}
    volumes_from:
      - mysql-data

  adminer:
    image: 'clue/adminer:latest'
    restart: on-failure
    labels:
{{- if ne .Values.host_affinity ""}}
      io.rancher.scheduler.affinity:host_label: ${host_affinity}
{{- end}}
    links:
      - mysql:db


volumes:
  mysqldata:
    driver: ${VOLUME_DRIVER}
    per_container: true
