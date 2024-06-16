use crate::api::request::Request;
use serde::{Deserialize, Serialize};
#[derive(Serialize)]
pub struct ForgotPasswordRequest {
    pub email: String,
}

#[derive(Deserialize)]
pub struct ForgotPasswordResponse {
    pub status: bool,
}

impl Request for ForgotPasswordRequest {
    type Response = ForgotPasswordResponse;
    const CODE: u8 = 22;
}
