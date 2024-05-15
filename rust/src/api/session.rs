use std::net::{SocketAddr, TcpStream};
use std::str::FromStr;
use std::time::Duration;
use crate::api::error::{Error};
use crate::api::request::{Request};
use crate::api::request::get_user_data::{GetUserDataRequest, UserData};
use crate::api::request::login::LoginRequest;
use crate::api::request::signup::SignupRequest;
use crate::api::request::logout::LogoutRequest;
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
        let socket = TcpStream::connect_timeout(&SocketAddr::from_str(&address).map_err(|_| Error::InvalidAddress(address))?, Duration::from_secs(1)).map_err(|err| Error::ServerConnectionError(err.to_string()))?;
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
    pub fn get_user_data(&mut self) -> Result<UserData, Error> {
        let get_user_data_request = GetUserDataRequest;
        let response = get_user_data_request.write_and_read(&mut self.socket)?;
        if !response.status {
            return Err(Error::InternalServerError);
        }

        Ok(response.user_data)
    }

    #[flutter_rust_bridge::frb]
    pub fn update_user_data(&mut self, update_user_data_request: UpdateUserDataRequest) -> Result<(), Error> {
        let response = update_user_data_request.write_and_read(&mut self.socket)?;
        if !response.status {
            return Err(Error::UpdateUserDataError(response.message));
        }

        Ok(())
    }
}