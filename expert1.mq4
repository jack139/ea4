/*
	jack139@gmail.com
*/
#property copyright "F8GEEK"
#property link      "http://f8geek.com"

extern string Pair = "GBP-USD-TimeFrame_M15";
extern int magic = 7749;
extern double start_lot = 0.1;
extern double tp_in_money = 5.0;
extern double range = 25.0;
extern int level = 10;
extern bool lot_multiplier = TRUE;
extern double multiplier = 0.0;  // online data
extern double increament = 0.0;  // online data
extern bool use_sl_and_tp = FALSE;
extern double sl = 60.0;	
extern double tp = 30.0;	
extern bool stealth_mode = TRUE;
extern bool use_daily_target = FALSE;
extern double daily_target = 100.0;
extern bool trade_in_fri = TRUE;
extern bool UseMA = TRUE;
extern double MA_Period1 = 0.0;	// online data
extern double MA_Shift1 = 0.0;
extern double MA_Method1 = 1.0;
extern double Applied_Price1 = 0.0;
extern double MA_Period2 = 0.0;	// online data
extern double MA_Shift2 = 0.0;
extern double MA_Method2 = 2.0;
extern double Applied_Price2 = 0.0;
double Gd_244;
double G_minlot_252;
double G_stoplevel_260;
int Gi_268 = 0;
int G_count_272 = 0;
int G_ticket_276 = 0;

// E37F0136AA3FFAF149B351F6A4C948E9
int init() {
	if (Digits == 3 || Digits == 5) Gd_244 = 10.0 * Point;
	else Gd_244 = Point;
	G_minlot_252 = MarketInfo(Symbol(), MODE_MINLOT);
	G_stoplevel_260 = MarketInfo(Symbol(), MODE_STOPLEVEL);
	if (start_lot < G_minlot_252) Print("lotsize is to small.");
	if (sl < G_stoplevel_260) Print("stoploss is to tight.");
	if (tp < G_stoplevel_260) Print("takeprofit is to tight.");
	if (G_minlot_252 == 0.01) Gi_268 = 2;
	if (G_minlot_252 == 0.1) Gi_268 = 1;
	return (0);
}

// 52D46093050F38C27267BCE42543EF60
int deinit() {
	return (0);
}

