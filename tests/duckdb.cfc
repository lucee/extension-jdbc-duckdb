component extends="org.lucee.cfml.test.LuceeTestCase" labels="duckdb" {

	function beforeAll (){
		variables.bundleName = "org.duckdb.duckdb_jdbc";
		variables.bundleVersion = "1.4.0.0";
		variables.ds = {
			class: "org.duckdb.DuckDBDriver"
			, bundleName: bundleName
			, bundleVersion: bundleVersion
			, connectionString: "jdbc:duckdb:"
		};
	}

	function run(){
		describe( title="basic duckdb tests", body=function(){

			it(title="verify memory connection with dbinfo", body=function(){
				dbinfo datasource="#ds#" name="local.result" type="version";
				systemOutput( local.result, true );
				expect( local.result ).notToBeEmpty();
			});

			it(title="verify file connection with dbinfo", body=function(){
				var ds = duplicate(ds);
				var tempDir = getTempDirectory() & createUUID() & server.separator.file;
				directoryCreate( tempDir );
				ds.connectionString = "jdbc:duckdb:file:#tempDir#test.sqlite";
				systemOutput( ds, true );
				dbinfo datasource="#ds#" name="local.result" type="version";
				systemOutput( local.result, true );
				expect( local.result ).notToBeEmpty();
			});

		});
	}
}
