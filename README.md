# Architectural Overview
## Cluster Setup
<img src="https://github.com/wangpatrick57/parkbench/assets/20631215/543cb21f-42c9-4e60-8fb5-c196a498e3d2" width="600">

## Node Internals
<img src="https://github.com/wangpatrick57/parkbench/assets/20631215/aad9f4cc-1c44-4e8d-9869-7ccab267092e" width="800">

**Local Node:**
* _API Client Scripts_ are intuitively used by users to control the cluster

**Coordinator Node:**
* _API Server Process_ is intuitively about responding to API requests
* _Coordinator Process_ is intuitively about replicating orchestration and setup across worker nodes and partitioning queries across worker nodes
* _Metadata DB_ is intuitively the source-of-truth for the state of the cluster
    * It is stored locally since there is only one coordinator

**Worker Node:**
* _Orchestration Scripts_ are intuitively about getting a running Postgres instance
* _Setup Scripts_ are intuitively about getting the Postgres instance ready for a workload run
* _Query Process_ is intuitively about running the queries of a workload
* _Target DBMS_ is the target DBMS used by all workloads. Each workload will have its own database within the DBMS instance
