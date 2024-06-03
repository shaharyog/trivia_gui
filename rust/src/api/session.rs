use std::net::{SocketAddr, TcpStream};
use std::str::FromStr;
use std::time::Duration;

use crate::api::error::Error;
use crate::api::request::create_room::{CreateRoomRequest, RoomData};
use crate::api::request::get_highscores::GetHighScoresRequest;
use crate::api::request::get_room_players::{GetRoomPlayersRequest, Player};
use crate::api::request::get_room_state::{GetRoomStateRequest, GetRoomStateResponse};
use crate::api::request::get_rooms::{GetRoomsRequest, Room};
use crate::api::request::get_user_data::{GetUserDataRequest, UserDataAndStatistics};
use crate::api::request::join_room::JoinRoomRequest;
use crate::api::request::leave_room::LeaveRoomRequest;
use crate::api::request::login::LoginRequest;
use crate::api::request::logout::LogoutRequest;
use crate::api::request::Request;
use crate::api::request::signup::SignupRequest;
use crate::api::request::update_user_data::UpdateUserDataRequest;

#[flutter_rust_bridge::frb(opaque)]
pub struct Session {
    #[allow(dead_code)]
    socket: TcpStream,
}

impl Session {
    #[flutter_rust_bridge::frb]
    pub fn login(login_request: LoginRequest, address: String) -> Result<Session, Error> {
        let mut socket = Self::connect(address)?;
        let response = login_request.write_and_read(&mut socket)?;
        if !response.status {
            return Err(Error::LoginError(response.message));
        }
        Ok(Session { socket })
    }

    #[flutter_rust_bridge::frb]
    pub fn signup(signup_request: SignupRequest, address: String) -> Result<Session, Error> {
        let mut socket = Self::connect(address)?;
        let response = signup_request.write_and_read(&mut socket)?;
        if !response.status {
            return Err(Error::SignupError(response.message));
        }
        Ok(Session { socket })
    }

    fn connect(address: String) -> Result<TcpStream, Error> {
        let socket = TcpStream::connect_timeout(
            &SocketAddr::from_str(&address).map_err(|_| Error::InvalidAddress(address))?,
            Duration::from_secs(1),
        )
            .map_err(|err| Error::ServerConnectionError(err.to_string()))?;
        Ok(socket)
    }

    #[flutter_rust_bridge::frb]
    pub fn logout(mut self) -> Result<(), Error> {
        let logout_request = LogoutRequest;
        let response = logout_request.write_and_read(&mut self.socket)?;
        if !response.status {
            return Err(Error::LogoutError);
        }
        Ok(())
    }

    #[flutter_rust_bridge::frb]
    pub fn get_user_data(&mut self) -> Result<UserDataAndStatistics, Error> {
        let get_user_data_request = GetUserDataRequest;
        let response = get_user_data_request.write_and_read(&mut self.socket)?;
        if !response.status {
            return Err(Error::InternalServerError);
        }

        Ok(response.user_data_and_statistics)
    }

    #[flutter_rust_bridge::frb]
    pub fn update_user_data(
        &mut self,
        update_user_data_request: UpdateUserDataRequest,
    ) -> Result<(), Error> {
        let response = update_user_data_request.write_and_read(&mut self.socket)?;
        if !response.status {
            return Err(Error::UpdateUserDataError(response.message));
        }

        Ok(())
    }

    #[flutter_rust_bridge::frb]
    pub fn get_rooms(&mut self) -> Result<Vec<Room>, Error> {
        let response = GetRoomsRequest.write_and_read(&mut self.socket)?;
        if !response.status {
            return Err(Error::InternalServerError);
        }

        Ok(response.rooms)
    }

    #[flutter_rust_bridge::frb]
    pub fn get_room_players(&mut self, room_id: String) -> Result<Vec<Player>, Error> {
        let response = GetRoomPlayersRequest {
            room_id: room_id.clone(),
        }
            .write_and_read(&mut self.socket)?;
        if !response.status {
            return Err(Error::InvalidRoomId(room_id));
        }

        Ok(response.players)
    }

    #[flutter_rust_bridge::frb]
    pub fn create_room(&mut self, room_data: RoomData) -> Result<(), Error> {
        let response = CreateRoomRequest {
            room_data
        }
            .write_and_read(&mut self.socket)?;
        if !response.status {
            return Err(Error::CouldNotCreateRoom);
        }

        Ok(())
    }

    #[flutter_rust_bridge::frb]
    pub fn get_highscores(&mut self) -> Result<Vec<Player>, Error> {
        let response = GetHighScoresRequest.write_and_read(&mut self.socket)?;
        if !response.status {
            return Err(Error::InternalServerError);
        }

        Ok(response.players)
    }

    #[flutter_rust_bridge::frb]
    pub fn get_room_state(&mut self) -> Result<GetRoomStateResponse, Error> {
        let response = GetRoomStateRequest.write_and_read(&mut self.socket)?;
        if !response.status {
            return Err(Error::InternalServerError);
        }

        Ok(response)
    }

    #[flutter_rust_bridge::frb]
    pub fn join_room(&mut self, room_id: String) -> Result<(), Error> {
        let response = JoinRoomRequest {
            room_id
        }.write_and_read(&mut self.socket)?;
        if !response.status {
            return Err(Error::InternalServerError);
        }

        Ok(())
    }

    #[flutter_rust_bridge::frb]
    pub fn leave_room(&mut self) -> Result<(), Error> {
        let response = LeaveRoomRequest.write_and_read(&mut self.socket)?;
        if !response.status {
            return Err(Error::InternalServerError);
        }

        Ok(())
    }
}
