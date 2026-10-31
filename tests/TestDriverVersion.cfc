component extends="org.lucee.cfml.test.LuceeTestCase" labels="duckdb" {

	// keep in sync with pom.xml driverVersion (major.minor.patch.revision)
	variables.mavenVersion = "2.0.0.1";
	// DuckDB reports its engine version (e.g. "v2.0.0") as the database product
	// version; the JDBC driver_version is a generic "1.0", so we assert on the
	// engine version derived from the first three segments of the maven version.
	variables.engineVersion = listGetAt( mavenVersion, 1, "." )
		& "." & listGetAt( mavenVersion, 2, "." )
		& "." & listGetAt( mavenVersion, 3, "." );

	// the driver is only loaded through its maven coordinates, there is no OSGi bundle fallback
	private struct function getDatasource() {
		return {
			class: "org.duckdb.DuckDBDriver",
			maven: "org.duckdb:duckdb_jdbc:" & variables.mavenVersion,
			connectionString: "jdbc:duckdb:"
		};
	}

	function run( testResults, testBox ) {
		describe( title="DuckDB JDBC extension driver version", body=function() {
			it(
				title="loads the DuckDB JDBC driver from maven and reports the expected engine version",
				body=function( currentSpec ) {
					var ds = getDatasource();

					dbinfo datasource=ds name="local.dbVersion" type="version";

					var info = {
						luceeVersion: server.lucee.version,
						datasourceClass: ds.class,
						maven: ds.maven,
						driverName: dbVersion.driver_name,
						driverVersion: dbVersion.driver_version,
						databaseProduct: dbVersion.database_productname,
						databaseVersion: dbVersion.database_version,
						jdbcVersion: dbVersion.jdbc_major_version & "." & dbVersion.jdbc_minor_version
					};

					systemOutput( "DuckDB JDBC driver info: " & serializeJSON( info ), true );

					expect( dbVersion.recordCount ).toBe( 1 );
					expect( dbVersion.driver_name ).toInclude( "DuckDB" );
					// e.g. "v2.0.0" contains "2.0.0" -> confirms the 2.0.0.1 artifact is loaded
					expect( dbVersion.database_version ).toInclude( variables.engineVersion );
				}
			);

			it(
				title="runs a query against an in-memory database",
				body=function( currentSpec ) {
					var ds = getDatasource();

					// one statement, so it does not depend on a table living on a pooled connection
					var qry = queryExecute(
						"SELECT 40 + 2 AS answer, upper(?) AS word",
						[ "lucee" ],
						{ datasource: ds }
					);

					expect( qry.recordCount ).toBe( 1 );
					expect( qry.answer ).toBe( 42 );
					expect( qry.word ).toBe( "LUCEE" );
				}
			);
		} );
	}

}
