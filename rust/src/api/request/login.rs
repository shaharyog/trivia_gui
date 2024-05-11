use serde::{Deserialize, Serialize};
use crate::api::request::Request;

#[derive(Serialize)]
pub struct LoginRequest {
    pub username: String,
    pub password: String,
}

#[derive(Deserialize)]
pub struct LoginResponse {
    pub status: bool,
    pub message: String,
}

impl Request for LoginRequest {
    type Response = LoginResponse;
    const CODE: u8 = 1;
}