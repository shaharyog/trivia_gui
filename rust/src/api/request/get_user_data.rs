use crate::api::request::Request;
use chrono::NaiveDateTime;
use serde::{Deserialize, Serialize};
#[derive(Serialize)]
pub struct GetUserDataRequest;

#[derive(Deserialize)]
pub struct UserData {
    pub username: String,
    pub email: String,
    pub address: String,
    #[serde(rename = "phoneNumber")]
    pub phone_number: String,
    pub birthday: String,
    #[serde(rename = "avatarColor")]
    pub avatar_color: String,
    #[serde(rename = "memberSince", with = "chrono::naive::serde::ts_seconds")]
    pub member_since: NaiveDateTime,
}

#[derive(Deserialize)]
pub struct GetUserDataResponse {
    pub status: bool,
    #[serde(rename = "userData")]
    pub user_data: UserData,
}

impl Request for GetUserDataRequest {
    type Response = GetUserDataResponse;
    const CODE: u8 = 10;
}
