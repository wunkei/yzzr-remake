package src.tool
{
   import com.hotpoint.braveManIII.views.itemsPanel.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   import src.*;
   
   public class ZhuFuMC extends MovieClip
   {
      
      public function ZhuFuMC()
      {
         super();
         go_btn.addEventListener(MouseEvent.CLICK,onCLICK);
         go_mc.close_btn.addEventListener(MouseEvent.CLICK,onClose);
      }
      
      private function onCLICK(param1:*) : *
      {
         var _loc2_:int = 0;
         if(Main.gameNum.getValue() == 18)
         {
            _loc2_ = 4;
         }
         else if(Main.gameNum.getValue() == 19)
         {
            _loc2_ = 3;
         }
         else if(Main.gameNum.getValue() == 20)
         {
            _loc2_ = 1;
         }
         else if(Main.gameNum.getValue() == 21)
         {
            _loc2_ = 2;
         }
         else if(Main.gameNum.getValue() == 22)
         {
            _loc2_ = 5;
         }
         else if(Main.gameNum.getValue() == 23)
         {
            _loc2_ = 8;
         }
         else if(Main.gameNum.getValue() == 24)
         {
            _loc2_ = 4;
         }
         else if(Main.gameNum.getValue() == 25)
         {
            _loc2_ = 3;
         }
         else if(Main.gameNum.getValue() == 26)
         {
            _loc2_ = 1;
         }
         else if(Main.gameNum.getValue() == 27)
         {
            _loc2_ = 2;
         }
         JinHuaPanel.open(true,Main.gameNum.getValue() - 17,_loc2_);
      }
      
      private function onClose(param1:*) : *
      {
      }
   }
}

