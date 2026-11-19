package src
{
   import com.*;
   import com.adobe.serialization.json.*;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.net.*;
   import flash.text.*;
   import flash.utils.*;
   import src.tool.*;
   
   public class GengXin extends MovieClip
   {
      
      public static var _this:GengXin;
      
      public static var yn:Boolean;
      
      public static var saveVar:int = 0;
      
      public static var saveTime:String = "2014/7/10";
      
      public static var saveTimeNow:String = "2014/7/10";
      
      public static var timeX:int = 0;
      
      public static var timeMax:int = 27 * 60 * 30;
      
      public static var selNum:int = 0;
      
      public static var selVar:int = 0;
      
      public static var g1:GengXin1 = new GengXin1();
      
      public static var g2:GengXin2 = new GengXin2();
      
      public function GengXin()
      {
         super();
         addEventListener(Event.ENTER_FRAME,onTime);
      }
      
      public static function CaXun() : *
      {
         if(!_this)
         {
            _this = new GengXin();
         }
         _this.addEventListener(Event.ENTER_FRAME,onTime);
      }
      
      public static function onTime(param1:*) : *
      {
         var _loc2_:Array = null;
         ++timeX;
         if(timeX >= timeMax && Boolean(TimeXX()) && selNum < 7)
         {
            timeX = 0;
            _loc2_ = [57];
            Api_4399_GongHui.getNum(_loc2_);
            ++selNum;
            TiaoShi.txtShow("GengXin 查询次数:" + selNum);
         }
      }
      
      public static function Go(param1:int = 0, param2:int = 0) : *
      {
         TiaoShi.txtShow("GengXin.Go() ===> " + param1);
         if(param1 % 4 == 0)
         {
            TiaoShi.txtShow("Go 默认状态 timeMax = " + timeMax);
         }
         else if(param1 % 4 == 1)
         {
            TiaoShi.txtShow("Go 更新提醒");
            if(!Main.tiaoShiYN && Main.gameNum.getValue() == 0 && saveVar < param2)
            {
               g1.x = g1.y = 0;
               Main._stage.addChild(g1);
               GengXin.saveTime = GengXin.saveTimeNow;
               saveVar = param2;
               Main.Save();
            }
            _this.addEventListener(Event.ENTER_FRAME,onTime);
         }
         else if(param1 % 4 == 2)
         {
            TiaoShi.txtShow("Go 刷新游戏");
            if(!Main.tiaoShiYN && Main.gameNum.getValue() == 0 && saveVar < param2)
            {
               g2.x = g2.y = 0;
               Main._stage.addChild(g2);
               GengXin.saveTime = GengXin.saveTimeNow;
               saveVar = param2;
               Main.Save();
            }
            _this.addEventListener(Event.ENTER_FRAME,onTime);
         }
         else if(param1 % 4 == 3)
         {
            TiaoShi.txtShow("Go 停止侦听");
            _this.removeEventListener(Event.ENTER_FRAME,onTime);
         }
      }
      
      private static function TimeXX() : Boolean
      {
         var _loc1_:Date = new Date();
         var _loc2_:String = _loc1_.getFullYear() + "/" + (_loc1_.getMonth() + 1) + "/" + _loc1_.getDate();
         var _loc3_:Date = new Date(_loc2_);
         var _loc4_:Date = new Date(saveTime);
         saveTimeNow = _loc3_;
         if(_loc3_ > _loc4_)
         {
            return true;
         }
         return false;
      }
      
      public static function reGame() : *
      {
         if(Main.gameNum.getValue() == 0)
         {
            navigateToURL(new URLRequest("javascript:window.location.reload( false );"),"_self");
         }
         _this.addEventListener(Event.ENTER_FRAME,reGameGO);
      }
      
      public static function reGameGO(param1:*) : *
      {
         if(Main.gameNum.getValue() == 0)
         {
            navigateToURL(new URLRequest("javascript:window.location.reload( false );"),"_self");
         }
      }
   }
}

