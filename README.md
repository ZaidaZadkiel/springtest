# springtest
testing java spring backend

error:
`unknown lifecycle phase "/root/.m2".`
means that the env var MAVEN_CONFIG is being set to root home, it should be unset 
example:
`MAVEN_CONFIG= ./mvnw dependency:resolve`

