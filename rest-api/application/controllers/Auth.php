<?php
defined('BASEPATH') or exit('No direct script access allowed');

class Auth extends CI_Controller
{

	public function validate()
	{
		echo json_encode($this->db->query('call Auth("' . $_POST['email'] . '","' . $_POST['password'] . '")')->row());
	}
}
