<?php
defined('BASEPATH') or exit('No direct script access allowed');

class Pay_Rolls extends CI_Controller
{
	public function index($month = null)
	{
		echo json_encode($this->db->query('call getPayRolls("' . $month . '")')->result());
	}

	public function getEmployeePayroll()
	{
		echo json_encode($this->db->query('call getEmployeePayroll("' . $_POST['_file_no'] . '","' . $_POST['_cnic'] . '","' . $_POST['_month'] . '")')->row());
	}

	public function updateRow()
	{
		$this->db
			->where('official_id', $_POST['official_id'])
			->where('month', $_POST['month'])
			->delete('monthly_pay_rolls');
		echo json_encode($this->db->insert('monthly_pay_rolls', $_POST));
	}

	public function create()
	{
		$this->db
			->where('official_id', $_POST['official_id'])
			->where('month', $_POST['month'])
			->delete('monthly_pay_rolls');
		$data = array(
			'official_id' => $_POST['official_id'],
			'month' => $_POST['month'],
			'monthly_pay' => $_POST['monthly_pay'],
			'arrears' => $_POST['arrears'],
			'over_time' => $_POST['over_time'],
			'income_tax' => $_POST['income_tax'],
			'union_fund' => $_POST['union_fund'],
			'recovery' => $_POST['recovery'],
			'absentees' => $_POST['absentees'],
			'gross_pay' => $_POST['gross_pay'],
			'deductions' => $_POST['deductions'],
			'net_salary' => $_POST['net_salary'],
			'remarks' => $_POST['remarks'],
			'absentees_amount' => $_POST['absentees_amount']
		);
		$this->db->insert('monthly_pay_rolls', $data);
		echo json_encode($this->db->error());
	}
}
