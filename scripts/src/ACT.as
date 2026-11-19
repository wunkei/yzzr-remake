package src
{
   import flash.display.*;
   import flash.events.*;
   import flash.media.*;
   import flash.text.*;
   import flash.utils.*;
   
   public class ACT extends MovieClip
   {
      
      public function ACT()
      {
         super();
      }
      
      public static function Play(param1:Object, param2:Object, param3:String = "") : *
      {
         var _loc6_:Class = null;
         var _loc7_:* = undefined;
         var _loc4_:int = int(param1.data.skinArr[param1.data.skinNum]);
         var _loc5_:String = "ACT_" + _loc4_;
         if(param3 != "")
         {
            _loc6_ = NewLoad.XiaoGuoData.getClass(param3) as Class;
            _loc7_ = new _loc6_();
         }
         else
         {
            _loc6_ = NewLoad.XiaoGuoData.getClass(_loc5_) as Class;
            _loc7_ = new _loc6_();
         }
         _loc7_.x = param2.x;
         if(param2 is Enemy && param2.id == 31)
         {
            _loc7_.y = 160;
         }
         else
         {
            _loc7_.y = param2.y - 50;
         }
         Main.world.moveChild_Other.addChild(_loc7_);
      }
      
      public static function Play2(param1:int, param2:Enemy) : *
      {
         var _loc3_:String = "ACT_" + param1;
         var _loc4_:* = NewLoad.XiaoGuoData.getClass(_loc3_) as Class;
         var _loc5_:ACT = new _loc4_();
         _loc5_.x = param2.x;
         if(param2.id == 31)
         {
            _loc5_.y = 160;
         }
         else
         {
            _loc5_.y = param2.y - 50;
         }
         Main.world.moveChild_Other.addChild(_loc5_);
      }
   }
}

