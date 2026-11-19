package src.tool
{
   import com.greensock.*;
   import com.greensock.easing.*;
   import com.hotpoint.braveManIII.views.achPanel.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   import src.*;
   
   public class Sel_NanDu3 extends MovieClip
   {
      
      public var Close_btn:SimpleButton;
      
      public var NanDu1_btn:SimpleButton;
      
      public var NanDu2_btn:SimpleButton;
      
      public var NanDu3_btn:SimpleButton;
      
      public var NanDu4_btn:SimpleButton;
      
      public var XXX_1:SimpleButton;
      
      public var XXX_2:SimpleButton;
      
      public var XXX_3:SimpleButton;
      
      public var XXX_4:SimpleButton;
      
      public var killPoint_btn:SimpleButton;
      
      public var killPoint_1:*;
      
      public var killPoint_2:*;
      
      public function Sel_NanDu3()
      {
         super();
         Close_btn.addEventListener(MouseEvent.CLICK,Close);
         killPoint_btn.addEventListener(MouseEvent.CLICK,BuyKill);
         NanDu1_btn.addEventListener(MouseEvent.CLICK,NanDu1);
         NanDu2_btn.addEventListener(MouseEvent.CLICK,NanDu2);
         NanDu3_btn.addEventListener(MouseEvent.CLICK,NanDu3);
         NanDu4_btn.addEventListener(MouseEvent.CLICK,NanDu4);
      }
      
      public function Open() : *
      {
         this.x = this.y = 0;
         this.visible = true;
         Show();
      }
      
      public function Close(param1:* = null) : *
      {
         this.x = this.y = 5000;
         this.visible = false;
      }
      
      private function NanDu1(param1:*) : *
      {
         if(Main.guanKa[53] <= 0)
         {
            return;
         }
         if(Main.P1P2 == false && Main.player1.killPoint.getValue() >= InitData.BuyNum_20.getValue())
         {
            Main.player1.killPoint.setValue(Main.player1.killPoint.getValue() - InitData.BuyNum_20.getValue());
            Main.gameNum.setValue(81);
            Main.gameNum2.setValue(1);
            GameData.gameLV = 4;
            GameGo();
         }
         else if(Main.P1P2 == true && Main.player1.killPoint.getValue() >= InitData.BuyNum_20.getValue() && Main.player2.killPoint.getValue() >= InitData.BuyNum_20.getValue())
         {
            Main.player1.killPoint.setValue(Main.player1.killPoint.getValue() - InitData.BuyNum_20.getValue());
            Main.player2.killPoint.setValue(Main.player2.killPoint.getValue() - InitData.BuyNum_20.getValue());
            Main.gameNum.setValue(81);
            Main.gameNum2.setValue(1);
            GameData.gameLV = 4;
            GameGo();
         }
         else
         {
            NewMC.Open("文字提示",Main._this,480,290,30,0,true,2,"击杀点不足");
         }
      }
      
      private function NanDu2(param1:*) : *
      {
         if(Main.guanKa[56] <= 0)
         {
            return;
         }
         if(Main.P1P2 == false && Main.player1.killPoint.getValue() >= InitData.BuyNum_30.getValue())
         {
            Main.player1.killPoint.setValue(Main.player1.killPoint.getValue() - InitData.BuyNum_30.getValue());
            Main.gameNum.setValue(82);
            Main.gameNum2.setValue(1);
            GameData.gameLV = 4;
            GameGo();
         }
         else if(Main.P1P2 == true && Main.player1.killPoint.getValue() >= InitData.BuyNum_30.getValue() && Main.player2.killPoint.getValue() >= InitData.BuyNum_30.getValue())
         {
            Main.player1.killPoint.setValue(Main.player1.killPoint.getValue() - InitData.BuyNum_30.getValue());
            Main.player2.killPoint.setValue(Main.player2.killPoint.getValue() - InitData.BuyNum_30.getValue());
            Main.gameNum.setValue(82);
            Main.gameNum2.setValue(1);
            GameData.gameLV = 4;
            GameGo();
         }
         else
         {
            NewMC.Open("文字提示",Main._this,480,290,30,0,true,2,"击杀点不足");
         }
      }
      
      private function NanDu3(param1:*) : *
      {
         if(Main.guanKa[59] <= 0)
         {
            return;
         }
         if(Main.P1P2 == false && Main.player1.killPoint.getValue() >= InitData.BuyNum_40.getValue())
         {
            Main.player1.killPoint.setValue(Main.player1.killPoint.getValue() - InitData.BuyNum_40.getValue());
            Main.gameNum.setValue(83);
            Main.gameNum2.setValue(1);
            GameData.gameLV = 4;
            GameGo();
         }
         else if(Main.P1P2 == true && Main.player1.killPoint.getValue() >= InitData.BuyNum_40.getValue() && Main.player2.killPoint.getValue() >= InitData.BuyNum_40.getValue())
         {
            Main.player1.killPoint.setValue(Main.player1.killPoint.getValue() - InitData.BuyNum_40.getValue());
            Main.player2.killPoint.setValue(Main.player2.killPoint.getValue() - InitData.BuyNum_40.getValue());
            Main.gameNum.setValue(83);
            Main.gameNum2.setValue(1);
            GameData.gameLV = 4;
            GameGo();
         }
         else
         {
            NewMC.Open("文字提示",Main._this,480,290,30,0,true,2,"击杀点不足");
         }
      }
      
      private function NanDu4(param1:*) : *
      {
         if(Main.guanKa[84] <= 0)
         {
            return;
         }
         if(Main.P1P2 == false && Main.player1.killPoint.getValue() >= InitData.BuyNum_50.getValue())
         {
            Main.player1.killPoint.setValue(Main.player1.killPoint.getValue() - InitData.BuyNum_50.getValue());
            Main.gameNum.setValue(84);
            Main.gameNum2.setValue(1);
            GameData.gameLV = 4;
            GameGo();
         }
         else if(Main.P1P2 == true && Main.player1.killPoint.getValue() >= InitData.BuyNum_50.getValue() && Main.player2.killPoint.getValue() >= InitData.BuyNum_50.getValue())
         {
            Main.player1.killPoint.setValue(Main.player1.killPoint.getValue() - InitData.BuyNum_50.getValue());
            Main.player2.killPoint.setValue(Main.player2.killPoint.getValue() - InitData.BuyNum_50.getValue());
            Main.gameNum.setValue(84);
            Main.gameNum2.setValue(1);
            GameData.gameLV = 4;
            GameGo();
         }
         else
         {
            NewMC.Open("文字提示",Main._this,480,290,30,0,true,2,"击杀点不足");
         }
      }
      
      private function GameGo() : *
      {
         SelMap.Close();
         Main.gameNum2.setValue(1);
         Main._this.Loading();
         Close();
      }
      
      private function Show() : *
      {
         var _loc2_:uint = 0;
         var _loc1_:int = 1;
         while(_loc1_ < 5)
         {
            if(this["XXX_" + _loc1_])
            {
               _loc2_ = 50 + _loc1_ * 3;
               if(Main.guanKa[_loc2_] > 0)
               {
                  this["XXX_" + _loc1_].visible = false;
               }
               else
               {
                  this["XXX_" + _loc1_].visible = true;
               }
            }
            _loc1_++;
         }
         killPoint_1.text = Main.player1.killPoint.getValue();
         if(Main.P1P2)
         {
            killPoint_2.text = Main.player2.killPoint.getValue();
         }
      }
      
      private function BuyKill(param1:*) : *
      {
         Shop4399.Open(4);
      }
   }
}

