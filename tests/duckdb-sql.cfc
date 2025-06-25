component extends="org.lucee.cfml.test.LuceeTestCase" labels="duckdb" {

	function beforeAll (){
		variables.bundleName = "org.duckdb.duckdb_jdbc";
		variables.bundleVersion = "1.4.0.0";
		variables.ds = {
			class: "org.duckdb.DuckDBDriver"
			,bundleName: bundleName
			, bundleVersion: bundleVersion
			,connectionString: "jdbc:duckdb:"
		};
		QueryExecute("DROP TABLE IF EXISTS test_table", {}, {datasource=ds});
		QueryExecute("CREATE TABLE test_table (id INTEGER, name VARCHAR)", {}, {datasource=ds});
	}

	function afterAll() {
		// Clean up after tests
		QueryExecute("DROP TABLE IF EXISTS test_table", {}, {datasource=ds});
	}

	function run(){

		describe("DuckDB CRUD Tests", function() {

			it("can insert a row into duckdb", function() {
				QueryExecute(
					"INSERT INTO test_table (id, name) VALUES (?, ?)",
					[1, "Alice"],
					{datasource=ds}
				);
				var result = QueryExecute(
					"SELECT * FROM test_table WHERE id = ?",
					[1],
					{datasource=ds}
				);
				expect(result.recordCount).toBe(1);
				expect(result.name).toBe("Alice");
			});

			it("can select multiple rows from duckdb", function() {
				QueryExecute("INSERT INTO test_table (id, name) VALUES (?, ?)", 
					[2, "Bob"], 
					{datasource=ds}
				);
				var result = QueryExecute(
					"SELECT * FROM test_table ORDER BY id",
					{},
					{datasource=ds}
				);
				expect(result.recordCount).toBeGTE(2);
				expect(result.name[1]).toBe("Alice");
				expect(result.name[2]).toBe("Bob");
			});

			it("can update a row in duckdb", function() {
				QueryExecute(
					"UPDATE test_table SET name = ? WHERE id = ?",
					["Charlie", 1],
					{datasource=ds}
				);
				var result = QueryExecute(
					"SELECT name FROM test_table WHERE id = ?",
					[1],
					{datasource=ds}
				);
				expect(result.name).toBe("Charlie");
			});

			it("can delete a row from duckdb", function() {
				QueryExecute(
					"DELETE FROM test_table WHERE id = ?",
					[2],
					{datasource=ds}
				);
				var result = QueryExecute(
					"SELECT * FROM test_table WHERE id = ?",
					[2],
					{datasource=ds}
				);
				expect(result.recordCount).toBe(0);
			});

		});
	}

}
