use crate::api::request::Request;
use serde::{Deserialize, Serialize};
#[derive(Serialize)]
pub struct CreateRoomRequest{
    #[serde(flatten)]
    pub room_data: RoomData
}

#[derive(Serialize, Deserialize)]
pub struct RoomData{
    pub name: String,
    #[serde(rename = "maxPlayers")]
    pub max_players: u32,
    #[serde(rename = "questionCount")]
    pub question_count: u32,
    #[serde(rename = "timePerQuestion")]
    pub time_per_question: u32,
}

#[derive(Deserialize)]
pub struct CreateRoomResponse {
    pub status: bool,
}

impl Request for CreateRoomRequest {
    type Response = CreateRoomResponse;
    const CODE: u8 = 8;
}
