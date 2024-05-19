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
pub struct UserStatistics {
    #[serde(rename = "averageAnswerTime")]
    pub average_answer_time: Option<u32>,
    #[serde(rename = "correctAnswers")]
    pub correct_answers: u32,
    #[serde(rename = "wrongAnswers")]
    pub wrong_answers: u32,
    #[serde(rename = "totalAnswers")]
    pub total_answers: u32,
    #[serde(rename = "totalGames")]
    pub total_games: u32,
    #[serde(rename = "score")]
    pub score: u32,
}

#[derive(Deserialize)]
pub struct UserDataAndStatistics {
    #[serde(rename = "userData")]
    pub user_data: UserData,
    #[serde(rename = "userStatistics")]
    pub user_statistics: UserStatistics,
}
#[derive(Deserialize)]
pub struct GetUserDataResponse {
    pub status: bool,
    #[serde(flatten)]
    pub user_data_and_statistics: UserDataAndStatistics,
}

impl Request for GetUserDataRequest {
    type Response = GetUserDataResponse;
    const CODE: u8 = 10;
}
