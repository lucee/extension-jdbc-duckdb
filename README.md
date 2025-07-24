# Lucee DuckDB JDBC Extension

https://duckdb.org/docs/stable/clients/java

https://github.com/duckdb/duckdb-java

https://mvnrepository.com/artifact/org.duckdb/duckdb_jdbc

Requires Lucee 6.2.1 or newer

[![Java CI](https://github.com/lucee/extension-jdbc-duckdb/actions/workflows/main.yml/badge.svg)](https://github.com/lucee/extension-jdbc-duckdb/actions/workflows/main.yml)

Issues: https://luceeserver.atlassian.net/issues/?jql=labels%20%3D%20duckdb

Manual Downloads: https://download.lucee.org/#811918E2-796C-4354-8374B1F331118AEB

### OSGI

In order for this to work, we needed OSGI Metadata to be added to DuckDB-java client

https://github.com/duckdb/duckdb-java/issues/285

OSGI update, the initial duckdb java release with OSGI, 1.3.2.0 has the wrong bundle version, 1.4.0.0

https://github.com/duckdb/duckdb-java/issues/309

The bundled jar has the MANIFEST.mf metadata corrected
