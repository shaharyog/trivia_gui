use serde::{Deserialize, Serialize};
use crate::api::request::get_question::Question;
use crate::api::request::get_room_players::Player;

use crate::api::request::Request;

#[derive(Serialize)]
pub struct GetGameResultsRequest;

#[derive(Deserialize)]
pub struct PlayerResult {
    pub player: Player,
    #[serde(rename = "isOnline")]
    pub is_online: bool,
    #[serde(rename = "scoreChange")]
    pub score_change: i32,
    #[serde(rename = "correctAnswerCount")]
    pub correct_answer_count: u32,
    #[serde(rename = "wrongAnswerCount")]
    pub wrong_answer_count: u32,
    #[serde(rename = "avgAnswerTime")]
    pub avg_answer_time: u32,
}


#[derive(Deserialize)]
pub struct QuestionAnswered {
    pub question: String,
    pub answers: Vec<(u32, String)>,
    #[serde(rename = "correctAnswer")]
    pub correct_answer: u32,
    #[serde(rename = "userAnswer")]
    pub user_answer: u32,
    #[serde(rename = "timeTaken")]
    pub time_taken: u32,
}

#[derive(Deserialize)]
pub struct GameResults {
    #[serde(rename = "userAnswers")]
    pub user_answers: Vec<QuestionAnswered>,
    #[serde(rename = "players")]
    pub players_results: Vec<PlayerResult>,
}
#[derive(Deserialize)]
pub struct GetGameResultsResponse {
    pub status: bool,
    #[serde(flatten)]
    pub game_results: GameResults,
}

impl Request for GetGameResultsRequest {
    type Response = GetGameResultsResponse;
    const CODE: u8 = 19;
}