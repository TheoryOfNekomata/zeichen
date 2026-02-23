use axum::Json;
use serde_json::{Value, json};

pub async fn healthcheck_v1() -> Json<Value> {
    Json(json!({ "message": "Welcome to Zeichen API v1" }))
}
