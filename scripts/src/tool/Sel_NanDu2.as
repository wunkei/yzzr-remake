package src.tool
{
   import com.greensock.*;
   import com.greensock.easing.*;
   import com.hotpoint.braveManIII.models.common.*;
   import com.hotpoint.braveManIII.views.achPanel.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   import src.*;
   
   public class Sel_NanDu2 extends MovieClip
   {
      
      public static var _this:Sel_NanDu2;
      
      private static var gameNumX:int = 0;
      
      private static var dianQuanYN:Boolean = false;
      
      public var NanDu_mc_1:MovieClip;
      
      public var NanDu_mc_2:MovieClip;
      
      public var NanDu_mc_3:MovieClip;
      
      public var NanDu_mc_4:MovieClip;
      
      public var Close_btn:SimpleButton;
      
      public var next_btn:SimpleButton;
      
      public var back_btn:SimpleButton;
      
      public var x1_txt:*;
      
      public var x2_txt:*;
      
      public var x3_txt:*;
      
      public var x4_txt:*;
      
      public var dianQuan_mc:MovieClip;
      
      public var NoMoney_mc:MovieClip;
      
      public var yes_btn:SimpleButton;
      
      public var addMoney_btn:SimpleButton;
      
      public var _txt:*;
      
      public var dianQuan_Yes:SimpleButton;
      
      public var dianQuan_No:SimpleButton;
      
      public var tiaozan_mc:MovieClip;
      
      public var xxx_mc:MovieClip;
      
      public var dianQuan2_mc:MovieClip;
      
      private var chenJiuArr:Array = [0,35,35,35,35,35,35,35,35,35,35];
      
      private var chenJiuXXXArr:Array = [0,19,49,59,79,89,99,109,119,119,119];
      
      private var txtArr1:Array = ["?????????????????","解锁条件:游戏成就达到20点","解锁条件:游戏成就达到50点","解锁条件:游戏成就达到60点","解锁条件:游戏成就达到80点","解锁条件:游戏成就达到90点","解锁条件:游戏成就达到100点","解锁条件:游戏成就达到110点","解锁条件:游戏成就达到120点","解锁条件:游戏成就达到120点","解锁条件:游戏成就达到120点"];
      
      private var txtArr2:Array = ["?????????????????","星座功能:史诗指环祝福","星座功能:史诗项链祝福","星座功能:史诗头饰祝福","星座功能:史诗战甲祝福","星座功能:史诗武器祝福","星座功能:时装翅膀祝福","星座功能:史诗指环进阶祝福","星座功能:史诗项链进阶祝福","星座功能:史诗头饰进阶祝福","星座功能:史诗战甲进阶祝福"];
      
      private var numX:int = 1;
      
      private var numMax:int = 10;
      
      internal var gameX:uint = 18;
      
      public function Sel_NanDu2()
      {
         super();
         _this = this;
         dianQuan_mc.addEventListener(Event.ADDED_TO_STAGE,DianQuanShow);
         Close_btn.addEventListener(MouseEvent.CLICK,Close);
         next_btn.addEventListener(MouseEvent.CLICK,Next_Fun);
         back_btn.addEventListener(MouseEvent.CLICK,Back_Fun);
         Show();
      }
      
      public static function DianQuanGoGame() : *
      {
         if(gameNumX == 0)
         {
            return;
         }
         Main.gameNum.setValue(gameNumX);
         GameData.gameLV = 4;
         if(SelMap.tiaoZanType)
         {
            GameData.gameLV = 5;
         }
         _this.GameGo();
         gameNumX = 0;
      }
      
      private static function DianQuan_Fun() : *
      {
         _this.dianQuan2_mc.visible = true;
         _this.dianQuan2_mc.ok_btn.addEventListener(MouseEvent.CLICK,DianQuan_ok);
         _this.dianQuan2_mc.close_btn.addEventListener(MouseEvent.CLICK,DianQuan_close);
      }
      
      private static function DianQuan_ok(param1:*) : *
      {
         if(Shop4399.moneyAll.getValue() >= 5)
         {
            Api_4399_All.BuyObj(127);
            _this.xxx_mc.visible = true;
            dianQuanYN = true;
         }
         else
         {
            NewMC.Open("文字提示",Main._stage,400,400,30,0,true,2,"点券不足");
            _this.dianQuan2_mc.visible = false;
         }
      }
      
      private static function DianQuan_close(param1:*) : *
      {
         _this.dianQuan2_mc.visible = false;
      }
      
      public static function DianQuan_GO() : *
      {
         if(dianQuanYN)
         {
            dianQuanYN = false;
            _this.xxx_mc.visible = true;
            GameData.gameLV = 5;
            _this.Close();
            Main.gameNum2.setValue(1);
            Main._this.Loading();
         }
      }
      
      public static function TxtShow1(param1:Array, param2:int) : *
      {
         var _loc3_:Object = null;
         if(!_this)
         {
            return;
         }
         if(PaiHang_Data.paiHangArr[param2][1])
         {
            _loc3_ = PaiHang_Data.paiHangArr[param2][1];
            _this.tiaozan_mc.x1_txt.text = _loc3_.userName;
            _this.tiaozan_mc.x2_txt.text = _loc3_.score;
         }
         else
         {
            _this.tiaozan_mc.x1_txt.text = "暂无";
            _this.tiaozan_mc.x2_txt.text = "暂无";
         }
      }
      
      public static function TxtShow2(param1:Array, param2:int) : *
      {
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         if(!_this)
         {
            return;
         }
         if(param1 != null && param1.length != 0)
         {
            for(_loc3_ in param1)
            {
               _loc4_ = param1[_loc3_];
               if(int(_loc4_.index) == Main.saveNum)
               {
                  _this.tiaozan_mc.x3_txt.text = _loc4_.score;
                  return;
               }
            }
            _this.tiaozan_mc.x3_txt.text = "未上榜";
         }
         else
         {
            _this.tiaozan_mc.x3_txt.text = "未上榜";
         }
      }
      
      private function Next_Fun(param1:*) : *
      {
         var _loc2_:int = (PaiHang_Data.gameNum_x1_4.length - 2) / 4 + 1;
         var _loc3_:int = (numMax - 1) / 4 + 1;
         if(!SelMap.tiaoZanType)
         {
            if(numX < _loc3_)
            {
               ++numX;
               Show();
            }
         }
         else if(numX < _loc2_)
         {
            ++numX;
            Show();
         }
         else
         {
            NewMC.Open("文字提示",this,400,400,30,0,true,2,"其他星灵挑战模式暂未开启");
         }
      }
      
      private function Back_Fun(param1:*) : *
      {
         if(numX > 1)
         {
            --numX;
            Show();
         }
      }
      
      private function DianQuanShow(param1:*) : *
      {
         dianQuan_mc.dianQuan_Yes.addEventListener(MouseEvent.CLICK,DianQuan);
         dianQuan_mc.dianQuan_No.addEventListener(MouseEvent.CLICK,DianQuanClose);
      }
      
      public function Open() : *
      {
         numX = 1;
         this.x = this.y = 0;
         this.visible = true;
         dianQuan_mc.visible = false;
         dianQuan_mc.x = dianQuan_mc.y = 0;
         Show();
      }
      
      public function Close(param1:* = null) : *
      {
         numX = 1;
         this.x = this.y = 5000;
         this.visible = false;
         dianQuan_mc.visible = false;
      }
      
      public function DianQuan(param1:* = null) : *
      {
         if(Shop4399.moneyAll.getValue() < InitData.xingLing.getValue())
         {
            (NoMoney_mc as NoMoneyInfo).Open(InitData.xingLing.getValue());
            return;
         }
         Api_4399_All.BuyObj(InitData.xingLing.getValue());
         dianQuan_mc.visible = false;
      }
      
      public function DianQuanClose(param1:* = null) : *
      {
         dianQuan_mc.visible = false;
      }
      
      private function SelNanDu_MOUSE_MOVE(param1:MouseEvent) : *
      {
         gameX = (param1.target.parent.name as String).substr(9,1);
         gameX = (numX - 1) * 4 + 17 + gameX;
         _this.tiaozan_mc.mouseChildren = _this.tiaozan_mc.mouseEnabled = false;
         _this.tiaozan_mc.x = mouseX + 15;
         _this.tiaozan_mc.y = mouseY - 25;
         if(SelMap.tiaoZanType)
         {
            XXX(gameX,param1.target.parent);
         }
      }
      
      private function SelNanDu_MOUSE_OUT(param1:MouseEvent) : *
      {
         _this.tiaozan_mc.x = _this.tiaozan_mc.y = -5000;
      }
      
      private function SelNanDu(param1:MouseEvent) : *
      {
         gameX = (param1.target.parent.name as String).substr(9,1);
         gameX = (numX - 1) * 4 + 17 + gameX;
         if(Boolean(Main.isVip()) && AchData.cjPoint_1.getValue() >= 18)
         {
            Main.gameNum.setValue(gameX);
            GameData.gameLV = 4;
            if(SelMap.tiaoZanType)
            {
               GameData.gameLV = 5;
            }
            GameGo();
            if(!SelMap.tiaoZanType)
            {
               AchData.cjPoint_1.setValue(AchData.cjPoint_1.getValue() - 18);
            }
         }
         else if(AchData.cjPoint_1.getValue() >= chenJiuArr[gameX - 17])
         {
            Main.gameNum.setValue(gameX);
            GameData.gameLV = 4;
            if(SelMap.tiaoZanType)
            {
               GameData.gameLV = 5;
            }
            GameGo();
            if(!SelMap.tiaoZanType)
            {
               AchData.cjPoint_1.setValue(AchData.cjPoint_1.getValue() - chenJiuArr[gameX - 17]);
            }
         }
         else
         {
            dianQuan_mc.visible = true;
            gameNumX = gameX;
         }
      }
      
      private function XXX(param1:int, param2:MovieClip) : *
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc10_:Object = null;
         var _loc11_:Object = null;
         if(Main.P1P2)
         {
            _loc3_ = 2;
         }
         else
         {
            _loc3_ = 1;
         }
         var _loc6_:int = param1;
         if(_loc6_ >= 1 && _loc6_ <= 9)
         {
            _loc4_ = 1;
            _loc5_ = _loc6_;
         }
         else if(_loc6_ >= 10 && _loc6_ <= 16)
         {
            _loc4_ = 2;
            _loc5_ = _loc6_ - 9;
         }
         else if(_loc6_ >= 51 && _loc6_ <= 62)
         {
            _loc4_ = 3;
            _loc5_ = _loc6_ - 50;
         }
         else if(_loc6_ >= 18 && _loc6_ <= 29)
         {
            _loc4_ = 4;
            _loc5_ = _loc6_ - 17;
         }
         var _loc7_:int = int(PaiHang_Data["gameNum_x" + _loc3_ + "_" + _loc4_][_loc5_]);
         if(!PaiHang_Data.paiHangArr[_loc7_])
         {
            Api_4399_All.GetRankListsData(1,50,_loc7_);
            Api_4399_All.GetOneRankInfo(Main.logName,_loc7_,1);
         }
         if(Boolean(PaiHang_Data.paiHangArr[_loc7_]) && Boolean(PaiHang_Data.paiHangArr[_loc7_][0]))
         {
            _loc10_ = PaiHang_Data.paiHangArr[_loc7_][0];
            tiaozan_mc.x3_txt.text = _loc10_.score;
         }
         else
         {
            tiaozan_mc.x3_txt.text = "暂无";
         }
         if(Boolean(PaiHang_Data.paiHangArr[_loc7_]) && Boolean(PaiHang_Data.paiHangArr[_loc7_][1]))
         {
            _loc11_ = PaiHang_Data.paiHangArr[_loc7_][1];
            tiaozan_mc.x1_txt.text = _loc11_.userName;
            tiaozan_mc.x2_txt.text = _loc11_.score;
         }
         else
         {
            tiaozan_mc.x1_txt.text = "暂无";
            tiaozan_mc.x2_txt.text = "暂无";
         }
         var _loc8_:int = int((PaiHang_Data.dataArr[_loc6_][0] as VT).getValue());
         var _loc9_:int = int(PaiHang_Data.inGameNum[_loc6_]);
         param2["txt1"].text = "消耗击杀点:10\n消耗金币:" + _loc8_;
         param2["txt2"].text = "本关剩余挑战次数:" + _loc9_;
      }
      
      private function GameGo() : *
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         if(SelMap.tiaoZanType)
         {
            _loc1_ = int((PaiHang_Data.dataArr[Main.gameNum.getValue()][0] as VT).getValue());
            if(Main.P1P2)
            {
               if(Main.player1.getGold() < _loc1_ || Main.player2.getGold() < _loc1_)
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
               if(Main.player1.getGold() < _loc1_)
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
            _loc2_ = int(PaiHang_Data.inGameNum[Main.gameNum.getValue()]);
            if(_loc2_ <= 0)
            {
               DianQuan_Fun();
               return;
            }
            if(Main.P1P2)
            {
               Main.player1.payGold(_loc1_);
               Main.player2.payGold(_loc1_);
               Main.player1.killPoint.setValue(Main.player1.killPoint.getValue() - 10);
               Main.player2.killPoint.setValue(Main.player2.killPoint.getValue() - 10);
            }
            else
            {
               Main.player1.payGold(_loc1_);
               Main.player1.killPoint.setValue(Main.player1.killPoint.getValue() - 10);
            }
            --PaiHang_Data.inGameNum[Main.gameNum.getValue()];
         }
         SelMap.Close();
         Main.gameNum2.setValue(1);
         Main._this.Loading();
         Close();
         Main.Save();
      }
      
      private function Show() : *
      {
         var _loc2_:uint = 0;
         xxx_mc.visible = false;
         dianQuan2_mc.visible = false;
         var _loc1_:uint = 1;
         while(_loc1_ < 5)
         {
            _loc2_ = (numX - 1) * 4 + _loc1_;
            this["NanDu_mc_" + _loc1_].gotoAndStop(_loc2_);
            if(numMax < (numX - 1) * 4 + _loc1_)
            {
               this["NanDu_mc_" + _loc1_].visible = false;
            }
            else
            {
               this["NanDu_mc_" + _loc1_].visible = true;
               if(AchData.cjPoint_2.getValue() > chenJiuXXXArr[_loc2_])
               {
                  this["NanDu_mc_" + _loc1_].shou_mc.visible = false;
                  this["NanDu_mc_" + _loc1_]._txt.text = txtArr2[_loc2_];
                  if(!SelMap.tiaoZanType)
                  {
                     this["NanDu_mc_" + _loc1_]._txt2.text = "进入条件:消耗每日成就35点";
                  }
                  else
                  {
                     this["NanDu_mc_" + _loc1_]._txt2.text = "进入条件:无";
                  }
                  this["NanDu_mc_" + _loc1_]._btn.addEventListener(MouseEvent.CLICK,SelNanDu);
                  this["NanDu_mc_" + _loc1_]._btn.addEventListener(MouseEvent.MOUSE_MOVE,SelNanDu_MOUSE_MOVE);
                  this["NanDu_mc_" + _loc1_]._btn.addEventListener(MouseEvent.MOUSE_OUT,SelNanDu_MOUSE_OUT);
               }
               else
               {
                  this["NanDu_mc_" + _loc1_].shou_mc.visible = true;
                  this["NanDu_mc_" + _loc1_]._txt.text = txtArr1[_loc2_];
                  this["NanDu_mc_" + _loc1_]._btn.removeEventListener(MouseEvent.CLICK,SelNanDu);
                  this["NanDu_mc_" + _loc1_]._btn.removeEventListener(MouseEvent.MOUSE_MOVE,SelNanDu_MOUSE_MOVE);
                  this["NanDu_mc_" + _loc1_]._btn.removeEventListener(MouseEvent.MOUSE_OUT,SelNanDu_MOUSE_OUT);
               }
            }
            this["NanDu_mc_" + _loc1_].txt1.visible = this["NanDu_mc_" + _loc1_].txt2.visible = tiaozan_mc.visible = false;
            if(SelMap.tiaoZanType)
            {
               this["NanDu_mc_" + _loc1_].txt1.visible = this["NanDu_mc_" + _loc1_].txt2.visible = tiaozan_mc.visible = true;
            }
            _loc1_++;
         }
         x1_txt.text = AchData.cjPoint_1.getValue();
         x2_txt.text = AchData.cjPoint_2.getValue();
         x3_txt.text = numX + "/3";
         x4_txt.text = Shop4399.moneyAll.getValue();
      }
   }
}

