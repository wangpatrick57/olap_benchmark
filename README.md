# Runbook
### Add new node to cluster
1. **Node Registration**
2. For all workloads, **Workload One Node Initialization**
3. For all workloads, **Workload One Node Startup**

### Recover node which crashed without losing disk
1. For all workloads, **Workload One Node Startup**

### Recover node which lost disk
1. For all workloads, **Workload One Node Initialization**
2. For all workloads, **Workload One Node Startup**

### Workload Registration (!)
**Frequency:** once per new workload<br>
**Params:** `workload_name`, `pgdata_path`, `pgbin_path`<br>
**Preconditions:**
- `workload_name` non-existent in metadata DB

**Postconditions:**
- `workload_name` existent in metadata DB

### Node Registration (!)
**Frequency:** once per new node<br>
**Params:** `node_name`, `hostname`<br>

### Workload One Node Initialization (!)
**Frequency:** when a new node joins the cluster<br>
**Params:** `workload_name`, `node_name`<br>
**Preconditions:**
- `workload_name` existent in metadata DB
- `node_name` existent in metadata DB
- `pgdata_path` non-existent/empty on node

**Postconditions:**
- `pgdata_path` existent and correctly initialized on node

### Workload One Node Destruction
**Params:** `workload_name`, `node_name`<br>
**Preconditions:**
- `workload_name` existent in metadata DB
- `node_name` existent in metadata DB

**Postconditions:**
- If `pgdata_path` is non-existent/empty, nothing will happen
- If `pgdata_path` is existent, the instance corresponding to `pgdata_path` will be stopped and `pgdata_path` will be deleted

**Notes:** destruction is actually the mirror of initialization + startup since it first stops any running instances and then removes `pgdata_path`

### Workload All Nodes Initialization (!)
**Frequency:** once per workload change (registration counts as a change too)<br>
**Params:** `workload_name`<br>
**Preconditions:**
- `workload_name` existent in metadata DB
- No current runs of `workload_name`

**Postconditions:**
- On nodes where `pgdata_path` is existent, the workload will be destructed and re-initialized
- On nodes where `pgdata_path` is non-existent/empty, the workload Postgres instance will be initialized


### Workload One Node Startup (!)
**Frequency:** after initialization a node that just came online (either because it crashed or because it's new)<br>
**Params:** `workload_name`, `node_name`<br>
**Preconditions:**
- `workload_name` existent in metadata DB
- `pgbin_path` contains standard Postgres executables (pg_ctl, postgres, etc.) on all worker nodes

**Postconditions:**
- Postgres instance for `workload_name` running on all worker nodes

### Workload All Nodes Startup (!)
**Frequency:** when the workload is registered<br>
**Params:** `workload_name`<br>
**Preconditions:**
- `workload_name` existent in metadata DB
- No current runs of `workload_name`