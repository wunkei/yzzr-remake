package src.other
{
   import com.*;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.utils.*;
   import src.*;
   import src.tool.*;
   
   public class Boss84FP extends MovieClip
   {
      
      public static var yaopinChengFa:Boolean = false;
      
      public static var playKey:int = 0;
      
      public static var paiState:int = 0;
      
      public var LeiClass:Class;
      
      public var cdOK:Boolean = true;
      
      public var timeTemp:int = 0;
      
      public function Boss84FP()
      {
         super();
         gotoAndStop(1);
         addEventListener(Event.ENTER_FRAME,fanpai);
         addEventListener(Event.REMOVED_FROM_STAGE,removeALL);
         LeiClass = Enemy.EnemyArr[84].getClass("雷惩罚") as Class;
      }
      
      public function removeALL(param1:*) : *
      {
         paiState = 0;
         removeEventListener(Event.ENTER_FRAME,fanpai);
      }
      
      public function fanpai(param1:*) : *
      {
         var _loc2_:Fly = null;
         ++timeTemp;
         if(currentFrame == 1 && playKey == 1)
         {
            paiState = 0;
         }
         if(timeTemp > 27)
         {
            cdOK = true;
            timeTemp = 0;
         }
         if(paiState == 1 && playKey == 0)
         {
            gotoAndStop(1);
            gotoAndStop(2);
            playKey = 1;
         }
         if(paiState == 2 && playKey == 0)
         {
            gotoAndStop(1);
            gotoAndStop(3);
            playKey = 1;
         }
         if(paiState == 3 && playKey == 0)
         {
            gotoAndStop(1);
            gotoAndStop(4);
            playKey = 1;
         }
         if(paiState == 4 && playKey == 0)
         {
            gotoAndStop(1);
            gotoAndStop(5);
            playKey = 1;
         }
         if(paiState == 5 && playKey == 0)
         {
            gotoAndStop(1);
            gotoAndStop(6);
            playKey = 1;
         }
         if(paiState == 1 && Main.gameNum.getValue() == 84 && cdOK)
         {
            _loc2_ = new LeiClass();
            _loc2_.y = 475;
            if(Main.player_1.fbChengFa)
            {
               _loc2_.x = Main.player_1.x;
               Main.world.moveChild_Other.addChild(_loc2_);
               Main.player_1.fbChengFa = false;
            }
            if(Boolean(Main.P1P2) && Boolean(Main.player_2.fbChengFa))
            {
               _loc2_.x = Main.player_2.x;
               Main.world.moveChild_Other.addChild(_loc2_);
               Main.player_2.fbChengFa = false;
            }
            cdOK = false;
         }
         if(paiState == 2 && Main.gameNum.getValue() == 84 && cdOK)
         {
            _loc2_ = new LeiClass();
            _loc2_.y = 475;
            if(Main.player_1.fbChengFa)
            {
               _loc2_.x = Main.player_1.x;
               Main.world.moveChild_Other.addChild(_loc2_);
               Main.player_1.fbChengFa = false;
            }
            if(Boolean(Main.P1P2) && Boolean(Main.player_2.fbChengFa))
            {
               _loc2_.x = Main.player_2.x;
               Main.world.moveChild_Other.addChild(_loc2_);
               Main.player_2.fbChengFa = false;
            }
            cdOK = false;
         }
         if(paiState == 3 && Main.gameNum.getValue() == 84 && cdOK)
         {
            _loc2_ = new LeiClass();
            _loc2_.y = 475;
            if(Main.player_1.fbChengFa)
            {
               _loc2_.x = Main.player_1.x;
               Main.world.moveChild_Other.addChild(_loc2_);
               Main.player_1.fbChengFa = false;
            }
            if(Boolean(Main.P1P2) && Boolean(Main.player_2.fbChengFa))
            {
               _loc2_.x = Main.player_2.x;
               Main.world.moveChild_Other.addChild(_loc2_);
               Main.player_2.fbChengFa = false;
            }
            cdOK = false;
         }
         if(paiState == 4 && Main.gameNum.getValue() == 84 && cdOK)
         {
            _loc2_ = new LeiClass();
            _loc2_.y = 475;
            if(Main.player_1.fbChengFa)
            {
               _loc2_.x = Main.player_1.x;
               Main.world.moveChild_Other.addChild(_loc2_);
               Main.player_1.fbChengFa = false;
            }
            if(Boolean(Main.P1P2) && Boolean(Main.player_2.fbChengFa))
            {
               _loc2_.x = Main.player_2.x;
               Main.world.moveChild_Other.addChild(_loc2_);
               Main.player_2.fbChengFa = false;
            }
            cdOK = false;
         }
         if(paiState == 5 && Main.gameNum.getValue() == 84 && cdOK)
         {
            _loc2_ = new LeiClass();
            _loc2_.y = 475;
            if(Main.player_1.gravity == 0)
            {
               _loc2_.x = Main.player_1.x;
               Main.world.moveChild_Other.addChild(_loc2_);
            }
            if(Boolean(Main.P1P2) && Main.player_2.gravity == 0)
            {
               _loc2_.x = Main.player_2.x;
               Main.world.moveChild_Other.addChild(_loc2_);
            }
            cdOK = false;
         }
      }
   }
}

