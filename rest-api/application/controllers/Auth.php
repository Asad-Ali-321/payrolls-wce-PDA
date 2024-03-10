<?php
defined('BASEPATH') or exit('No direct script access allowed');

class Auth extends CI_Controller
{

	/**
	 * Index Page for this controller.
	 *
	 * Maps to the following URL
	 * 		http://example.com/index.php/welcome
	 *	- or -
	 * 		http://example.com/index.php/welcome/index
	 *	- or -
	 * Since this controller is set as the default controller in
	 * config/routes.php, it's displayed at http://example.com/
	 *
	 * So any other public methods not prefixed with an underscore will
	 * map to /index.php/welcome/<method_name>
	 * @see https://codeigniter.com/userguide3/general/urls.html
	 */
	public function index()
	{
		$this->load->view('welcome_message');
	}
	public function create()
	{
		try {
			$SQL =
				'INSERT INTO ' .
				$_POST['collection'] .
				' ' .
				$this->getHeaderAndValues($_POST['data'])['headers'] .
				' VALUES ' .
				$this->getHeaderAndValues($_POST['data'])['values'];
			echo 'QUERY: ' . $SQL . '<br>';
			$results = $this->db->query($SQL);
			return ['status' => true, '_id' => $results];
		} catch (Exception $error) {
			echo 'Error occurred while executing query: ' . $error->getMessage() . '<br>';
			return ['status' => false, 'error' => $error->getMessage()];
		}
	}

	public function find()
	{
		echo json_encode($this->crud_model->find($_POST));
	}

	public function findSingle()
	{
		try {
			$WHERE = $this->getHeaderAndValuesWhere($_POST['where']);
			$SQL = 'SELECT * FROM ' . $_POST['collection'];
			$SQL = $WHERE ? $SQL . ' WHERE ' . $WHERE : $SQL;
			$results = $this->db->query($SQL)->row();
			return ['status' => true, 'data' => count($results) > 0 ? $results[0] : []];
		} catch (Exception $error) {
			echo 'Error occurred while executing query: ' . $error->getMessage() . '<br>';
			return ['status' => false, 'error' => $error->getMessage()];
		}
	}

	public function delete()
	{
		try {
			$WHERE = $this->getHeaderAndValuesWhere($_POST['where']);
			if (!$WHERE)
				return ['status' => false, 'error' => 'where condition is mandatory for delete'];
			$SQL = 'DELETE FROM ' . $_POST['collection'];
			$SQL = $WHERE ? $SQL . ' WHERE ' . $WHERE : $SQL;
			$results = $this->db->query($SQL);
			return ['status' => true, 'data' => $results];
		} catch (Exception $error) {
			echo 'Error occurred while executing query: ' . $error->getMessage() . '<br>';
			return ['status' => false, 'error' => $error->getMessage()];
		}
	}

	public function update()
	{
		try {
			$WHERE = $this->getHeaderAndValuesWhere($_POST['where']);
			$UPDATE = $this->getHeaderAndValuesWhere($_POST['data']);
			if (!$WHERE || !$UPDATE)
				return ['status' => false, 'error' => 'data & where clauses are mandatory for update'];
			$SQL = 'UPDATE ' . $_POST['collection'];
			$SQL = $UPDATE ? $SQL . ' SET ' . $UPDATE : $SQL;
			$SQL = $WHERE ? $SQL . ' WHERE ' . $WHERE : $SQL;
			$results = $this->db->query($SQL);
			return ['status' => true, 'data' => $results];
		} catch (Exception $error) {
			echo 'Error occurred while executing query: ' . $error->getMessage() . '<br>';
			return ['status' => false, 'error' => $error->getMessage()];
		}
	}

	public function getHeaderAndValues($data)
	{
		$headers = '(' . implode(',', array_keys($data)) . ')';
		$values = '(' . implode(',', array_map(function ($value) {
			return "'" . $this->stringCast($value) . "'";
		}, $data)) . ')';
		return ['headers' => $headers, 'values' => $values];
	}

	public function stringCast($string)
	{
		return is_string($string) ? str_replace("'", "`", $string) : $string;
	}

	public function getHeaderAndValuesWhere($data)
	{
		try {
			if (!is_array($data)) return false;
			$keyValuePairs = array_map(function ($key, $value) {
				return "`$key`='$value'";
			}, array_keys($data), array_map([$this, 'stringCast'], $data));
			return implode(',', $keyValuePairs);
		} catch (Exception $error) {
			// Log the error or handle it as required
			return false;
		}
	}
}
