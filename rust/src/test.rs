use crate::api;

#[test]
fn test_session(){
    let session = api::session::Session::login(api::request::login::LoginRequest{
        username: "test".to_string(),
        password: "test".to_string(),
    }, "1.1.1.1:8826".to_string()).unwrap();
}