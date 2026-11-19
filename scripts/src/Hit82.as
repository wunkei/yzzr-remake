package src
{
   import flash.display.*;
   import flash.events.*;
   import src.other.*;
   import src.tool.*;
   
   public class Hit82 extends MovieClip
   {
      
      private static var fff:Fly;
      
      public static var AllHit82:Array = [];
      
      public var objArr:Array = [];
      
      public function Hit82()
      {
         super();
         _stage = Main._this;
         addEventListener(Event.ADDED_TO_STAGE,onADDED_TO_STAGE);
         addEventListener(Event.REMOVED_FROM_STAGE,onREMOVED_FROM_STAGE);
      }
      
      public static function HitFly() : *
      {
         var _loc2_:Hit82 = null;
         var _loc3_:int = 0;
         var _loc1_:int = 0;
         while(_loc1_ < AllHit82.length)
         {
            _loc2_ = AllHit82[_loc1_];
            if(_loc2_.parent is BossSX82)
            {
               _loc3_ = 0;
               while(_loc3_ < Fly.All.length)
               {
                  if(Boolean(fff != Fly.All[_loc3_] && Fly.All[_loc3_]._name == "黑幕球" && (_loc2_.parent as BossSX82).hp > 0 && Fly.All[_loc3_].life != 0) && Boolean(Fly.All[_loc3_].aaaaa) && _loc2_.hitTestObject(Fly.All[_loc3_].aaaaa))
                  {
                     fff = Fly.All[_loc3_];
                     (Fly.All[_loc3_] as Fly).life = 0;
                     (_loc2_.parent as BossSX82).hpxx();
                  }
                  _loc3_++;
               }
            }
            _loc1_++;
         }
      }
      
      private function onADDED_TO_STAGE(param1:*) : *
      {
         var _loc2_:int = 0;
         if(AllHit82)
         {
            _loc2_ = 0;
            while(_loc2_ < AllHit82.length)
            {
               if(AllHit82[_loc2_] == this)
               {
                  return;
               }
               _loc2_++;
            }
         }
         AllHit82[AllHit82.length] = this;
      }
      
      private function onREMOVED_FROM_STAGE(param1:*) : *
      {
         var _loc2_:int = 0;
         if(AllHit82)
         {
            _loc2_ = 0;
            while(_loc2_ < AllHit82.length)
            {
               if(AllHit82[_loc2_] == this)
               {
                  AllHit82.splice(_loc2_,1);
               }
               _loc2_++;
            }
         }
         this.objArr = new Array();
      }
   }
}

