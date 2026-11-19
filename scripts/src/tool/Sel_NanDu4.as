package src.tool
{
   import com.greensock.*;
   import com.greensock.easing.*;
   import com.hotpoint.braveManIII.views.achPanel.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   import src.*;
   
   public class Sel_NanDu4 extends MovieClip
   {
      
      public var Close_btn:SimpleButton;
      
      public var lianYu1:SimpleButton;
      
      public var lianYu2:SimpleButton;
      
      public function Sel_NanDu4()
      {
         super();
         Close_btn.addEventListener(MouseEvent.CLICK,Close);
         lianYu1.addEventListener(MouseEvent.CLICK,NanDu1);
         lianYu2.addEventListener(MouseEvent.CLICK,NanDu2);
      }
      
      public function Open() : *
      {
         this.x = this.y = 0;
         this.visible = true;
      }
      
      public function Close(param1:* = null) : *
      {
         this.x = this.y = 5000;
         this.visible = false;
      }
      
      private function NanDu1(param1:*) : *
      {
         if(Main.player1.getBag().getOtherobjNum(63155) > 0)
         {
            Main.player1.getBag().delOtherById(63155,1);
            Main.gameNum.setValue(17);
            Main.gameNum2.setValue(1);
            GameData.gameLV = 4;
            Main._this.Loading();
            Close();
            Main.Save();
         }
         else if(Boolean(Main.P1P2) && Main.player2.getBag().getOtherobjNum(63155) > 0)
         {
            Main.player2.getBag().delOtherById(63155,1);
            Main.gameNum.setValue(17);
            Main.gameNum2.setValue(1);
            GameData.gameLV = 4;
            Main._this.Loading();
            Close();
            Main.Save();
         }
         else
         {
            NewMC.Open("文字提示",this,480,290,30,0,true,2,"缺少炼狱入场券");
         }
      }
      
      private function NanDu2(param1:*) : *
      {
         if(Main.player1.getBag().getOtherobjNum(63326) > 0)
         {
            Main.player1.getBag().delOtherById(63326,1);
            Main.gameNum.setValue(1000);
            Main.gameNum2.setValue(1);
            GameData.gameLV = 4;
            Main._this.Loading();
            Close();
            Main.Save();
         }
         else if(Boolean(Main.P1P2) && Main.player2.getBag().getOtherobjNum(63326) > 0)
         {
            Main.player2.getBag().delOtherById(63326,1);
            Main.gameNum.setValue(1000);
            Main.gameNum2.setValue(1);
            GameData.gameLV = 4;
            Main._this.Loading();
            Close();
            Main.Save();
         }
         else
         {
            NewMC.Open("文字提示",this,480,290,30,0,true,2,"缺少极限炼狱入场券");
         }
      }
      
      private function NanDu3(param1:*) : *
      {
      }
   }
}

