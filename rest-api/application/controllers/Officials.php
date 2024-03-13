<?php
defined('BASEPATH') or exit('No direct script access allowed');

class Officials extends CI_Controller
{
	public function index()
	{
		echo json_encode($this->db->query('call getOfficials()')->result());
	}

	public function create()
	{
		echo json_encode($this->db->insert('officials', $_POST));
	}

	public function update()
	{
		$this->db->where('official_id', $_POST['official_id']);
		$this->db->update('officials', $_POST);
		echo json_encode(true);
	}

	public function getOne($id = 0)
	{
		echo json_encode($this->db
			->where('official_id', $id)
			->get('officials')->row());
	}

	public function deleteByID($id = 0)
	{
		echo json_encode($this->db
			->where('official_id', $id)
			->delete('officials'));
	}

	public function directorWiseStaff()
	{
		echo json_encode($this->db->query('call getDirectorateWiseStaff()')->result());
	}

	public function designationWiseStaff()
	{
		echo json_encode($this->db->query('call getDesignationWiseStaff()')->result());
	}

	public function monthlyPayWiseStaff()
	{
		echo json_encode($this->db->query('call getMonthlyPayWiseStaff()')->result());
	}
}
