use crate::api::request::Request;
use serde::{Deserialize, Serialize};
use crate::api::request::create_room::RoomData;

#[derive(Serialize)]
pub struct GetRoomsRequest;

#[derive(Deserialize)]
pub struct Room {
    pub id: String,
    #[serde(flatten)]
    pub room_data: RoomData,
    #[serde(rename = "isActive")]
    pub is_active: bool,
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
