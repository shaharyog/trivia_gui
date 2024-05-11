use std::fmt::{Debug};
use thiserror::Error;



#[derive(Error, Debug)]
pub enum Error {
    #[error("Could not connect to server: {0}")]
    ServerConnectionError(String),
    #[error("Could not serialize request: {0}")]
    RequestSerializationError(String),
    #[error("Could not deserialize response: {0}")]
    ResponseDeserializationError(String),
    #[error("Serialized request is bigger than u32::MAX")]
    RequestTooBig,
    #[error("{0}")]
    ResponseError(String),
    #[error("Invalid response code: {0}")]
    InvalidResponseCode(u8),
    #[error("Login failed: {0}")]
    LoginError(String),
    #[error("Signup failed: {0}")]
    SignupError(String),
    #[error("Logout failed")]
    LogoutError,
    #[error("Invalid address: {0}")]
    InvalidAddress(String),
}

impl Error{
    #[flutter_rust_bridge::frb(sync)]
    pub fn format(&self) -> String {
        format!("{}", self)
    }
}