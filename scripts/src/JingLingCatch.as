package src
{
   import com.hotpoint.braveManIII.models.elves.Elves;
   import com.hotpoint.braveManIII.models.player.PlayerData;
   import com.hotpoint.braveManIII.repository.elves.*;
   import com.hotpoint.braveManIII.repository.jingLingCatch.*;
   import com.hotpoint.braveManIII.views.itemsPanel.*;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.text.*;
   
   public class JingLingCatch extends MovieClip
   {
      
      public static var skin:MovieClip;
      
      public static var chuxianMC:MovieClip;
      
      public static var zhuaMC:MovieClip;
      
      public static var chenggongMC:MovieClip;
      
      public static var shibaiMC:MovieClip;
      
      public static var classStr:String;
      
      public static var gailv:int = 15;
      
      public static var myplayer:PlayerData = Main.player1;
      
      public static var only:Boolean = true;
      
      public static var count:int = 0;
      
      public static var jinglingID:int = 1;
      
      public static var isMove:Boolean = true;
      
      public static var arr:Array = [];
      
      private static var xxxx:int = 0;
      
      private static var xxxx2:int = 0;
      
      private static var rushNum2:int = 0;
      
      private static var rushNum3:int = 0;
      
      private static var temp:int = 0;
      
      private static var temp2:int = 0;
      
      private static var alltime:int = 500;
      
      public var who:Player;
      
      public var data:Elves;
      
      public var RL:Boolean = true;
      
      public function JingLingCatch()
      {
         super();
      }
      
      public static function catchJL() : *
      {
         isMove = false;
         var _loc1_:Class = NewLoad.OtherData.getClass("ZhuaJL") as Class;
         zhuaMC = new _loc1_();
         Main.world.moveChild_Other.addChild(zhuaMC);
         zhuaMC.x = skin.x;
         zhuaMC.y = skin.y;
         zhuaMC.addEventListener(Event.ENTER_FRAME,panDuan);
      }
      
      public static function addSkin() : *
      {
         var _loc1_:* = undefined;
         var _loc2_:Class = null;
         var _loc3_:Class = null;
         arr = [];
         for(_loc1_ in JLCFactory.allData)
         {
            if(JLCFactory.allData[_loc1_][0] == GameData.BOSSid.getValue() && JLCFactory.allData[_loc1_][3] == GameData.gameLV)
            {
               arr.push(JLCFactory.allData[_loc1_]);
            }
         }
         for(_loc1_ in arr)
         {
            if(Main.isVip())
            {
               arr[_loc1_][2] += arr[_loc1_][4];
            }
            if(int(Math.random() * 1000) < arr[_loc1_][2])
            {
               jinglingID = arr[_loc1_][1];
               classStr = ElvesFactory.getClassName(arr[_loc1_][1]);
               _loc2_ = ChongWu.loadData.getClass(classStr) as Class;
               skin = new _loc2_();
               Main.world.moveChild_Other.addChild(skin);
               if(GameData.BossIS)
               {
                  skin.x = GameData.BossIS.x - int(Math.random() * 100);
                  skin.y = GameData.BossIS.y - int(Math.random() * 200);
                  skin.visible = false;
               }
               count = 1;
               _loc3_ = NewLoad.OtherData.getClass("ChuXian") as Class;
               chuxianMC = new _loc3_();
               Main.world.moveChild_Other.addChild(chuxianMC);
               chuxianMC.gotoAndPlay(1);
               chuxianMC.x = skin.x;
               chuxianMC.y = skin.y;
               chuxianMC.addEventListener(Event.ENTER_FRAME,playChuXian);
               break;
            }
         }
      }
      
      private static function panDuan(param1:*) : *
      {
         var _loc2_:Class = null;
         if(zhuaMC.currentLabel == "结束")
         {
            zhuaMC.visible = false;
            if(int(Math.random() * 100) < gailv)
            {
               _loc2_ = NewLoad.OtherData.getClass("zhuaTrue") as Class;
               chenggongMC = new _loc2_();
               Main.world.moveChild_Other.addChild(chenggongMC);
               chenggongMC.gotoAndPlay(1);
               chenggongMC.x = skin.x;
               chenggongMC.y = skin.y;
               isMove = true;
               count = 0;
               alltime = 0;
               if(myplayer.getElvesSlot().backElvesSlotNum() > 0)
               {
                  myplayer.getElvesSlot().addElvesSlot(ElvesFactory.creatElves(jinglingID));
               }
               else
               {
                  NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"精灵栏已满，请清理扩充");
               }
               skin.visible = false;
               ItemsPanel.itemsPanel["jinglingOPEN"].visible = true;
               chenggongMC.addEventListener(Event.ENTER_FRAME,playChengGong);
            }
            else
            {
               _loc2_ = NewLoad.OtherData.getClass("zhuaFalse") as Class;
               shibaiMC = new _loc2_();
               Main.world.moveChild_Other.addChild(shibaiMC);
               shibaiMC.gotoAndPlay(1);
               shibaiMC.x = skin.x;
               shibaiMC.y = skin.y;
               skin.visible = true;
               isMove = true;
               shibaiMC.addEventListener(Event.ENTER_FRAME,playShiBai);
            }
            zhuaMC.removeEventListener(Event.ENTER_FRAME,panDuan);
         }
      }
      
      private static function playChengGong(param1:*) : *
      {
         if(chenggongMC.currentLabel == "结束")
         {
            chenggongMC.visible = false;
            chenggongMC.removeEventListener(Event.ENTER_FRAME,playChengGong);
         }
      }
      
      private static function playShiBai(param1:*) : *
      {
         if(shibaiMC.currentLabel == "结束")
         {
            shibaiMC.visible = false;
            shibaiMC.removeEventListener(Event.ENTER_FRAME,playShiBai);
         }
      }
      
      private static function playChuXian(param1:*) : *
      {
         if(chuxianMC.currentLabel == "结束")
         {
            chuxianMC.visible = false;
            temp = int(Math.random() * 30) + 30;
            temp2 = int(Math.random() * 20) + 20;
            alltime = 99999;
            xxxx = 0;
            xxxx2 = 0;
            rushNum2 = 60;
            rushNum3 = 0;
            skin.addEventListener(Event.ENTER_FRAME,playJingLing);
            chuxianMC.removeEventListener(Event.ENTER_FRAME,playChuXian);
         }
      }
      
      private static function playJingLing(param1:*) : *
      {
         if(skin.currentLabel != "移动")
         {
            skin.gotoAndPlay("移动");
         }
         skin.visible = true;
         --alltime;
         if(isMove)
         {
            if(alltime > 0)
            {
               if(rushNum2 < 0)
               {
                  xxxx = 1;
                  skin.scaleX = -1;
               }
               if(rushNum2 > temp)
               {
                  xxxx = 0;
                  skin.scaleX = 1;
               }
               if(rushNum3 < 0)
               {
                  xxxx2 = 1;
               }
               if(rushNum3 > temp2)
               {
                  xxxx2 = 0;
               }
               if(xxxx == 0)
               {
                  --rushNum2;
                  skin.x -= 3;
               }
               else
               {
                  ++rushNum2;
                  skin.x += 3;
               }
               if(xxxx2 == 0)
               {
                  --rushNum3;
                  skin.y -= 3;
               }
               else
               {
                  ++rushNum3;
                  skin.y += 3;
               }
            }
            else
            {
               count = 0;
               skin.visible = false;
               skin.removeEventListener(Event.ENTER_FRAME,playJingLing);
            }
         }
      }
      
      public function Close() : *
      {
      }
   }
}

