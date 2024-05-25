use crate::api::request::Request;
use serde::{Deserialize, Serialize};

#[derive(Serialize)]
pub struct SignupRequest {
    pub username: String,
    pub password: String,
    pub email: String,
    pub address: String,
    #[serde(rename = "phoneNumber")]
    pub phone_number: String,
    pub birthday: String,
}

#[derive(Deserialize)]
pub struct SignupResponse {
    pub status: bool,
    pub message: String,
}

impl Request for SignupRequest {
    type Response = SignupResponse;
    const CODE: u8 = 2;
}
