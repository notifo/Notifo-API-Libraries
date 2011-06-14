[//lasso
	library('encode_json.inc');
	library('notifo.inc');
	
	var('notifo') = notifo( -username='foo', -secret='bar');
	
	var('result') = $notifo->send_notification(
		-to='joeschmoe',
		-msg='This is a test notification message!',
		-label='A Test Label',
		-title='Test Title',
		-uri='http://www.foo.com/'
	);
	
	if($result->find('status') == 'success');
		'Notification sent successfully!';
	else;
		'There was a problem sending the notification: ';
		$result->find('response_message');
	/if;
]
