version: '2'
services:
  pgweb:
    image: moritanosuke/docker-pgweb
    labels:
      POSTGRES_DB: ${postgres_db}
      POSTGRES_USER: ${postgres_user}
      POSTGRES_PASSWORD: ${postgres_password}
      POSTGRES=postgres
      PORT=5432
      SSL=disable

  postgres-data:
    image: busybox
    labels:
      io.rancher.container.start_once: true
    {{- if ne .Values.host_label ""}}
      io.rancher.scheduler.affinity:host_label: ${host_label}
    {{- end}}
    volumes:
      - pgdata:/var/lib/postgresql/data/pgdata

  postgres:
    image: postgres:${POSTGRES_TAG}
    environment:
      PGDATA: /var/lib/postgresql/data/pgdata
      POSTGRES_DB: ${postgres_db}
      POSTGRES_USER: ${postgres_user}
      POSTGRES_PASSWORD: ${postgres_password}
    tty: true
    stdin_open: true
    labels:
      io.rancher.sidekicks: postgres-data
    {{- if ne .Values.host_label ""}}
      io.rancher.scheduler.affinity:host_label: ${host_label}
    {{- end}}
    volumes_from:
      - postgres-data
volumes:
  pgdata:
    driver: ${VOLUME_DRIVER}
    per_container: true
