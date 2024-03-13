<?php
defined('BASEPATH') or exit('No direct script access allowed');

class Pay_Rolls extends CI_Controller
{
	public function index($month = null)
	{
		echo json_encode($this->db->query('call getPayRolls("' . $month . '")')->result());
	}

	public function updateRow()
	{
		$this->db
			->where('official_id', $_POST['official_id'])
			->where('month', $_POST['month'])
			->delete('monthly_pay_rolls');
		echo json_encode($this->db->insert('monthly_pay_rolls', $_POST));
	}
}
