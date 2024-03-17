<?php
defined('BASEPATH') or exit('No direct script access allowed');

class ChargeableHeads extends CI_Controller
{
	public function index()
	{
		echo json_encode($this->db->get('chargeable_heads')->result());
	}

	public function create()
	{
		$this->db->insert('chargeable_heads', $_POST);
		echo json_encode($this->db->error());
	}

	public function deleteByID($id = 0)
	{
		echo json_encode($this->db
			->where('chargeable_head_id', $id)
			->delete('chargeable_heads'));
	}

	public function getOne($id = 0)
	{
		echo json_encode($this->db
			->where('chargeable_head_id', $id)
			->get('chargeable_heads')
			->row());
	}

	public function update()
	{
		$this->db->where('chargeable_head_id', $_POST['chargeable_head_id']);
		$this->db->update('chargeable_heads', $_POST);
		echo json_encode($this->db->error());
	}
}
