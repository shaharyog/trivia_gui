use serde::{Deserialize, Serialize};

use crate::api::request::Request;

#[derive(Serialize)]
pub struct GetGameResultsRequest;

#[derive(Deserialize)]
pub struct PlayerResult {
    pub username: String,
    #[serde(rename = "correctAnswerCount")]
    pub correct_answer_count: u32,
    #[serde(rename = "wrongAnswerCount")]
    pub wrong_answer_count: u32,
    #[serde(rename = "avgAnswerTime")]
    pub avg_answer_time: u32,
}


#[derive(Deserialize)]
pub struct GetGameResultsResponse {
    pub status: bool,
    #[serde(flatten)]
    pub players_results: Vec<PlayerResult>,
}

impl Request for GetGameResultsRequest {
    type Response = GetGameResultsResponse;
    const CODE: u8 = 19;
}