package src.Skin
{
   import com.greensock.*;
   import com.greensock.easing.*;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.utils.*;
   import src.*;
   import src.other.*;
   
   public class Boss83 extends EnemySkin
   {
      
      public static var b1:Enemy;
      
      public static var b2:Enemy;
      
      public static var b3:Enemy;
      
      public static var r1:Enemy;
      
      public static var r2:Enemy;
      
      public static var r3:Enemy;
      
      public static var lanNUM:int = 0;
      
      public static var hongNUM:int = 0;
      
      private var bool:Boolean = true;
      
      private var hongMC:MovieClip = new redMC();
      
      private var lanMC:MovieClip = new blueMC();
      
      public function Boss83()
      {
         super();
      }
      
      override public function otherGoTo(param1:String) : *
      {
         if(Boolean(this.parent) && Boolean(bool))
         {
            this.parent.x = 689;
            lanNUM = 0;
            hongNUM = 0;
            Main.world.moveChild_Enemy.addChild(lanMC);
            lanMC.x = 54;
            lanMC.y = 534;
            Main.world.moveChild_Enemy.addChild(hongMC);
            hongMC.x = 1324;
            hongMC.y = 528;
            b1 = new Enemy(5019);
            b2 = new Enemy(5020);
            b3 = new Enemy(5021);
            r1 = new Enemy(5016);
            r2 = new Enemy(5017);
            r3 = new Enemy(5018);
            addEventListener(Event.ENTER_FRAME,BlueMovie);
            addEventListener(Event.ENTER_FRAME,RedMovie);
            bool = false;
         }
      }
      
      public function BlueMovie(param1:*) : *
      {
         if(lanNUM == 0)
         {
            lanMC.gotoAndStop(1);
         }
         if(lanNUM == 1 && lanMC.currentFrame == 1)
         {
            lanMC.gotoAndPlay(2);
         }
         if(lanNUM == 2 && lanMC.currentFrame == 24)
         {
            lanMC.visible = true;
            lanMC.gotoAndPlay(25);
         }
         if(lanNUM == 3 && lanMC.currentFrame == 48)
         {
            lanMC.visible = true;
            lanMC.gotoAndPlay(49);
         }
         if(lanMC.currentFrame == 23)
         {
            Main.world.moveChild_Enemy.addChild(b1);
            b1.x = 54;
            b1.y = 534;
            lanMC.gotoAndStop(24);
            lanMC.visible = false;
         }
         if(lanMC.currentFrame == 47)
         {
            Main.world.moveChild_Enemy.addChild(b2);
            b2.x = 54;
            b2.y = 534;
            lanMC.gotoAndStop(48);
            lanMC.visible = false;
         }
         if(lanMC.currentFrame == 71)
         {
            Main.world.moveChild_Enemy.addChild(b3);
            b3.x = 54;
            b3.y = 534;
            lanMC.gotoAndStop(72);
            lanMC.visible = false;
         }
         if(lanNUM == 2)
         {
            if(b1)
            {
               b1.Dead();
            }
         }
         if(lanNUM >= 3)
         {
            if(b1)
            {
               b1.Dead();
            }
            if(b2)
            {
               b2.Dead();
            }
         }
         if(GameData.BossIS.life.getValue() <= 0 || Main.gameNum.getValue() == 0)
         {
            if(b1)
            {
               b1.life.setValue(0);
            }
            if(b2)
            {
               b2.life.setValue(0);
            }
            if(b3)
            {
               b3.life.setValue(0);
            }
            if(r1)
            {
               r1.life.setValue(0);
            }
            if(r2)
            {
               r2.life.setValue(0);
            }
            if(r3)
            {
               r3.life.setValue(0);
            }
         }
      }
      
      public function RedMovie(param1:*) : *
      {
         if(hongNUM == 0)
         {
            hongMC.gotoAndStop(1);
         }
         if(hongNUM == 1 && hongMC.currentFrame == 1)
         {
            hongMC.gotoAndPlay(2);
         }
         if(hongNUM == 2 && hongMC.currentFrame == 24)
         {
            hongMC.visible = true;
            hongMC.gotoAndPlay(25);
         }
         if(hongNUM == 3 && hongMC.currentFrame == 48)
         {
            hongMC.visible = true;
            hongMC.gotoAndPlay(49);
         }
         if(hongMC.currentFrame == 23)
         {
            Main.world.moveChild_Enemy.addChild(r1);
            r1.x = 1324;
            r1.y = 528;
            hongMC.gotoAndStop(24);
            hongMC.visible = false;
         }
         if(hongMC.currentFrame == 47)
         {
            r2 = new Enemy(5017);
            Main.world.moveChild_Enemy.addChild(r2);
            r2.x = 1324;
            r2.y = 528;
            hongMC.gotoAndStop(48);
            hongMC.visible = false;
         }
         if(hongMC.currentFrame == 71)
         {
            r3 = new Enemy(5018);
            Main.world.moveChild_Enemy.addChild(r3);
            r3.x = 1324;
            r3.y = 528;
            hongMC.gotoAndStop(72);
            hongMC.visible = false;
         }
         if(hongNUM == 2)
         {
            if(r1)
            {
               r1.Dead();
            }
         }
         if(hongNUM >= 3)
         {
            if(r1)
            {
               r1.Dead();
            }
            if(r2)
            {
               r2.Dead();
            }
         }
      }
   }
}

