# API Hosting Guide for Task Flow

This guide provides comprehensive options for hosting the Task Flow backend API, including free hosting platforms and self-hosting on your Contabo server using LXD containers.

---

## Table of Contents

1. [Free Hosting Options](#1-free-hosting-options)
2. [Self-Hosting on Contabo with LXD](#2-self-hosting-on-contabo-with-lxd)
3. [Deployment Configurations](#3-deployment-configurations)
4. [Cost Comparison](#4-cost-comparison)
5. [Recommendations](#5-recommendations)

---

# 1. Free Hosting Options

## 1.1 Railway.app

**Best for:** Simple deployment with PostgreSQL database

**Features:**
- ✅ Free tier: $5 credit per month (enough for small apps)
- ✅ PostgreSQL database included
- ✅ Automatic HTTPS
- ✅ Git-based deployment
- ✅ Environment variables management
- ✅ Monitoring and logs
- ✅ Custom domains

**Tech Stack:**
- Node.js/Express or Python/FastAPI
- PostgreSQL for relational data
- Redis for caching (optional)

**Limitations:**
- $5/month credit (expires unused)
- Sleep after inactivity (can be prevented)
- Limited to 512MB RAM on free tier

**Setup:**
```bash
# 1. Install Railway CLI
npm install -g @railway/cli

# 2. Login
railway login

# 3. Initialize project
railway init

# 4. Add PostgreSQL
railway add postgresql

# 5. Deploy
railway up
```

**Deployment File (railway.json):**
```json
{
  "$schema": "https://railway.app/railway.schema.json",
  "build": {
    "builder": "NIXPACKS"
  },
  "deploy": {
    "startCommand": "npm start",
    "restartPolicyType": "ON_FAILURE"
  }
}
```

**Cost:** Free (with $5/month credit)  
**Website:** https://railway.app

---

## 1.2 Render.com

**Best for:** Production-ready free hosting

**Features:**
- ✅ Always-on free tier (no sleep)
- ✅ PostgreSQL database (90-day retention)
- ✅ Automatic HTTPS
- ✅ Git-based deployment
- ✅ Environment variables
- ✅ Custom domains
- ✅ Background workers

**Tech Stack:**
- Node.js, Python, Ruby, Go, Rust
- PostgreSQL database
- Redis available on paid plans

**Limitations:**
- Free tier: 512MB RAM
- Slower cold starts
- 90-day database retention on free tier
- Limited bandwidth

**Setup:**
```bash
# 1. Create render.yaml
cat > render.yaml << EOF
services:
  - type: web
    name: taskflow-api
    env: node
    buildCommand: npm install
    startCommand: npm start
    envVars:
      - key: DATABASE_URL
        fromDatabase:
          name: taskflow-db
          property: connectionString
      - key: JWT_SECRET
        generateValue: true

databases:
  - name: taskflow-db
    databaseName: taskflow
    user: taskflow
EOF

# 2. Push to GitHub and connect to Render
```

**Cost:** Free (with limitations)  
**Website:** https://render.com

---

## 1.3 Fly.io

**Best for:** Global edge deployment

**Features:**
- ✅ Free tier: 3 shared VMs, 3GB storage
- ✅ Global distribution (multiple regions)
- ✅ PostgreSQL support
- ✅ Automatic HTTPS
- ✅ Docker-based deployment
- ✅ CLI deployment
- ✅ Monitoring included

**Tech Stack:**
- Any language (Docker-based)
- PostgreSQL or SQLite
- Global edge network

**Limitations:**
- Free tier: 3 VMs with shared CPU
- Outbound data transfer limits
- Requires credit card for free tier

**Setup:**
```bash
# 1. Install Fly CLI
curl -L https://fly.io/install.sh | sh

# 2. Login
fly auth login

# 3. Launch app
fly launch

# 4. Create Postgres
fly postgres create

# 5. Attach to app
fly postgres attach --app taskflow-api

# 6. Deploy
fly deploy
```

**Dockerfile:**
```dockerfile
FROM node:18-alpine
WORKDIR /app
COPY package*.json ./
RUN npm ci --production
COPY . .
EXPOSE 8080
CMD ["npm", "start"]
```

**fly.toml:**
```toml
app = "taskflow-api"
primary_region = "fra"

[env]
  PORT = "8080"

[http_service]
  internal_port = 8080
  force_https = true
  auto_stop_machines = true
  auto_start_machines = true
  min_machines_running = 0

[[services]]
  internal_port = 8080
  protocol = "tcp"

  [[services.ports]]
    port = 80
    handlers = ["http"]

  [[services.ports]]
    port = 443
    handlers = ["tls", "http"]
```

**Cost:** Free (3 shared VMs + 3GB storage)  
**Website:** https://fly.io

---

## 1.4 Supabase (Backend-as-a-Service)

**Best for:** PostgreSQL + Auth + Storage + Realtime

**Features:**
- ✅ PostgreSQL database (500MB)
- ✅ Built-in authentication (email, OAuth)
- ✅ RESTful API auto-generated
- ✅ Real-time subscriptions
- ✅ File storage (1GB)
- ✅ Edge Functions (serverless)
- ✅ No credit card required

**Tech Stack:**
- PostgreSQL with PostgREST
- Built-in auth system
- Edge Functions (Deno)
- Storage for file uploads

**Limitations:**
- 500MB database on free tier
- 2GB bandwidth per month
- 50,000 monthly active users
- Paused after 1 week of inactivity

**Setup:**
```bash
# 1. Install Supabase CLI
npm install -g supabase

# 2. Login
supabase login

# 3. Initialize project
supabase init

# 4. Start local dev
supabase start

# 5. Create tables (SQL migrations)
# 6. Deploy
supabase db push
```

**Example Migration:**
```sql
-- Create users table
CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  username TEXT UNIQUE NOT NULL,
  email TEXT UNIQUE NOT NULL,
  full_name TEXT,
  created_at TIMESTAMP DEFAULT NOW()
);

-- Create tasks table
CREATE TABLE tasks (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES users(id),
  title TEXT NOT NULL,
  description TEXT,
  status TEXT DEFAULT 'pending',
  priority TEXT DEFAULT 'medium',
  due_date TIMESTAMP,
  created_at TIMESTAMP DEFAULT NOW()
);
```

**Cost:** Free (500MB database + 1GB storage)  
**Website:** https://supabase.com

---

## 1.5 PocketBase (Self-hosted BaaS)

**Best for:** Single-file backend with SQLite

**Features:**
- ✅ Single executable file
- ✅ SQLite database (built-in)
- ✅ Authentication (email, OAuth)
- ✅ RESTful API auto-generated
- ✅ Real-time subscriptions
- ✅ File storage
- ✅ Admin dashboard
- ✅ Extremely lightweight

**Tech Stack:**
- Go (single binary)
- SQLite database
- Built-in admin UI

**Limitations:**
- SQLite limitations for high concurrency
- Single server (not distributed)
- Requires hosting (but very cheap)

**Setup:**
```bash
# 1. Download PocketBase
wget https://github.com/pocketbase/pocketbase/releases/download/v0.20.0/pocketbase_0.20.0_linux_amd64.zip
unzip pocketbase_0.20.0_linux_amd64.zip

# 2. Run
./pocketbase serve --http="0.0.0.0:8090"

# 3. Access admin UI
# http://localhost:8090/_/
```

**Schema Definition:**
```javascript
// Collections can be created via Admin UI or migrations
// Example: Tasks collection
{
  "name": "tasks",
  "type": "base",
  "schema": [
    {
      "name": "title",
      "type": "text",
      "required": true
    },
    {
      "name": "status",
      "type": "select",
      "options": {
        "values": ["pending", "in_progress", "completed"]
      }
    },
    {
      "name": "user",
      "type": "relation",
      "options": {
        "collectionId": "users"
      }
    }
  ]
}
```

**Deployment on Free Platforms:**
- Can be deployed to Fly.io (free tier)
- Can run on your Contabo server
- Very low resource requirements (10-50MB RAM)

**Cost:** Free (self-hosted) or $5/month on Fly.io  
**Website:** https://pocketbase.io

---

## 1.6 Appwrite (Self-hosted BaaS)

**Best for:** Complete backend platform with Docker

**Features:**
- ✅ PostgreSQL or MariaDB
- ✅ Authentication (30+ OAuth providers)
- ✅ Database (collections)
- ✅ Storage (file uploads)
- ✅ Functions (serverless)
- ✅ Real-time events
- ✅ Admin console

**Tech Stack:**
- Docker-based deployment
- Multiple database options
- Microservices architecture

**Limitations:**
- Requires more resources (minimum 2GB RAM)
- Docker dependency
- More complex than PocketBase

**Setup:**
```bash
# 1. Install with Docker
docker run -it --rm \
  --volume /var/run/docker.sock:/var/run/docker.sock \
  --volume "$(pwd)"/appwrite:/usr/src/code/appwrite:rw \
  --entrypoint="install" \
  appwrite/appwrite:1.4.13

# 2. Start
cd appwrite
docker compose up -d
```

**Cost:** Free (self-hosted)  
**Website:** https://appwrite.io

---

## 1.7 Vercel (Serverless Functions)

**Best for:** API with serverless architecture

**Features:**
- ✅ Serverless functions (unlimited)
- ✅ Automatic HTTPS
- ✅ Git-based deployment
- ✅ Edge network (global CDN)
- ✅ Environment variables
- ✅ Zero configuration

**Tech Stack:**
- Node.js serverless functions
- External database (Supabase, PlanetScale)
- Redis optional (Upstash)

**Limitations:**
- Free tier: 100GB bandwidth
- Serverless function timeout (10s on free)
- No persistent file storage
- Cold starts

**Setup:**
```bash
# 1. Install Vercel CLI
npm i -g vercel

# 2. Project structure
/api
  /auth.js
  /tasks.js
  /teams.js

# 3. Deploy
vercel
```

**Example API Function:**
```javascript
// api/tasks.js
export default async function handler(req, res) {
  if (req.method === 'GET') {
    // Get tasks from database
    const tasks = await getTasks();
    res.status(200).json(tasks);
  } else if (req.method === 'POST') {
    // Create task
    const task = await createTask(req.body);
    res.status(201).json(task);
  }
}
```

**Cost:** Free (100GB bandwidth)  
**Website:** https://vercel.com

---

## 1.8 Cloudflare Workers

**Best for:** Edge computing with global distribution

**Features:**
- ✅ 100,000 requests/day (free)
- ✅ Global edge network
- ✅ KV storage included
- ✅ D1 database (SQLite on edge)
- ✅ R2 storage (S3-compatible)
- ✅ Sub-millisecond latency

**Tech Stack:**
- JavaScript/TypeScript workers
- D1 (SQLite) or external DB
- KV for caching
- R2 for file storage

**Limitations:**
- Free tier: 100,000 requests/day
- CPU time limits
- Learning curve

**Setup:**
```bash
# 1. Install Wrangler
npm install -g wrangler

# 2. Login
wrangler login

# 3. Create project
wrangler init taskflow-api

# 4. Create D1 database
wrangler d1 create taskflow-db

# 5. Deploy
wrangler publish
```

**Worker Example:**
```javascript
export default {
  async fetch(request, env) {
    const url = new URL(request.url);
    
    if (url.pathname === '/api/tasks' && request.method === 'GET') {
      const { results } = await env.DB.prepare(
        'SELECT * FROM tasks'
      ).all();
      return Response.json(results);
    }
    
    return new Response('Not found', { status: 404 });
  }
}
```

**Cost:** Free (100,000 requests/day)  
**Website:** https://workers.cloudflare.com

---

# 2. Self-Hosting on Contabo with LXD

## 2.1 Why LXD Containers?

**Benefits:**
- ✅ Lightweight (compared to VMs)
- ✅ Better isolation than Docker
- ✅ Full Linux environment
- ✅ Easy snapshots and backups
- ✅ Resource limits
- ✅ Multiple containers on one server

**Use Case:**
Perfect for running multiple isolated environments on your Contabo server.

---

## 2.2 LXD Setup on Contabo

### Step 1: Install LXD

```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Install LXD
sudo snap install lxd

# Initialize LXD
sudo lxd init
```

**LXD Init Configuration:**
```
Would you like to use LXD clustering? (yes/no) [default=no]: no
Do you want to configure a new storage pool? (yes/no) [default=yes]: yes
Name of the new storage pool [default=default]: default
Name of the storage backend to use (zfs, btrfs, dir, lvm) [default=zfs]: zfs
Create a new ZFS pool? (yes/no) [default=yes]: yes
Would you like to use an existing empty disk? (yes/no) [default=no]: no
Size in GB of the new loop device (1GB minimum) [default=30GB]: 50GB
Would you like to connect to a MAAS server? (yes/no) [default=no]: no
Would you like to create a new local network bridge? (yes/no) [default=yes]: yes
What should the new bridge be called? [default=lxdbr0]: lxdbr0
What IPv4 address should be used? [default=auto]: auto
What IPv6 address should be used? [default=auto]: auto
Would you like the LXD server to be available over the network? (yes/no) [default=no]: no
Would you like stale cached images to be updated automatically? (yes/no) [default=yes]: yes
```

### Step 2: Create Container for API

```bash
# Launch Ubuntu container
lxc launch ubuntu:22.04 taskflow-api

# Access container
lxc exec taskflow-api -- bash
```

### Step 3: Install Dependencies in Container

```bash
# Inside container
apt update && apt upgrade -y

# Install Node.js 18
curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
apt install -y nodejs

# Install PostgreSQL
apt install -y postgresql postgresql-contrib

# Install nginx (reverse proxy)
apt install -y nginx

# Install certbot (SSL)
apt install -y certbot python3-certbot-nginx
```

### Step 4: Configure PostgreSQL

```bash
# Switch to postgres user
sudo -u postgres psql

# Create database and user
CREATE DATABASE taskflow;
CREATE USER taskflow WITH ENCRYPTED PASSWORD 'your_secure_password';
GRANT ALL PRIVILEGES ON DATABASE taskflow TO taskflow;
\q
```

### Step 5: Deploy API Application

```bash
# Create app directory
mkdir -p /opt/taskflow-api
cd /opt/taskflow-api

# Clone or upload your API code
git clone https://github.com/yourusername/taskflow-api.git .

# Install dependencies
npm install

# Create .env file
cat > .env << EOF
NODE_ENV=production
PORT=3000
DATABASE_URL=postgresql://taskflow:your_secure_password@localhost:5432/taskflow
JWT_SECRET=$(openssl rand -hex 32)
EOF

# Install PM2 (process manager)
npm install -g pm2

# Start application
pm2 start npm --name "taskflow-api" -- start
pm2 save
pm2 startup
```

### Step 6: Configure Nginx Reverse Proxy

```bash
# Create nginx config
cat > /etc/nginx/sites-available/taskflow << EOF
server {
    listen 80;
    server_name api.taskflow.com;

    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_cache_bypass \$http_upgrade;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}
EOF

# Enable site
ln -s /etc/nginx/sites-available/taskflow /etc/nginx/sites-enabled/
nginx -t
systemctl restart nginx
```

### Step 7: Setup SSL with Let's Encrypt

```bash
# Get SSL certificate
certbot --nginx -d api.taskflow.com

# Auto-renewal is configured automatically
```

### Step 8: Configure Port Forwarding

```bash
# Exit container
exit

# Forward port 80 from host to container
lxc config device add taskflow-api http proxy listen=tcp:0.0.0.0:80 connect=tcp:127.0.0.1:80

# Forward port 443 for HTTPS
lxc config device add taskflow-api https proxy listen=tcp:0.0.0.0:443 connect=tcp:127.0.0.1:443
```

---

## 2.3 Alternative: Docker in LXD

You can also run Docker inside an LXD container for more flexibility:

```bash
# Create container with Docker support
lxc launch ubuntu:22.04 taskflow-docker -c security.nesting=true

# Access container
lxc exec taskflow-docker -- bash

# Install Docker
curl -fsSL https://get.docker.com | sh

# Create docker-compose.yml
cat > docker-compose.yml << EOF
version: '3.8'

services:
  api:
    build: .
    ports:
      - "3000:3000"
    environment:
      DATABASE_URL: postgresql://taskflow:password@db:5432/taskflow
      JWT_SECRET: your-secret-key
    depends_on:
      - db
    restart: unless-stopped

  db:
    image: postgres:15
    environment:
      POSTGRES_DB: taskflow
      POSTGRES_USER: taskflow
      POSTGRES_PASSWORD: password
    volumes:
      - postgres_data:/var/lib/postgresql/data
    restart: unless-stopped

  redis:
    image: redis:7-alpine
    restart: unless-stopped

volumes:
  postgres_data:
EOF

# Start services
docker compose up -d
```

---

## 2.4 LXD Container Management

### Resource Limits

```bash
# Set CPU limit (2 cores)
lxc config set taskflow-api limits.cpu 2

# Set memory limit (2GB)
lxc config set taskflow-api limits.memory 2GB

# Set disk limit
lxc config device set taskflow-api root size 20GB
```

### Backup and Snapshots

```bash
# Create snapshot
lxc snapshot taskflow-api backup-2026-01-05

# List snapshots
lxc info taskflow-api

# Restore snapshot
lxc restore taskflow-api backup-2026-01-05

# Export container
lxc export taskflow-api taskflow-backup.tar.gz
```

### Monitoring

```bash
# View container stats
lxc list
lxc info taskflow-api

# View logs
lxc exec taskflow-api -- journalctl -u nginx
lxc exec taskflow-api -- pm2 logs
```

---

# 3. Deployment Configurations

## 3.1 Node.js/Express API Example

**Directory Structure:**
```
taskflow-api/
├── src/
│   ├── routes/
│   │   ├── auth.js
│   │   ├── tasks.js
│   │   ├── teams.js
│   │   └── notifications.js
│   ├── models/
│   ├── middleware/
│   └── index.js
├── package.json
└── .env
```

**index.js:**
```javascript
const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
require('dotenv').config();

const app = express();

// Middleware
app.use(helmet());
app.use(cors());
app.use(express.json());

// Routes
app.use('/api/auth', require('./routes/auth'));
app.use('/api/tasks', require('./routes/tasks'));
app.use('/api/teams', require('./routes/teams'));
app.use('/api/notifications', require('./routes/notifications'));

// Health check
app.get('/health', (req, res) => {
  res.json({ status: 'ok', timestamp: new Date() });
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`API server running on port ${PORT}`);
});
```

---

## 3.2 Environment Variables

```bash
# Production .env
NODE_ENV=production
PORT=3000
DATABASE_URL=postgresql://user:pass@localhost:5432/taskflow
JWT_SECRET=your-secret-key-here
JWT_EXPIRES_IN=1h
REFRESH_TOKEN_SECRET=your-refresh-secret
REFRESH_TOKEN_EXPIRES_IN=7d
ALLOWED_ORIGINS=https://taskflow.com,https://app.taskflow.com
```

---

# 4. Cost Comparison

| Platform | Free Tier | Database | Storage | Bandwidth | Best For |
|----------|-----------|----------|---------|-----------|----------|
| **Railway** | $5/month credit | PostgreSQL ✅ | Included | Limited | Quick start |
| **Render** | Always-on | PostgreSQL (90d) ✅ | Limited | 100GB | Production |
| **Fly.io** | 3 VMs + 3GB | PostgreSQL ✅ | 3GB | Limited | Global edge |
| **Supabase** | 500MB DB | PostgreSQL ✅ | 1GB | 2GB/month | BaaS solution |
| **PocketBase** | Self-hosted | SQLite ✅ | Unlimited | Unlimited | Lightweight |
| **Vercel** | Unlimited functions | External | None | 100GB | Serverless |
| **Cloudflare** | 100k req/day | D1 (SQLite) ✅ | KV + R2 | Unlimited | Edge computing |
| **Contabo VPS** | ~$6/month | Self-hosted ✅ | 200-400GB | Unlimited | Full control |

---

# 5. Recommendations

## 5.1 For Development/Testing

**Recommended: Railway or Render**
- Easy to set up
- Free tier sufficient for testing
- PostgreSQL included
- Good for prototyping

```bash
# Quick start with Railway
railway login
railway init
railway add postgresql
railway up
```

## 5.2 For Production (Small Scale)

**Recommended: Fly.io or Contabo LXD**

**Fly.io Benefits:**
- Global distribution
- Free tier for small apps
- Easy scaling
- Automatic HTTPS

**Contabo LXD Benefits:**
- Full control
- Very cheap (~$6/month for VPS)
- Multiple containers
- No usage limits

## 5.3 For Production (Large Scale)

**Recommended: Contabo with LXD + Load Balancer**
- Multiple API containers
- PostgreSQL in separate container
- Redis for caching
- Nginx load balancer

**Architecture:**
```
Internet → Nginx LB → API Container 1
                   → API Container 2
                   → API Container 3
                   ↓
            PostgreSQL Container
                   ↓
            Redis Container
```

## 5.4 Best Overall Solution

**For Task Flow Specifically:**

1. **Start with:** Railway or Render (free tier)
   - Quick deployment
   - Test API with Flutter app
   - Validate functionality

2. **Move to:** Contabo VPS with LXD
   - Cost-effective for production
   - Full control
   - Scalable
   - Multiple environments (dev, staging, prod)

3. **Future:** Consider Fly.io for global distribution
   - When you have users worldwide
   - Need low latency everywhere
   - Can afford paid tier

---

## 5.5 Contabo Setup Summary

**Minimum Server Specs:**
- VPS S: 4 vCPU, 8GB RAM, 200GB SSD (~$6/month)
- VPS M: 6 vCPU, 16GB RAM, 400GB SSD (~$12/month)

**Containers Layout:**
```
Server (Contabo VPS)
├── taskflow-api-prod (Production API)
├── taskflow-api-staging (Staging API)
├── taskflow-db (PostgreSQL)
├── taskflow-redis (Redis Cache)
└── taskflow-nginx (Load Balancer)
```

**Monthly Cost Breakdown:**
- Contabo VPS S: $6/month
- Domain name: $10-15/year
- SSL Certificate: Free (Let's Encrypt)
- **Total: ~$6-7/month**

---

## Additional Resources

- **LXD Documentation:** https://linuxcontainers.org/lxd/docs/latest/
- **Railway Docs:** https://docs.railway.app/
- **Render Docs:** https://render.com/docs
- **Fly.io Docs:** https://fly.io/docs/
- **Supabase Docs:** https://supabase.com/docs
- **PocketBase Docs:** https://pocketbase.io/docs/
- **Cloudflare Workers:** https://developers.cloudflare.com/workers/

---

**Last Updated:** January 2026
