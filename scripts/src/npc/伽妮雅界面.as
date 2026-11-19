package src.npc
{
   import com.hotpoint.braveManIII.views.equipShopPanel.*;
   import com.hotpoint.braveManIII.views.itemsPanel.*;
   import com.hotpoint.braveManIII.views.skillPanel.*;
   import com.hotpoint.braveManIII.views.strPanel.*;
   import com.hotpoint.braveManIII.views.taskPanel.*;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.text.*;
   import src.*;
   
   public class 伽妮雅界面 extends MovieClip
   {
      
      private static var only:伽妮雅界面;
      
      public var close2:SimpleButton;
      
      public var QH_btn:SimpleButton;
      
      public var xili_p1:SimpleButton;
      
      public var xili_p2:SimpleButton;
      
      public var buy_btn:SimpleButton;
      
      public function 伽妮雅界面()
      {
         super();
         close2.addEventListener(MouseEvent.CLICK,CloseXX);
         QH_btn.addEventListener(MouseEvent.CLICK,P4QQ);
         xili_p1.addEventListener(MouseEvent.CLICK,P1XL);
         xili_p2.addEventListener(MouseEvent.CLICK,P2XL);
         if(!Main.P1P2)
         {
            xili_p2.visible = false;
         }
         buy_btn.addEventListener(MouseEvent.CLICK,BUY);
      }
      
      public static function Open(param1:int = 0, param2:int = 0) : *
      {
         var _loc3_:Class = null;
         var _loc4_:MovieClip = null;
         MusicBox.MusicPlay2("m11");
         if(!only)
         {
            _loc3_ = All_Npc.loadData.getClass("src.npc.伽妮雅界面") as Class;
            _loc4_ = new _loc3_();
            only = _loc4_;
         }
         Main._stage.addChild(only);
         only.x = param1;
         only.y = param2;
         only.visible = true;
      }
      
      public static function Close() : *
      {
         if(only)
         {
            only.x = 5000;
            only.y = 5000;
            only.visible = false;
         }
      }
      
      private function CloseXX(param1:* = null) : *
      {
         Close();
      }
      
      private function P4QQ(param1:*) : *
      {
         StrPanel.open();
         CloseXX();
      }
      
      private function P1XL(param1:*) : *
      {
         xilianPanel.open(true);
      }
      
      private function P2XL(param1:*) : *
      {
         xilianPanel.open(false);
      }
      
      private function BUY(param1:*) : *
      {
         EquipShopPanel.open();
         伽妮雅界面.Close();
      }
   }
}

