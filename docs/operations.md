# Operations Guide

## Introduction

This document describes the operational procedures required to run, maintain, monitor, and support a Canary server in development, staging or production environments.

The audience for this document includes:

* System Administrators
* DevOps Engineers
* Infrastructure Engineers
* Server Owners
* Community Managers

This guide focuses on:

* Deployment
* Monitoring
* Backups
* Recovery
* Security
* Upgrades
* Incident Response

---

# Operational Overview

A typical native or production Canary deployment consists of:

```text
Internet
    │
    ▼
Load Balancer / Firewall
    │
    ▼
Canary Server
    │
    ▼
MariaDB
    │
    ▼
Persistent Storage
```

Optional components:

```text
Canary
├── MyAAC
├── Login Server
├── Metrics Collector
├── Discord Webhooks
└── Reverse Proxy
```

---

# Environment Types

## Development

Purpose:

* Feature testing
* Lua development
* Bug fixing

Characteristics:

* Local database
* Local Docker stack
* Non-production data

---

## Staging

Purpose:

* Release validation
* Migration testing
* Performance verification

Characteristics:

* Mirrors production
* Uses isolated data
* Receives internal testing traffic

---

## Production

Purpose:

* Live players

Requirements:

* Automated backups
* Monitoring
* Alerting
* Security controls
* Recovery procedures

---

# Deployment Models

## Docker Quickstart

Recommended for local development, local testing and LAN demos.

Canary provides a Docker Compose quickstart including:

* Canary from the published runtime image
* MariaDB
* MyAAC as website/admin AAC
* `opentibiabr/login-server` as the client login webservice
* Optional test accounts and characters

Startup:

```bash
cd docker
cp .env.dist .env
docker compose up -d --build
```

The `--build` flag builds the MyAAC quickstart image. It does not compile
Canary locally.

Default exposed endpoints and ports:

```text
MyAAC website:            http://localhost:8080
Client login API:         http://localhost:8088/login
Canary login protocol:    7171
Canary game protocol:     7172
Canary status protocol:   7173
Login-server gRPC:        9090
```

The quickstart is not a hardened production deployment with default settings.
Before using it outside a trusted local network, change all default passwords,
disable or remove test accounts, review published ports, and pin image tags.
For the full contract, see `docker/DOCKER.md`.

---

## Native Deployment

Suitable when:

* Maximum performance is required
* Custom infrastructure exists
* Advanced monitoring is used
* Production hardening is required

Typical deployment:

```text
Linux Server
├── Canary Binary
├── Config Files
├── Datapack
├── MariaDB
└── Backup Storage
```

---

# Infrastructure Requirements

The values below are starting points only. Real capacity depends on the datapack,
map size, Lua scripts, enabled metrics, database latency and player behavior.
Validate production sizing with monitoring and representative load.

## Small Community

```text
2 CPU Cores
4 GB RAM
50 GB SSD
```

Expected load:

```text
10–100 Players
```

---

## Medium Community

```text
4 CPU Cores
8 GB RAM
100 GB SSD
```

Expected load:

```text
100–500 Players
```

---

## Large Community

```text
8+ CPU Cores
16+ GB RAM
NVMe Storage
```

Expected load:

```text
500+ Players
```

---

# Configuration Management

Primary configuration:

```text
config.lua
```

Best practices:

* Store secrets outside Git
* Version-control configuration templates
* Document environment-specific overrides
* Review configuration changes before deployment

---

# Secrets Management

Sensitive values include:

```text
Database Passwords
API Keys
Webhook Tokens
SMTP Credentials
Admin Accounts
```

Never:

* Commit secrets to Git
* Store passwords in documentation
* Share production credentials

Recommended:

```text
Environment Variables
Docker Secrets
Vault Systems
```

---

# Database Operations

## Health Checks

Verify connectivity:

```sql
SELECT 1;
```

Verify player activity:

```sql
SELECT COUNT(*) FROM players;
```

Verify account count:

```sql
SELECT COUNT(*) FROM accounts;
```

---

## Maintenance

Regular tasks:

* Optimize tables
* Check indexes
* Remove orphaned records
* Monitor storage growth

Example:

```sql
OPTIMIZE TABLE players;
```

---

# Backup Strategy

## Critical Assets

Always back up:

```text
Database
config.lua
data/
data-canary/
data-otservbr-global/
Custom Scripts
Website Files
```

---

## Backup Schedule

Recommended:

### Hourly

```text
Recent database backup or binary-log/incremental backup if configured
```

### Daily

```text
Full Database Backup
```

### Weekly

```text
Full Server Snapshot
```

### Monthly

```text
Offsite Archive
```

---

# Database Backup

Example:

```bash
mysqldump \
  -u root \
  -p \
  canary > backup.sql
```

Compressed:

```bash
mysqldump -u root -p canary | gzip > backup.sql.gz
```

---

# Recovery Procedures

## Database Restore

```bash
mysql -u root -p canary < backup.sql
```

---

## Full Environment Restore

Restore:

