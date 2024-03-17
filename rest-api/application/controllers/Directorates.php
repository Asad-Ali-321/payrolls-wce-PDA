<?php
defined('BASEPATH') or exit('No direct script access allowed');

class Directorates extends CI_Controller
{
	public function index()
	{
		echo json_encode($this->db->get('directorates')->result());
	}

	public function create()
	{
		$this->db->insert('directorates', $_POST);
		echo json_encode($this->db->error());
	}

	public function deleteByID($id = 0)
	{
		echo json_encode($this->db
			->where('directorate_id', $id)
			->delete('directorates'));
	}

	public function getOne($id = 0)
	{
		echo json_encode($this->db
			->where('directorate_id', $id)
			->get('directorates')
			->row());
	}

	public function update()
	{
		$this->db->where('directorate_id', $_POST['directorate_id']);
		$this->db->update('directorates', $_POST);
		echo json_encode($this->db->error());
	}
}
