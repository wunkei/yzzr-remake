package src
{
   import com.hotpoint.braveManIII.repository.pet.*;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.text.*;
   import flash.utils.*;
   import src.tool.*;
   
   public class NewLoad2 extends MovieClip
   {
      
      private static var loadNameArr:Array = ["Music2.swf"];
      
      public static var loadNumArr:Array = [];
      
      public static var loadDataArr:Array = new Array();
      
      public function NewLoad2()
      {
         super();
      }
      
      public static function Loading() : *
      {
         Init_loadNumArr();
         if(loadNameArr.length > 0 && loadNumArr[0] == 0)
         {
            Loading_go();
         }
      }
      
      public static function Init_loadNumArr() : *
      {
         var _loc1_:int = 0;
         while(_loc1_ < loadNameArr.length)
         {
            if(loadNumArr[_loc1_] == null)
            {
               loadNumArr[_loc1_] = 0;
            }
            _loc1_++;
         }
      }
      
      public static function Loading_go() : *
      {
         loadNumArr[0] = 1;
         loadDataArr[0] = new ClassLoader(loadNameArr[0]);
         loadDataArr[0].addEventListener(Event.COMPLETE,Loading_OK);
      }
      
      private static function Loading_OK(param1:* = null) : *
      {
         if(loadNameArr[0] == "Music2.swf")
         {
            MusicBox.loadOK = true;
            MusicBox.MusicPlay();
         }
         loadNumArr[0] = 2;
         loadNameArr.shift();
         loadNumArr.shift();
         Loading();
      }
   }
}

