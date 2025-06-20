SET JAVA_HOME=C:\Program Files\Eclipse Adoptium\jdk-11.0.25.9-hotspot
call ant
set testLabels=duckdb
set testFilter=

ant -buildfile="d:\work\script-runner" -DluceeVersion="light-6.0.0.585" -Dwebroot="d:\work\lucee6\test" -Dexecute="/bootstrap-tests.cfm" -DextensionDir="d:\work\lucee-extensions\extension-jdbc-duckdb\dist" -DluceeVersionQuery="6.2/all/light"