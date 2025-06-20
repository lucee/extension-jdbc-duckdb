component extends="org.lucee.cfml.test.LuceeTestCase" labels="duckdb" {

	function run(){
		describe( title="basic duckdb tests", ,body=function(){
			it(title="verify connection with dbinfo", body=function(){
				// do somthing!
				var ds = {
					class: "org.duckdb.DuckDBDriver"
					,bundleName: "org.duckdb.duckdb_jdbc"
					,connectionString: "jdbc:duckdb:"
				}
				dbinfo datasource="#ds#" name="local.result" type="version";
				systemOutput( local.result, true );
			});
		});
	}

}
