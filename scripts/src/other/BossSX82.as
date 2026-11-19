package src.other
{
   import com.*;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.utils.*;
   import src.*;
   import src.tool.*;
   
   public class BossSX82 extends MovieClip
   {
      
      public var hpMAX:int = 3;
      
      public var hp:int = 3;
      
      public function BossSX82()
      {
         super();
         gotoAndStop(1);
         addEventListener(Event.ENTER_FRAME,daiji);
      }
      
      public function daiji(param1:*) : *
      {
         if(this.hp > this.hpMAX * 2 / 3)
         {
            gotoAndStop(1);
         }
         else if(this.hp > this.hpMAX * 1 / 3)
         {
            gotoAndStop(2);
         }
         else if(this.hp > 0)
         {
            gotoAndStop(3);
         }
         else if(this.hp <= 0)
         {
            gotoAndStop(4);
         }
      }
      
      public function hpxx() : *
      {
         if(hp > 0)
         {
            --hp;
            TiaoShi.txtShow("hp = " + hp);
         }
      }
   }
}

