use crate::api::request::Request;
use serde::{Deserialize, Serialize};

#[derive(Serialize)]
pub struct ResendVerificationCodeRequest;

#[derive(Deserialize)]
pub struct ResendVerificationCodeResponse {
    pub status: bool,
}

impl Request for ResendVerificationCodeRequest {
    type Response = ResendVerificationCodeResponse;
    const CODE: u8 = 21;
}
