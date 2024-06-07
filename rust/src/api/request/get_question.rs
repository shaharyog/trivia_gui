use serde::{Deserialize, Serialize};

use crate::api::request::Request;

#[derive(Serialize)]
pub struct GetCurrentQuestionRequest;

#[derive(Deserialize)]
pub struct Question {
    #[serde(rename = "questionId")]
    pub question_id: u32,
    pub question: String,
    pub answers: Vec<(u32, String)>,
}

#[derive(Deserialize)]
pub struct GetCurrentQuestionResponse {
    pub status: bool,
    #[serde(flatten)]
    pub question: Question,
}

impl Request for GetCurrentQuestionRequest {
    type Response = GetCurrentQuestionResponse;
    const CODE: u8 = 17;
}
