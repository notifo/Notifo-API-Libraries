<?php

class Notifo_API {
  
  const API_ROOT = 'https://api.notifo.com/';
  const API_VER = 'v1';

  protected $apiUsername;
  protected $apiSecret;

  /**
   * class constructor
   */
  function __construct($apiUsername, $apiSecret) {
    $this->apiUsername = $apiUsername;
    $this->apiSecret = $apiSecret;
  }

  /**
   * function: sendNotification
   * @param: $params - an associative array of parameters to send to the Notifo API.
   * These can be any of the following:
   * to, msg, label, title, uri
   * See https://api.notifo.com/ for more information
   */
  function sendNotification($params) {
    $validFields = array('to', 'msg', 'label', 'title', 'uri');
    $params = array_intersect_key($params, array_flip($validFields));
    return $this->sendRequest('send_notification', $params);
  } /* end function sendNotification */

  /**
   * function: subscribeUser
   * @param: $username - the username to subscribe to your Notifo service
   * See https://api.notifo.com/ for more information
   */
  function subscribeUser($username) {
    return $this->sendRequest('subscribe_user', array('username' => $username));
  } /* end function subscribeUser */


  /**
   * helper function to send the requests
   * @param $method - name of remote method to call
   * @param $data - array with arguments for remote method
   */
  protected function sendRequest($method, $data) {
    $ch = curl_init(self::API_ROOT.self::API_VER.'/'.$method);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
    curl_setopt($ch, CURLOPT_POST, true);
    curl_setopt($ch, CURLOPT_POSTFIELDS, $data);
    curl_setopt($ch, CURLOPT_USERPWD, $this->apiUsername.':'.$this->apiSecret);
    curl_setopt($ch, CURLOPT_HEADER, false);
    $result = curl_exec($ch);
    $result = json_decode($result, true);
    return $result;
  } /* end function sendRequest */

// for backwards compatibility
  function send_notification($params) { return json_encode($this->sendNotification($params)); }
  function subscribe_user($username) { return json_encode($this->subscribeUser($username)); }
  
} /* end class Notifo_API */

?>