// EA2B2676C28C0DB26D39331A336C6B92
int start() {
	// check license
	if (!check_license()) return (-1);

	int cmd_0;
	double order_open_price_4;
	double order_lots_12;
	double order_stoploss_20;
	double order_takeprofit_28;
	f0_5();
	int Li_36 = 3524209;
	int acc_number_40 = AccountNumber();
	if (acc_number_40 == Li_36) {
		Alert("Anda tidak bisa menggunakan akun (" + DoubleToStr(acc_number_40, 0) + ") untuk program ini!");
		return (0);
	}
	if (use_daily_target && f0_4() >= daily_target) {
		Comment("\ndaily target achieved.");
		return (0);
	}
	//if (Day() >= 30 && Month() >= 12 && Year() >= 2012) {
	//	Alert("METODE Expired.");
	//	Comment("METODE EXPIRED.");
	//	return (0);
	//}
	if ((!trade_in_fri) && DayOfWeek() == 5 && f0_6() == 0) {
		Comment("\nstop trading in Friday.");
		return (0);
	}
	if (f0_6() == 0 && G_count_272 == 0) {
		if (f0_1() == -2) {
			if (stealth_mode) {
				if (use_sl_and_tp) G_ticket_276 = OrderSend(Symbol(), OP_BUY, start_lot, Ask, 3, Ask - sl * Gd_244, Ask + tp * Gd_244, "", magic, 0, Blue);
				else G_ticket_276 = OrderSend(Symbol(), OP_BUY, start_lot, Ask, 3, 0, 0, "", magic, 0, Blue);
			} else {
				if (use_sl_and_tp) {
					if (OrderSend(Symbol(), OP_BUY, start_lot, Ask, 3, Ask - sl * Gd_244, Ask + tp * Gd_244, "", magic, 0, Blue) > 0) {
						for (int Li_44 = 1; Li_44 < level; Li_44++) {
							if (lot_multiplier) {
								G_ticket_276 = OrderSend(Symbol(), OP_BUYLIMIT, NormalizeDouble(start_lot * MathPow(multiplier, Li_44), Gi_268), Ask - range * Li_44 * Gd_244, 3, Ask - range * Li_44 * Gd_244 - sl * Gd_244,
									Ask - range * Li_44 * Gd_244 + tp * Gd_244, "", magic, 0, Blue);
							} else {
								G_ticket_276 = OrderSend(Symbol(), OP_BUYLIMIT, NormalizeDouble(start_lot + increament * Li_44, Gi_268), Ask - range * Li_44 * Gd_244, 3, Ask - range * Li_44 * Gd_244 - sl * Gd_244,
									Ask - range * Li_44 * Gd_244 + tp * Gd_244, "", magic, 0, Blue);
							}
						}
					}
				} else {
					if (OrderSend(Symbol(), OP_BUY, start_lot, Ask, 3, 0, 0, "", magic, 0, Blue) > 0) {
						for (Li_44 = 1; Li_44 < level; Li_44++) {
							if (lot_multiplier) {
								G_ticket_276 = OrderSend(Symbol(), OP_BUYLIMIT, NormalizeDouble(start_lot * MathPow(multiplier, Li_44), Gi_268), Ask - range * Li_44 * Gd_244, 3, 0, 0, "", magic,
									0, Blue);
							} else G_ticket_276 = OrderSend(Symbol(), OP_BUYLIMIT, NormalizeDouble(start_lot + increament * Li_44, Gi_268), Ask - range * Li_44 * Gd_244, 3, 0, 0, "", magic, 0, Blue);
						}
					}
				}
			}
		}
		if (f0_1() == 2) {
			if (stealth_mode) {
				if (use_sl_and_tp) G_ticket_276 = OrderSend(Symbol(), OP_SELL, start_lot, Bid, 3, Bid + sl * Gd_244, Bid - tp * Gd_244, "", magic, 0, Red);
				else G_ticket_276 = OrderSend(Symbol(), OP_SELL, start_lot, Bid, 3, 0, 0, "", magic, 0, Red);
			} else {
				if (use_sl_and_tp) {
					if (OrderSend(Symbol(), OP_SELL, start_lot, Bid, 3, Bid + sl * Gd_244, Bid - tp * Gd_244, "", magic, 0, Red) > 0) {
						for (Li_44 = 1; Li_44 < level; Li_44++) {
							if (lot_multiplier) {
								G_ticket_276 = OrderSend(Symbol(), OP_SELLLIMIT, NormalizeDouble(start_lot * MathPow(multiplier, Li_44), Gi_268), Bid + range * Li_44 * Gd_244, 3, Bid + range * Li_44 * Gd_244 +
									sl * Gd_244, Bid + range * Li_44 * Gd_244 - tp * Gd_244, "", magic, 0, Red);
							} else {
								G_ticket_276 = OrderSend(Symbol(), OP_SELLLIMIT, NormalizeDouble(start_lot + increament * Li_44, Gi_268), Bid + range * Li_44 * Gd_244, 3, Bid + range * Li_44 * Gd_244 +
									sl * Gd_244, Bid + range * Li_44 * Gd_244 - tp * Gd_244, "", magic, 0, Red);
							}
						}
					}
				} else {
					if (OrderSend(Symbol(), OP_SELL, start_lot, Bid, 3, 0, 0, "", magic, 0, Red) > 0) {
						for (Li_44 = 1; Li_44 < level; Li_44++) {
							if (lot_multiplier) {
								G_ticket_276 = OrderSend(Symbol(), OP_SELLLIMIT, NormalizeDouble(start_lot * MathPow(multiplier, Li_44), Gi_268), Bid + range * Li_44 * Gd_244, 3, 0, 0, "", magic,
									0, Red);
							} else G_ticket_276 = OrderSend(Symbol(), OP_SELLLIMIT, NormalizeDouble(start_lot + increament * Li_44, Gi_268), Bid + range * Li_44 * Gd_244, 3, 0, 0, "", magic, 0, Red);
						}
					}
				}
			}
		}
	}
	if (stealth_mode && f0_6() > 0 && f0_6() < level) {
		for (Li_44 = 0; Li_44 < OrdersTotal(); Li_44++) {
			OrderSelect(Li_44, SELECT_BY_POS, MODE_TRADES);
			if (OrderSymbol() != Symbol() || OrderMagicNumber() != magic) continue;
			cmd_0 = OrderType();
			order_open_price_4 = OrderOpenPrice();
			order_lots_12 = OrderLots();
		}
		if (cmd_0 == OP_BUY && Ask <= order_open_price_4 - range * Gd_244) {
			if (use_sl_and_tp) {
				if (lot_multiplier) G_ticket_276 = OrderSend(Symbol(), OP_BUY, NormalizeDouble(order_lots_12 * multiplier, Gi_268), Ask, 3, Ask - sl * Gd_244, Ask + tp * Gd_244, "", magic, 0, Blue);
				else G_ticket_276 = OrderSend(Symbol(), OP_BUY, NormalizeDouble(order_lots_12 + increament, Gi_268), Ask, 3, Ask - sl * Gd_244, Ask + tp * Gd_244, "", magic, 0, Blue);
			} else {
				if (lot_multiplier) G_ticket_276 = OrderSend(Symbol(), OP_BUY, NormalizeDouble(order_lots_12 * multiplier, Gi_268), Ask, 3, 0, 0, "", magic, 0, Blue);
				else G_ticket_276 = OrderSend(Symbol(), OP_BUY, NormalizeDouble(order_lots_12 + increament, Gi_268), Ask, 3, 0, 0, "", magic, 0, Blue);
			}
		}
		if (cmd_0 == OP_SELL && Bid >= order_open_price_4 + range * Gd_244) {
			if (use_sl_and_tp) {
				if (lot_multiplier) G_ticket_276 = OrderSend(Symbol(), OP_SELL, NormalizeDouble(order_lots_12 * multiplier, Gi_268), Bid, 3, Bid + sl * Gd_244, Bid - tp * Gd_244, "", magic, 0, Red);
				else G_ticket_276 = OrderSend(Symbol(), OP_SELL, NormalizeDouble(order_lots_12 + increament, Gi_268), Bid, 3, Bid + sl * Gd_244, Bid - tp * Gd_244, "", magic, 0, Red);
			} else {
				if (lot_multiplier) G_ticket_276 = OrderSend(Symbol(), OP_SELL, NormalizeDouble(order_lots_12 * multiplier, Gi_268), Bid, 3, 0, 0, "", magic, 0, Red);
				else G_ticket_276 = OrderSend(Symbol(), OP_SELL, NormalizeDouble(order_lots_12 + increament, Gi_268), Bid, 3, 0, 0, "", magic, 0, Red);
			}
		}
	}
	if (use_sl_and_tp && f0_6() > 1) {
		for (Li_44 = 0; Li_44 < OrdersTotal(); Li_44++) {
			OrderSelect(Li_44, SELECT_BY_POS, MODE_TRADES);
			if (OrderSymbol() != Symbol() || OrderMagicNumber() != magic || OrderType() > OP_SELL) continue;
			cmd_0 = OrderType();
			order_stoploss_20 = OrderStopLoss();
			order_takeprofit_28 = OrderTakeProfit();
		}
		for (Li_44 = OrdersTotal() - 1; Li_44 >= 0; Li_44--) {
			OrderSelect(Li_44, SELECT_BY_POS, MODE_TRADES);
			if (OrderSymbol() != Symbol() || OrderMagicNumber() != magic || OrderType() > OP_SELL) continue;
			if (OrderType() == cmd_0)
				if (OrderStopLoss() != order_stoploss_20 || OrderTakeProfit() != order_takeprofit_28) OrderModify(OrderTicket(), OrderOpenPrice(), order_stoploss_20, order_takeprofit_28, 0, CLR_NONE);
		}
	}
	double Ld_48 = 0;
	for (Li_44 = 0; Li_44 < OrdersTotal(); Li_44++) {
		OrderSelect(Li_44, SELECT_BY_POS, MODE_TRADES);
		if (OrderSymbol() != Symbol() || OrderMagicNumber() != magic || OrderType() > OP_SELL) continue;
		Ld_48 += OrderProfit();
	}
	if (Ld_48 >= tp_in_money || G_count_272 > 0) {
		f0_2();
		f0_2();
		f0_2();
		G_count_272++;
		if (f0_6() == 0) G_count_272 = 0;
	}
	if ((!stealth_mode) && use_sl_and_tp && f0_6() < level) f0_2();
	return (0);
}

