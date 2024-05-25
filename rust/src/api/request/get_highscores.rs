use crate::api::request::Request;
use serde::{Deserialize, Serialize};
use crate::api::request::get_room_players::Player;

#[derive(Serialize)]
pub struct GetHighScoresRequest;


#[derive(Deserialize)]
pub struct GetHighScoresResponse {
    pub status: bool,
    pub players: Vec<Player>,
}

impl Request for GetHighScoresRequest {
    type Response = GetHighScoresResponse;
    const CODE: u8 = 6;
}
