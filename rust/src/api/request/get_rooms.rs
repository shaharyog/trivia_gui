use crate::api::request::Request;
use serde::{Deserialize, Serialize};
use crate::api::request::create_room::RoomData;
use crate::api::request::get_room_players::Player;

#[derive(Serialize)]
pub struct GetRoomsRequest;

#[derive(Deserialize)]
pub struct Room {
    pub id: String,
    #[serde(flatten)]
    pub room_data: RoomData,
    pub players: Vec<Player>,
    #[serde(rename = "isActive")]
    pub is_active: bool,
    #[serde(rename = "isFinished")]
    pub is_finished: bool,
}

#[derive(Deserialize)]
pub struct GetRoomsResponse {
    pub status: bool,
    pub rooms: Vec<Room>,
}

impl Request for GetRoomsRequest {
    type Response = GetRoomsResponse;
    const CODE: u8 = 4;
}