// 9B1AEE847CFB597942D106A4135D4FE6
double f0_4() {
	int day_0 = Day();
	double Ld_ret_4 = 0;
	for (int pos_12 = 0; pos_12 < OrdersHistoryTotal(); pos_12++) {
		OrderSelect(pos_12, SELECT_BY_POS, MODE_HISTORY);
		if (OrderSymbol() != Symbol() || OrderMagicNumber() != magic) continue;
		if (TimeDay(OrderOpenTime()) == day_0) Ld_ret_4 += OrderProfit();
	}
	return (Ld_ret_4);
}

// D1DDCE31F1A86B3140880F6B1877CBF8
int f0_6() {
	int count_0 = 0;
	for (int pos_4 = 0; pos_4 < OrdersTotal(); pos_4++) {
		OrderSelect(pos_4, SELECT_BY_POS, MODE_TRADES);
		if (OrderSymbol() != Symbol() || OrderMagicNumber() != magic) continue;
		count_0++;
	}
	return (count_0);
}

// 2569208C5E61CB15E209FFE323DB48B7
int f0_1() {
	//Print("MA_Period1", DoubleToString(MA_Period1));
	//Print("MA_Period2", DoubleToString(MA_Period2));
	double ima_0 = iMA(Symbol(), 0, MA_Period1, MA_Shift1, MA_Method1, Applied_Price1, 1);
	double ima_8 = iMA(Symbol(), 0, MA_Period2, MA_Shift2, MA_Method2, Applied_Price2, 1);
	if (UseMA) {
		if (ima_0 < ima_8) return (2);
		if (ima_0 > ima_8) return (-2);
		return (0);
	}
	return (0);
}

