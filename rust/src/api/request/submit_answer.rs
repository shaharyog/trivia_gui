use serde::{Deserialize, Serialize};

use crate::api::request::Request;

#[derive(Serialize)]
pub struct SubmitAnswerRequest {
    #[serde(rename = "answerId")]
    pub answer_id: u32,
    #[serde(rename = "questionId")]
    pub question_id: u32,
}

#[derive(Deserialize)]
pub struct SubmitAnswerResponse {
    pub status: bool,
    #[serde(rename = "correctAnswerId")]
    pub correct_answer_id: u32,
}

impl Request for SubmitAnswerRequest {
    type Response = SubmitAnswerResponse;
    const CODE: u8 = 18;
}
