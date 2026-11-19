package src
{
   import com.*;
   import com.efnx.fps.*;
   import com.hotpoint.braveManIII.models.container.*;
   import com.hotpoint.braveManIII.repository.gem.*;
   import com.hotpoint.braveManIII.repository.other.*;
   import com.hotpoint.braveManIII.repository.supplies.*;
   import com.hotpoint.braveManIII.views.itemsPanel.*;
   import com.hotpoint.braveManIII.views.itemsTooltip.*;
   import com.hotpoint.braveManIII.views.setKeyPanel.*;
   import com.hotpoint.braveManIII.views.taskPanel.*;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.text.*;
   import flash.utils.*;
   import src.tool.*;
   
   public class ZhuanPan extends MovieClip
   {
      
      private static var loadData:ClassLoader;
      
      private static var _this:ZhuanPan;
      
      public static var saveYN:Boolean;
      
      private static var OpenYN:Boolean = false;
      
      private static var loadName:String = "ZhuanPan.swf";
      
      private static var show_NUM:int = 1;
      
      private static var sel_NUM:int = 1;
      
      private static var ZPtime:int = 0;
      
      private static var ZPSpeed:int = 2;
      
      public static var saveNum:int = 0;
      
      public static var saveTime:int = 0;
      
      public static var Num1:int = 0;
      
      public static var Num1YN2:int = 0;
      
      public static var Num1time:int = 27 * 3599;
      
      private static var dianQuanYN:Boolean = false;
      
      private var skin:MovieClip;
      
      public function ZhuanPan()
      {
         super();
         LoadSkin();
         _this = this;
         Init();
      }
      
      public static function Open() : *
      {
         if(_this)
         {
            _this.visible = true;
            _this.x = _this.y = 0;
            _this.Show();
            _this.skin.tishi_mc.visible = false;
         }
         else
         {
            InitOpen();
         }
      }
      
      private static function InitOpen() : *
      {
         var _loc1_:ZhuanPan = new ZhuanPan();
         Main._stage.addChild(_loc1_);
         OpenYN = true;
      }
      
      public static function CloseX() : *
      {
         var _loc1_:int = 0;
         if(_this)
         {
            _this.visible = false;
            _this.x = _this.y = 5000;
            _loc1_ = 1;
            while(_loc1_ <= 10)
            {
               _this.skin["mc" + _loc1_].gotoAndStop(1);
               _loc1_++;
            }
         }
      }
      
      public static function DianquanGo() : *
      {
         if(dianQuanYN)
         {
            dianQuanYN = false;
            _this.ZhuanPan_GO();
         }
      }
      
      private function Init() : *
      {
         var _loc1_:int = int(Main.serverTime.getValue());
         TiaoShi.txtShow("ZhuanPan time = " + _loc1_ + ", saveTime = " + saveTime);
         if(_loc1_ > saveTime)
         {
            saveTime = _loc1_;
            Num1YN2 = 1;
            Num1 = 1;
         }
      }
      
      private function Num1Time_fun(param1:*) : *
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         if(Num1YN2 == 2)
         {
            --Num1time;
            if(Num1time <= 0)
            {
               Num1 = 1;
               removeEventListener(Event.ENTER_FRAME,Num1Time_fun);
               Show();
            }
            else
            {
               _loc2_ = Num1time / 27;
               _loc3_ = _loc2_ / 60;
               _loc4_ = _loc2_ % 60;
               skin._txt.text = _loc3_ + ":" + _loc4_;
               if(_loc3_ == 0 && _loc4_ == 0)
               {
                  skin._txt.text = 0;
               }
            }
         }
         else
         {
            removeEventListener(Event.ENTER_FRAME,Num1Time_fun);
         }
      }
      
      private function LoadSkin() : *
      {
         if(!skin && !loadData)
         {
            loadData = new ClassLoader(loadName);
            loadData.addEventListener(Event.COMPLETE,onLoadingOK);
            LoadInGame.Open(loadData);
         }
      }
      
      private function onLoadingOK(param1:*) : *
      {
         Play_Interface.interfaceX["load_mc"].visible = false;
         var _loc2_:Class = loadData.getClass("ZhuanPan_mc") as Class;
         this.skin = new _loc2_();
         addChild(skin);
         var _loc3_:int = 1;
         while(_loc3_ <= 10)
         {
            skin["mc" + _loc3_].gotoAndStop(1);
            _loc3_++;
         }
         skin._btn.addEventListener(MouseEvent.MOUSE_DOWN,onCLICK);
         skin._btn.addEventListener(MouseEvent.MOUSE_MOVE,onMOVE);
         skin._btn.addEventListener(MouseEvent.MOUSE_OUT,onOUT);
         skin.Close_btn.addEventListener(MouseEvent.CLICK,Close);
         addEventListener(Event.ENTER_FRAME,Num1Time_fun);
         Show();
         if(OpenYN)
         {
            Open();
         }
         else
         {
            Close();
         }
      }
      
      private function Close(param1:* = null) : *
      {
         CloseX();
      }
      
      private function Show() : *
      {
         skin._txt.text = Num1;
         var _loc1_:int = int(Main.player1.getBag().getOtherobjNum(63299));
         if(Main.P1P2)
         {
            _loc1_ += Main.player2.getBag().getOtherobjNum(63299);
         }
         skin._txt2.text = _loc1_;
      }
      
      public function onENTER_FRAME(param1:*) : *
      {
         ++ZPtime;
         ZPSpeed = 1;
         if(ZPtime < 15 || saveYN && ZPtime > 100)
         {
            ZPSpeed = 3;
            if(saveYN && ZPtime > 100)
            {
               --saveNum;
            }
         }
         var _loc2_:int = 1;
         while(_loc2_ <= 10)
         {
            skin["mc" + _loc2_].gotoAndStop(1);
            _loc2_++;
         }
         if(ZPtime % ZPSpeed == 0)
         {
            ++show_NUM;
         }
         if(show_NUM > 10)
         {
            show_NUM = 1;
         }
         skin["mc" + show_NUM].gotoAndPlay(2);
         if(saveNum < 0 && show_NUM == sel_NUM)
         {
            removeEventListener(Event.ENTER_FRAME,onENTER_FRAME);
            skin._btn.addEventListener(MouseEvent.MOUSE_DOWN,onCLICK);
            skin._btn.addEventListener(MouseEvent.MOUSE_MOVE,onMOVE);
            skin._btn.addEventListener(MouseEvent.MOUSE_OUT,onOUT);
            skin.Close_btn.addEventListener(MouseEvent.CLICK,Close);
            skin._btn.visible = true;
            saveYN = false;
            NewMC.Open("文字提示",this,480,290,30,0,true,2,"物品已放入背包");
         }
      }
      
      private function onMOVE(param1:*) : *
      {
         if(Num1 < 1 && Main.player1.getBag().getOtherobjNum(63299) < 1)
         {
            skin.tishi_mc.visible = true;
         }
      }
      
      private function onOUT(param1:*) : *
      {
         skin.tishi_mc.visible = false;
      }
      
      private function onCLICK(param1:*) : *
      {
         skin.tishi_mc.visible = false;
         if(Main.player1.getBag().backOtherBagNum() < 1 || Main.player1.getBag().backGemBagNum() < 1 || Main.player1.getBag().backSuppliesBagNum() < 1)
         {
            NewMC.Open("文字提示",this,480,290,30,0,true,2,"背包空间不足");
            return;
         }
         if(Num1 > 0)
         {
            --Num1;
            ++Num1YN2;
            ZhuanPan_GO();
         }
         else if(Main.player1.getBag().getOtherobjNum(63299) > 0)
         {
            Main.player1.getBag().delOtherById(63299,1);
            ZhuanPan_GO();
            if(Main.player1.getBag().getOtherobjNum(63299) <= 0)
            {
               skin.tishi_mc.visible = true;
            }
         }
         else if(Boolean(Main.P1P2) && Main.player2.getBag().getOtherobjNum(63299) > 0)
         {
            Main.player2.getBag().delOtherById(63299,1);
            ZhuanPan_GO();
            if(Main.player2.getBag().getOtherobjNum(63299) <= 0)
            {
               skin.tishi_mc.visible = true;
            }
         }
         else if(Shop4399.moneyAll.getValue() >= 12)
         {
            Api_4399_All.BuyObj(231);
            dianQuanYN = true;
         }
         else
         {
            NewMC.Open("文字提示",Main._stage,400,400,30,0,true,2,"点券不足");
         }
         Show();
      }
      
      private function ZhuanPan_GO() : *
      {
         ZPtime = 0;
         var _loc1_:int = Math.random() * 100;
         if(_loc1_ < 10)
         {
            sel_NUM = 1;
         }
         else if(_loc1_ < 20)
         {
            sel_NUM = 2;
         }
         else if(_loc1_ < 35)
         {
            sel_NUM = 3;
         }
         else if(_loc1_ < 37)
         {
            sel_NUM = 4;
         }
         else if(_loc1_ < 48)
         {
            sel_NUM = 5;
         }
         else if(_loc1_ < 68)
         {
            sel_NUM = 6;
         }
         else if(_loc1_ < 78)
         {
            sel_NUM = 7;
         }
         else if(_loc1_ < 80)
         {
            sel_NUM = 8;
         }
         else if(_loc1_ < 95)
         {
            sel_NUM = 9;
         }
         else
         {
            sel_NUM = 10;
         }
         saveNum = 30;
         saveYN = false;
         TiaoShi.txtShow("sel_NUM = " + sel_NUM);
         GetObj();
         addEventListener(Event.ENTER_FRAME,onENTER_FRAME);
         skin._btn.visible = false;
         skin._btn.removeEventListener(MouseEvent.MOUSE_DOWN,onCLICK);
         skin._btn.removeEventListener(MouseEvent.MOUSE_MOVE,onMOVE);
         skin._btn.removeEventListener(MouseEvent.MOUSE_OUT,onOUT);
         skin.Close_btn.removeEventListener(MouseEvent.CLICK,Close);
         addEventListener(Event.ENTER_FRAME,Num1Time_fun);
         Main.Save2();
      }
      
      private function GetObj() : *
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         if(sel_NUM == 1)
         {
            Main.player1.getBag().addOtherobjBag(OtherFactory.creatOther(63181));
         }
         else if(sel_NUM == 2)
         {
            Main.player1.getBag().addSuppliesBag(SuppliesFactory.getSuppliesById(21226));
         }
         else if(sel_NUM == 3)
         {
            Main.player1.getBag().addOtherobjBag(OtherFactory.creatOther(63203));
         }
         else if(sel_NUM == 4)
         {
            Main.player1.getBag().addOtherobjBag(OtherFactory.creatOther(63204));
         }
         else if(sel_NUM == 5)
         {
            Main.player1.getBag().addSuppliesBag(SuppliesFactory.getSuppliesById(21221));
         }
         else if(sel_NUM == 6)
         {
            Main.player1.getBag().addOtherobjBag(OtherFactory.creatOther(63290));
         }
         else if(sel_NUM == 7)
         {
            Main.player1.getBag().addGemBag(GemFactory.creatGemById(31216));
         }
         else if(sel_NUM == 8)
         {
            _loc1_ = Math.random() * 100;
            if(_loc1_ < 20)
            {
               Main.player1.getBag().addOtherobjBag(OtherFactory.creatOther(63209));
            }
            else if(_loc1_ < 45)
            {
               Main.player1.getBag().addOtherobjBag(OtherFactory.creatOther(63237));
            }
            else if(_loc1_ < 70)
            {
               Main.player1.getBag().addOtherobjBag(OtherFactory.creatOther(63255));
            }
            else if(_loc1_ < 75)
            {
               Main.player1.getBag().addOtherobjBag(OtherFactory.creatOther(63266));
            }
            else if(_loc1_ < 95)
            {
               Main.player1.getBag().addOtherobjBag(OtherFactory.creatOther(63271));
            }
            else
            {
               Main.player1.getBag().addOtherobjBag(OtherFactory.creatOther(63291));
            }
         }
         else if(sel_NUM == 9)
         {
            _loc2_ = 0;
            while(_loc2_ < 3)
            {
               Main.player1.getBag().addOtherobjBag(OtherFactory.creatOther(63147));
               _loc2_++;
            }
         }
         else if(sel_NUM == 10)
         {
            Main.player1.getBag().addOtherobjBag(OtherFactory.creatOther(63249));
         }
      }
   }
}

