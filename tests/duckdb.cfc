component extends="org.lucee.cfml.test.LuceeTestCase" labels="duckdb" {

	function beforeAll (){
		variables.bundleName = "org.duckdb.duckdb_jdbc";
		//variables.bundleVersion = "1.4.0.0";
		variables.ds = {
			class: "org.duckdb.DuckDBDriver"
			, bundleName: bundleName
		//	, bundleVersion: bundleVersion
			, connectionString: "jdbc:duckdb:"
		};
	}

	function run(){
		describe( title="basic duckdb tests - using sqlite", body=function(){

			it(title="verify memory connection with dbinfo", body=function(){
				dbinfo datasource="#ds#" name="local.result" type="version";
				systemOutput( "", true );
				systemOutput( ds, true );
				systemOutput( local.result.toJson(), true );
				expect( local.result ).notToBeEmpty();
			});

			it(title="verify file connection with dbinfo - sqlite", body=function(){
				var ds = duplicate(ds);
				var tempDB = getTempDirectory() & createUUID() & server.separator.file;
				directoryCreate( tempDB );
				ds.connectionString = "jdbc:duckdb:sqlite:#tempDB#test.sqlite";
				systemOutput( "", true );
				systemOutput( ds, true );
				dbinfo datasource="#ds#" name="local.result" type="version";
				systemOutput( local.result.toJson(), true );
				expect( local.result ).notToBeEmpty();
			});

			it(title="verify file connection with dbinfo - duckdb", body=function(){
				var ds = duplicate(ds);
				var tempDB = getTempDirectory() & createUUID() & server.separator.file;
				directoryCreate( tempDB );
				ds.connectionString = "jdbc:duckdb:#tempDB#test.duckdb"; // can be any extension, just convention
				systemOutput( "", true );
				systemOutput( ds, true );
				dbinfo datasource="#ds#" name="local.result" type="version";
				systemOutput( local.result.toJson(), true );
				expect( local.result ).notToBeEmpty();
			});

		});
	}
}
