use crate::api::request::Request;
use serde::{Deserialize, Serialize};

#[derive(Serialize)]
pub struct LogoutRequest;

#[derive(Deserialize)]
pub struct LogoutResponse {
    pub status: bool,
}

impl Request for LogoutRequest {
    type Response = LogoutResponse;
    const CODE: u8 = 3;
}
