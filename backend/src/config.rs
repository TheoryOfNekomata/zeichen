use crate::{Error, Result};
use std::env;
use std::sync::OnceLock;
use tracing::warn;

pub fn load_config() -> &'static Config {
    static INSTANCE: OnceLock<Config> = OnceLock::new();

    INSTANCE.get_or_init(|| {
        Config::from_env().unwrap_or_else(|e| panic!("FATAL: Failed loading env variable. {:?}", e))
    })
}

#[allow(non_snake_case)]
#[derive(Debug, Clone, PartialEq)]
pub struct Config {
    pub DATABASE_URL: String,
    pub PORT: String,
}

impl Config {
    fn from_env() -> Result<Self> {
        Ok(Self {
            DATABASE_URL: get_env("DATABASE_URL")?,
            PORT: get_env_opt("PORT", "8000"),
        })
    }
}

fn get_env(key: &'static str) -> Result<String> {
    env::var(key).map_err(|_| Error::ConfigMissingEnv(key))
}

fn get_env_opt(key: &str, default: &str) -> String {
    warn!(
        "Failed loading env variable: {}. Using fallback value: {}",
        key, default
    );
    env::var(key).unwrap_or_else(|_| default.to_string())
}
