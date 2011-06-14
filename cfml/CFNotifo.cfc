<!---
	// **************************************** LICENSE INFO **************************************** \\
	
	Copyright 2010, Bob Silverberg
	
	Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in 
	compliance with the License.  You may obtain a copy of the License at 
	
		http://www.apache.org/licenses/LICENSE-2.0
	
	Unless required by applicable law or agreed to in writing, software distributed under the License is 
	distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or 
	implied.  See the License for the specific language governing permissions and limitations under the 
	License.
--->
<cfcomponent hint="A wrapper for the Notifo API" output="false">

	<cffunction name="init" access="public" returntype="Any" output="false">
		<cfargument name="username" type="string" required="true" hint="The notifo username of the service" />
		<cfargument name="apiSecret" type="string" required="true" hint="The notifo apiSecret of the service" />
		<cfargument name="notifoUrl" type="string" required="false" default="https://api.notifo.com/v1/" hint="The base notifo url" />
		<cfargument name="notifoTimeout" type="numeric" required="false" default="60" hint="The timeout for communication with the notifo service" />
		
		<cfscript>
			variables.username = arguments.username;
			variables.apiSecret = arguments.apiSecret;
			variables.notifoUrl = arguments.notifoUrl;
			variables.notifoTimeout = arguments.notifoTimeout;
			return this;
		</cfscript>

	</cffunction> 
 
	<cffunction name="send" access="public" returntype="struct" output="false" hint="Used to send a notification to a Notifo user">
		<cfargument name="msg" type="string" required="true" hint="The message to send" />
		<cfargument name="to" type="string" required="false" hint="The notifo user to send the message to" />
		<cfargument name="label" type="string" required="false" hint="The label for the message" />
		<cfargument name="title" type="string" required="false" hint="The title of the message" />
		<cfargument name="uri" type="string" required="false" hint="The uri to open after viewing the message" />
		
		<cfreturn sendRequest(urlSuffix="send_notification",params=arguments) />

	</cffunction> 
 
	<cffunction name="subscribe" access="public" returntype="struct" output="false" hint="Used to send a notification to a Notifo user">
		<cfargument name="username" type="string" required="true" hint="The notifo user who wishes to subscribe" />
		
		<cfreturn sendRequest(urlSuffix="subscribe_user",params=arguments) />

	</cffunction> 
 
	<cffunction name="sendRequest" access="public" returntype="struct" output="false" hint="Used to send a notification to a Notifo user">
		<cfargument name="urlSuffix" type="string" required="true" hint="The API suffix for the service" />
		<cfargument name="params" type="struct" required="true" hint="Parameters to be added to the http call" />
		
		<cfset var returnStruct = {success=false,httpResponse=structNew(),notifoResponse=structNew()} />
		<cfset var param = 0 />
		<cfhttp url="#variables.notifoUrl##arguments.urlSuffix#" username="#variables.username#" password="#variables.apiSecret#" method="post" redirect="false" timeout="#variables.notifoTimeout#">
			<cfloop collection="#arguments.params#" item="param">
				<cfif isDefined("arguments.params.#param#")>
					<cfhttpparam name="#lCase(param)#" value="#arguments.params[param]#" encoded="true" type="formfield" />
				</cfif>
			</cfloop>
		</cfhttp> 
		<cfset returnStruct.httpResponse = cfhttp />
		<cfif structKeyExists(cfhttp,"Responseheader") and cfhttp.Responseheader.Status_Code eq 200>
			<cfset returnStruct.success = true />
		</cfif>
		<cfif structKeyExists(cfhttp,"Filecontent") and isJson(cfhttp.Filecontent)>
			<cfset returnStruct.notifoResponse = deserializeJSON(cfhttp.Filecontent) />
		</cfif>
		<cfreturn returnStruct />
 
	</cffunction> 

</cfcomponent>

