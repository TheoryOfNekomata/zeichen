use thiserror::Error;

pub type Result<T> = core::result::Result<T, Error>;

#[derive(Error, Debug)]
pub enum Error {
    #[error("Missing configuration: {0}")]
    ConfigMissingEnv(&'static str),
}
