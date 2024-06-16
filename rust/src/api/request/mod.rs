pub mod get_room_players;
pub mod get_rooms;
pub mod get_user_data;
pub mod login;
pub mod logout;
pub mod signup;
pub mod update_user_data;
pub mod create_room;
pub mod get_highscores;
pub mod get_room_state;
pub mod join_room;
pub mod leave_room;
pub mod close_room;
pub mod get_question;
pub mod leave_game;
pub mod submit_answer;
pub mod get_game_results;
pub mod start_game;
pub mod submit_verification_code;
pub mod resend_verification_code;
pub mod forgot_password;

use crate::api::error::Error;
use serde::{Deserialize, Serialize};
use std::io::{Read, Write};
const ERROR_RESPONSE_CODE: u8 = 0;
pub trait Request: Serialize {
    type Response: for<'a> Deserialize<'a>;

    const CODE: u8;

    fn write_request(&self, writer: &mut impl Write) -> Result<(), Error> {
        let serialized_json = serde_json::to_vec(self)
            .map_err(|err| Error::RequestSerializationError(err.to_string()))?;
        let length = u32::try_from(serialized_json.len()).map_err(|_| Error::RequestTooBig)?;

        writer
            .write(&[Self::CODE])
            .map_err(|err| Error::ServerConnectionError(err.to_string()))?;
        writer
            .write_all(&length.to_be_bytes())
            .map_err(|err| Error::ServerConnectionError(err.to_string()))?;
        writer
            .write_all(&serialized_json)
            .map_err(|err| Error::ServerConnectionError(err.to_string()))?;
        Ok(())
    }

    fn read_response(&self, reader: &mut impl Read) -> Result<Self::Response, Error> {
        let mut code = [0u8; 1];
        let mut length = [0u8; 4];
        reader
            .read_exact(&mut code)
            .map_err(|err| Error::ServerConnectionError(err.to_string()))?;

        let code = code[0];
        reader
            .read_exact(&mut length)
            .map_err(|err| Error::ServerConnectionError(err.to_string()))?;

        let length = u32::from_be_bytes(length);
        let mut serialized_json = vec![0u8; length as usize];
        reader
            .read_exact(&mut serialized_json)
            .map_err(|err| Error::ServerConnectionError(err.to_string()))?;
        if code == Self::CODE {
            Ok(serde_json::from_slice(&serialized_json)
                .map_err(|err| Error::ResponseDeserializationError(err.to_string()))?)
        } else if code == ERROR_RESPONSE_CODE {
            Err(Error::ResponseError(
                serde_json::from_slice::<ErrorResponse>(&serialized_json)
                    .map_err(|err| Error::ResponseDeserializationError(err.to_string()))?
                    .message,
            ))
        } else {
            Err(Error::InvalidResponseCode(code))
        }
    }

    fn write_and_read(
        &self,
        reader_writer: &mut (impl Read + Write),
    ) -> Result<Self::Response, Error> {
        self.write_request(reader_writer)?;
        self.read_response(reader_writer)
    }
}

#[derive(Deserialize)]
pub struct ErrorResponse {
    pub message: String,
}
