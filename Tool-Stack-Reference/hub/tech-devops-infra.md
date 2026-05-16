# Tech Reference: Devops Infra

| Name | Description | URL |
|------|-------------|-----|
| **Docker** | Package applications and their dependencies into portable containers.  | docker.com |
| **Kubernetes** | Google's open-source system for automating containerised app deploymen | kubernetes.io |
| **Terraform** | HashiCorp's IaC tool. Declare infrastructure in HCL and provision acro | terraform.io |
| **GitHub Actions** | Built-in CI/CD for GitHub repos. YAML workflows, marketplace with 10k+ | github.com/features/actions |
| **ArgoCD** | Declarative GitOps continuous delivery for Kubernetes. Sync your K8s c | argo-cd.readthedocs.io |
| **Helm** | The package manager for Kubernetes. Bundle K8s manifests as charts, ma | helm.sh |
| **Pulumi** | Modern IaC using real programming languages (TypeScript, Python, Go, C | pulumi.com |
| **Dagger** | CI/CD pipeline engine you run locally and in any CI. Write pipelines i | dagger.io |
| **Ansible** | Red Hat's agentless IT automation - YAML playbooks over SSH. | www.ansible.com |
| **Chef** | Pioneering config management tool - Ruby DSL, recipes and cookbooks. | www.chef.io |
| **Puppet** | Long-standing infrastructure-as-code platform - declarative manifests. | www.puppet.com |
| **SaltStack** | SaltProject - event-driven IaC and orchestration with high-speed messa | saltproject.io |
| **Jenkins** | The original CI server - plugin-rich, self-hosted, ubiquitous in enter | www.jenkins.io |
| **GitLab CI** | GitLab's built-in CI/CD - runners, pipelines, environments. | docs.gitlab.com/ee/ci |
| **CircleCI** | Cloud CI/CD platform - first-class Docker, orbs, parallelism. | circleci.com |
| **Travis CI** | OG hosted CI for open-source projects - declarative .travis.yml. | www.travis-ci.com |
| **TeamCity** | JetBrains' on-prem CI/CD with first-class IntelliJ integration. | www.jetbrains.com/teamcity |
| **Bamboo** | Atlassian's CI/CD server - deep Jira/Bitbucket integration. | www.atlassian.com/software/bamboo |
| **Buildkite** | Hybrid CI/CD - orchestrator in the cloud, runners on your infra. | buildkite.com |
| **Drone CI** | Container-native CI engine - pipelines defined in YAML, runs in Docker | www.drone.io |
| **Woodpecker CI** | OSS community fork of Drone - container-native CI. | woodpecker-ci.org |
| **Tekton** | Cloud-native CI/CD building blocks for Kubernetes - pipelines as CRDs. | tekton.dev |
| **Spinnaker** | Multi-cloud continuous delivery platform from Netflix. | spinnaker.io |
| **nginx** | Official NGINX web server image. | hub.docker.com/_/nginx |
| **postgres** | Official PostgreSQL database image. | hub.docker.com/_/postgres |
| **mysql** | Official MySQL database image. | hub.docker.com/_/mysql |
| **redis** | Official Redis in-memory data store image. | hub.docker.com/_/redis |
| **mongo** | Official MongoDB image. | hub.docker.com/_/mongo |
| **node** | Official Node.js runtime image. | hub.docker.com/_/node |
| **python** | Official Python runtime image. | hub.docker.com/_/python |
| **alpine** | Minimal Alpine Linux base image. | hub.docker.com/_/alpine |
| **ubuntu** | Official Ubuntu base image. | hub.docker.com/_/ubuntu |
| **debian** | Official Debian base image. | hub.docker.com/_/debian |
| **httpd** | Official Apache HTTP Server image. | hub.docker.com/_/httpd |
| **traefik** | Cloud-native edge router and reverse proxy. | hub.docker.com/_/traefik |
| **caddy** | Web server with automatic HTTPS. | hub.docker.com/_/caddy |
| **mariadb** | Official MariaDB relational database image. | hub.docker.com/_/mariadb |
| **rabbitmq** | Official RabbitMQ message broker image. | hub.docker.com/_/rabbitmq |
| **elasticsearch** | Elasticsearch search and analytics engine image. | hub.docker.com/_/elasticsearch |
| **kibana** | Kibana visualization UI for Elasticsearch. | hub.docker.com/_/kibana |
| **grafana/grafana** | Grafana dashboard and observability image. | hub.docker.com/r/grafana/grafana |
| **prom/prometheus** | Prometheus monitoring system image. | hub.docker.com/r/prom/prometheus |
| **jenkins/jenkins** | Jenkins automation server image. | hub.docker.com/r/jenkins/jenkins |
| **wordpress** | Official WordPress image. | hub.docker.com/_/wordpress |
| **php** | Official PHP runtime image. | hub.docker.com/_/php |
| **golang** | Official Go language image. | hub.docker.com/_/golang |
| **rust** | Official Rust language image. | hub.docker.com/_/rust |
| **docker** | Docker CLI/daemon image for Docker workflows. | hub.docker.com/_/docker |
| **hashicorp/aws** | Terraform provider for AWS resources. | registry.terraform.io/providers/hashicorp/aws/latest |
| **hashicorp/azurerm** | Terraform provider for Microsoft Azure resources. | registry.terraform.io/providers/hashicorp/azurerm/latest |
| **hashicorp/google** | Terraform provider for Google Cloud resources. | registry.terraform.io/providers/hashicorp/google/latest |
| **hashicorp/kubernetes** | Terraform provider for Kubernetes resources. | registry.terraform.io/providers/hashicorp/kubernetes/latest |
| **hashicorp/helm** | Terraform provider for Helm releases. | registry.terraform.io/providers/hashicorp/helm/latest |
| **hashicorp/random** | Utility provider for random values. | registry.terraform.io/providers/hashicorp/random/latest |
| **hashicorp/null** | Provider for no-op resources and provisioners. | registry.terraform.io/providers/hashicorp/null/latest |
| **hashicorp/tls** | Provider for TLS keys and certificates. | registry.terraform.io/providers/hashicorp/tls/latest |
| **hashicorp/vault** | Terraform provider for HashiCorp Vault. | registry.terraform.io/providers/hashicorp/vault/latest |
| **hashicorp/consul** | Terraform provider for HashiCorp Consul. | registry.terraform.io/providers/hashicorp/consul/latest |
| **cloudflare/cloudflare** | Terraform provider for Cloudflare resources. | registry.terraform.io/providers/cloudflare/cloudflare/latest |
| **datadog/datadog** | Terraform provider for Datadog. | registry.terraform.io/providers/DataDog/datadog/latest |
| **integrations/github** | Terraform provider for GitHub resources. | registry.terraform.io/providers/integrations/github/latest |
| **gitlabhq/gitlab** | Terraform provider for GitLab resources. | registry.terraform.io/providers/gitlabhq/gitlab/latest |
| **snowflake-labs/snowflake** | Terraform provider for Snowflake. | registry.terraform.io/providers/Snowflake-Labs/snowflake/latest |
| **terraform-aws-modules/vpc/aws** | Popular AWS VPC Terraform module. | registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest |
| **terraform-aws-modules/eks/aws** | Popular AWS EKS Terraform module. | registry.terraform.io/modules/terraform-aws-modules/eks/aws/latest |
| **terraform-aws-modules/security-group/aws** | Reusable AWS security group module. | registry.terraform.io/modules/terraform-aws-modules/security-group/aws/latest |
| **terraform-aws-modules/rds/aws** | AWS RDS Terraform module. | registry.terraform.io/modules/terraform-aws-modules/rds/aws/latest |
| **terraform-aws-modules/lambda/aws** | AWS Lambda Terraform module. | registry.terraform.io/modules/terraform-aws-modules/lambda/aws/latest |
| **Azure/network/azurerm** | Azure network Terraform module. | registry.terraform.io/modules/Azure/network/azurerm/latest |
| **GoogleCloudPlatform/lb-http/google** | Google Cloud HTTP load balancer module. | registry.terraform.io/modules/GoogleCloudPlatform/lb-http/google/latest |
| **terraform-google-modules/kubernetes-engine/google** | Google Kubernetes Engine Terraform module. | registry.terraform.io/modules/terraform-google-modules/kubernetes-engine/google/latest |
| **Azure/aks/azurerm** | Azure Kubernetes Service Terraform module. | registry.terraform.io/modules/Azure/aks/azurerm/latest |
| **oracle/oci** | Terraform provider for Oracle Cloud Infrastructure. | registry.terraform.io/providers/oracle/oci/latest |
