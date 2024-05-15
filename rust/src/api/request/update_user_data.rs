use serde::{Deserialize, Serialize};
use crate::api::request::Request;
#[derive(Serialize)]
pub struct UpdateUserDataRequest{
    pub password: Option<String>,
    pub email: String,
    pub address: String,
    #[serde(rename = "phoneNumber")]
    pub phone_number: String,
    #[serde(rename = "avatarColor")]
    pub avatar_color: String,

}


#[derive(Deserialize)]
pub struct UpdateUserDataResponse {
    pub status: bool,
    pub message: String,
}

impl Request for UpdateUserDataRequest {
    type Response = UpdateUserDataResponse;
    const CODE: u8 = 11;
}