# Architectural Overview
## Cluster Setup
<img src="https://github.com/wangpatrick57/parkbench/assets/20631215/543cb21f-42c9-4e60-8fb5-c196a498e3d2" width="400">

## Node Internals
<img src="https://github.com/wangpatrick57/parkbench/assets/20631215/14610d56-9962-46a1-83e7-c464f7132e40" width="600">


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
* _Target DB_ is the target DB for the workload