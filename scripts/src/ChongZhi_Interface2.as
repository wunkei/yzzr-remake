package src
{
   import com.*;
   import com.efnx.fps.*;
   import com.hotpoint.braveManIII.repository.equip.*;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.text.*;
   import flash.utils.*;
   import src.tool.*;
   
   public class ChongZhi_Interface2 extends MovieClip
   {
      
      public static var _this:ChongZhi_Interface2;
      
      public static var openYn:Boolean = false;
      
      public static var buyOk:Boolean = false;
      
      public static var selYN:Boolean = false;
      
      public function ChongZhi_Interface2()
      {
         super();
         _this = this;
         var _loc1_:Class = NewLoad.chongZhiData.getClass("mc2") as Class;
         _this.XX_mc.addChild(new _loc1_());
         _this.XX_mc.x = 136;
         _this.XX_mc.y = 47;
         close_btn.addEventListener(MouseEvent.CLICK,Close);
         lingqu_btn.addEventListener(MouseEvent.CLICK,lingQuFun);
      }
      
      public static function Open() : *
      {
         var _loc1_:ChongZhi_Interface2 = null;
         if(!_this)
         {
            _loc1_ = new ChongZhi_Interface2();
         }
         _this.addEventListener(Event.ENTER_FRAME,onENTER_FRAME);
         _this.x = _this.y = 0;
         Main._this.addChild(_this);
         Show();
      }
      
      public static function onENTER_FRAME(param1:*) : *
      {
         if(!openYn && Main.gameNum.getValue() == 0)
         {
            openYn = true;
            _this.x = _this.y = 0;
         }
      }
      
      public static function Close(param1:* = null) : *
      {
         var _loc2_:ChongZhi_Interface2 = null;
         if(!_this)
         {
            _loc2_ = new ChongZhi_Interface2();
            Main._this.addChild(_loc2_);
         }
         _this.removeEventListener(Event.ENTER_FRAME,onENTER_FRAME);
         _this.x = _this.y = -5000;
      }
      
      public static function lingQuFun(param1:* = null) : *
      {
         if(Main.player1.getBag().backequipBagNum() >= 2)
         {
            if(Shop4399.moneyAll.getValue() >= 499)
            {
               Api_4399_All.BuyObj(239);
               buyOk = true;
            }
            else
            {
               NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"点卷不足！");
               buyOk = false;
            }
         }
         else
         {
            NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"背包空间不足,请整理背包!");
         }
         Show();
      }
      
      public static function Buy_OK() : *
      {
         if(buyOk)
         {
            Main.player1.getBag().addEquipBag(EquipFactory.createEquipByID(14721));
            Main.player1.getBag().addEquipBag(EquipFactory.createEquipByID(14727));
            Api_4399_GongHui.upNum(126);
            NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"购买成功!");
            buyOk = false;
            Show();
         }
      }
      
      public static function Show() : *
      {
         _this.lingqu_btn.visible = false;
         _this.lingqu_btn.x = _this.lingqu_btn.y = -5000;
         if(!buyOk)
         {
            _this.lingqu_btn.visible = true;
            _this.lingqu_btn.x = 267;
            _this.lingqu_btn.y = 352;
         }
      }
   }
}

