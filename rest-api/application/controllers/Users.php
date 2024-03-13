<?php
defined('BASEPATH') or exit('No direct script access allowed');

class Users extends CI_Controller
{

	public function index()
	{
		echo json_encode($this->db->query('call getUsers()')->result());
	}

	public function create()
	{
		$this->db->insert('users', $_POST);
		echo json_encode($this->db->error());
	}

	public function unblock($user_id = 0)
	{
		$this->db->where('user_id', $user_id);
		$this->db->update('users', array('status' => 'active', 'attempts' => 0));
		echo json_encode(true);
	}

	public function getOne($id = 0)
	{
		echo json_encode($this->db
			->where('user_id', $id)
			->get('users')->row());
	}

	public function update()
	{
		$this->db->where('user_id', $_POST['user_id']);
		$this->db->update('users', $_POST);
		echo json_encode($this->db->error());
	}
}
