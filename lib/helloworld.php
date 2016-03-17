<?php
/*
  This is a testfile for testing the mybic Ajax library
  The mybic server expects the php classfiles in this lib directory 
*/

class helloworld 
{
	var $queryVars;
	function helloworld($queryVars)
	{
		$this->queryVars = $queryVars;
	}
	/**
	 * Method to return the status of the AJAX transaction
	 *
	 * @return  string A string of raw HTML fetched from the Server
	 */
	function return_response()
	{
		$resp = "Hello World from the server!";
		return $resp;
	}
	
	function is_authorized()
	{
		return true;
	}
}

?>
