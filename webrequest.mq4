/*
	WebRequest first test
*/
extern string Pair = "WebRequest test";

// init()
int init() {
	return (0);
}

// deinit()
int deinit() {
	return (0);
}

// start()
int start() {
	string cookie=NULL,headers;
	char post[],result[];
	string license="test";
	string post_str="license="+license;
	int res;
	//--- to enable access to the server, you should add URL "https://www.google.com/finance"
	//--- in the list of allowed URLs (Main Menu->Tools->Options, tab "Expert Advisors"):
	string post_url="http://wx.jack139.top/ea/lic";
	//--- Reset the last error code
	ResetLastError();
	//--- Loading a html page from Google Finance
	int timeout=5000; //--- Timeout below 1000 (1 sec.) is not enough for slow Internet connection
	ArrayResize(post,StringToCharArray(post_str,post,0,WHOLE_ARRAY,CP_UTF8)-1);
	res=WebRequest("POST",post_url,cookie,NULL,timeout,post,0,result,headers);
	//--- Checking errors
	if(res==-1){
		Print("Error in WebRequest. Error code  =",GetLastError());
		//--- Perhaps the URL is not listed, display a message about the necessity to add the address
		MessageBox("Add the address '"+post_url+"' in the list of allowed URLs on tab 'Expert Advisors'","Error",MB_ICONINFORMATION);
	}
	else{
		//--- Load successfully
		PrintFormat("The file has been successfully loaded, File size =%d bytes.",ArraySize(result));
		//Print("",result);
		//--- Save the data to a file
		int filehandle=FileOpen("ea_lic.txt",FILE_WRITE|FILE_BIN);
		//--- Checking errors
		if(filehandle!=INVALID_HANDLE){
			Print("File writing...");
			//--- Save the contents of the result[] array to a file
			FileWriteArray(filehandle,result,0,ArraySize(result));
			//--- Close the file
			FileClose(filehandle);
		}
		else Print("Error in FileOpen. Error code=",GetLastError());
	}
}

