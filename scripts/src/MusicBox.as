package src
{
   import flash.display.*;
   import flash.events.*;
   import flash.media.*;
   import flash.text.*;
   import flash.utils.*;
   
   public class MusicBox extends MovieClip
   {
      
      public static var MusicData:ClassLoader;
      
      public static var musicString:String;
      
      public static var s1:Sound;
      
      public static var sc1:* = new SoundChannel();
      
      public static var loadOK:Boolean = false;
      
      public static var mArr0:Array = [["攻击1","战士挥刀声音"],["攻击2","战士挥刀声音"],["攻击3","战士挥刀声音"],["攻击4","战士挥刀声音"],["转职技能4","战士转职技能4声音"]];
      
      public static var mArr1:Array = [["攻击1","法师挥杖声音"],["攻击2","法师挥杖声音"],["攻击3","法师挥杖声音"],["攻击4","法师挥杖声音"]];
      
      public static var mArr2:Array = [["攻击1","法师挥杖声音"]];
      
      public static var mArrX0:Array = [["攻击1","战士击中声音"],["攻击2","战士击中声音"],["攻击3","战士击中声音"],["攻击4","战士击中声音"]];
      
      public static var mArrX1:Array = [["攻击1","法师击中声音"],["攻击2","法师击中声音"],["攻击3","法师击中声音"],["攻击4","法师击中声音"]];
      
      public static var mArrX2:Array = [["攻击1","拳手普通攻击123声音"],["攻击2","拳手普通攻击123声音"],["攻击3","拳手普通攻击123声音"],["攻击4","拳手普通攻击4声音"],["技能2","拳手技能2声音"]];
      
      public function MusicBox()
      {
         super();
      }
      
      public static function MusicPlay2(param1:String) : *
      {
         var _loc3_:* = undefined;
         var _loc2_:* = new SoundChannel();
         var _loc4_:Class = MusicData.getClass(param1) as Class;
         _loc3_ = new _loc4_();
         _loc2_ = _loc3_.play(0,1);
      }
      
      public static function MusicPlay(param1:String = "", param2:int = 99999) : *
      {
         var _loc3_:String = null;
         var _loc4_:Class = null;
         if(param1 != "")
         {
            _loc3_ = param1;
         }
         else if(Main.gameNum.getValue() == 0 && Main.gameNum2.getValue() == 0)
         {
            _loc3_ = "村庄音乐";
         }
         else if(Main.gameNum.getValue() == 0 && Main.gameNum2.getValue() == 1)
         {
            _loc3_ = "女神音乐";
         }
         else if(Main.gameNum.getValue() == 0 && Main.gameNum2.getValue() == 4)
         {
            _loc3_ = "海皇城";
         }
         else if(Main.gameNum.getValue() == 0 && Main.gameNum2.getValue() == 3)
         {
            _loc3_ = "村庄音乐2";
         }
         else if(Main.gameNum.getValue() > 0 && Main.gameNum.getValue() < 50)
         {
            _loc3_ = "战斗音乐";
         }
         else if(Main.gameNum.getValue() > 50 && Main.gameNum.getValue() < 100)
         {
            _loc3_ = "艾尔之海";
         }
         else if(Main.gameNum.getValue() == 2015)
         {
            _loc3_ = "战斗音乐";
         }
         else
         {
            _loc3_ = "村庄音乐2";
         }
         if(!loadOK)
         {
            try
            {
               if(s1)
               {
                  sc1.stop();
                  return;
               }
            }
            catch(e:*)
            {
            }
         }
         if(musicString != _loc3_)
         {
            try
            {
               if(s1)
               {
                  sc1.stop();
               }
            }
            catch(e:*)
            {
            }
            musicString = _loc3_;
            if(_loc3_ == "封面声音")
            {
               _loc4_ = getDefinitionByName(musicString) as Class;
            }
            else
            {
               _loc4_ = NewLoad2.loadDataArr[0].getClass(musicString) as Class;
            }
            s1 = new _loc4_();
            sc1 = s1.play(0,param2);
         }
      }
      
      public static function ActMusicPlay(param1:int, param2:String) : *
      {
         var _loc4_:int = 0;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:Class = null;
         if(param2 == "站" || param2 == "走" || param2 == "跳" || param2 == "跑")
         {
            return;
         }
         var _loc3_:String = "";
         for(_loc4_ in MusicBox["mArr" + param1])
         {
            if(MusicBox["mArr" + param1][_loc4_][0] == param2)
            {
               _loc3_ = MusicBox["mArr" + param1][_loc4_][1];
            }
         }
         if(_loc3_ != "")
         {
            _loc5_ = new SoundChannel();
            _loc7_ = MusicData.getClass(_loc3_) as Class;
            _loc6_ = new _loc7_();
            _loc5_ = _loc6_.play(0,1);
         }
         else
         {
            _loc5_ = new SoundChannel();
            _loc3_ = MusicBox["mArr" + param1][0][1];
            _loc7_ = MusicData.getClass(_loc3_) as Class;
            _loc6_ = new _loc7_();
            _loc5_ = _loc6_.play(0,1);
         }
      }
      
      public static function ActMusicPlayX(param1:int, param2:String) : *
      {
         var _loc4_:int = 0;
         var _loc5_:* = undefined;
         var _loc6_:Class = null;
         var _loc3_:String = "";
         for(_loc4_ in MusicBox["mArrX" + param1])
         {
            if(MusicBox["mArrX" + param1][_loc4_][0] == param2)
            {
               _loc3_ = MusicBox["mArrX" + param1][_loc4_][1];
            }
         }
         _loc5_ = new SoundChannel();
         if(_loc3_ != "")
         {
            _loc6_ = MusicData.getClass(_loc3_) as Class;
         }
         else
         {
            _loc3_ = MusicBox["mArrX" + param1][0][1];
            _loc6_ = MusicData.getClass(_loc3_) as Class;
         }
         var _loc7_:Sound = new _loc6_();
         var _loc8_:SoundTransform = new SoundTransform(0.5);
         _loc5_ = _loc7_.play(0,1,_loc8_);
      }
   }
}

