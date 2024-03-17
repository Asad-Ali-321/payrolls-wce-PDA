<?php
defined('BASEPATH') or exit('No direct script access allowed');

class Officials extends CI_Controller
{
	public function index()
	{
		$data = $this->db->query('call getOfficials()')->result();
		echo json_encode(
			$data
		);
	}

	public function create()
	{
		$this->db->insert('officials', $_POST);
		echo json_encode(array('id' => $this->db->insert_id(), 'status' => $this->db->error()));
	}

	public function create_banks()
	{
		echo json_encode($this->db->insert('bank_details', $_POST));
	}

	public function update()
	{
		$this->db->where('official_id', $_POST['official_id']);
		$this->db->update('officials', $_POST);
		echo json_encode($this->db->error());
	}

	public function update_banks()
	{
		$this->db
			->where('official_id', $_POST['official_id'])
			->delete('bank_details');


		$this->db->insert('bank_details', $_POST);

		echo json_encode(true);
	}

	public function getOne($id = 0)
	{
		echo json_encode(array(
			'bankData' => $this->db
				->where('official_id', $id)
				->get('bank_details')
				->row(),
			'userData' => $this->db
				->select('officials.*, extensions_validity.validity_to as valid_upto')
				->join('extensions_validity', 'extensions_validity.official_id=officials.official_id', 'left')
				->where('officials.official_id', $id)
				->get('officials')
				->row()
		));
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
