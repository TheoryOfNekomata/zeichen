use axum::Router;

use crate::AppState;

pub mod healthcheck;

pub async fn api_v1_routes(shared_state: AppState) -> Router {
    Router::new()
        .with_state(shared_state)
        .merge(healthcheck::routes::healthcheck_routes().await)
}
