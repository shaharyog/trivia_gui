use serde::{Deserialize, Serialize};

use crate::api::request::Request;

#[derive(Serialize)]
pub struct LeaveGameRequest;

#[derive(Deserialize)]
pub struct LeaveGameResponse {
    pub status: bool,
}

impl Request for LeaveGameRequest {
    type Response = LeaveGameResponse;
    const CODE: u8 = 16;
}
