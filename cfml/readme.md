## CFNotifo - A CFML (ColdFusion) Wrapper for the Notifo API ##

### What is Notifo? ###

Notifo is a service which allows you to send push notifications to mobile clients from a server via a REST interface.

### What is CFNotifo? ###

CFNotifo is an API wrapper for the Notifo service which makes subscribing users and sending notifications easy peasy.

### Requirements ###

1. [ColdFusion 8+](http://www.coldfusion.com), [Railo](http://www.getrailo.org/) or [OpenBD](http://www.openbluedragon.org/)
2. A [Notifo](http://notifo.com) service account, for sending notifications

### Usage ###

Create an instance of CFNotifo, passing in the credentials for the service:
	CFNotifo = createObject("component","CFNotifo").init(username="serviceNotifoUsername",apiSecret="serviceAPISecret");

Subscribe a user to your service:
	response = CFNotifo.subscribe(username="userToSubscribe");
	if (response.success)
	{
		// It worked!
	} else 
	{
		// Something went wrong
		writeDump(var=response.notifoResponse, label="Notifo's Response");
	}

Send a notification to a user:
	response = CFNotifo.send(to="subscribedUser", msg="Message to send");
	if (response.success)
	{
		// It worked!
	} else 
	{
		// Something went wrong
		writeDump(var=response.notifoResponse, label="Notifo's Response");
	}

### Demo ###

An online demo of CFNotifo is available on [my blog](http://www.silverwareconsulting.com/CFNotifo.cfm)
