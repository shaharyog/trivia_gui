use serde::{Deserialize, Serialize};

use crate::api::request::Request;

#[derive(Serialize)]
pub struct JoinRoomRequest {
    #[serde(rename = "roomId")]
    pub room_id: String,
}

#[derive(Deserialize)]
pub struct JoinRoomResponse {
    pub status: bool,
}

impl Request for JoinRoomRequest {
    type Response = JoinRoomResponse;
    const CODE: u8 = 9;
}