// 6ABA3523C7A75AAEA41CC0DEC7953CC5
void f0_2() {
	for (int pos_0 = OrdersTotal() - 1; pos_0 >= 0; pos_0--) {
		OrderSelect(pos_0, SELECT_BY_POS, MODE_TRADES);
		if (OrderSymbol() != Symbol() || OrderMagicNumber() != magic) continue;
		if (OrderType() > OP_SELL) OrderDelete(OrderTicket());
		else {
			if (OrderType() == OP_BUY) OrderClose(OrderTicket(), OrderLots(), Bid, 3, CLR_NONE);
			else OrderClose(OrderTicket(), OrderLots(), Ask, 3, CLR_NONE);
		}
	}
}

// A9B24A824F70CC1232D1C2BA27039E8D
void f0_5() {
	string dbl2str_0 = DoubleToStr(f0_3(2), 2);
	Comment(" \nF8 AUTO TRADE AUTOMATED TRADING SOLUTION (VER.0.1)", 
		"\nAccount Leverage  =  " + "1 : " + AccountLeverage(), 
		"\nAccount Type       =  " + AccountServer(), 
		"\nServer Time         =  " + TimeToStr(TimeCurrent(), TIME_SECONDS), 
		"\nAccount Equity     =  ", AccountEquity(), 
		"\nFree Margin         =  ", AccountFreeMargin(), 
		"\nProfit                  =  ", AccountProfit(), 
		"\nJumlah OP          =  ", f0_0(), 
	"\nDrawdown          =  ", dbl2str_0, "%\n");
}

// 945D754CB0DC06D04243FCBA25FC0802
double f0_3(int Ai_0) {
	double Ld_ret_4;
	if (Ai_0 == 2) {
		Ld_ret_4 = (AccountEquity() / AccountBalance() - 1.0) / (-0.01);
		if (Ld_ret_4 > 0.0) return (Ld_ret_4);
		return (0);
	}
	if (Ai_0 == 1) {
		Ld_ret_4 = 100.0 * (AccountEquity() / AccountBalance() - 1.0);
		if (Ld_ret_4 > 0.0) return (Ld_ret_4);
		return (0);
	}
	return (0.0);
}

// 09CBB5F5CE12C31A043D5C81BF20AA4A
int f0_0() {
	int count_0 = 0;
	for (int pos_4 = 0; pos_4 < OrdersTotal(); pos_4++) {
		OrderSelect(pos_4, SELECT_BY_POS, MODE_TRADES);
		if (OrderSymbol() == Symbol() && OrderMagicNumber() == magic) count_0++;
	}
	return (count_0);
}



int check_license() {
	string cookie=NULL,headers;
	char post[],result[];
	string license;
	string lic_file = "license.bin";
	int res;

	// read license file
	int filehandle=FileOpen(lic_file,FILE_SHARE_READ|FILE_TXT);
	if(filehandle==INVALID_HANDLE){
		// read license error， exit program
		Print("Error in open license file. Error code=",GetLastError());
		MessageBox("请检查授权文件（MetaTrader安装目录\\MQL4\\Files\\"+lic_file+"）是否正确","Error",MB_ICONINFORMATION);
		return false;
	}

	license = FileReadString(filehandle);
	//Print("Read license... ", license);
	FileClose(filehandle);

	// access to the server, check license online
	string post_host="https://jack139.top";
	string post_url=post_host+"/ea/lic";
	string post_str="license="+license;
	//--- Reset the last error code
	ResetLastError();
	// ready to send request
	int timeout=15000; //--- Timeout below 1000 (1 sec.) is not enough for slow Internet connection
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
	//PrintFormat("The license has been successfully loaded, %d bytes recieved.",ArraySize(result));
	str_ret = CharArrayToString(result);
	//Print(str_ret);

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
	//for(int i=0; i<cnt; i++) 
	//	Print(DoubleToString(param[i]));

	multiplier = param[1]; 
	increament = param[2];
	MA_Period1 = param[3];
	MA_Period2 = param[4];

	return true;
}

