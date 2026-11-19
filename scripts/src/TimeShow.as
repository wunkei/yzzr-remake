package src
{
   import com.*;
   import com.efnx.fps.*;
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
   
   public class TimeShow extends MovieClip
   {
      
      public static var _this:TimeShow;
      
      public static var skin:MovieClip;
      
      public function TimeShow()
      {
         super();
         _this = this;
         addChild(skin);
         Play_Interface.interfaceX.addChild(this);
         addEventListener(Event.ENTER_FRAME,onENTER_FRAME);
      }
      
      private function onENTER_FRAME(param1:*) : *
      {
         if(GameData.gameLV == 5 && Main.gameNum.getValue() != 0)
         {
            skin.time_txt.text = "剩余时间:" + PaiHang_Data.showTime;
            Open();
         }
         else
         {
            Close();
         }
      }
      
      public function Open() : *
      {
         _this.visible = true;
         _this.x = _this.y = 0;
      }
      
      public function Close() : *
      {
         _this.visible = false;
         _this.x = _this.y = -5000;
      }
   }
}

