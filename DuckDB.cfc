<cfcomponent extends="types.Driver" implements="types.IDatasource">
	<cfset fields=array(
		field(
			"DuckDB Database Type",
			"dbtype",
			"memory,file", // cloud
			true,
			"Type of duckdb database",
			"radio"
		),
		/*
		field(
			"MotherDuck Database",
			"motherduck_database",
			"",
			false,
			"Name of MotherDuck (DuckDB cloud service) database, only required for type=cloud"
		),
		field(
			"MotherDuck Token",
			"motherduck_token",
			"",
			false,
			"Authentication Token for MotherDuck (DuckDB cloud service) database, only required for type=cloud"
		),
		*/
		field(
			"Path",
			"path",
			"",
			false,
			"Path to a file database (with an extension like .duckdb, .db, etc) located (only Filesystem, virtual Resources like ""ram"" not supported), only required for type=file"
		),
		field(
			"Read only",
			"duckdb.read_only",
			"false,true",
			false,
			"(Version 6.0+) Declares the application workload type to connect to a server.",
			"radio"
		),
		field(
			"JDBC Result Streaming",
			"jdbc_stream_results",
			"false,true",
			false,
			"Result streaming is opt-in in the JDBC driver",
			"radio"
		)
	)>

	<cfset this.type.host=this.TYPE_HIDDEN>
	<cfset this.type.database=this.TYPE_HIDDEN>
	<cfset this.type.username=this.TYPE_HIDDEN>
	<cfset this.type.password=this.TYPE_HIDDEN>
	
	<cfset this.dsn="jdbc:duckdb:file:{path}">
	<cfset this.className="org.duckdb.DuckDBDriver">
	<cfset this.bundleName="org.duckdb.duckdb_jdbc">
	
	<cfset SLASH=struct(
		'/':'\',
		'\':'/'
	)>

	<cfscript>
		string function getDSN() output="no" {
			var _dsn = "";
			switch (form.custom_dbtype){
				case "file":
					_dsn = "jdbc:duckdb:{path}";
					break;
				case "cloud":
					_dsn = "jdbc:duckdb:md:#form.custom_motherduck_database#?motherduck_token=#form.custom_motherduck_token#";
					break;
				case "memory":
					_dsn = "jdbc:duckdb:";
					break;
				default:
					throw message="Unsupported DuckDB database type [#form.custom_dbtype#]";
			}
			return _dsn;
		}

		function customParameterSyntax(){
			return {leadingdelimiter:';',delimiter:';',separator:'='};
		}
	</cfscript>

	
	<cffunction name="onBeforeUpdate" returntype="void" output="no">

		<cfswitch expression="#form.custom_dbtype#">
			<cfcase value="file">
				<cfscript>
					var notRequired = ['custom_motherduck_database', 'custom_motherduck_token' ];
					arrayEach( notRequired, function (ff) {
						if ( len( form[ ff ] ?: "" ) > 0)
							throw "#ff# is not required for type=file";
					});
					if ( len( form.custom_path ?: "" ) == 0)
						throw "[path] is required for type=file";
					break;
				</cfscript>
				
			</cfcase>
			<cfcase value="cloud">
				<cfscript>
					var required = ['custom_motherduck_database', 'custom_motherduck_token' ];
					arrayEach( required, function (ff) {
						if ( len( form[ ff ] ?: "" ) > 0)
							throw "[#ff#] is not required for type=memory";
					});
					break;
				</cfscript>
			</cfcase>
			<cfcase value="memory">
				<cfscript>
					var notRequired = ['custom_motherduck_database', 'custom_motherduck_token', 'custom_path' ];
					arrayEach( notRequired, function (ff) {
						if ( len( form[ ff ] ?: "" ) > 0)
							throw "[#ff#] is not required for type=memory";
					});
					break;
				</cfscript>
			</cfcase>
			<cfdefaultcase>
				<cfthrow message="Unsupported duckdb database type [#form.custom_dbtype#]">
			</cfdefaultcase>
		</cfswitch>
		<cfif len(form.custom_path)>
			<cfset var pathExt = listLast(form.custom_path, ".")>
			<cfif !isEmpty( pathExt ) >
				<cfthrow message="path [#form.custom_path#] needs to specify a file with a extension, i.e .duckdb, .db, etc">
			</cfif>
			<cfset form.custom_path=replace(
							form.custom_path,
							SLASH[server.separator.file],
							server.separator.file,
							'all')>
			<cfif right(form.custom_path,1) NEQ server.separator.file>
				<cfset form.custom_path=form.custom_path&server.separator.file>
			</cfif>
			
			
			<cfif not directoryExists(form.custom_path)>
				<cfset var parent=mid(form.custom_path,1,len(form.custom_path)-1)>
				<cfset parent=getDirectoryFromPath(parent)>
				<cfif directoryExists(parent)>
					<cfdirectory directory="#form.custom_path#" action="create" mode="777">
				<cfelse>
					<cfthrow message="directory [#form.custom_path#] doesn't exist">
				</cfif>
			</cfif>
		</cfif>
	</cffunction>

	<cffunction name="getName" returntype="string" output="no"
		hint="returns display name of the driver">
		<cfreturn "DuckDB JDBC Driver">
	</cffunction>

	<cffunction name="getId" returntype="string" output="no"
		hint="returns the ID of the driver">
		<cfreturn "duckdb">
	</cffunction>
	
	<cffunction name="getDescription" returntype="string" output="no"
		hint="returns description for the driver">
		<cfreturn "DuckDB JDBC Driver. Here you can not only create a database connection to a existing DuckDB Database, you can also create a new one.
		That means, when a Database doesn't exist, it will be automatically created.">"
	</cffunction>
	
	<cffunction name="getFields" returntype="array" output="no"
		hint="returns array of fields">
		<cfreturn fields>
	</cffunction>
	
	
</cfcomponent>