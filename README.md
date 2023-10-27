# Pnpm mono skaffold

## pplication

- server

  - nestjs
  - postgres (Prisma)

- client
  - vite & react & react-router-dom & material-ui

## Prerequisites

To run this project, you need:

- Node.js v20.9.0 or higher

- PNPM 8.9 or higher

- Nx

- Kubernetes cluster such as Microk8s, Minikube, Kind, etc (Optional for deploy )

## Installation:

To install the dependencies, run:

`pnpm install`

## Usage

> **_NOTE:_** Make sure clone .env.example to .env and replace compatible value

To start the frontend app, run:

`npx nx dev @app/client`

To start the backend app, run:

`pnpm --filter @app/server prisma generate`
`npx nx dev @app/server`

To deploy the apps to Kubernetes using Helm, run:

```bash
  # Create namespace for deployment
  kubectl create namespace <namespace>
  kubectl config set-context --current --namespace <namespace>

  # Build dependency for helm chart
  helm dependency up infra/helms

  # Install release
  helm upgrade --install <release-name> infra/helms

  ** you can change value file infra/helms/values.yml and upgrade chart with above command `helm upgrade <release-name> infra/helms`
```
