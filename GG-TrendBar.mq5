//+------------------------------------------------------------------+
//|                                                  GG-TrendBar.mq5 |
//|                                                   Mozheykin Igor |
//|  https://www.upwork.com/freelancers/~01dd7daccf19642309?viewMode |
//+------------------------------------------------------------------+
#property copyright "Mozheykin Igor"
#property link      "https://www.upwork.com/freelancers/~01dd7daccf19642309?viewMode"
#property version   "1.00"
#property indicator_chart_window

ENUM_TIMEFRAMES tframe[9]= {PERIOD_M1,PERIOD_M5,PERIOD_M15,PERIOD_M30,PERIOD_H1,PERIOD_H4,PERIOD_D1,PERIOD_W1,PERIOD_MN1};
string tf[]= {"M1","M5","M15","M30","H1","H4","D1","W1","MN1"};
int tfnumber=9;

input string ___PositionIndicator___=">>> Position Indicator:<<<";
input int x_pos = 0;
input int y_pos = 0;

input string ___IndicatorSetup___=">>> Indicator Setup:<<<";
input int ADX_Period=14;
input int ADX_Price=PRICE_CLOSE;
input double Step_Psar=0.02;
input double Max_Psar=0.2;
input string ___DisplaySetup___=">>> Display Setup:<<<";
input color UpColor=Lime;
input color DownColor=Red;
input color FlatColor=Yellow;
input color TextColor=Aqua;
input int Corner=0;

double Psar;
double PADX,NADX;
string TimeFrameStr;
double IndVal[9];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
   for(int w=1; w<tfnumber+1; w++)
     {
      ObjectCreate(0, tf[w-1],OBJ_LABEL,0,0,0,0,0);
      ObjectSetInteger(0,tf[w-1],OBJPROP_CORNER,Corner);
      ObjectSetInteger(0,tf[w-1],OBJPROP_XDISTANCE, x_pos + (w-1)*23+15);
      ObjectSetInteger(0,tf[w-1],OBJPROP_YDISTANCE,y_pos + 20);
      ObjectSetString(0,tf[w-1],OBJPROP_TEXT,tf[w-1]);
      ObjectSetString(0,tf[w-1],OBJPROP_FONT,"Tahoma");
      ObjectSetInteger(0,tf[w-1],OBJPROP_FONTSIZE,8);
      ObjectSetInteger(0,tf[w-1],OBJPROP_COLOR,TextColor);
     }
   return(INIT_SUCCEEDED);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   for(int k=1; k<tfnumber+1; k++)
      ObjectDelete(0, "Ind"+k);
   for(int k=1; k<tfnumber+1; k++)
      ObjectDelete(0, tf[k-1]);
   
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {
   for(int a=1; a<tfnumber+1; a++)
      ObjectDelete(0,"Ind"+a);


   int to_copy;
   if(prev_calculated>rates_total || prev_calculated<=0)
      to_copy=rates_total;
   else
     {
      to_copy=rates_total-prev_calculated;
      to_copy++;
     }

   for(int j=1; j<tfnumber+1; j++)
     {
      ObjectCreate(0,"Ind"+j,OBJ_LABEL,0,0,0,0,0);
      ObjectSetInteger(0,"Ind"+j,OBJPROP_CORNER,Corner);
      ObjectSetInteger(0,"Ind"+j,OBJPROP_XDISTANCE, x_pos + (j-1)*23+15);
      ObjectSetInteger(0,"Ind"+j,OBJPROP_YDISTANCE, y_pos + 30);
      ObjectSetString(0,"Ind"+j,OBJPROP_TEXT,CharToString(110));
      ObjectSetString(0,"Ind"+j,OBJPROP_FONT,"Wingdings");
      ObjectSetInteger(0,"Ind"+j,OBJPROP_FONTSIZE,12);
      ObjectSetInteger(0,"Ind"+j,OBJPROP_COLOR,White);
     }


   double PADX[];
   double NADX[];
   double Psar[];

   for(int x=1; x<=tfnumber; x++)
     {

      //PADX=iADX(NULL,tframe[x-1],ADX_Period,ADX_Price,1,0);
      //NADX=iADX(NULL,tframe[x-1],ADX_Period,ADX_Price,2,0);
      //Psar=iSAR(NULL,tframe[x-1],Step_Psar,Max_Psar,0) ;
      int ADX_Handle=iADX(NULL,tframe[x-1],ADX_Period);
      if (CopyBuffer(ADX_Handle,1,0,to_copy,PADX)<=0) return(0);
      if (CopyBuffer(ADX_Handle,2,0,to_copy,NADX)<=0) return(0);
      int SAR_Handle=iSAR(NULL,tframe[x-1],Step_Psar,Max_Psar);
      if (CopyBuffer(SAR_Handle,0,0,to_copy,Psar)<=0) return(0);
      
      if(Psar[0] < iClose(NULL,tframe[x-1],0) && PADX[0] > NADX[0])
        {
         IndVal[x-1]=1;
        }
      else
         if(Psar[0] > iClose(NULL,tframe[x-1],0) && NADX[0] > PADX[0])
           {
            IndVal[x-1]=-1;
           }
         else
            IndVal[x-1]=0;
     }



   for(int y=1; y<tfnumber+1; y++)
     {
      if(IndVal[y-1]==-1)
        {
         //ObjectSetString(0, "Ind"+y,IntegerToString(110),12,"Wingdings",DownColor);
         ObjectSetString(0,"Ind"+y,OBJPROP_TEXT,CharToString(110));
         ObjectSetString(0,"Ind"+y,OBJPROP_FONT,"Wingdings");
         ObjectSetInteger(0,"Ind"+y,OBJPROP_FONTSIZE,12);
         ObjectSetInteger(0,"Ind"+y,OBJPROP_COLOR,DownColor);
        }

      if(IndVal[y-1]==0)
        {
         //ObjectSetString(0, "Ind"+y,IntegerToString(110),12,"Wingdings",FlatColor);
         ObjectSetString(0,"Ind"+y,OBJPROP_TEXT,CharToString(110));
         ObjectSetString(0,"Ind"+y,OBJPROP_FONT,"Wingdings");
         ObjectSetInteger(0,"Ind"+y,OBJPROP_FONTSIZE,12);
         ObjectSetInteger(0,"Ind"+y,OBJPROP_COLOR,FlatColor);
        }

      if(IndVal[y-1]==1)
        {
         //ObjectSetString(0, "Ind"+y,IntegerToString(110),12,"Wingdings",UpColor);
         ObjectSetString(0,"Ind"+y,OBJPROP_TEXT,CharToString(110));
         ObjectSetString(0,"Ind"+y,OBJPROP_FONT,"Wingdings");
         ObjectSetInteger(0,"Ind"+y,OBJPROP_FONTSIZE,12);
         ObjectSetInteger(0,"Ind"+y,OBJPROP_COLOR,UpColor);
        }

     }
   return(rates_total);
  }
//+------------------------------------------------------------------+
