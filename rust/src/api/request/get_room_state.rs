use serde::{Deserialize, Serialize};

use crate::api::request::get_room_players::Player;
use crate::api::request::Request;

#[derive(Serialize)]
pub struct GetRoomStateRequest;

#[derive(Deserialize)]
pub struct RoomState {
    #[serde(rename = "hasGameBegun")]
    pub has_game_begun: bool,
    pub players: Vec<Player>,
    #[serde(rename = "questionsCount")]
    pub questions_count: u32,
    #[serde(rename = "answerTimeout")]
    pub answer_timeout: u32,
    #[serde(rename = "maxPlayers")]
    pub max_players: u32,
    #[serde(rename = "isClosed")]
    pub is_closed: bool,
}

#[derive(Deserialize)]
pub struct GetRoomStateResponse {
    pub status: bool,
    #[serde(flatten)]
    pub room_state: RoomState,
}

impl Request for GetRoomStateRequest {
    type Response = GetRoomStateResponse;
    const CODE: u8 = 14;
}