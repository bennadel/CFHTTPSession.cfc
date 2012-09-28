
<cfcomponent 
	output="false"
	hint="I define the applications settings and event handlers.">


	<!--- Define the application settings. --->
	<cfset this.name = hash( getCurrentTemplatePath() ) />
	<cfset this.applicationTimeout = createTimeSpan( 0, 0, 5, 0 ) />
	<cfset this.sessionManagement = false />

	<!--- Get the current directory and the root directory. --->
	<cfset this.appDirectory = getDirectoryFromPath( getCurrentTemplatePath() ) />
	<cfset this.projectDirectory = (this.appDirectory & "../../") />

	<!--- Map the LIB directory so we can create our components. --->
	<cfset this.mappings[ "/lib" ] = (this.projectDirectory & "lib") />


</cfcomponent>