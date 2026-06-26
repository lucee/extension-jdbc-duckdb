component extends="org.lucee.cfml.test.LuceeTestCase" labels="duckdb" {

	// keep in sync with pom.xml mvnVersion (major.minor.patch.revision)
	variables.mavenDriverVersionPrefix = "1.4.5.0";

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
			ds.maven = "org.duckdb:duckdb_jdbc:" & variables.mavenDriverVersionPrefix;
		}
		return ds;
	}

	function run( testResults, testBox ) {
		describe( title="DuckDB JDBC extension driver version", body=function() {
			it(
				title="reports the DuckDB JDBC driver version in use",
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

					if ( mode eq "maven" ) {
						expect( dbVersion.driver_version ).toInclude( variables.mavenDriverVersionPrefix );
					} else {
						systemOutput( "DuckDB JDBC driver loaded via OSGi bundle; Maven version assertion skipped", true );
					}
				}
			);
		} );
	}

}
