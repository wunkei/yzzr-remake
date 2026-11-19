package src.tool
{
   import com.hotpoint.braveManIII.Tool.*;
   import com.hotpoint.braveManIII.models.common.*;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.text.*;
   import flash.utils.*;
   import src.*;
   
   public class PaiHang_Data
   {
      
      public static var now_pID:int;
      
      public static var now_pID_0:int;
      
      public static var now_pID_x:int;
      
      public static var showTime:String;
      
      public static var saveXX:Array;
      
      public static var inGameNum:Array = [-1,0,0,0,0,0,0,0,0,0];
      
      public static var sArr2:Array = new Array();
      
      public static var jiFenArr:Array = new Array();
      
      public static var daLu:int = 0;
      
      public static var paiHangArr:Array = new Array();
      
      public static var gameNum_x1_1:Array = [1164,1132,1134,1136,1138,1140,1142,1144,1146,1148];
      
      public static var gameNum_x2_1:Array = [1165,1133,1135,1137,1139,1141,1143,1145,1147,1149];
      
      public static var gameNum_x1_2:Array = [1166,1150,1152,1154,1156,1158,1160,1162];
      
      public static var gameNum_x2_2:Array = [1167,1151,1153,1155,1157,1159,1161,1163];
      
      public static var gameNum_x1_3:Array = [1188,1168,1170,1172,1174,1176,1178,1180,1182,1184,1186,1245,1279];
      
      public static var gameNum_x2_3:Array = [1189,1169,1171,1173,1175,1177,1179,1181,1183,1185,1187,1246,1280];
      
      public static var gameNum_x1_4:Array = [1210,1190,1192,1194,1196,1198,1200,1202,1204,1206,1208];
      
      public static var gameNum_x2_4:Array = [1211,1191,1193,1195,1197,1199,1201,1203,1205,1207,1209];
      
      public static var gameNum_x1_0:Array = [1212];
      
      public static var gameNum_x2_0:Array = [1213];
      
      public static var time:uint = 0;
      
      public static var sNum:VT = VT.createVT();
      
      public static var sNumX:int = 0;
      
      public static var myXml:XML = new XML();
      
      public static var dataArr:Array = [];
      
      public static var myXml2:XML = new XML();
      
      public static var AllData:Array = new Array();
      
      public function PaiHang_Data()
      {
         super();
      }
      
      public static function creatFactory() : *
      {
         var _loc1_:XML = null;
         var _loc2_:uint = 0;
         myXml2 = XMLAsset.createXML(Data2.duiHuanData);
         for each(_loc1_ in myXml2.兑换神权利器)
         {
            _loc2_ = uint(_loc1_.序号);
            AllData[_loc2_] = new Array();
            AllData[_loc2_][0] = VT.createVT(Number(_loc1_.物品ID));
            AllData[_loc2_][1] = int(_loc1_.帧数);
            AllData[_loc2_][2] = VT.createVT(Number(_loc1_.概率));
         }
      }
      
      public static function TimeStart() : String
      {
         if(time > 0)
         {
            --time;
         }
         var _loc1_:int = int(time);
         var _loc2_:int = _loc1_ / 27;
         var _loc3_:int = _loc2_ / 3600;
         var _loc4_:int = (_loc2_ - _loc3_ * 3600) / 60;
         var _loc5_:int = (_loc2_ - _loc3_ * 3600) % 60;
         var _loc6_:int = (_loc1_ - (_loc3_ * 3600 + _loc4_ * 60 + _loc5_) * 27) * 37;
         var _loc7_:String = String(_loc4_);
         if(_loc4_ < 10)
         {
            _loc7_ = "0" + _loc4_;
         }
         var _loc8_:String = String(_loc5_);
         if(_loc5_ < 10)
         {
            _loc8_ = "0" + _loc5_;
         }
         var _loc9_:String = String(_loc6_).substr(0,2);
         var _loc10_:String = _loc7_ + ":" + _loc8_ + "." + _loc6_;
         showTime = _loc10_;
         return _loc10_;
      }
      
      public static function EnemyOver() : int
      {
         var _loc1_:int = 0;
         if(time <= 0)
         {
            return undefined;
         }
         if(GameData.gameLV == 5)
         {
            _loc1_ = Math.random() * InitData.tNum_100.getValue();
            if(_loc1_ < 2)
            {
               ++sNumX;
               sNum.setValue(sNum.getValue() + InitData.tNum_300.getValue());
               NewMC.Open("文字提示",Main._stage,470,350,30,0,true,2,"获得300积分");
               TiaoShi.txtShow("积分球:300");
               return 300;
            }
            if(_loc1_ < 5)
            {
               ++sNumX;
               sNum.setValue(sNum.getValue() + InitData.tNum_200.getValue());
               NewMC.Open("文字提示",Main._stage,470,350,30,0,true,2,"获得200积分");
               TiaoShi.txtShow("积分球:200");
               return 200;
            }
            if(_loc1_ < 10)
            {
               ++sNumX;
               sNum.setValue(sNum.getValue() + InitData.tNum_100.getValue());
               NewMC.Open("文字提示",Main._stage,470,350,30,0,true,2,"获得100积分");
               TiaoShi.txtShow("积分球:100");
               return 100;
            }
         }
         return undefined;
      }
      
      public static function All_0() : *
      {
         if(Boolean(PaiHang_Data.dataArr[Main.gameNum.getValue()]) && Main.gameNum2.getValue() == 1)
         {
            time = (PaiHang_Data.dataArr[Main.gameNum.getValue()][1] as VT).getValue();
            sNum = VT.createVT();
            sNumX = 0;
         }
      }
      
      public static function InitDataX() : *
      {
         var _loc1_:XML = null;
         var _loc2_:uint = 0;
         for each(_loc1_ in myXml.挑战关卡)
         {
            _loc2_ = uint(_loc1_.关卡);
            dataArr[_loc2_] = new Array();
            dataArr[_loc2_][0] = VT.createVT(Number(_loc1_.金币));
            dataArr[_loc2_][1] = VT.createVT(Number(_loc1_.时间));
         }
      }
      
      public static function InitSave() : *
      {
         var _loc1_:int = 0;
         if(inGameNum[0] != Main.serverTime.getValue())
         {
            TiaoShi.txtShow("InitSave() serverTime = " + Main.serverTime.getValue());
            inGameNum[0] = Main.serverTime.getValue();
            _loc1_ = 1;
            while(_loc1_ <= 62)
            {
               inGameNum[_loc1_] = 2;
               _loc1_++;
            }
         }
         if(!sArr2[0])
         {
            sArr2[0] = new Array();
         }
         _loc1_ = 1;
         while(_loc1_ <= 9)
         {
            if(!sArr2[0][_loc1_])
            {
               sArr2[0][_loc1_] = VT.createVT();
            }
            _loc1_++;
         }
         if(!sArr2[1])
         {
            sArr2[1] = new Array();
         }
         _loc1_ = 10;
         while(_loc1_ <= 16)
         {
            if(!sArr2[1][_loc1_])
            {
               sArr2[1][_loc1_] = VT.createVT();
            }
            _loc1_++;
         }
         if(!sArr2[2])
         {
            sArr2[2] = new Array();
         }
         _loc1_ = 51;
         while(_loc1_ <= 62)
         {
            if(!sArr2[2][_loc1_])
            {
               sArr2[2][_loc1_] = VT.createVT();
            }
            _loc1_++;
         }
         if(!sArr2[4])
         {
            sArr2[4] = new Array();
         }
         _loc1_ = 18;
         while(_loc1_ <= 29)
         {
            if(!sArr2[4][_loc1_])
            {
               sArr2[4][_loc1_] = VT.createVT();
            }
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < 5)
         {
            if(!jiFenArr[_loc1_])
            {
               jiFenArr[_loc1_] = VT.createVT();
            }
            _loc1_++;
         }
      }
      
      private static function SelDaLu() : int
      {
         var _loc1_:int = int(Main.gameNum.getValue());
         if(_loc1_ >= 1 && _loc1_ <= 9)
         {
            TiaoShi.txtShow("SelDaLu() 提交大陆1 ");
            return 0;
         }
         if(_loc1_ >= 10 && _loc1_ <= 16)
         {
            TiaoShi.txtShow("SelDaLu() 提交大陆2 ");
            return 1;
         }
         if(_loc1_ >= 51 && _loc1_ <= 62)
         {
            TiaoShi.txtShow("SelDaLu() 提交大陆3 ");
            return 2;
         }
         if(_loc1_ >= 18 && _loc1_ <= 29)
         {
            TiaoShi.txtShow("SelDaLu() 提交大陆4 ");
            return 4;
         }
         return 3;
      }
      
      public static function Show() : Array
      {
         var _loc2_:int = 0;
         var _loc1_:Array = new Array();
         TiaoShi.txtShow("Show~~~~~~~~1");
         var _loc3_:uint = 0;
         TiaoShi.txtShow("Show~~~~~~~~2");
         if(Main.player_1.playerCW)
         {
            if(Main.player_1.playerCW.data.getPetEquip())
            {
               if(Main.player_1.playerCW.data.getPetEquip().getType() == 15)
               {
                  WinShow.txt_3 -= Main.player_1.playerCW.data.getPetEquip().getColor();
                  if(WinShow.txt_3 < 0)
                  {
                     WinShow.txt_3 = 0;
                  }
               }
               if(Main.player_1.playerCW.data.getPetEquip().getType() == 16)
               {
                  time += Main.player_1.playerCW.data.getPetEquip().getColor() * 27;
               }
            }
         }
         if(Boolean(Main.P1P2) && Boolean(Main.player_2.playerCW))
         {
            if(Main.player_2.playerCW.data.getPetEquip())
            {
               if(Main.player_2.playerCW.data.getPetEquip().getType() == 15)
               {
                  WinShow.txt_3 -= Main.player_2.playerCW.data.getPetEquip().getColor();
                  if(WinShow.txt_3 < 0)
                  {
                     WinShow.txt_3 = 0;
                  }
               }
               if(Main.player_2.playerCW.data.getPetEquip().getType() == 16)
               {
                  time += Main.player_2.playerCW.data.getPetEquip().getColor() * 27;
               }
            }
         }
         _loc2_ = time * 37;
         TiaoShi.txtShow("Show~~~~~~~~3");
         if(WinShow.txt_3 > 0 && WinShow.txt_3 < 50)
         {
            _loc3_ = (_loc2_ + sNum.getValue()) * WinShow.txt_3 / 100;
         }
         else if(WinShow.txt_3 > 50 && WinShow.txt_3 < 999999)
         {
            _loc3_ = (_loc2_ + sNum.getValue()) * 50 / 100;
         }
         TiaoShi.txtShow("Show~~~~~~~~4");
         TiaoShi.txtShow("剩余时间:" + time);
         TiaoShi.txtShow("时间积分:" + _loc2_);
         TiaoShi.txtShow("关卡积分:" + sNum.getValue());
         TiaoShi.txtShow("被击扣分:" + _loc3_);
         var _loc4_:uint = _loc2_ + sNum.getValue() - _loc3_;
         TiaoShi.txtShow("~~~~~~~~关卡积分:" + _loc4_ + "\n");
         if(sArr2[daLu][Main.gameNum.getValue()])
         {
            TiaoShi.txtShow("~~~~~~~~之前最高分:" + (sArr2[daLu][Main.gameNum.getValue()] as VT).getValue() + "\n");
         }
         daLu = SelDaLu();
         if(_loc4_ > (sArr2[daLu][Main.gameNum.getValue()] as VT).getValue())
         {
            _loc1_[8] = true;
            sArr2[daLu][Main.gameNum.getValue()] = VT.createVT(_loc4_);
         }
         else
         {
            _loc1_[8] = false;
         }
         TiJiaoFun(_loc4_);
         _loc1_[0] = TimeStart();
         _loc1_[1] = _loc2_;
         _loc1_[2] = sNumX;
         _loc1_[3] = sNum.getValue();
         _loc1_[4] = WinShow.txt_3;
         _loc1_[5] = _loc3_;
         _loc1_[6] = sArr2[daLu][Main.gameNum.getValue()].getValue();
         _loc1_[7] = _loc4_;
         return _loc1_;
      }
      
      private static function TiJiaoFun(param1:int) : *
      {
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc10_:int = 0;
         Sel_now_pID();
         var _loc2_:Array = new Array();
         var _loc3_:int = int(PaiHang_Data.now_pID);
         _loc2_[0] = new Object();
         _loc2_[0].rId = _loc3_;
         _loc2_[0].score = int(param1);
         _loc2_[0].extra = Main.player_1.paiHangShow;
         if(Main.tiaoShiYN)
         {
            _loc2_[0].score = int(param1 / 3);
         }
         var _loc4_:int = int(PaiHang_Data.now_pID_0);
         var _loc5_:Array = new Array();
         _loc7_ = 1;
         while(_loc7_ <= 100)
         {
            if(sArr2[daLu][_loc7_])
            {
               _loc6_ += sArr2[daLu][_loc7_].getValue();
            }
            _loc7_++;
         }
         _loc5_[0] = new Object();
         _loc5_[0].rId = _loc4_;
         _loc5_[0].score = int(_loc6_);
         _loc5_[0].extra = Main.player_1.paiHangShow;
         if(Main.tiaoShiYN)
         {
            _loc5_[0].score = int(_loc6_ / 3);
         }
         var _loc8_:int = int(PaiHang_Data.now_pID_x);
         var _loc9_:Array = new Array();
         var _loc11_:int = 0;
         while(_loc11_ <= 4)
         {
            if(_loc11_ != 3)
            {
               _loc7_ = 1;
               while(_loc7_ <= 100)
               {
                  if(sArr2[_loc11_][_loc7_])
                  {
                     _loc10_ += sArr2[_loc11_][_loc7_].getValue();
                  }
                  _loc7_++;
               }
            }
            _loc11_++;
         }
         _loc9_[0] = new Object();
         _loc9_[0].rId = _loc8_;
         _loc9_[0].score = int(_loc10_);
         _loc9_[0].extra = Main.player_1.paiHangShow;
         if(Main.tiaoShiYN)
         {
            _loc9_[0].score = int(_loc10_ / 3);
         }
         TiaoShi.txtShow("提交成绩:\n" + _loc3_ + "关卡积分" + _loc2_[0].score + "\n" + _loc4_ + "大陆积分" + _loc5_[0].score + "\n" + _loc8_ + "总积分" + _loc9_[0].score);
         Api_4399_All.SubmitScore(Main.saveNum,_loc2_);
         Api_4399_All.SubmitScore(Main.saveNum,_loc5_);
         Api_4399_All.SubmitScore(Main.saveNum,_loc9_);
         paiHangArr[_loc3_] = null;
         paiHangArr[_loc4_] = null;
         paiHangArr[_loc8_] = null;
      }
      
      private static function Sel_now_pID() : *
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         if(Main.P1P2)
         {
            _loc2_ = 2;
         }
         else
         {
            _loc2_ = 1;
         }
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = int(Main.gameNum.getValue());
         if(_loc5_ >= 1 && _loc5_ <= 9)
         {
            _loc3_ = 1;
            _loc4_ = _loc5_;
         }
         if(_loc5_ >= 10 && _loc5_ <= 16)
         {
            _loc3_ = 2;
            _loc4_ = _loc5_ - 9;
         }
         if(_loc5_ >= 51 && _loc5_ <= 62)
         {
            _loc3_ = 3;
            _loc4_ = _loc5_ - 50;
         }
         if(_loc5_ >= 18 && _loc5_ <= 29)
         {
            _loc3_ = 4;
            _loc4_ = _loc5_ - 17;
         }
         now_pID_x = PaiHang_Data["gameNum_x" + _loc2_ + "_0"][0];
         now_pID_0 = PaiHang_Data["gameNum_x" + _loc2_ + "_" + _loc3_][0];
         now_pID = PaiHang_Data["gameNum_x" + _loc2_ + "_" + _loc3_][_loc4_];
         TiaoShi.txtShow("Sel_now_pID:\n" + "gameNum_x" + _loc2_ + "_" + _loc3_ + ", xID" + _loc4_);
      }
      
      public static function DataAry1(param1:Array, param2:int) : *
      {
         var _loc3_:int = 0;
         if(!PaiHang_Data.paiHangArr[param2])
         {
            PaiHang_Data.paiHangArr[param2] = new Array();
         }
         for(_loc3_ in param1)
         {
            PaiHang_Data.paiHangArr[param2][_loc3_ + 1] = param1[_loc3_];
         }
      }
      
      public static function DataAry2(param1:Array, param2:int) : *
      {
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         if(!PaiHang_Data.paiHangArr[param2])
         {
            PaiHang_Data.paiHangArr[param2] = new Array();
         }
         if(param1 != null && param1.length != 0)
         {
            for(_loc3_ in param1)
            {
               _loc4_ = param1[_loc3_];
               if(int(_loc4_.index) == Main.saveNum)
               {
                  PaiHang_Data.paiHangArr[param2][0] = _loc4_;
                  return;
               }
            }
         }
      }
   }
}

