/*
	WebRequest first test
*/
extern string Pair = "WebRequest test";

// init()
int init() {
	if (!check_license()) return (1);

	return (0);
}

// deinit()
int deinit() {
	return (0);
}


// start()
int start() {
	Print("Running start function... ");
}

int check_license() {
	string cookie=NULL,headers;
	char post[],result[];
	string license;
	string lic_file = "license.bin";
	int res;

	// read license file
	int filehandle=FileOpen(lic_file,FILE_READ|FILE_TXT);
	if(filehandle==INVALID_HANDLE){
		// read license error， exit program
		Print("Error in open license file. Error code=",GetLastError());
		MessageBox("请检查授权文件（MetaTrader安装目录\\MQL4\\Files\\"+lic_file+"）是否正确","Error",MB_ICONINFORMATION);
		return false;
	}

	license = FileReadString(filehandle);
	Print("Read license... ", license);
	FileClose(filehandle);

	// access to the server, check license online
	string post_host="http://wx.jack139.top";
	string post_url=post_host+"/ea/lic";
	string post_str="license="+license;
	//--- Reset the last error code
	ResetLastError();
	// ready to send request
	int timeout=5000; //--- Timeout below 1000 (1 sec.) is not enough for slow Internet connection
	ArrayResize(post,StringToCharArray(post_str,post,0,WHOLE_ARRAY,CP_UTF8)-1);
	res=WebRequest("POST",post_url,cookie,NULL,timeout,post,0,result,headers);
	//--- Checking errors
	if(res==-1){
		Print("Error in WebRequest. Error code  =",GetLastError());
		//--- Perhaps the URL is not listed, display a message about the necessity to add the address
		MessageBox("请在菜单“工具--选型--EA交易”选项页中，将 '"+post_host+"' 添加到“WebRequest允许的URL”中。","Error",MB_ICONINFORMATION);
		return false;
	}

	string str_ret;
	int pos, next, cnt;
	double param[];

	//--- Load successfully
	PrintFormat("The license has been successfully loaded, File size =%d bytes.",ArraySize(result));
	str_ret = CharArrayToString(result);
	Print(str_ret);

	// analyse result
	pos = 0;
	cnt = 0;
	while(1){
		next = StringFind(str_ret, "|", pos);
		if (next==-1) break;
		string val = StringSubstr(str_ret, pos, next-pos);

		ArrayResize(param, cnt+1);

		// check first val is TRUE or FALSE
		if (cnt==0){
			if (StringCompare(val, "TRUE", false)!=0){
				MessageBox("授权无效："+StringSubstr(str_ret, next+1),"Error",MB_ICONINFORMATION);
				return false;
			}
			param[0] = 0.0; // no use
		}
		else{
			param[cnt] = StringToDouble(val);
		}

		cnt++;
		pos = next + 1;
	}

	// assign parameters
	for(int i=0; i<cnt; i++) 
	   Print(DoubleToString(param[i]));

	return true;
}

