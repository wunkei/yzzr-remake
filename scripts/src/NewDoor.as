package src
{
   import com.hotpoint.braveManIII.models.container.*;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.text.*;
   import src.tool.*;
   
   public class NewDoor extends MovieClip
   {
      
      public static var bool_1:* = true;
      
      public static var bool_2:* = true;
      
      public static var bool_3:* = true;
      
      public static var bool_4:* = true;
      
      public static var bool_0:* = false;
      
      private static var arr:* = [263,515,728,947];
      
      private var time:int = 0;
      
      public function NewDoor()
      {
         super();
         if(this.name == "t1")
         {
            if(bool_1)
            {
               Open();
            }
            else
            {
               Close();
            }
         }
         if(this.name == "t2")
         {
            if(bool_2)
            {
               Open();
            }
            else
            {
               Close();
            }
         }
         if(this.name == "t3")
         {
            if(bool_3)
            {
               Open();
            }
            else
            {
               Close();
            }
         }
         if(this.name == "t4")
         {
            if(bool_4)
            {
               Open();
            }
            else
            {
               Close();
            }
         }
         if(this.name == "bk2" || this.name == "bk3" || this.name == "bk4" || this.name == "bk5")
         {
            Close();
         }
         if(this.name == "t1")
         {
            this.x = arr[0];
            this.y = 547;
         }
         else if(this.name == "t2")
         {
            this.x = arr[1];
            this.y = 547;
         }
         else if(this.name == "t3")
         {
            this.x = arr[2];
            this.y = 547;
         }
         else if(this.name == "t4")
         {
            this.x = arr[3];
            this.y = 547;
         }
      }
      
      private static function randomsort(param1:*, param2:*) : *
      {
         return Math.random() > 0.5 ? -1 : 1;
      }
      
      public static function setRdm() : *
      {
         arr.sort(randomsort);
      }
      
      public function Open(param1:int = 0) : *
      {
         if(!visible)
         {
            time = param1;
         }
         addEventListener(Event.ENTER_FRAME,onENTER_FRAME);
      }
      
      public function Close() : *
      {
         this.visible = false;
         removeEventListener(Event.ENTER_FRAME,onENTER_FRAME);
      }
      
      private function onENTER_FRAME(param1:*) : *
      {
         var _loc2_:Player = null;
         if(this.parent != Main.world)
         {
            removeEventListener(Event.ENTER_FRAME,onENTER_FRAME);
            return;
         }
         if(time > 0)
         {
            --time;
            return;
         }
         this.visible = true;
         i2 = 0;
         while(i2 < Player.All.length)
         {
            _loc2_ = Player.All[i2];
            if(Boolean(visible) && Boolean(_loc2_.hit) && Boolean(this.hit.hitTestObject(_loc2_.hit)))
            {
               if(_loc2_.getKeyStatus("上",2) && this.parent == Main.world)
               {
                  removeEventListener(Event.ENTER_FRAME,onENTER_FRAME);
                  GoWhere();
               }
            }
            ++i2;
         }
      }
      
      public function GoWhere() : *
      {
         var _loc1_:WinShow = null;
         if(this.name == "t1")
         {
            Main.gameNum.setValue(82);
            Main.gameNum2.setValue(2);
            Main._this.Loading();
         }
         else if(this.name == "t2")
         {
            Main.gameNum.setValue(82);
            Main.gameNum2.setValue(3);
            Main._this.Loading();
         }
         else if(this.name == "t3")
         {
            Main.gameNum.setValue(82);
            Main.gameNum2.setValue(4);
            Main._this.Loading();
         }
         else if(this.name == "t4")
         {
            Main.gameNum.setValue(82);
            Main.gameNum2.setValue(5);
            Main._this.Loading();
         }
         else if(this.name == "bk2")
         {
            Main.gameNum.setValue(82);
            Main.gameNum2.setValue(1);
            Main._this.Loading();
         }
         else if(this.name == "bk3")
         {
            Main.gameNum.setValue(82);
            Main.gameNum2.setValue(1);
            Main._this.Loading();
         }
         else if(this.name == "bk4")
         {
            Main.gameNum.setValue(82);
            Main.gameNum2.setValue(1);
            Main._this.Loading();
         }
         else if(this.name == "bk5")
         {
            _loc1_ = new WinShow();
         }
      }
   }
}

