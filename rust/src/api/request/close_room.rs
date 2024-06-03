use serde::{Deserialize, Serialize};

use crate::api::request::Request;

#[derive(Serialize)]
pub struct CloseRoomRequest;

#[derive(Deserialize)]
pub struct CloseRoomResponse {
    pub status: bool,
}

impl Request for CloseRoomRequest {
    type Response = CloseRoomResponse;
    const CODE: u8 = 12;
}
