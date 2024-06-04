use serde::{Deserialize, Serialize};

use crate::api::request::Request;

#[derive(Serialize)]
pub struct StartGameRequest;

#[derive(Deserialize)]
pub struct StartGameResponse {
    pub status: bool,
}

impl Request for StartGameRequest {
    type Response = StartGameResponse;
    const CODE: u8 = 13;
}
