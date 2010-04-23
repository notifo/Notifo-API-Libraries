<?php

class Notifo_API {
  
  private $apiusername;
  private $apisecret;

  private $API_ROOT = "https://api.notifo.com/";
  private $API_VER  = "v1";
  private $API_SUBSCRIBE_USER_METHOD = "/subscribe_user";
  private $API_SEND_NOTIFICATION_METHOD = "/send_notification";

  /* class constructor */
  function Notifo_API($apiusername = "", $apisecret = "") {
    $this->apiusername = $apiusername;
    $this->apisecret = $apisecret;
  }

  function set_apiusername($val) {
    $this->apiusername = $val;
  }

  function set_apisecret($val) {
    $this->apisecret = $val;
  }

  /*
   * function: send_notification
   * @param: $params - an associative array of parameters to send to the Notifo API.
   *                   These can be any of the following:
   *                   to, msg, label, title, uri
   *                   See https://api.notifo.com/ for more information
   */
  function send_notification($params) {
    
    $data = "";
    $data .= "to=" . $params["to"];
    $data .= "&msg=" . urlencode($params["msg"]);

    if (isset($params["label"]) && $params["label"] != "") {
      $data .= "&label=" . urlencode($params["label"]);
    }

    if (isset($params["title"]) && $params["title"] != "") {
      $data .= "&title=" . urlencode($params["title"]);
    }

    if (isset($params["uri"]) && $params["uri"] != "") {
      $data .= "&uri=" . urlencode($params["uri"]);
    }

    $api_url = $this->API_ROOT . $this->API_VER . $this->API_SEND_NOTIFICATION_METHOD;

    $response = $this->send_request($api_url, "POST", $data);

    return $response;
  } /* end function api_send_notification */

  /*
   * function: subscribe_user
   * @param: $username - the username to subscribe to your Notifo service
   *                     See https://api.notifo.com/ for more information
   */
  function subscribe_user($username) {
    
    $data = "username=" . $username;

    $api_url = $this->API_ROOT . $this->API_VER . $this->API_SUBSCRIBE_USER_METHOD;

    $response = $this->send_request($api_url, "POST", $data);

    return $response;
  } /* end function api_subscribe_user */

  /* helper function to send the requests */
  function send_request($url, $type, $data) {

    $ch = curl_init();
    curl_setopt($ch, CURLOPT_URL, $url);
    curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, FALSE);
    curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, FALSE);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
    curl_setopt($ch, CURLOPT_POSTFIELDS, $data);
    curl_setopt($ch, CURLOPT_USERPWD, $this->apiusername . ":" . $this->apisecret);
    curl_setopt($ch, CURLOPT_HEADER, false);
    curl_setopt($ch, CURLOPT_HTTP_VERSION, CURL_HTTP_VERSION_1_0);
    if ($type == "POST") {
      curl_setopt($ch, CURLOPT_POST, 1);
    }

    $result = curl_exec($ch);

    return $result;

  } /* end function send_request */
  
} /* end class Notifo_API */