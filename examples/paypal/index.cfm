
<!--- Set login credentials for paypal.com. --->
<cfset strUsername = "xxxxxx" />
<cfset strPassword = "yyyyyy" />


<!--- 
	Create the CFHttpSession object that will be sued to 
	make our multiple calls to the same remote application.
--->
<cfset objHttpSession = CreateObject( "component", "lib.CFHTTPSession" ).Init(
	LogFilePath = ExpandPath( "./log.txt" )
	) />
	
	
<!--- 
	Call the PayPal website. We need to call the homepage 
	first to set up the proper cookies and referer. If we
	try to access the login page directly, we will get
	denies access.
--->
<cfset objResponse = objHttpSession
	.NewRequest( "http://www.paypal.com" )
	.Get()
	/>

	
<!--- 
	Now that we have our session set up, let's go ahead
	and log into PayPal.com.
--->
<cfset objResponse = objHttpSession
	.NewRequest( "https://www.paypal.com/us/cgi-bin/webscr" )
	.AddUrl( "cmd", "_login-submit" )
	.AddFormField( "login_email", strUsername )
	.AddFormField( "login_password", strPassword )
	.AddFormField( "submit.x", "Log In" )
	.AddFormField( "form_charset", "UTF-8" )
	.Post()
	/>
	
	
<!--- 
	At this point, we should be logged into the system. Now, 
	let's hop over to the account overview page.
--->
<cfset objResponse = objHttpSession
	.NewRequest( "https://www.paypal.com/us/cgi-bin/webscr" )
	.AddUrl( "cmd", "_account" )
	.AddUrl( "nav", "0" )
	.Get()
	/>
	
	
<!--- 
	To make sure that everything is working, output the 
	PayPal account overview page.
--->
<cfoutput>
	
	<h1>
		From My Server:
	</h1>
	
	<br />
	
	<div style="width: 500px ; height: 400 ; border: 4px solid gold ; overflow: auto ;">
		#objResponse.FileContent#
	</div>
	
</cfoutput>
