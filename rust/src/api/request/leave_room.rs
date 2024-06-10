use serde::{Deserialize, Serialize};

use crate::api::request::Request;

#[derive(Serialize)]
pub struct LeaveRoomRequest;

#[derive(Deserialize)]
pub struct LeaveRoomResponse {
    pub status: bool,
}

impl Request for LeaveRoomRequest {
    type Response = LeaveRoomResponse;
    const CODE: u8 = 15;
}
