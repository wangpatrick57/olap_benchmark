/**
 * # Environment
 * Run on worker nodes
 * 
 * # Arguments
 *  * `pgdata_dpath` - The data directory for this Postgres instance
 *  * `pgbin_dpath` - The bin directory with initdb
 * 
 * # Preconditions
 *  * `pgdata_dpath` is non-existent
 *  * `pgbin_dpath` is a built Postgres bin
 * 
 * # Postconditions
 *  * `initdb` will be called on `pgdata_dpath`
 * 
 * # Notes
 *  * `worker_pg_start` is separate from `worker_pg_init` because start happens every time a node crashes and comes back but init only happens once
 */
fn main() {
    
}