package src.tool
{
   import flash.display.*;
   import flash.events.*;
   import flash.net.*;
   import flash.text.*;
   import src.*;
   
   public class JiFenLingQue3
   {
      
      public static var urlLoader:URLLoader;
      
      public static var saveTime:String = "2014/7/13";
      
      public static var gameTime:int = 0;
      
      public function JiFenLingQue3()
      {
         super();
      }
      
      public static function Post(param1:Boolean = false) : *
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:String = null;
         var _loc10_:URLRequest = null;
         if(Boolean(TimeXX()) || param1)
         {
            _loc2_ = A_fun();
            _loc3_ = B_fun();
            _loc4_ = C_fun();
            _loc5_ = D_fun();
            _loc6_ = E_fun();
            _loc7_ = F_fun();
            _loc8_ = G_fun();
            _loc9_ = "http://stat.api.4399.com/archive_statistics/log.js?" + "game_id=100016523" + "&uid=" + Main.userId + "&index=" + Main.saveNum + "&a=" + _loc2_ + "&b=" + _loc3_ + "&c=" + _loc4_ + "&d=" + _loc5_ + "&e=" + _loc6_ + "&f=" + _loc7_ + "&g=" + _loc8_;
            if(!param1)
            {
               gameTime = 0;
            }
            TiaoShi.txtShow("Post str = " + _loc9_);
            _loc10_ = new URLRequest(_loc9_);
            _loc10_.method = URLRequestMethod.POST;
            urlLoader = new URLLoader();
            urlLoader.load(_loc10_);
         }
      }
      
      private static function TimeXX() : Boolean
      {
         var _loc1_:Date = new Date();
         var _loc2_:String = _loc1_.getFullYear() + "/" + (_loc1_.getMonth() + 1) + "/" + _loc1_.getDate();
         var _loc3_:Date = new Date(_loc2_);
         var _loc4_:Date = new Date(saveTime);
         TiaoShi.txtShow("当前时间:" + _loc3_ + ",\n 保存时间:" + _loc4_);
         saveTime = _loc2_;
         if(_loc3_ > _loc4_)
         {
            TiaoShi.txtShow("TimeXX ==> true");
            return true;
         }
         TiaoShi.txtShow("TimeXX ==> false");
         return false;
      }
      
      public static function A_fun() : int
      {
         var _loc2_:int = 0;
         var _loc1_:int = int(Main.player1.level.getValue());
         if(_loc1_ <= 40)
         {
            return _loc1_ / 10 + 1;
         }
         return int((_loc1_ - 40) / 5 + 5);
      }
      
      public static function B_fun() : int
      {
         var _loc1_:int = 0;
         var _loc2_:int = 1;
         while(_loc2_ <= 18)
         {
            if(Main.guanKa[_loc2_ + 1] > 0 && Main.guanKa[_loc2_] > 0)
            {
               _loc1_ = _loc2_;
            }
            _loc2_++;
         }
         _loc2_ = 51;
         while(_loc2_ <= 60)
         {
            if(Main.guanKa[_loc2_ + 1] > 0 && Main.guanKa[_loc2_] > 0)
            {
               _loc1_ = _loc2_;
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      public static function C_fun() : int
      {
         var _loc1_:int = 0;
         var _loc2_:int = 101;
         while(_loc2_ <= 105)
         {
            if(Main.guanKa[_loc2_ + 1] > 0 && Main.guanKa[_loc2_] > 0)
            {
               _loc1_ = _loc2_;
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      public static function D_fun() : int
      {
         var _loc1_:int = 0;
         var _loc2_:int = 1;
         while(_loc2_ <= 18)
         {
            if(Main.guanKa[_loc2_] >= 3)
            {
               _loc1_ = _loc2_;
            }
            _loc2_++;
         }
         _loc2_ = 51;
         while(_loc2_ <= 60)
         {
            if(Main.guanKa[_loc2_] >= 3)
            {
               _loc1_ = _loc2_;
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      public static function E_fun() : int
      {
         return Main.player1.skinArr[Main.player1.skinNum];
      }
      
      public static function F_fun() : int
      {
         if(Main.P1P2)
         {
            return 2;
         }
         return 1;
      }
      
      public static function G_fun() : int
      {
         var _loc1_:int = gameTime / (27 * 60 * 10) + 1;
         TiaoShi.txtShow("G_fun = " + _loc1_);
         if(_loc1_ >= 18)
         {
            _loc1_ = 18;
         }
         return _loc1_;
      }
      
      public static function ioErrorEvent(param1:*) : *
      {
      }
      
      public static function onCOMPLETE(param1:*) : *
      {
      }
      
      public static function onSECURITY_ERROR(param1:*) : *
      {
      }
   }
}

