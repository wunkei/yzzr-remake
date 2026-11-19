package src.tool
{
   import com.adobe.serialization.json.*;
   import flash.display.*;
   import flash.events.*;
   import flash.net.*;
   import flash.text.*;
   import src.*;
   
   public class JiFenLingQue2 extends MovieClip
   {
      
      private static var _this:JiFenLingQue2;
      
      private static var logYN:Boolean = false;
      
      private static var urlLoader:URLLoader = new URLLoader();
      
      private static var phpUrl:URLRequest = new URLRequest("http://my.4399.com/events/2014/fiveyear/login-counter");
      
      private static var dayNum:int = 0;
      
      public function JiFenLingQue2()
      {
         super();
         _this = this;
         this.visible = false;
      }
      
      public static function DengLuUp() : *
      {
         TiaoShi.txtShow("连续登录调用");
         if(Boolean(logYN) || TeShuHuoDong.TeShuHuoDongArr[30] >= 1)
         {
            return;
         }
         phpUrl.method = URLRequestMethod.POST;
         var _loc1_:URLVariables = new URLVariables();
         _loc1_.app_id = 38;
         _loc1_.game_id = 10;
         TiaoShi.txtShow("Main.serverTimeStr = " + Main.serverTimeStr);
         _loc1_.time = String(Date.parse(Main.serverTimeStr)).substr(0,10);
         TiaoShi.txtShow("uv.time = " + _loc1_.time);
         _loc1_.uid = Main.userId;
         _loc1_.uri = "/events/2014/fiveyear/login-counter";
         var _loc2_:String = _loc1_.app_id + "||" + _loc1_.game_id + "||" + _loc1_.time + "||" + _loc1_.uid + "||" + _loc1_.uri + "||" + "919e2199989011d08e1c37f03017a27b";
         var _loc3_:String = MD5contrast.GetScoreMD5(_loc2_);
         _loc1_.token = _loc3_;
         phpUrl.data = _loc1_;
         urlLoader.load(phpUrl);
         urlLoader.addEventListener(Event.COMPLETE,completeHandler_All);
         logYN = true;
      }
      
      private static function completeHandler_All(param1:Event) : void
      {
         var _loc2_:String = (param1.currentTarget as URLLoader).data;
         TiaoShi.txtShow("连续登录时间 返回: " + _loc2_);
         var _loc3_:Object = JSONs.decode(_loc2_,true);
         if(_loc3_.code == 100)
         {
            _loc2_ = "连续登录: " + _loc3_.result + "天";
         }
         else if(_loc3_.code == 1)
         {
            _loc2_ = "未知错误";
         }
         else if(_loc3_.code == 2)
         {
            _loc2_ = "参数错误";
         }
         else if(_loc3_.code == 3)
         {
            _loc2_ = "没有权限";
         }
         else if(_loc3_.code == 61)
         {
            _loc2_ = "Token过期";
         }
         else if(_loc3_.code == 62)
         {
            _loc2_ = "Token错误";
         }
         else if(_loc3_.code == 63)
         {
            _loc2_ = "需要APP_ID";
         }
         else if(_loc3_.code == 64)
         {
            _loc2_ = "无法识别APP_ID";
         }
         else if(_loc3_.code == 65)
         {
            _loc2_ = "请求方式错误";
         }
         else
         {
            _loc2_ = "未知错误2";
         }
         TiaoShi.txtShow("连续登录时间 = " + _loc2_);
         _this.Show(_loc3_.result);
      }
      
      public function Show(param1:int = 0) : *
      {
         this.visible = true;
         dayNum = param1;
         var _loc2_:int = 1;
         while(_loc2_ < 4)
         {
            this["day" + _loc2_].gotoAndStop(1);
            if(_loc2_ <= param1)
            {
               this["day" + _loc2_].gotoAndStop(2);
            }
            _loc2_++;
         }
         lingQu_btn.addEventListener(MouseEvent.CLICK,LingQu_fun);
         close_btn.addEventListener(MouseEvent.CLICK,Close_fun);
      }
      
      private function LingQu_fun(param1:*) : *
      {
         var _loc2_:URLRequest = null;
         if(dayNum >= 3)
         {
            _loc2_ = new URLRequest("http://my.4399.com/events/2014/fiveyear/login");
            navigateToURL(_loc2_,"_blank");
         }
         else
         {
            NewMC.Open("文字提示",this,400,400,30,0,true,2,"需连续登录三天方可领取");
         }
      }
      
      private function Close_fun(param1:*) : *
      {
         this.x = this.y = -5000;
         this.visible = false;
      }
   }
}

