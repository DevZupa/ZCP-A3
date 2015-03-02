"PV_ZCP_zupastic" addPublicVariableEventHandler {
	_messageArray = _this select 1;
	hint parseText (format [	   
		"<t color='#ff0000' size='2' align='center'>%1</t><br /><t align='center'>%2</t><br/>",
		_messageArray  select 0,_messageArray  select 1
	]);
};