component extends="org.lucee.cfml.test.LuceeTestCase" labels="duckdb" {

	// keep in sync with pom.xml mvnVersion (major.minor.patch.revision)
	variables.mavenVersion = "1.5.4.0";
	// DuckDB reports its engine version (e.g. "v1.4.5") as the database product
	// version; the JDBC driver_version is a generic "1.0", so we assert on the
	// engine version derived from the first three segments of the maven version.
	variables.engineVersion = listGetAt( mavenVersion, 1, "." )
		& "." & listGetAt( mavenVersion, 2, "." )
		& "." & listGetAt( mavenVersion, 3, "." );

	private boolean function luceeSupportsMavenJdbc() {
		try {
			return server.doesJDBCSupportMaven();
		} catch ( any e ) {
			return false;
		}
	}

	private struct function getDatasource( required string mode ) {
		var ds = {
			class: "org.duckdb.DuckDBDriver",
			bundleName: "org.duckdb.duckdb_jdbc",
			connectionString: "jdbc:duckdb:"
		};
		if ( arguments.mode eq "maven" ) {
			ds.maven = "org.duckdb:duckdb_jdbc:" & variables.mavenVersion;
		}
		return ds;
	}

	function run( testResults, testBox ) {
		describe( title="DuckDB JDBC extension driver version", body=function() {
			it(
				title="loads the DuckDB JDBC driver and reports the expected engine version",
				body=function( currentSpec ) {
					var mode = luceeSupportsMavenJdbc() ? "maven" : "bundle";
					var ds = getDatasource( mode );

					dbinfo datasource=ds name="local.dbVersion" type="version";

					var info = {
						luceeVersion: server.lucee.version,
						datasourceClass: ds.class,
						mode: mode,
						maven: ds.maven ?: "",
						driverName: dbVersion.driver_name,
						driverVersion: dbVersion.driver_version,
						databaseProduct: dbVersion.database_productname,
						databaseVersion: dbVersion.database_version,
						jdbcVersion: dbVersion.jdbc_major_version & "." & dbVersion.jdbc_minor_version
					};

					systemOutput( "DuckDB JDBC driver info: " & serializeJSON( info ), true );

					expect( dbVersion.recordCount ).toBe( 1 );
					expect( dbVersion.driver_name ).toInclude( "DuckDB" );
					// e.g. "v1.4.5" contains "1.4.5" -> confirms the 1.4.5.0 artifact is loaded
					expect( dbVersion.database_version ).toInclude( variables.engineVersion );
				}
			);
		} );
	}

}
