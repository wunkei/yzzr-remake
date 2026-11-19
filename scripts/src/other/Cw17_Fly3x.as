package src.other
{
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import src.*;
   
   public class Cw17_Fly3x extends Fly
   {
      
      private var yn:Boolean = false;
      
      public function Cw17_Fly3x()
      {
         super();
      }
      
      override public function otherXX() : *
      {
         if(Boolean(!yn) && Boolean(this.who) && this.who.who is Player)
         {
            this.x = this.who.x + (Math.random() * 800 - 400);
            this.y = 520;
            yn = true;
         }
      }
   }
}

