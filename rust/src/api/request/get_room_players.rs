use crate::api::request::Request;
use serde::{Deserialize, Serialize};
#[derive(Serialize)]
pub struct GetRoomPlayersRequest {
    #[serde(rename = "roomId")]
    pub room_id: String,
}

#[derive(Deserialize)]
pub struct Player {
    pub username: String,
    #[serde(rename = "avatarColor")]
    pub avatar_color: String,
    pub score: u32,
}
#[derive(Deserialize)]
pub struct GetRoomPlayersResponse {
    pub status: bool,
    pub players: Vec<Player>,
}

impl Request for GetRoomPlayersRequest {
    type Response = GetRoomPlayersResponse;
    const CODE: u8 = 5;
}
