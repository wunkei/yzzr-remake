package src.other
{
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import src.*;
   
   public class SkillDarkBoom extends Fly
   {
      
      public function SkillDarkBoom()
      {
         super();
      }
      
      override public function onADDED_TO_STAGE(param1:* = null) : *
      {
         var _loc3_:MovieClip = null;
         removeEventListener(Event.ADDED_TO_STAGE,onADDED_TO_STAGE);
         var _loc2_:int = 0;
         while(_loc2_ < All.length)
         {
            if(All[_loc2_] == this)
            {
               return;
            }
            _loc2_++;
         }
         All[All.length] = this;
         _loc3_ = this;
         while(_loc3_ != _stage)
         {
            if(_loc3_ is Skin_WuQi && _loc3_.parent is Player)
            {
               who = _loc3_.parent;
               this.RL = (who as Player).RL;
               硬直 = who.skin.硬直;
               gongJi_hp_MAX = 12000;
               gongJi_hp = 3.2;
               attTimes = who.skin.attTimes;
               runX = who.skin.runX;
               runTime = who.skin.runTime;
               break;
            }
            if(_loc3_ is EnemySkin && _loc3_.parent is Enemy)
            {
               who = _loc3_.parent;
               this.RL = (who as Enemy).RL;
               硬直 = who.skin.硬直;
               attTimes = who.skin.attTimes;
               runX = (_loc3_ as EnemySkin).runX;
               runTime = (_loc3_ as EnemySkin).runTime;
               type = (_loc3_ as EnemySkin).type;
               space = (_loc3_ as EnemySkin).space;
               totalTime = (_loc3_ as EnemySkin).totalTime;
               numValue = (_loc3_ as EnemySkin).numValue;
               break;
            }
            _loc3_ = _loc3_.parent as MovieClip;
         }
         Main.world.moveChild_Other2.addChild(this);
         this.y = Enemy.hit_y;
         this.x = Enemy.hit_x;
      }
   }
}

