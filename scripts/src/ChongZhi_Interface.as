package src
{
   import com.*;
   import com.efnx.fps.*;
   import com.hotpoint.braveManIII.models.common.*;
   import com.hotpoint.braveManIII.repository.other.*;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.text.*;
   import flash.utils.*;
   import src.tool.*;
   
   public class ChongZhi_Interface extends MovieClip
   {
      
      public static var _this:ChongZhi_Interface;
      
      public static var HDpoint8:VT = VT.createVT(-1);
      
      public static var openYn:Boolean = false;
      
      public static var lingQu:Boolean = false;
      
      public static var lingQu2:Boolean = false;
      
      public static var lingQu3:Boolean = false;
      
      public static var lingQu4:Boolean = false;
      
      public static var lingQu5:Boolean = false;
      
      public static var lingQu6:Boolean = false;
      
      public static var lingQu8:int = 0;
      
      public static var selYN:Boolean = false;
      
      public function ChongZhi_Interface()
      {
         super();
         _this = this;
         var _loc1_:Class = NewLoad.chongZhiData.getClass("mc1") as Class;
         _this.XX_mc.addChild(new _loc1_());
         _this.XX_mc.x = 136;
         _this.XX_mc.y = 47;
         _this.lingqu_btn.visible = false;
         _this.go_btn.visible = true;
         lingqu_btn.addEventListener(MouseEvent.CLICK,lingQuFun);
         addEventListener(Event.ENTER_FRAME,onENTER_FRAME);
         Open();
      }
      
      public static function Open() : *
      {
         var _loc1_:ChongZhi_Interface = null;
         if(!_this)
         {
            _loc1_ = new ChongZhi_Interface();
         }
         _this.go_btn.addEventListener(MouseEvent.CLICK,OpenWEB);
         _this.close_btn.addEventListener(MouseEvent.CLICK,Close);
         _this.addEventListener(Event.ENTER_FRAME,onENTER_FRAME);
         _this.x = _this.y = 0;
         if(!selYN && HDpoint8.getValue() < 0)
         {
            Api_4399_All.GetTotalRecharged(8);
            selYN = true;
         }
         Show();
      }
      
      public static function Close(param1:* = null) : *
      {
         var _loc2_:ChongZhi_Interface = null;
         if(!_this)
         {
            _loc2_ = new ChongZhi_Interface();
            Main._this.addChild(_loc2_);
         }
         _this.go_btn.removeEventListener(MouseEvent.CLICK,OpenWEB);
         _this.close_btn.removeEventListener(MouseEvent.CLICK,Close);
         _this.removeEventListener(Event.ENTER_FRAME,onENTER_FRAME);
         _this.x = _this.y = -5000;
      }
      
      public static function onENTER_FRAME(param1:*) : *
      {
         if(!openYn && Main.gameNum.getValue() == 0)
         {
            openYn = true;
            _this.x = _this.y = 0;
         }
         if(Main.gameNum.getValue() != 0)
         {
            _this.x = _this.y = -5000;
         }
      }
      
      public static function lingQuFun(param1:* = null) : *
      {
         if(Main.player1.getBag().backOtherBagNum() >= 1)
         {
            Main.player1.getBag().addOtherobjBag(OtherFactory.creatOther(63327));
            NewMC.Open("获得物品提示",Main._stage,480,400,35,0,true,2,"419");
            Api_4399_GongHui.upNum(127);
            ++lingQu8;
            Show();
         }
         else
         {
            NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"背包空间不足,请整理背包!");
         }
      }
      
      public static function Show() : *
      {
         _this.lingqu_btn.visible = false;
         _this.go_btn.visible = true;
         _this.lingqu_btn.x = _this.lingqu_btn.y = -5000;
         var _loc1_:int = HDpoint8.getValue() / 300 - lingQu8;
         _this._txt.text = "可领取" + _loc1_ + "次黑暗武器幻化券";
         if(HDpoint8.getValue() > 299 && _loc1_ > 0)
         {
            _this.lingqu_btn.visible = true;
            _this.lingqu_btn.x = 400;
            _this.lingqu_btn.y = 388;
            _this.go_btn.visible = false;
         }
      }
      
      public static function OpenWEB(param1:*) : *
      {
         if(Main.serviceHold)
         {
            SelMoneyTime = 50000;
            PayMoneyVar.instance.money = 100;
            Main.serviceHold.payMoney_As3(PayMoneyVar.instance);
         }
         _this.x = _this.y = -5000;
      }
   }
}

