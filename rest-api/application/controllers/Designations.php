<?php
defined('BASEPATH') or exit('No direct script access allowed');

class Designations extends CI_Controller
{
	public function index()
	{
		echo json_encode($this->db->get('designations')->result());
	}

	public function create()
	{
		$this->db->insert('designations', $_POST);
		echo json_encode($this->db->error());
	}

	public function deleteByID($id = 0)
	{
		echo json_encode($this->db
			->where('designation_id', $id)
			->delete('designations'));
	}

	public function getOne($id = 0)
	{
		echo json_encode($this->db
			->where('designation_id', $id)
			->get('designations')
			->row());
	}

	public function update()
	{
		$this->db->where('designation_id', $_POST['designation_id']);
		$this->db->update('designations', $_POST);
		echo json_encode($this->db->error());
	}
}
