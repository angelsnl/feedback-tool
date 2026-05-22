# claude-test

A SvelteKit contact form app backed by PostgreSQL. Submissions are stored as JSONB. Infrastructure is managed with Terraform on UpCloud.

## Stack

- [SvelteKit](https://svelte.dev/docs/kit) + TypeScript
- [Bun](https://bun.sh) runtime (`svelte-adapter-bun`)
- PostgreSQL via [postgres.js](https://github.com/porsager/postgres)
- Terraform (UpCloud managed DB + server, or local PostgreSQL)

## Setup

### 1. Start local PostgreSQL

```sh
bun run db       # initializes db/data on first run, then starts postgres
```

### 2. Configure environment

```sh
cp .env.example .env.docker
# edit .env.docker and set DATABASE_URL
```

### 3. Run migrations

```sh
bun run migrate
```

### 4. Develop

```sh
bun run dev
```

## Scripts

| Script | Description |
|---|---|
| `bun run dev` | Start dev server |
| `bun run build` | Build for production |
| `bun run check` | Type-check with svelte-check |
| `bun run db` | Start local PostgreSQL (data in `db/data/`) |
| `bun run migrate` | Apply pending migrations |
| `bun run docker:build` | Build Docker image |
| `bun run docker:run` | Run Docker image with `.env.docker` |

## Migrations

Migration files live in `migrations/*.sql`, applied in alphabetical order. The runner tracks applied migrations in a `schema_migrations` table.

```sh
# add a new migration
touch migrations/002_add_index.sql
bun run migrate
```

## Terraform

Two profiles:

### UpCloud (production)

Provisions a managed PostgreSQL database and server.

```sh
cd terraform
cp terraform.tfvars.example terraform.tfvars
# fill in credentials
terraform init && terraform apply
terraform output -raw db_service_uri   # use as DATABASE_URL
```

### Local

Creates a database and role on a locally running PostgreSQL instance.

```sh
cd terraform/local
cp terraform.tfvars.example terraform.tfvars
terraform init && terraform apply
terraform output -raw database_url
```

## Docker

The image uses a multi-stage build: Bun installs deps, builds, and runs the app.

```sh
bun run docker:build
bun run docker:run    # reads DATABASE_URL from .env.docker
```

For local development, set `DATABASE_URL` to use `host.docker.internal` instead of `localhost`.
