package src.other
{
   import com.greensock.*;
   import com.greensock.easing.*;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import src.*;
   
   public class GDpic extends MovieClip
   {
      
      private var timeX:int = 28;
      
      public function GDpic(param1:int, param2:int, param3:MovieClip, param4:Player)
      {
         super();
         this.x = param1;
         this.y = param2;
         param3.addChild(this);
         param1 = 580;
         if(param4 == Main.player_1)
         {
            param1 = 357;
         }
         TweenMax.to(this,1,{
            "bezier":[{
               "x":param1,
               "y":52
            }],
            "ease":Cubic.easeOut
         });
         addEventListener(Event.ENTER_FRAME,onENTER_FRAME);
      }
      
      public function onENTER_FRAME(param1:*) : *
      {
         --timeX;
         if(timeX <= 0)
         {
            this.parent.removeChild(this);
            removeEventListener(Event.ENTER_FRAME,onENTER_FRAME);
         }
      }
   }
}

