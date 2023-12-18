# Architecture
### Design Assumptions
Each point is an assumption while subpoints are implications.
1. Workloads are read-only.
    * Loading only happens once per workload per node, not once per workload run.
    * Queries of the same workload run can be executed on different nodes.
2. Queries are long-running.
    * It's important to execute different queries of the same workload run in parallel.

### Components
Components ordered from least to most frequently invoked.
| Component | Invoked Once Per New... |
|----------|----------|
| Initializer | ...worker node. |
| Loader | ...workload on node. |
| Configurer | ...postgresql.conf change. |
| Coordinator | ...workload run. |
| Worker | ...query in workload. |