```text
Database
Configuration
Datapack
Custom Files
```

Validate:

```text
Login
Character Load
Map Load
NPCs
Monsters
```

before reopening the server.

---

# Monitoring

## What To Monitor

### Infrastructure

```text
CPU
Memory
Disk
Network
```

### Database

```text
Connections
Queries
Replication
Storage Usage
```

### Application

```text
Online Players
Crash Rate
Scheduler Delays
Save Operations
Lua Errors
```

---

# Metrics

Canary includes optional OpenTelemetry-based metrics support.

The repository provides Prometheus and Grafana examples under `metrics/`.
Common integrations:

```text
Prometheus
Grafana
OpenTelemetry
```

Monitor trends rather than isolated spikes.

---

# Logging

Sources:

```text
Console Output
Application Logs
Docker Logs
Database Logs
Web Server Logs
```

Retention recommendation:

```text
30–90 Days
```

---

# Alerting

Critical alerts:

## P1

Immediate response required:

```text
Server Down
Database Unavailable
Data Corruption
Backup Failure
```

---

## P2

High priority:

```text
High Memory Usage
Slow Queries
Repeated Crashes
```

---

## P3

Normal priority:

```text
Warnings
Configuration Drift
Minor Script Errors
```

---

# Release Management

## Release Workflow

```text
Development
      ↓
Staging
      ↓
Validation
      ↓
Production
```

Never deploy directly from an untested branch.

---

# Upgrade Procedure

## Before Upgrade

Checklist:

```text
Backup Database
Backup Configuration
Backup Datapacks
Read Release Notes
Validate Migration Requirements
```

---

## Upgrade Steps

```text
Stop Canary
Backup Environment
Deploy New Version
Apply Migrations
Start Canary
Validate Services
```

---

## Post-Upgrade Validation

Verify:

```text
Login
Character Creation
Movement
Combat
Market
NPC Interaction
Save Operations
```

---

# Incident Response

## Server Crash

Actions:

```text
Capture Logs
Generate Stack Trace
Preserve Environment
Restart Service
```

Do not immediately delete temporary files or logs.

---

## Database Failure

Actions:

```text
Verify Connectivity
Check Disk Space
Inspect Logs
Restore Backup If Needed
```

---

## Data Corruption

Actions:

```text
Stop Writes
Create Snapshot
Investigate Scope
Restore From Backup
```

Never continue operating on a corrupted database.

---

# Security Operations

## Network Security

Restrict:

```text
3306 (MariaDB)
SSH
Administration Panels
```

Expose only required services.

---

## Firewall Example

Allow:

```text
7171  Canary login protocol, if used directly
7172  Canary game protocol
7173  Canary status protocol, if public status is needed
80    Web/API HTTP, preferably redirected to HTTPS
443   Web/API HTTPS
8088  login-server HTTP, only if not behind a reverse proxy
```

Keep `9090` login-server gRPC and `3306` MariaDB restricted to trusted
networks unless a deployment explicitly requires otherwise.

Restrict:

```text
3306
22
```

to trusted addresses.

---

# Access Control

Separate accounts for:

```text
Administration
Development
Automation
Monitoring
```

Avoid shared credentials.

---

# SSL/TLS

Always use HTTPS for:

```text
MyAAC
APIs
Administration Panels
```

Recommended:

```text
Let's Encrypt
Cloudflare
Reverse Proxy TLS
```

---

# Capacity Planning

Monitor growth:

```text
Player Count
Database Size
CPU Utilization
Memory Usage
Bandwidth
```

Review monthly.

---

# Routine Maintenance

## Daily

```text
Review Alerts
Verify Backups
Check Online Status
```

---

## Weekly

```text
Review Logs
Validate Restores
Inspect Performance
```

---

## Monthly

```text
Upgrade Dependencies
Review Security
Capacity Assessment
```

---

# Operational Runbook

## Startup

Docker quickstart:

```bash
cd docker
docker compose up -d
```

Native server:

```bash
./canary
```

Verify:

```text
Database Connected
Map Loaded
Players Can Login
```

---

## Shutdown

Graceful shutdown:

```text
Notify Players
Save State
Stop Server
```

Avoid forced termination whenever possible.

---

# Disaster Recovery Objectives

Recommended targets:

## RPO (Recovery Point Objective)

```text
≤ 1 Hour
```

Maximum acceptable data loss.

---

## RTO (Recovery Time Objective)

```text
≤ 30 Minutes
```

Maximum acceptable downtime.

---

# Operational Checklist

Before Production Launch:

* Database secured
* Backups tested
* Monitoring enabled
* Alerting configured
* SSL enabled
* Firewall configured
* Admin credentials changed
* Recovery procedures documented
* Upgrade process tested
* Capacity validated

---

# Conclusion

Successful Canary operations depend on:

* Reliable backups
* Continuous monitoring
* Secure infrastructure
* Controlled deployments
* Documented recovery procedures

Following these practices helps ensure stable gameplay, faster incident recovery and a safer production environment for both administrators and players.
