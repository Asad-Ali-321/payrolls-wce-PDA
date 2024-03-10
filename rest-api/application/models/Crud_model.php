<?php
defined('BASEPATH') or exit('No direct script access allowed');

class Crud_model extends CI_Model
{
	public function create($body)
	{
		try {
			$SQL =
				'INSERT INTO ' .
				$body['collection'] .
				' ' .
				$this->getHeaderAndValues($body['data'])['headers'] .
				' VALUES ' .
				$this->getHeaderAndValues($body['data'])['values'];
			echo 'QUERY: ' . $SQL . '<br>';
			$results = $this->crudModel->query($SQL);
			return ['status' => true, '_id' => $results];
		} catch (Exception $error) {
			echo 'Error occurred while executing query: ' . $error->getMessage() . '<br>';
			return ['status' => false, 'error' => $error->getMessage()];
		}
	}

	public function find($body)
	{
		try {
			if (!isset($body['collection']))    throw new Exception("collection name must required");
			$SQL = 'SELECT * FROM ' . $body['collection'];

			$WHERE = isset($body['where']) ? $this->getHeaderAndValuesWhere($body['where']) : null;
			$SQL = $WHERE ? $SQL . ' WHERE ' . $WHERE : $SQL;

			$ORDER_BY = isset($body['order_by']) ? $body['order_by'] : null;
			$SQL = $ORDER_BY ? $SQL . ' ORDER BY ' . $ORDER_BY : $SQL;

			$query = $this->db->query($SQL);
			if ($query === false) throw new Exception($this->db->error()['message']);
			$results = $query->result();

			return ['status' => true, 'data' => $results];
		} catch (Exception $error) {
			return ['status' => false, 'error' => $error->getMessage()];
		}
	}

	public function execute_query($body)
	{
		try {
			if (!isset($body['query']))    throw new Exception("query required");

			$query = $this->db->query($body['query']);
			if ($query === false) throw new Exception($this->db->error()['message']);
			$results = $query->result();

			return ['status' => true, 'data' => $results];
		} catch (Exception $error) {
			return ['status' => false, 'error' => $error->getMessage()];
		}
	}

	public function findSingle($body)
	{
		try {
			$WHERE = $this->getHeaderAndValuesWhere($body['where']);
			$SQL = 'SELECT * FROM ' . $body['collection'];
			$SQL = $WHERE ? $SQL . ' WHERE ' . $WHERE : $SQL;
			$results = $this->crudModel->query($SQL);
			return ['status' => true, 'data' => count($results) > 0 ? $results[0] : []];
		} catch (Exception $error) {
			echo 'Error occurred while executing query: ' . $error->getMessage() . '<br>';
			return ['status' => false, 'error' => $error->getMessage()];
		}
	}

	public function delete($body)
	{
		try {
			$WHERE = $this->getHeaderAndValuesWhere($body['where']);
			if (!$WHERE)
				return ['status' => false, 'error' => 'where condition is mandatory for delete'];
			$SQL = 'DELETE FROM ' . $body['collection'];
			$SQL = $WHERE ? $SQL . ' WHERE ' . $WHERE : $SQL;
			$results = $this->crudModel->query($SQL);
			return ['status' => true, 'data' => $results];
		} catch (Exception $error) {
			echo 'Error occurred while executing query: ' . $error->getMessage() . '<br>';
			return ['status' => false, 'error' => $error->getMessage()];
		}
	}

	public function update($body)
	{
		try {
			$WHERE = $this->getHeaderAndValuesWhere($body['where']);
			$UPDATE = $this->getHeaderAndValuesWhere($body['data']);
			if (!$WHERE || !$UPDATE)
				return ['status' => false, 'error' => 'data & where clauses are mandatory for update'];
			$SQL = 'UPDATE ' . $body['collection'];
			$SQL = $UPDATE ? $SQL . ' SET ' . $UPDATE : $SQL;
			$SQL = $WHERE ? $SQL . ' WHERE ' . $WHERE : $SQL;
			$results = $this->crudModel->query($SQL);
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

	public function getHeaderAndValuesWhere($data)
	{
		try {
			$keyValuePairs = array_map(function ($key, $value) {
				return "`$key`='$value'";
			}, array_keys($data), array_map([$this, 'stringCast'], $data));
			return implode(',', $keyValuePairs);
		} catch (Exception $error) {
			return false;
		}
	}

	public function stringCast($string)
	{
		return is_string($string) ? str_replace("'", "`", $string) : $string;
	}
}
