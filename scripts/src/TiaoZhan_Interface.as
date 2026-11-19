package src
{
   import com.*;
   import com.efnx.fps.*;
   import com.hotpoint.braveManIII.models.common.*;
   import com.hotpoint.braveManIII.models.container.*;
   import com.hotpoint.braveManIII.views.itemsPanel.*;
   import com.hotpoint.braveManIII.views.itemsTooltip.*;
   import com.hotpoint.braveManIII.views.setKeyPanel.*;
   import com.hotpoint.braveManIII.views.taskPanel.*;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.text.*;
   import flash.utils.*;
   import src.tool.*;
   
   public class TiaoZhan_Interface extends MovieClip
   {
      
      public static var loadData:ClassLoader;
      
      private static var _this:TiaoZhan_Interface;
      
      private static var skin:MovieClip;
      
      public static var loadingOK:int = 0;
      
      private static var OpenYN:Boolean = false;
      
      private static var loadName:String = "TiaoZhan_v850.swf";
      
      private static var dianQuanYN:Boolean = false;
      
      public function TiaoZhan_Interface()
      {
         super();
         _this = this;
      }
      
      public static function LoadSkin() : *
      {
         var _loc1_:TiaoZhan_Interface = null;
         var _loc2_:TiaoZhanPaiHang_Interface = null;
         if(loadingOK == 0)
         {
            loadingOK = 1;
            _loc1_ = new TiaoZhan_Interface();
            _loc2_ = new TiaoZhanPaiHang_Interface();
            loadData = new ClassLoader(loadName);
            loadData.addEventListener(Event.COMPLETE,onLoadingOK);
            LoadInGame.Open(loadData,false);
         }
      }
      
      private static function onLoadingOK(param1:*) : *
      {
         loadingOK = 2;
         var _loc2_:Class = loadData.getClass("Skin") as Class;
         skin = new _loc2_();
         skin.close_btn.addEventListener(MouseEvent.CLICK,Close);
         skin.go_btn.addEventListener(MouseEvent.CLICK,GameGo);
         _this.addChild(skin);
         if(SelMap.selMapX)
         {
            SelMap.selMapX.tiaozhan_loading.visible = false;
         }
         var _loc3_:Class = loadData.getClass("Skin_PaiHang") as Class;
         TiaoZhanPaiHang_Interface.skin = new _loc3_();
         TiaoZhanPaiHang_Interface.InitSkin();
         var _loc4_:Class = loadData.getClass("skin_TJ") as Class;
         WinShow2.skin = new _loc4_();
         var _loc5_:Class = loadData.getClass("Skin_time") as Class;
         TimeShow.skin = new _loc5_();
         new TimeShow();
      }
      
      private static function GameGo(param1:*) : *
      {
         var _loc2_:int = int((PaiHang_Data.dataArr[Main.gameNum.getValue()][0] as VT).getValue());
         if(Main.P1P2)
         {
            if(Main.player1.getGold() < _loc2_ || Main.player2.getGold() < _loc2_)
            {
               NewMC.Open("文字提示",Main._stage,400,400,30,0,true,2,"金币不足");
               return;
            }
            if(Main.player1.killPoint.getValue() < 10 || Main.player2.killPoint.getValue() < 10)
            {
               NewMC.Open("文字提示",Main._stage,400,400,30,0,true,2,"击杀点不足");
               return;
            }
            if(Main.player1.level.getValue() < 30 || Main.player2.level.getValue() < 30)
            {
               NewMC.Open("文字提示",Main._stage,400,400,30,0,true,2,"等级30级后方可进入");
               return;
            }
         }
         else
         {
            if(Main.player1.level.getValue() < 30)
            {
               NewMC.Open("文字提示",Main._stage,400,400,30,0,true,2,"等级30级后方可进入");
               return;
            }
            if(Main.player1.getGold() < _loc2_)
            {
               NewMC.Open("文字提示",Main._stage,400,400,30,0,true,2,"金币不足");
               return;
            }
            if(Main.player1.killPoint.getValue() < 10)
            {
               NewMC.Open("文字提示",Main._stage,400,400,30,0,true,2,"击杀点不足");
               return;
            }
         }
         if(Main.guanKa[Main.gameNum.getValue()] < 3)
         {
            NewMC.Open("文字提示",Main._stage,400,400,30,0,true,2,"开启3星难度方可进入");
            return;
         }
         var _loc3_:int = int(PaiHang_Data.inGameNum[Main.gameNum.getValue()]);
         if(_loc3_ <= 0)
         {
            DianQuan_Fun();
            return;
         }
         if(Main.P1P2)
         {
            Main.player1.payGold(_loc2_);
            Main.player2.payGold(_loc2_);
            Main.player1.killPoint.setValue(Main.player1.killPoint.getValue() - 10);
            Main.player2.killPoint.setValue(Main.player2.killPoint.getValue() - 10);
         }
         else
         {
            Main.player1.payGold(_loc2_);
            Main.player1.killPoint.setValue(Main.player1.killPoint.getValue() - 10);
         }
         --PaiHang_Data.inGameNum[Main.gameNum.getValue()];
         GameData.gameLV = 5;
         Close();
         SelMap.Close();
         Main.gameNum2.setValue(1);
         Main._this.Loading();
         Main.Save();
      }
      
      private static function DianQuan_Fun() : *
      {
         skin.dianQuan_mc.visible = true;
         skin.dianQuan_mc.ok_btn.addEventListener(MouseEvent.CLICK,DianQuan_ok);
         skin.dianQuan_mc.close_btn.addEventListener(MouseEvent.CLICK,DianQuan_close);
      }
      
      private static function DianQuan_ok(param1:*) : *
      {
         if(Shop4399.moneyAll.getValue() >= 5)
         {
            Api_4399_All.BuyObj(127);
            skin.xxx_mc.visible = true;
            dianQuanYN = true;
         }
         else
         {
            NewMC.Open("文字提示",Main._stage,400,400,30,0,true,2,"点券不足");
            skin.dianQuan_mc.visible = false;
         }
      }
      
      public static function DianQuan_GO() : *
      {
         if(dianQuanYN)
         {
            dianQuanYN = false;
            skin.xxx_mc.visible = true;
            GameData.gameLV = 5;
            Close();
            SelMap.Close();
            Main.gameNum2.setValue(1);
            Main._this.Loading();
         }
      }
      
      private static function DianQuan_close(param1:*) : *
      {
         skin.dianQuan_mc.visible = false;
      }
      
      public static function Open() : *
      {
         LoadInGame.Open(loadData);
         SelMap.selMapX.addChild(_this);
         _this.visible = true;
         _this.x = _this.y = 0;
         Show();
      }
      
      public static function Close(param1:* = null) : *
      {
         _this.visible = false;
         _this.x = _this.y = 5000;
      }
      
      private static function Show() : *
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc8_:Object = null;
         var _loc9_:Object = null;
         skin.xxx_mc.visible = false;
         skin.dianQuan_mc.visible = false;
         skin.x1_txt.text = "";
         skin.x2_txt.text = "";
         skin.x3_txt.text = "";
         skin.show_mc.gotoAndStop("d" + Main.gameNum.getValue());
         if(Main.P1P2)
         {
            _loc1_ = 2;
         }
         else
         {
            _loc1_ = 1;
         }
         var _loc4_:int = int(Main.gameNum.getValue());
         if(_loc4_ >= 1 && _loc4_ <= 9)
         {
            _loc2_ = 1;
            _loc3_ = _loc4_;
         }
         else if(_loc4_ >= 10 && _loc4_ <= 16)
         {
            _loc2_ = 2;
            _loc3_ = _loc4_ - 9;
         }
         else if(_loc4_ >= 51 && _loc4_ <= 62)
         {
            _loc2_ = 3;
            _loc3_ = _loc4_ - 50;
         }
         else if(_loc4_ >= 18 && _loc4_ <= 29)
         {
            _loc2_ = 4;
            _loc3_ = _loc4_ - 17;
         }
         var _loc5_:int = int(PaiHang_Data["gameNum_x" + _loc1_ + "_" + _loc2_][_loc3_]);
         if(!PaiHang_Data.paiHangArr[_loc5_])
         {
            Api_4399_All.GetRankListsData(1,50,_loc5_);
            Api_4399_All.GetOneRankInfo(Main.logName,_loc5_,1);
         }
         if(Boolean(PaiHang_Data.paiHangArr[_loc5_]) && Boolean(PaiHang_Data.paiHangArr[_loc5_][0]))
         {
            _loc8_ = PaiHang_Data.paiHangArr[_loc5_][0];
            skin.x3_txt.text = _loc8_.score;
         }
         else
         {
            skin.x3_txt.text = "暂无";
         }
         if(Boolean(PaiHang_Data.paiHangArr[_loc5_]) && Boolean(PaiHang_Data.paiHangArr[_loc5_][1]))
         {
            _loc9_ = PaiHang_Data.paiHangArr[_loc5_][1];
            skin.x1_txt.text = _loc9_.userName;
            skin.x2_txt.text = _loc9_.score;
         }
         else
         {
            skin.x1_txt.text = "暂无";
            skin.x2_txt.text = "暂无";
         }
         var _loc6_:int = int((PaiHang_Data.dataArr[Main.gameNum.getValue()][0] as VT).getValue());
         var _loc7_:int = int(PaiHang_Data.inGameNum[Main.gameNum.getValue()]);
         skin["txt1"].text = "消耗击杀点:10   消耗金币:" + _loc6_;
         skin["txt2"].text = "本关剩余挑战次数:" + _loc7_;
      }
      
      public static function TxtShow1(param1:Array, param2:int) : *
      {
         var _loc3_:Object = null;
         if(PaiHang_Data.paiHangArr[param2][1])
         {
            _loc3_ = PaiHang_Data.paiHangArr[param2][1];
            skin.x1_txt.text = _loc3_.userName;
            skin.x2_txt.text = _loc3_.score;
         }
         else
         {
            skin.x1_txt.text = "暂无";
            skin.x2_txt.text = "暂无";
         }
      }
      
      public static function TxtShow2(param1:Array, param2:int) : *
      {
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         if(param1 != null && param1.length != 0)
         {
            for(_loc3_ in param1)
            {
               _loc4_ = param1[_loc3_];
               if(int(_loc4_.index) == Main.saveNum)
               {
                  skin.x3_txt.text = _loc4_.score;
                  return;
               }
            }
            skin.x3_txt.text = "未上榜";
         }
         else
         {
            skin.x3_txt.text = "未上榜";
         }
      }
   }
}

