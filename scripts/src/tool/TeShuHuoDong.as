package src.tool
{
   import flash.display.*;
   import flash.events.*;
   import src.*;
   
   public class TeShuHuoDong
   {
      
      public static var TeShuHuoDongArr:Array = [];
      
      public static var liBaoNumMax:int = 52;
      
      public function TeShuHuoDong()
      {
         super();
      }
      
      public static function Init() : *
      {
         var _loc1_:int = 0;
         while(_loc1_ <= liBaoNumMax)
         {
            if(!TeShuHuoDongArr[_loc1_])
            {
               TeShuHuoDongArr[_loc1_] = 0;
            }
            _loc1_++;
         }
      }
      
      public static function GetLiBaoNum(param1:int) : *
      {
         if(!TeShuHuoDongArr[param1])
         {
            TeShuHuoDongArr[param1] = 1;
         }
         else
         {
            ++TeShuHuoDongArr[param1];
         }
      }
      
      public static function AddLiBaoNum(param1:int) : *
      {
         if(!TeShuHuoDongArr[param1])
         {
            TeShuHuoDongArr[param1] = 1;
         }
         else
         {
            ++TeShuHuoDongArr[param1];
         }
      }
   }
}

