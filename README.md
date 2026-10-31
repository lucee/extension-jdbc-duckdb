# Lucee DuckDB JDBC Extension

https://duckdb.org/docs/stable/clients/java

https://github.com/duckdb/duckdb-java

https://mvnrepository.com/artifact/org.duckdb/duckdb_jdbc

Requires Lucee 7.1.0.184 or newer.

The extension version is the version of the DuckDB JDBC driver (`org.duckdb:duckdb_jdbc`), for example `2.0.0.1`. The driver is not bundled in the extension and it is not installed as an OSGi bundle: Lucee loads it from its Maven coordinates (`org.duckdb:duckdb_jdbc:<version>`), which is supported since Lucee 7.1.0.184, so this extension does not work on older Lucee versions.

[![Java CI](https://github.com/lucee/extension-jdbc-duckdb/actions/workflows/main.yml/badge.svg)](https://github.com/lucee/extension-jdbc-duckdb/actions/workflows/main.yml)

Issues: https://luceeserver.atlassian.net/issues/?jql=labels%20%3D%20duckdb

Manual Downloads: https://download.lucee.org/#811918E2-796C-4354-8374B1F331118AEB

## Build

```
mvn clean install
```

creates `target/duckdb-jdbc-extension-<version>.lex` and `target/duckdb-jdbc-extension-<version>.lite.lex` (without the `maven` folder).
