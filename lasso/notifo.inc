[//lasso
	/*---------------------------------------------------------------
	
	[notifo]
	Send push notifications to mobile devices via the notifo API.
	
	Author: Jason Huck
	
	Description:
	notifo API. Notifo is a free service which allows you to send push 
	notifications to mobile devices. Requires [decode_json].
		
	Sample Usage:
	var('notifo') = notifo( -username='foo', -secret='bar');
	
	$notifo->send_notification(
		-to='joeschmoe',
		-msg='This is a test notification message!',
		-label='A Test Label',
		-title='Test Title',
		-uri='http://www.foo.com/'
	);
		
	---------------------------------------------------------------*/
	
	define_type(
		'notifo',
		-prototype,
		-description='Wrapper for the Notifo API.'
	);
		local(
			'api_username' = string,
			'api_secret' = string,
			'api_root' = 'https://api.notifo.com/',
			'api_version' = 'v1'
		);
		
		define_tag(
			'oncreate',
			-req='username',
			-req='secret'
		);
			self->'api_username' = #username;
			self->'api_secret' = #secret;
		/define_tag;
		
		define_tag(
			'send',
			-req='method',
			-req='params'
		);
			local('response') = null;
			local('url') = (self->'api_root' + self->'api_version' + '/' + #method);
			
			protect;
				handle_error;
					#response = map(
						'status' = 'error',
						'response_code' = error_code,
						'response_message' = error_msg
					);
				/handle_error;
			
				#response = decode_json(include_url(
					#url,
					-username=self->'api_username',
					-password=self->'api_secret',
					-postparams=#params,
					-timeout=10,
					-connecttimeout=10
				));
			/protect;
			
			return(#response);
		/define_tag;
		
		define_tag('_unknowntag');
			local('params') = array;
			
			iterate(params, local('i'));
				local('n') = string(#i->first)->removeleading('-')&;
				#params->insert(#n = #i->second);
			/iterate;
			
			return(self->send( -method=tag_name, -params=#params));
		/define_tag;
	/define_type;
]
