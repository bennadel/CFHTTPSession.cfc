
# CFHTTPSession.cfc

by Ben Nadel ([www.bennadel.com][1])

The CFHttpSession.cfc is a ColdFusion component that wraps around multiple 
CFHttp requests in such a way that cookie and session information is maintained
from request to request. This allows you to use this ColdFusion component to 
log into remote systems and grab content that is behind a layer of security.

## Features

* Maintained session across multiple CFHttp requests
* Can handle most of the CFHttpParam data types
* Properly handles relocation header responses within sessions
* Can handle both GET and POST submission methods
* Can log both request and response data for easy debugging

## Initial Repository

For the initial repository, the only thing that I am doing is organizing the
files for GitHub. I haven't actually checked to make sure that the example
works or anything. This is just to get the project moved over.

<img src="https://github.com/downloads/bennadel/CFHTTPSession.cfc/ben_apt_dimensions.gif" />

Just testing image upload.


[1]: http://www.bennadel.com