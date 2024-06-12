use serde::{Deserialize, Serialize};
use crate::api::request::Request;

#[derive(Serialize)]
pub struct SubmitVerificationCodeRequest {
    pub code: String,
}

#[derive(Deserialize)]
pub struct SubmitVerificationCodeResponse {
    pub status: bool,
    #[serde(rename = "isVerified")]
    pub is_verified: bool,
}

impl Request for SubmitVerificationCodeRequest {
    type Response = SubmitVerificationCodeResponse;
    const CODE: u8 = 20;
}
