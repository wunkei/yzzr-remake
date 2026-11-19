package src
{
   import com.*;
   import com.efnx.fps.*;
   import com.hotpoint.braveManIII.Tool.*;
   import com.hotpoint.braveManIII.models.supplies.Supplies;
   import com.hotpoint.braveManIII.repository.other.*;
   import com.hotpoint.braveManIII.repository.skill.*;
   import com.hotpoint.braveManIII.views.achPanel.*;
   import com.hotpoint.braveManIII.views.cardPanel.*;
   import com.hotpoint.braveManIII.views.chunjiePanel.*;
   import com.hotpoint.braveManIII.views.fanpaiPanel.*;
   import com.hotpoint.braveManIII.views.itemsPanel.*;
   import com.hotpoint.braveManIII.views.itemsTooltip.*;
   import com.hotpoint.braveManIII.views.jiangliPanel.*;
   import com.hotpoint.braveManIII.views.petPanel.*;
   import com.hotpoint.braveManIII.views.setKeyPanel.*;
   import com.hotpoint.braveManIII.views.setTransfer.*;
   import com.hotpoint.braveManIII.views.taskPanel.*;
   import com.hotpoint.braveManIII.views.temaiPanel.*;
   import com.hotpoint.braveManIII.views.tuijianPanel.*;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.text.*;
   import flash.utils.*;
   import src.tool.*;
   
   public class Play_Interface extends MovieClip
   {
      
      public static var interfaceX:Play_Interface;
      
      public static var SaveLoadMC:MovieClip;
      
      public static var Xfile_YN:Boolean;
      
      public static var allTooltip:MovieClip;
      
      public static var BossLifeYN:Boolean;
      
      public static var bossIS:Enemy;
      
      public static var SixOneOK:Boolean = false;
      
      public static var templianJiNum:Array = [0,0];
      
      public static const data:Class = Play_Interface_data;
      
      public static var huaZhi:uint = 1;
      
      private static var OpenYN:Boolean = false;
      
      private static var showTimeNum:uint = 60;
      
      public var myXml:XML = new XML();
      
      private var saveTime:int = 0;
      
      private var infoArr0:Array = ["找“技能导师-奥古斯汀”可以学习各系武器的技能噢","去挑战关卡时，记得检查一下药品是否足够。如果不够，可以找“妮蒂亚”购买。","收集到第一块女神碎片后，村庄的左边会开启通往女神像地图的入口。","修复第一块女神碎片后，会在“技能导师”背后开启通往“神秘之地”的入口","装备属性低的话，可以找“装备商人-道格拉斯”进行装备强化，宝石合成、宝石镶嵌来提升。","2个“强化石”可以合成1个“精良的强化石”，用“精良的强化石”强化装备得到的属性会更高","2个“低级属性石”可以合成一个“中级属性石”，“中级属性石”会有两条属性噢。","“强化石碎片”可以强化史诗级以下的技能石，2个“强化石碎片”可以合成一个1级强化石。","到达25级时，可以找“技能导师”进行转职，转职后可学习4个新的转职技能。","在背包里“鼠标双击”或“拖动”装备可以进行穿戴，右手武器需要拖动武器到右手武器栏才能替换。","2段跳可以在“技能导师”的“通用技能”里习得。","“菜单”栏里可以进行“快捷键设置”“返回城镇”等操作。","如果游戏过程中比较卡，可以通过降低画质提升流畅性。","在仓库中可以进行1P和2P的物品交换。"];
      
      private var infoArr1:Array = ["注意观察怪物的发招动作，并采取相应的行动进行躲避，可以让你更轻松的过关","按“上+攻击”和“下+攻击”可以发动各职业的2种特有攻击方式","多使用技能攻击怪物，可以更快更安全的过关","按2次“A（←）”或者“D（→）”可以跑动，跑动中按“攻击”可以进行“跑攻”","注入“技能石”后，打怪时能量条会开始蓄气，满了之后按“N”可以发动怪物技能，2P按“PageDown”发动"];
      
      private var 滚动提示time:int = 135;
      
      public function Play_Interface()
      {
         var _loc1_:fpsBox = null;
         super();
         load_mc.visible = false;
         SaveLoadMC = new 游戏初始化();
         addChild(SaveLoadMC);
         SaveLoadMC.visible = false;
         interfaceX = this;
         if(Main.tiaoShiYN)
         {
            _loc1_ = new fpsBox();
            _loc1_.x = 75;
            _loc1_.y = 0;
            addChild(_loc1_);
         }
         info_mc.mouseChildren = info_mc.mouseEnabled = false;
         初始化技能图标();
         addEventListener(Event.ENTER_FRAME,onENTER_FRAME);
         Xbag_mc.addEventListener(MouseEvent.CLICK,bag_OPEN);
         Xfile_mc.addEventListener(MouseEvent.CLICK,File_OPEN);
         Xshop_mc.addEventListener(MouseEvent.CLICK,shop_OPEN);
         file_mc.addEventListener(MouseEvent.MOUSE_MOVE,画质提示开启);
         file_mc.addEventListener(MouseEvent.MOUSE_OUT,画质提示关闭);
         file_mc.A.addEventListener(MouseEvent.CLICK,画质);
         file_mc.C.addEventListener(MouseEvent.CLICK,画质);
         file_mc.A.gotoAndStop(1);
         file_mc.C.gotoAndStop(2);
         file_mc.addEventListener(MouseEvent.ROLL_OUT,系统菜单关闭);
         file_mc.visible = false;
         file_mc.gameStop_btn.addEventListener(MouseEvent.MOUSE_DOWN,游戏暂停);
         _Move_mc.renWuXX_mc.addEventListener(MouseEvent.MOUSE_DOWN,任务面板);
         CW_mc.addEventListener(MouseEvent.MOUSE_DOWN,CW面板);
         zb_1.addEventListener(MouseEvent.MOUSE_OVER,showOpen);
         zb_1.addEventListener(MouseEvent.MOUSE_OUT,showClose);
         zb_2.addEventListener(MouseEvent.MOUSE_OVER,showOpen2);
         zb_2.addEventListener(MouseEvent.MOUSE_OUT,showClose);
         _Move_mc.card_mc.addEventListener(MouseEvent.MOUSE_DOWN,卡片面板);
         _Move_mc.xingLing_btn.addEventListener(MouseEvent.MOUSE_DOWN,xingLing_Open);
         _Move_mc.vip_btn.addEventListener(MouseEvent.MOUSE_DOWN,vip_Open);
         _Move_mc.QianDao_btn.addEventListener(MouseEvent.MOUSE_DOWN,QianDaoFun);
         _Move_mc.jh_btn.addEventListener(MouseEvent.MOUSE_DOWN,jh_Open);
         _Move_mc.paiHang_Btn.addEventListener(MouseEvent.MOUSE_DOWN,PaiHang_Open);
         _Move_mc.jihua_mc.mouseEnabled = false;
         _Move_mc.jihua_mc.mouseChildren = false;
         TiShiShow(false);
         HuaZhiInit();
         _Move_mc.addEventListener(MouseEvent.MOUSE_MOVE,XOpen);
         _Move_mc.addEventListener(MouseEvent.MOUSE_OUT,XClose);
         Play1_mc.reXue.addEventListener(MouseEvent.MOUSE_DOWN,reXue1);
         Play2_mc.reXue.addEventListener(MouseEvent.MOUSE_DOWN,reXue2);
         zhuanZhi_btn.addEventListener(MouseEvent.CLICK,转职面板);
         Play1_mc["yuhuo1"].addEventListener(MouseEvent.MOUSE_OVER,tipOpen);
         Play1_mc["yuhuo1"].addEventListener(MouseEvent.MOUSE_OUT,tipClose);
         Play2_mc["yuhuo2"].addEventListener(MouseEvent.MOUSE_OVER,tipOpen);
         Play2_mc["yuhuo2"].addEventListener(MouseEvent.MOUSE_OUT,tipClose);
         yinCang_btn.addEventListener(MouseEvent.CLICK,YingCang1P2P);
         _Move_mc.tuijian_btn.addEventListener(MouseEvent.CLICK,TuiJianShop);
         jlNum_mc1.addEventListener(MouseEvent.MOUSE_MOVE,jlNum_mcShow1);
         jlNum_mc2.addEventListener(MouseEvent.MOUSE_MOVE,jlNum_mcShow2);
         jlNum_mc1.addEventListener(MouseEvent.MOUSE_OUT,jlNum_mc_out1);
         jlNum_mc2.addEventListener(MouseEvent.MOUSE_OUT,jlNum_mc_out2);
         duWu_btn.addEventListener(MouseEvent.MOUSE_DOWN,DuWu);
      }
      
      private static function ChunJie_Open(param1:*) : *
      {
         ChunJiePanel.open();
      }
      
      private static function chongZhi_Open(param1:*) : *
      {
         ChongZhi_Interface.Open();
      }
      
      private static function chongZhi_Open2(param1:*) : *
      {
         ChongZhi_Interface2.Open();
      }
      
      private static function teMai_Open(param1:*) : *
      {
         TeMaiPanel.open();
      }
      
      private static function Nian_Open(param1:*) : *
      {
         NewYear_Interface.Open();
      }
      
      private static function dengji_Open(param1:*) : *
      {
         if(Main.serverTime.getValue() < 20131219)
         {
            NewMC.Open("文字提示",Main._stage,470,400,30,0,true,2,"活动还未开始, 开放时间:12月19日~12月31日");
            return;
         }
         JiangLiPanel.open();
      }
      
      public static function WeiBoFaFang() : *
      {
         interfaceX.ShowWeiBoFaFang();
      }
      
      private static function HuoDong10_Fun(param1:*) : *
      {
         if(Main.serverTime.getValue() < 20131219)
         {
            NewMC.Open("文字提示",Main._stage,470,400,30,0,true,2,"活动还未开始, 开放时间:12月19日~12月31日");
            return;
         }
         FanPaiPanel.open();
      }
      
      private static function zhuanPan_Fun(param1:*) : *
      {
         ZhuanPan.Open();
      }
      
      public static function Open(param1:int = 0, param2:int = 0) : *
      {
         if(!interfaceX)
         {
            interfaceX = new Play_Interface();
         }
         interfaceX.初始化技能图标();
         Main._this.addChild(interfaceX);
         interfaceX.zhuanZhi_Fun();
         if(SixOne_Interface.okTimes.getValue() > 100 && SixOne_Interface.lingqu.getValue() == 0)
         {
            interfaceX.buCang_btn.visible = true;
            interfaceX.buCang_btn.addEventListener(MouseEvent.MOUSE_DOWN,buCang_Open);
         }
         if(Main.gameNum.getValue() == 0 && Main.gameNum2.getValue() != 1)
         {
            interfaceX.duWu_btn.visible = true;
            interfaceX.chongZhi_btn.visible = true;
            interfaceX.chongZhi_btn2.visible = true;
            interfaceX.Nian_btn.visible = true;
            interfaceX.teMai_btn.visible = true;
            interfaceX.chongZhi_btn.addEventListener(MouseEvent.MOUSE_DOWN,chongZhi_Open);
            interfaceX.chongZhi_btn2.addEventListener(MouseEvent.MOUSE_DOWN,chongZhi_Open2);
            interfaceX.Nian_btn.addEventListener(MouseEvent.MOUSE_DOWN,Nian_Open);
            interfaceX.teMai_btn.addEventListener(MouseEvent.MOUSE_DOWN,teMai_Open);
            if(Main.serverTime.getValue() >= 20140130)
            {
               interfaceX.chunJie_Btn.visible = true;
               interfaceX.chunJie_Btn.addEventListener(MouseEvent.MOUSE_DOWN,ChunJie_Open);
            }
            if(Main.serverTime.getValue() >= 20140206 && Main.serverTime.getValue() <= 20140214)
            {
               interfaceX.HuoDong10_btn.visible = true;
               interfaceX.HuoDong10_btn.addEventListener(MouseEvent.MOUSE_DOWN,HuoDong10_Fun);
            }
            if(Main.serverTime.getValue() >= 20140928 && Main.serverTime.getValue() <= 20141015)
            {
               interfaceX.zhuanPan_btn.visible = true;
               interfaceX.zhuanPan_btn.addEventListener(MouseEvent.MOUSE_DOWN,zhuanPan_Fun);
            }
            if(Main.serverTime.getValue() >= 20140530)
            {
               interfaceX.chongZhi_btn3.visible = true;
               interfaceX.chongZhi_btn3.addEventListener(MouseEvent.MOUSE_DOWN,LongZou);
            }
         }
         else
         {
            interfaceX.duWu_btn.visible = false;
            interfaceX.chongZhi_btn.visible = false;
            interfaceX.chongZhi_btn2.visible = false;
            interfaceX.Nian_btn.visible = false;
            interfaceX.teMai_btn.visible = false;
            TiaoShi.txtShow("隐藏按钮");
            interfaceX.teMai_btn.removeEventListener(MouseEvent.MOUSE_DOWN,teMai_Open);
            interfaceX.chongZhi_btn.removeEventListener(MouseEvent.MOUSE_DOWN,chongZhi_Open);
            interfaceX.chongZhi_btn2.removeEventListener(MouseEvent.MOUSE_DOWN,chongZhi_Open2);
            interfaceX.HuoDong10_btn.removeEventListener(MouseEvent.MOUSE_DOWN,HuoDong10_Fun);
            interfaceX.Nian_btn.removeEventListener(MouseEvent.MOUSE_DOWN,Nian_Open);
            interfaceX.chunJie_Btn.removeEventListener(MouseEvent.MOUSE_DOWN,ChunJie_Open);
         }
         interfaceX.black_guoDu_mc.gotoAndPlay(14);
         interfaceX.x = param1;
         interfaceX.y = param2;
         interfaceX.visible = true;
         BossLifeYN = false;
         ShowXX();
      }
      
      private static function buCang_Open(param1:*) : *
      {
         if(Main.player1.getBag().backOtherBagNum() > 0)
         {
            SixOne_Interface.lingqu.setValue(1);
            SixOneOK = true;
            SaveLoadMC.visible = true;
            interfaceX.buCang_btn.visible = false;
            Main.Save();
         }
         else
         {
            NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"背包其他栏空间不足");
         }
      }
      
      public static function getBuChang() : *
      {
         var _loc1_:Number = NaN;
         if(SixOneOK)
         {
            _loc1_ = Math.random() * 16;
            if(_loc1_ > 0 && _loc1_ < 3)
            {
               Main.player1.getBag().addOtherobjBag(OtherFactory.creatOther(63209));
            }
            else if(_loc1_ > 3 && _loc1_ < 6)
            {
               Main.player1.getBag().addOtherobjBag(OtherFactory.creatOther(63237));
            }
            else if(_loc1_ > 6 && _loc1_ < 7)
            {
               Main.player1.getBag().addOtherobjBag(OtherFactory.creatOther(63251));
            }
            else if(_loc1_ > 7 && _loc1_ < 10)
            {
               Main.player1.getBag().addOtherobjBag(OtherFactory.creatOther(63255));
            }
            else if(_loc1_ > 10 && _loc1_ < 11)
            {
               Main.player1.getBag().addOtherobjBag(OtherFactory.creatOther(63266));
            }
            else if(_loc1_ > 11 && _loc1_ < 12)
            {
               Main.player1.getBag().addOtherobjBag(OtherFactory.creatOther(63267));
            }
            else if(_loc1_ > 12 && _loc1_ < 15)
            {
               Main.player1.getBag().addOtherobjBag(OtherFactory.creatOther(63271));
            }
            else if(_loc1_ > 15 && _loc1_ < 16)
            {
               Main.player1.getBag().addOtherobjBag(OtherFactory.creatOther(63280));
            }
            SixOneOK = false;
            SaveLoadMC.visible = false;
         }
      }
      
      private static function LongZou(param1:*) : *
      {
         ChongZhi_Interface3.Open();
      }
      
      public static function Close() : *
      {
         if(!interfaceX)
         {
            interfaceX = new Play_Interface();
         }
         interfaceX.x = 5000;
         interfaceX.y = 5000;
         interfaceX.visible = false;
         BossLifeYN = false;
      }
      
      private static function ShowXX() : *
      {
         interfaceX._Move_mc.x = 0;
         showTimeNum = 60;
      }
      
      public static function WhoIsBoss(param1:Enemy) : *
      {
         bossIS = param1;
      }
      
      public static function jihuaTiShi(param1:Boolean = true) : *
      {
         if(!interfaceX)
         {
            return;
         }
         if(param1)
         {
            interfaceX._Move_mc.jihua_mc.visible = true;
         }
         else
         {
            interfaceX._Move_mc.jihua_mc.visible = false;
         }
      }
      
      public static function TiShiShow(param1:Boolean = true, param2:uint = 0) : *
      {
         var _loc3_:Class = null;
         var _loc4_:MovieClip = null;
         if(!interfaceX)
         {
            return;
         }
         if(param1)
         {
            interfaceX._Move_mc.RenWuTiShi_mc.visible = true;
            TaskPanel.TiShi_wanCeng();
         }
         else
         {
            interfaceX._Move_mc.RenWuTiShi_mc.visible = false;
            if(param2 == 110097)
            {
               TiaoShi.txtShow("过场.............");
               _loc3_ = SelMap.loadData.getClass("src.tool.XX_MC") as Class;
               _loc4_ = new _loc3_();
               Main._stage.addChild(_loc4_);
            }
         }
      }
      
      private function DuWu(param1:*) : *
      {
         DuWu_Interface.Open();
      }
      
      private function jlNum_mcShow1(param1:*) : *
      {
         if(Boolean(Main.player_1.playerJL) && Main.player1.playerJL_Data.getSKILL3() > 0)
         {
            info_mc2._txt.text = SkillFactory.getSkillById(Main.player1.playerJL_Data.getSKILL3()).getIntroduction();
            info_mc2.visible = true;
            info_mc2.x = mouseX + 5;
            info_mc2.y = mouseY + 5;
         }
         else
         {
            info_mc2._txt.text = "召唤精灵无主动圣物或未召唤精灵";
            info_mc2.visible = true;
            info_mc2.x = mouseX + 5;
            info_mc2.y = mouseY + 5;
         }
      }
      
      private function jlNum_mcShow2(param1:*) : *
      {
         if(Boolean(Main.player_2.playerJL) && Main.player2.playerJL_Data.getSKILL3() > 0)
         {
            info_mc2._txt.text = SkillFactory.getSkillById(Main.player2.playerJL_Data.getSKILL3()).getIntroduction();
            info_mc2.visible = true;
            info_mc2.x = mouseX + 5;
            info_mc2.y = mouseY + 5;
         }
         else
         {
            info_mc2._txt.text = "召唤精灵无主动圣物或未召唤精灵";
            info_mc2.visible = true;
            info_mc2.x = mouseX + 5;
            info_mc2.y = mouseY + 5;
         }
      }
      
      private function jlNum_mc_out1(param1:*) : *
      {
         info_mc2.visible = false;
      }
      
      private function jlNum_mc_out2(param1:*) : *
      {
         info_mc2.visible = false;
      }
      
      private function reXue1(param1:*) : *
      {
      }
      
      private function reXue2(param1:*) : *
      {
      }
      
      private function PaiHang_Open(param1:*) : *
      {
         TiaoZhanPaiHang_Interface.Open();
      }
      
      private function ShowWeiBoFaFang() : *
      {
         var _loc1_:XML = null;
         var _loc2_:String = null;
         var _loc3_:uint = 0;
         var _loc4_:String = null;
         var _loc5_:String = null;
         if(TeShuHuoDong.TeShuHuoDongArr[19])
         {
            weiBo_btn.x = weiBo_btn.y = -5000;
         }
         else
         {
            myXml = XMLAsset.createXML(Play_Interface.data);
            for each(_loc1_ in myXml.奖励发放)
            {
               _loc2_ = String(_loc1_.用户账号);
               _loc3_ = uint(_loc1_.存档序号);
               _loc4_ = Main.logName.toLocaleLowerCase();
               _loc5_ = _loc2_.toLocaleLowerCase();
               if(_loc4_ == _loc5_ && Main.saveNum + 1 == _loc3_)
               {
                  weiBo_btn.x = 470;
                  weiBo_btn.y = 250;
                  weiBo_btn.addEventListener(MouseEvent.CLICK,WeiBoFaFang);
               }
            }
         }
      }
      
      private function WeiBoFaFang(param1:*) : *
      {
         var _loc2_:int = 60000 + InitData.BuyNum_0.getValue();
         if(TeShuHuoDong.TeShuHuoDongArr[19])
         {
            NewMC.Open("文字提示",this,470,420,30,0,true,2,"已经领取过");
         }
         else if(Main.player1.getBag().backOtherBagNum() < 2)
         {
            NewMC.Open("文字提示",this,400,400,30,0,true,2,"其他类背包空间不足!");
         }
         else
         {
            Main.player1.getBag().addOtherobjBag(OtherFactory.creatOther(_loc2_ + 3251));
            Main.player1.getBag().addOtherobjBag(OtherFactory.creatOther(_loc2_ + 3245));
            ++TeShuHuoDong.TeShuHuoDongArr[19];
            NewMC.Open("文字提示",this,470,420,90,0,true,2,"微博活动奖励领取成功!");
            weiBo_btn.x = weiBo_btn.y = -5000;
            weiBo_btn.removeEventListener(MouseEvent.CLICK,WeiBoFaFang);
         }
      }
      
      private function tipOpen(param1:*) : *
      {
         yhcs_txt.visible = true;
         yhcs_txt.x = mouseX + 5;
         yhcs_txt.y = mouseY + 5;
      }
      
      private function tipClose(param1:*) : *
      {
         yhcs_txt.visible = false;
      }
      
      private function QianDaoFun(param1:*) : *
      {
         QianDao.Open();
      }
      
      private function xingLing_Open(param1:*) : *
      {
         XingLing_Interface.Open();
      }
      
      private function vip_Open(param1:*) : *
      {
         Vip_Interface.Open();
      }
      
      private function jh_Open(param1:*) : *
      {
         JiHua_Interface.Open();
      }
      
      private function zbP1P2() : *
      {
         zb_1.visible = false;
         zb_2.visible = false;
         if(Main.Map0_YN2)
         {
            if(Main.player_1.visible)
            {
               zb_1.visible = true;
            }
            if(Boolean(Main.P1P2) && Boolean(Main.player_2.visible))
            {
               zb_2.visible = true;
            }
            if(Main.water.getValue() != 1)
            {
               zb_1.gotoAndStop(1);
               zb_2.gotoAndStop(1);
            }
            else
            {
               zb_1.gotoAndStop(2);
               zb_2.gotoAndStop(2);
            }
         }
      }
      
      private function showOpen(param1:*) : *
      {
         var _loc4_:int = 0;
         var _loc5_:SuitToolShow = null;
         var _loc6_:ItemsTooltip = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc2_:Number = 0;
         var _loc3_:int = 0;
         allTooltip = new MovieClip();
         addChild(allTooltip);
         allTooltip.x = mouseX;
         allTooltip.y = mouseY;
         if(Main.water.getValue() != 1)
         {
            _loc4_ = 0;
            while(_loc4_ < 4)
            {
               _loc5_ = new SuitToolShow();
               _loc6_ = new ItemsTooltip();
               _loc7_ = _loc4_;
               if(_loc7_ >= 2)
               {
                  _loc7_++;
               }
               if(Main.player1.getEquipSlot().getEquipFromSlot(_loc7_) != null)
               {
                  _loc2_ += Main.player1.getEquipSlot().getEquipFromSlot(_loc7_).getSuitId();
                  _loc6_.equipTooltipSP(Main.player1.getEquipSlot().getEquipFromSlot(_loc7_),1);
                  allTooltip.addChild(_loc6_);
                  _loc6_.x = _loc3_ * 188;
                  _loc3_++;
               }
               if(_loc3_ == 4 && _loc2_ > 0)
               {
                  if(_loc2_ / 4 == Main.player1.getEquipSlot().getEquipFromSlot(_loc7_).getSuitId())
                  {
                     _loc5_.suitTooltipShow(Main.player1.getEquipSlot().getEquipFromSlot(_loc7_).getSuitId());
                     allTooltip.addChild(_loc5_);
                     _loc5_.x = _loc3_ * 188;
                  }
               }
               _loc4_++;
            }
         }
         else
         {
            _loc8_ = 8;
            while(_loc8_ < 12)
            {
               _loc5_ = new SuitToolShow();
               _loc6_ = new ItemsTooltip();
               _loc7_ = _loc8_;
               if(_loc7_ >= 10)
               {
                  _loc7_++;
               }
               if(Main.player1.getEquipSlot().getEquipFromSlot(_loc7_) != null)
               {
                  _loc2_ += Main.player1.getEquipSlot().getEquipFromSlot(_loc7_).getSuitId();
                  _loc6_.equipTooltipSP(Main.player1.getEquipSlot().getEquipFromSlot(_loc7_),1);
                  allTooltip.addChild(_loc6_);
                  _loc6_.x = _loc3_ * 188;
                  _loc3_++;
               }
               if(_loc3_ == 4 && _loc2_ > 0)
               {
                  if(_loc2_ / 4 == Main.player1.getEquipSlot().getEquipFromSlot(_loc7_).getSuitId())
                  {
                     _loc5_.suitTooltipShow(Main.player1.getEquipSlot().getEquipFromSlot(_loc7_).getSuitId());
                     allTooltip.addChild(_loc5_);
                     _loc5_.x = _loc3_ * 188;
                  }
               }
               _loc8_++;
            }
         }
         allTooltip.visible = true;
      }
      
      private function showClose(param1:*) : *
      {
         allTooltip.visible = false;
      }
      
      private function showOpen2(param1:*) : *
      {
         var _loc4_:int = 0;
         var _loc5_:SuitToolShow = null;
         var _loc6_:ItemsTooltip = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc2_:Number = 0;
         var _loc3_:int = 1;
         allTooltip = new MovieClip();
         addChild(allTooltip);
         allTooltip.x = mouseX;
         allTooltip.y = mouseY;
         if(Main.water.getValue() != 1)
         {
            _loc4_ = 0;
            while(_loc4_ < 4)
            {
               _loc5_ = new SuitToolShow();
               _loc6_ = new ItemsTooltip();
               _loc7_ = _loc4_;
               if(_loc7_ >= 2)
               {
                  _loc7_++;
               }
               if(Main.player2.getEquipSlot().getEquipFromSlot(_loc7_) != null)
               {
                  _loc2_ += Main.player2.getEquipSlot().getEquipFromSlot(_loc7_).getSuitId();
                  _loc6_.equipTooltipSP(Main.player2.getEquipSlot().getEquipFromSlot(_loc7_),1);
                  allTooltip.addChild(_loc6_);
                  _loc6_.x -= _loc3_ * 188;
                  _loc3_++;
               }
               TiaoShi.txtShow("suitID = " + _loc2_ / 4 + "," + Main.player2.getEquipSlot().getEquipFromSlot(_loc7_).getSuitId());
               if(_loc3_ == 5 && _loc2_ > 0)
               {
                  if(_loc2_ / 4 == Main.player2.getEquipSlot().getEquipFromSlot(_loc7_).getSuitId())
                  {
                     _loc5_.suitTooltipShow(Main.player2.getEquipSlot().getEquipFromSlot(_loc7_).getSuitId());
                     allTooltip.addChild(_loc5_);
                     _loc5_.x -= _loc3_ * 188;
                  }
               }
               _loc4_++;
            }
         }
         else
         {
            _loc8_ = 8;
            while(_loc8_ < 12)
            {
               _loc5_ = new SuitToolShow();
               _loc6_ = new ItemsTooltip();
               _loc7_ = _loc8_;
               if(_loc7_ >= 10)
               {
                  _loc7_++;
               }
               if(Main.player2.getEquipSlot().getEquipFromSlot(_loc7_) != null)
               {
                  _loc2_ += Main.player2.getEquipSlot().getEquipFromSlot(_loc7_).getSuitId();
                  _loc6_.equipTooltipSP(Main.player2.getEquipSlot().getEquipFromSlot(_loc7_),1);
                  allTooltip.addChild(_loc6_);
                  _loc6_.x -= _loc3_ * 188;
                  _loc3_++;
               }
               if(_loc3_ == 5 && _loc2_ > 0)
               {
                  if(_loc2_ / 4 == Main.player2.getEquipSlot().getEquipFromSlot(_loc7_).getSuitId())
                  {
                     _loc5_.suitTooltipShow(Main.player2.getEquipSlot().getEquipFromSlot(_loc7_).getSuitId());
                     allTooltip.addChild(_loc5_);
                     _loc5_.x -= _loc3_ * 188;
                  }
               }
               _loc8_++;
            }
         }
         allTooltip.visible = true;
      }
      
      public function HuaZhiInit() : *
      {
         file_mc.A.gotoAndStop(2);
         file_mc.C.gotoAndStop(2);
         if(huaZhi == 1)
         {
            Main._stage.quality = StageQuality.HIGH;
            file_mc.A.gotoAndStop(1);
         }
         else if(huaZhi == 2)
         {
            Main._stage.quality = StageQuality.LOW;
            file_mc.C.gotoAndStop(1);
         }
      }
      
      private function 卡片面板(param1:*) : *
      {
         CardPanel.open();
      }
      
      private function 游戏暂停(param1:*) : *
      {
         var _loc2_:GameStop = new GameStop();
      }
      
      private function onENTER_FRAME(param1:*) : *
      {
         Boss血条();
         玩家状态();
         连击计数();
         Cd计数();
         怪物技能计数();
         滚动提示();
         ShopObjTime_Show();
         Pk_mc();
         Go_mc();
         zbP1P2();
         if(showTimeNum > 0 && !Play_Interface.OpenYN && Main.gameNum.getValue() != 0)
         {
            --showTimeNum;
            if(interfaceX._Move_mc.x > -60)
            {
               --interfaceX._Move_mc.x;
            }
         }
         NewBag();
         if(Boolean(Main.P1P2) && Main.gameNum.getValue() == 0)
         {
            yinCang_btn.visible = true;
         }
         else
         {
            yinCang_btn.visible = false;
         }
      }
      
      private function YingCang1P2P(param1:*) : *
      {
         YinCang.Open();
      }
      
      private function TuiJianShop(param1:*) : *
      {
         TuiJianPanel.open();
      }
      
      private function QuanSouInfo() : *
      {
         if(Main.newPlay == 3)
         {
            openBag_mc.x = 380;
            openBag_mc.y = 465;
         }
         else
         {
            openBag_mc.x = openBag_mc.y = -5000;
         }
      }
      
      private function NewBag() : *
      {
         if(Main.newPlay == 3)
         {
            openBag_mc.x = 380;
            openBag_mc.y = 465;
         }
         else
         {
            openBag_mc.x = openBag_mc.y = -5000;
         }
      }
      
      private function XOpen(param1:*) : *
      {
         OpenYN = true;
         Play_Interface.ShowXX();
      }
      
      private function XClose(param1:*) : *
      {
         OpenYN = false;
      }
      
      private function Go_mc() : *
      {
         if(!Main.world.stopYn && Main.gameNum.getValue() > 50 && Main.gameNum.getValue() < 81)
         {
            gogogo_mc.visible = true;
         }
         else
         {
            gogogo_mc.visible = false;
         }
      }
      
      private function Pk_mc() : *
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         if(PK_UI.PK_ing)
         {
            _PK_time_mc.visible = true;
            if(uint(PK_UI.Pk_timeNum / 27 % 60) < 10)
            {
               _PK_time_mc._time_txt.text = uint(PK_UI.Pk_timeNum / 27 / 60) + ":0" + uint(PK_UI.Pk_timeNum / 27 % 60);
            }
            else
            {
               _PK_time_mc._time_txt.text = uint(PK_UI.Pk_timeNum / 27 / 60) + ":" + uint(PK_UI.Pk_timeNum / 27 % 60);
            }
            _loc1_ = PK_UI.killNum70up.getValue() + PK_UI.killNum70down.getValue();
            _PK_time_mc._kill_txt.text = _loc1_;
            if(PK_UI.playerTime == 0)
            {
               _PK_time_mc.time3_mc.gotoAndStop("x0");
            }
            else
            {
               _loc2_ = (PK_UI.playerTime + 26) / 27;
               _PK_time_mc.time3_mc.gotoAndStop("x" + _loc2_);
            }
         }
         else
         {
            _PK_time_mc.visible = false;
         }
      }
      
      private function 初始化技能图标() : *
      {
         var _loc1_:String = "";
         if(Main.player1.skinArr[Main.player1.skinNum] == 0)
         {
            _loc1_ = "a";
         }
         else if(Main.player1.skinArr[Main.player1.skinNum] == 1)
         {
            _loc1_ = "b";
         }
         else
         {
            _loc1_ = "c";
         }
         i = 8;
         while(i < 16)
         {
            Play1_mc["p_" + i]["p_mc"].gotoAndStop(_loc1_ + "" + i);
            ++i;
         }
         if(Boolean(Main.player2) && Boolean(Main.player_2))
         {
            if(Main.player2.skinArr[Main.player2.skinNum] == 0)
            {
               _loc1_ = "a";
            }
            else if(Main.player2.skinArr[Main.player2.skinNum] == 1)
            {
               _loc1_ = "b";
            }
            else
            {
               _loc1_ = "c";
            }
            i = 8;
            while(i < 16)
            {
               Play2_mc["p_" + i]["p_mc"].gotoAndStop(_loc1_ + "" + i);
               ++i;
            }
         }
      }
      
      private function Boss血条() : *
      {
         if(Boolean(bossIS) && BossLifeYN)
         {
            BossLife_mc.visible = true;
            BossLife_mc.touXiang.gotoAndStop("a" + bossIS.id);
            if(bossIS.life.getValue() > 0)
            {
               BossLife_mc.life_mc.Start(bossIS);
            }
         }
         else
         {
            BossLife_mc.visible = false;
            BossLife_mc.life_mc.Stop();
         }
      }
      
      private function 怪物技能计数() : *
      {
         if(Boolean(Main.player1) && Boolean(Main.player_1))
         {
            if(this.Play1_mc.guaiWu.currentFrame != Main.player_1.energySlot.getEnergyPer(Main.player_1))
            {
               this.Play1_mc.guaiWu.gotoAndStop(Main.player_1.energySlot.getEnergyPer(Main.player_1));
            }
         }
         if(Boolean(Main.P1P2) && Boolean(Main.player2) && Boolean(Main.player_2))
         {
            if(this.Play2_mc.guaiWu.currentFrame != Main.player_2.energySlot.getEnergyPer(Main.player_2))
            {
               this.Play2_mc.guaiWu.gotoAndStop(Main.player_2.energySlot.getEnergyPer(Main.player_2));
            }
         }
      }
      
      private function 玩家状态() : *
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         Play2_mc.head_mc.visible = false;
         if(Main.player_1)
         {
            _loc1_ = Math.round(Main.player_1.hp.getValue());
            _loc2_ = Math.round(Main.player_1.use_hp_Max.getValue());
            _loc3_ = int(Main.player_1.mp.getValue());
            _loc4_ = int(Main.player_1.use_mp_Max.getValue());
            _loc5_ = int(Main.player_1.data.getEXP());
            _loc6_ = int(Main.player_1.nextExp.getValue());
            _loc7_ = 100 - _loc1_ / _loc2_ * 100;
            _loc8_ = 100 - _loc3_ / _loc4_ * 100;
            _loc9_ = int(Main.player_1.data.getLevel());
            _loc10_ = Main.player_1.data.getEXP() / Main.player_1.nextExp.getValue() * 100;
            _loc11_ = int(Main.player_1.headFrame);
            if(_loc3_ == 1)
            {
               _loc3_ = 0;
            }
            Play1_mc.hp_txt.text = _loc1_ + "/" + _loc2_;
            Play1_mc.mp_txt.text = _loc3_ + "/" + _loc4_;
            Play1_mc.exp_txt.text = _loc5_ + "/" + _loc6_;
            Play1_mc.hp_mc.load_mc.scaleX = 1 - _loc7_ / 100;
            Play1_mc.mp_mc.load_mc.scaleX = 1 - _loc8_ / 100;
            showLV(_loc9_,1);
            Play1_mc.exp_mc.gotoAndStop(_loc10_);
            Play1_mc.head_mc.gotoAndStop(_loc11_);
            if(Main.player_1.zhongqiuState > 0)
            {
               Play1_mc["zhongqiu1"].visible = true;
            }
            else
            {
               Play1_mc["zhongqiu1"].visible = false;
            }
            if(Main.player_1.jianrenState > 0)
            {
               Play1_mc["jianren1"].visible = true;
            }
            else
            {
               Play1_mc["jianren1"].visible = false;
            }
            if(Main.player1.buffNine[0] > 0)
            {
               Play1_mc["yuhuo1"].visible = true;
               showYHCS1();
            }
            else
            {
               Play1_mc["yuhuo1"].visible = false;
            }
         }
         if(Main.P1P2)
         {
            _loc1_ = Math.round(Main.player_2.hp.getValue());
            _loc2_ = Math.round(Main.player_2.use_hp_Max.getValue());
            _loc3_ = int(Main.player_2.mp.getValue());
            _loc4_ = int(Main.player_2.use_mp_Max.getValue());
            _loc5_ = int(Main.player_2.data.getEXP());
            _loc6_ = int(Main.player_2.nextExp.getValue());
            _loc7_ = 100 - _loc1_ / _loc2_ * 100;
            _loc8_ = 100 - _loc3_ / _loc4_ * 100;
            _loc9_ = int(Main.player_2.data.getLevel());
            _loc10_ = Main.player_2.data.getEXP() / Main.player_2.nextExp.getValue() * 100;
            _loc11_ = int(Main.player_2.headFrame);
            if(_loc3_ == 1)
            {
               _loc3_ = 0;
            }
            Play2_mc.hp_txt.text = _loc1_ + "/" + _loc2_;
            Play2_mc.mp_txt.text = _loc3_ + "/" + _loc4_;
            Play2_mc.exp_txt.text = _loc5_ + "/" + _loc6_;
            Play2_mc.hp_mc.load_mc.scaleX = 1 - _loc7_ / 100;
            Play2_mc.mp_mc.load_mc.scaleX = 1 - _loc8_ / 100;
            showLV(_loc9_,2);
            Play2_mc.exp_mc.gotoAndStop(_loc10_);
            Play2_mc.head_mc.gotoAndStop(_loc11_);
            Play2_mc.head_mc.visible = true;
            if(Main.player_2.zhongqiuState > 0)
            {
               Play2_mc["zhongqiu2"].visible = true;
            }
            else
            {
               Play2_mc["zhongqiu2"].visible = false;
            }
            if(Main.player_2.jianrenState > 0)
            {
               Play2_mc["jianren2"].visible = true;
            }
            else
            {
               Play2_mc["jianren2"].visible = false;
            }
            if(Main.player2.buffNine[0] > 0)
            {
               Play2_mc["yuhuo2"].visible = true;
               showYHCS2();
            }
            else
            {
               Play2_mc["yuhuo2"].visible = false;
            }
         }
         Play1_mc.visible = Play2_mc.visible = true;
         jlNum_mc_X1.visible = jlNum_mc_X2.visible = true;
         jlNum_mc1.visible = jlNum_mc2.visible = true;
         jlNum_txt1.visible = jlNum_txt2.visible = true;
         if(!Main.player_1.visible)
         {
            Play1_mc.visible = false;
            jlNum_mc_X1.visible = false;
            jlNum_mc1.visible = false;
            jlNum_txt1.visible = false;
         }
         if(Boolean(Main.P1P2) && !Main.player_2.visible)
         {
            Play2_mc.visible = false;
            jlNum_mc_X2.visible = false;
            jlNum_mc2.visible = false;
            jlNum_txt2.visible = false;
         }
         if(!Main.P1P2)
         {
            Play2_mc.visible = false;
            jlNum_mc_X2.visible = false;
            jlNum_mc2.visible = false;
            jlNum_txt2.visible = false;
         }
      }
      
      private function showLV(param1:Number, param2:int) : *
      {
         var _loc3_:String = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         if(param1 < 10)
         {
            this["Play" + param2 + "_mc"]["level_1_mc"].gotoAndStop(param1);
            this["Play" + param2 + "_mc"]["level_2_mc"].visible = false;
         }
         else
         {
            this["Play" + param2 + "_mc"]["level_2_mc"].visible = true;
            _loc3_ = param1.toString();
            _loc4_ = int(_loc3_.substring(0,1));
            _loc5_ = int(_loc3_.substring(1,2));
            this["Play" + param2 + "_mc"]["level_1_mc"].gotoAndStop(_loc4_);
            if(_loc5_ == 0)
            {
               this["Play" + param2 + "_mc"]["level_2_mc"].gotoAndStop(10);
            }
            else
            {
               this["Play" + param2 + "_mc"]["level_2_mc"].gotoAndStop(_loc5_);
            }
         }
      }
      
      private function 连击计数() : *
      {
         if(Boolean(Main.player1) && Boolean(Main.player_1))
         {
            if(templianJiNum[0] != Main.player_1.lianJi.getValue() && Main.player_1.lianJi.getValue() != 0)
            {
               templianJiNum[0] = Main.player_1.lianJi.getValue();
               ShowLianJi(1,templianJiNum[0]);
            }
            if(Main.player_1.lianjiBool)
            {
               if(Main.player_1.lianJiTime.getValue() < 87)
               {
                  this["Play1_mc"]["LianJi_mc"].visible = true;
               }
               else
               {
                  this["Play1_mc"]["LianJi_mc"].visible = false;
               }
            }
            else if(Main.player_1.lianJiTime.getValue() < 60)
            {
               this["Play1_mc"]["LianJi_mc"].visible = true;
            }
            else
            {
               this["Play1_mc"]["LianJi_mc"].visible = false;
            }
         }
         if(Boolean(Main.P1P2) && Boolean(Main.player2) && Boolean(Main.player_2))
         {
            if(templianJiNum[1] != Main.player_2.lianJi.getValue() && Main.player_2.lianJi.getValue() != 0)
            {
               templianJiNum[1] = Main.player_2.lianJi.getValue();
               ShowLianJi(2,templianJiNum[1]);
            }
            if(Main.player_2.lianjiBool)
            {
               if(Main.player_2.lianJiTime.getValue() < 87)
               {
                  this["Play2_mc"]["LianJi_mc"].visible = true;
               }
               else
               {
                  this["Play2_mc"]["LianJi_mc"].visible = false;
               }
            }
            else if(Main.player_2.lianJiTime.getValue() < 60)
            {
               this["Play2_mc"]["LianJi_mc"].visible = true;
            }
            else
            {
               this["Play2_mc"]["LianJi_mc"].visible = false;
            }
         }
      }
      
      private function ShowLianJi(param1:int, param2:int) : *
      {
         var _loc5_:int = 0;
         this["Play" + param1 + "_mc"]["LianJi_mc"]["A_1"].visible = this["Play" + param1 + "_mc"]["LianJi_mc"]["A_2"].visible = this["Play" + param1 + "_mc"]["LianJi_mc"]["A_3"].visible = this["Play" + param1 + "_mc"]["LianJi_mc"]["A_4"].visible = false;
         var _loc3_:String = String(param2);
         var _loc4_:* = _loc3_.length;
         if(param2 <= 0)
         {
            return;
         }
         while(_loc4_)
         {
            _loc5_ = int(_loc3_.substr(_loc4_ - 1,1));
            this["Play" + param1 + "_mc"]["LianJi_mc"]["A_" + _loc4_].visible = true;
            if(_loc5_ == 0)
            {
               this["Play" + param1 + "_mc"]["LianJi_mc"]["A_" + _loc4_].gotoAndStop(10);
            }
            else
            {
               this["Play" + param1 + "_mc"]["LianJi_mc"]["A_" + _loc4_].gotoAndStop(_loc5_);
            }
            _loc4_--;
         }
      }
      
      private function Cd计数() : *
      {
         var _loc1_:String = null;
         var _loc2_:int = 0;
         var _loc3_:String = null;
         var _loc4_:int = 0;
         var _loc5_:Supplies = null;
         var _loc6_:String = null;
         初始化技能图标();
         if(Boolean(Main.player1) && Boolean(Main.player_1))
         {
            if(Main.player1.skinArr[Main.player1.skinNum] == 0)
            {
               _loc1_ = "a";
            }
            else if(Main.player1.skinArr[Main.player1.skinNum] == 1)
            {
               _loc1_ = "b";
            }
            else
            {
               _loc1_ = "c";
            }
            _loc2_ = 8;
            while(_loc2_ < 16)
            {
               _loc3_ = _loc1_ + String(_loc2_);
               _loc4_ = int(Main.player_1.selCD50(_loc3_));
               Play1_mc["p_" + _loc2_]["X50"].gotoAndStop(_loc4_);
               _loc2_++;
            }
         }
         if(Boolean(Main.player2) && Boolean(Main.player_2))
         {
            if(Main.player2.skinArr[Main.player2.skinNum] == 0)
            {
               _loc1_ = "a";
            }
            else if(Main.player2.skinArr[Main.player2.skinNum] == 1)
            {
               _loc1_ = "b";
            }
            else
            {
               _loc1_ = "c";
            }
            _loc2_ = 8;
            while(_loc2_ < 16)
            {
               _loc3_ = _loc1_ + String(_loc2_);
               _loc4_ = int(Main.player_2.selCD50(_loc3_));
               Play2_mc["p_" + _loc2_]["X50"].gotoAndStop(_loc4_);
               _loc2_++;
            }
         }
         if(Boolean(Main.player1) && Boolean(Main.player_1))
         {
            _loc2_ = 0;
            while(_loc2_ < 3)
            {
               _loc5_ = Main.player_1.data.getSuppliesSlot().getFromSuppliesSlot(_loc2_);
               if(_loc5_)
               {
                  _loc6_ = _loc5_.getName();
                  _loc4_ = int(Main.player_1.sel_objCD50(_loc6_));
                  Play1_mc["obj_" + _loc2_]["X50"].gotoAndStop(_loc4_);
                  Play1_mc["obj_" + _loc2_]["pic_mc"].gotoAndStop(Main.player1.getSuppliesSlot().getFromSuppliesSlot(_loc2_).getFrame());
                  Play1_mc["obj_" + _loc2_]["num_txt"].text = Main.player1.getSuppliesSlot().getNumFromSuppliesSlot(Main.player1.getBag(),_loc2_);
               }
               _loc2_++;
            }
         }
         if(Boolean(Main.player2) && Boolean(Main.player_2))
         {
            _loc2_ = 0;
            while(_loc2_ < 3)
            {
               _loc5_ = Main.player_2.data.getSuppliesSlot().getFromSuppliesSlot(_loc2_);
               if(_loc5_)
               {
                  _loc6_ = _loc5_.getName();
                  _loc4_ = int(Main.player_2.sel_objCD50(_loc6_));
                  Play2_mc["obj_" + _loc2_]["X50"].gotoAndStop(_loc4_);
                  Play2_mc["obj_" + _loc2_]["pic_mc"].gotoAndStop(Main.player2.getSuppliesSlot().getFromSuppliesSlot(_loc2_).getFrame());
                  Play2_mc["obj_" + _loc2_]["num_txt"].text = Main.player2.getSuppliesSlot().getNumFromSuppliesSlot(Main.player2.getBag(),_loc2_);
               }
               _loc2_++;
            }
         }
      }
      
      private function bag_OPEN(param1:*) : *
      {
         ItemsPanel.OpenFrist = true;
         ItemsPanel.open();
      }
      
      private function shop_OPEN(param1:*) : *
      {
         Shop4399.Open();
      }
      
      private function 系统菜单关闭(param1:* = null) : *
      {
         file_mc.visible = false;
      }
      
      private function 画质(param1:MouseEvent) : *
      {
         file_mc.A.gotoAndStop(2);
         file_mc.C.gotoAndStop(2);
         if(param1.currentTarget.name == "A")
         {
            Main._stage.quality = StageQuality.HIGH;
            file_mc.A.gotoAndStop(1);
            huaZhi = 1;
         }
         else if(param1.currentTarget.name == "C")
         {
            Main._stage.quality = StageQuality.LOW;
            file_mc.C.gotoAndStop(1);
            huaZhi = 2;
         }
      }
      
      private function 转职面板(param1:*) : *
      {
         SetTransferPanel.open();
      }
      
      private function File_OPEN(param1:*) : *
      {
         if(file_mc.visible == false)
         {
            file_mc.visible = true;
            file_mc.key_mc.addEventListener(MouseEvent.CLICK,键位);
            file_mc.save_mc.addEventListener(MouseEvent.CLICK,保存);
            file_mc.city_mc.addEventListener(MouseEvent.CLICK,回城);
         }
         else
         {
            file_mc.visible = false;
         }
      }
      
      private function 键位(param1:*) : *
      {
         SetKeyPanel.open();
         系统菜单关闭();
      }
      
      private function 回城(param1:*) : *
      {
         Load.loadGameNum = 1;
         Load.loadGameNum2 = 1;
         Main.gameNum.setValue(0);
         Main.gameNum2.setValue(0);
         Main._this.Loading();
         Player.一起信春哥();
         系统菜单关闭();
         AchData.gkOk();
         TaskData.isOk();
         WinShow.All_0();
         PaiHang_Data.All_0();
      }
      
      private function 保存(param1:*) : *
      {
         if(saveTime <= 0)
         {
            Main.Save();
            saveTime = 800;
            系统菜单关闭();
            addEventListener(Event.ENTER_FRAME,onTime);
         }
      }
      
      private function onTime(param1:*) : *
      {
         if(saveTime > 0)
         {
            --saveTime;
         }
         else
         {
            removeEventListener(Event.ENTER_FRAME,onTime);
         }
         file_mc.time_txt.text = int(saveTime / 27);
      }
      
      private function 画质提示开启(param1:*) : *
      {
         画质提示_mc.x = 画质提示_mc.y = -5000;
      }
      
      private function 画质提示关闭(param1:*) : *
      {
         画质提示_mc.x = 画质提示_mc.y = -5000;
      }
      
      private function ShopObjTime_Show() : *
      {
         if(InitData.EXPxTime.getValue() > 0)
         {
            EXPxTime_mc.x = EXPxTime_mc.y = 0;
            EXPxTime_mc.t1_txt.text = TimeNum(InitData.EXPxTime.getValue());
         }
         else
         {
            EXPxTime_mc.x = EXPxTime_mc.y = 5000;
         }
         if(InitData.DOWNxTime.getValue() > 0)
         {
            DOWNxTime_mc.x = DOWNxTime_mc.y = 0;
            DOWNxTime_mc.t1_txt.text = TimeNum(InitData.DOWNxTime.getValue());
         }
         else
         {
            DOWNxTime_mc.x = DOWNxTime_mc.y = 5000;
         }
      }
      
      private function TimeNum(param1:int) : String
      {
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc2_:int = param1 / 3600;
         var _loc3_:int = (param1 - _loc2_ * 3600) / 60;
         var _loc4_:int = param1 - _loc2_ * 3600 - _loc3_ * 60;
         if(_loc3_ < 10)
         {
            _loc5_ = "0" + _loc3_;
         }
         else
         {
            _loc5_ = _loc3_;
         }
         if(_loc4_ < 10)
         {
            _loc6_ = "0" + _loc4_;
         }
         else
         {
            _loc6_ = _loc4_;
         }
         return _loc2_ + ":" + _loc5_ + ":" + _loc6_;
      }
      
      private function 滚动提示() : *
      {
         var _loc1_:int = 0;
         ++滚动提示time;
         if(滚动提示time % 135 == 0)
         {
            if(Main.gameNum.getValue() == 0)
            {
               info_mc.x = info_mc.y = 0;
               _loc1_ = Math.random() * infoArr0.length;
               info_mc._txt.text = infoArr0[_loc1_];
            }
            else if(Main.gameNum.getValue() == 1 && Main.gameNum2.getValue() != 5)
            {
               info_mc.x = info_mc.y = 0;
               _loc1_ = Math.random() * infoArr1.length;
               info_mc._txt.text = infoArr1[_loc1_];
            }
            else
            {
               info_mc.x = info_mc.y = 5000;
            }
         }
      }
      
      private function 任务面板(param1:*) : *
      {
         TaskPanel.open();
      }
      
      private function CW面板(param1:*) : *
      {
         NewPetPanel.open();
      }
      
      public function zhuanZhi_Fun() : *
      {
         zhuanZhi_btn.visible = false;
         var _loc1_:Boolean = false;
         var _loc2_:Boolean = false;
         if(Main.P1P2)
         {
            if(!SetTransferPanel.tbo1() || !SetTransferPanel.tbo2())
            {
               _loc2_ = true;
            }
         }
         else if(!SetTransferPanel.tbo1())
         {
            _loc2_ = true;
         }
         if(Main.P1P2)
         {
            if(_loc2_)
            {
               if(Boolean(Main.player_1) && Boolean(Main.player_2))
               {
                  if(!SetTransferPanel.tbo1() && !SetTransferPanel.tbo2())
                  {
                     if(Main.player1.getLevel() >= 25 || Main.player2.getLevel() >= 25)
                     {
                        _loc1_ = true;
                     }
                  }
                  else if(Boolean(SetTransferPanel.tbo1()) && !SetTransferPanel.tbo2())
                  {
                     if(Main.player2.getLevel() >= 25)
                     {
                        _loc1_ = true;
                     }
                  }
                  else if(Boolean(SetTransferPanel.tbo2()) && !SetTransferPanel.tbo1())
                  {
                     if(Main.player1.getLevel() >= 25)
                     {
                        _loc1_ = true;
                     }
                  }
               }
            }
         }
         else if(_loc2_)
         {
            if(Main.player_1)
            {
               if(Main.player1.getLevel() >= 25)
               {
                  _loc1_ = true;
               }
            }
         }
         if(_loc1_ && Main.gameNum.getValue() == 0)
         {
            zhuanZhi_btn.visible = true;
         }
      }
      
      public function showYHCS1() : *
      {
         var _loc1_:int = 0;
         if(Main.player1.buffNine[0] > 0)
         {
            Play1_mc["yuhuo1"].gotoAndStop(1);
            _loc1_ = int(Main.player1.buffNine[0]);
            yhcs_txt.title_txt.text = "狱焰：一层";
            yhcs_txt._txt.text = "经验值获得15%  ";
            yhcs_txt.time_txt.text = "剩余" + Math.floor(_loc1_ / 3600) + "小时" + Math.floor(_loc1_ % 3600 / 60) + "分" + _loc1_ % 3600 % 60 + "秒";
         }
         if(Main.player1.buffNine[1] > 0)
         {
            Play1_mc["yuhuo1"].gotoAndStop(2);
            _loc1_ = int(Main.player1.buffNine[1]);
            yhcs_txt.title_txt.text = "狱焰：二层";
            yhcs_txt._txt.text = "经验值获得15%   \n 防御力+10%   ";
            yhcs_txt.time_txt.text = "剩余" + Math.floor(_loc1_ / 3600) + "小时" + Math.floor(_loc1_ % 3600 / 60) + "分" + _loc1_ % 3600 % 60 + "秒";
         }
         if(Main.player1.buffNine[2] > 0)
         {
            Play1_mc["yuhuo1"].gotoAndStop(3);
            _loc1_ = int(Main.player1.buffNine[2]);
            yhcs_txt.title_txt.text = "狱焰：三层";
            yhcs_txt._txt.text = "经验值获得15%   \n 防御力+10%   \n 魔法值+10%  ";
            yhcs_txt.time_txt.text = "剩余" + Math.floor(_loc1_ / 3600) + "小时" + Math.floor(_loc1_ % 3600 / 60) + "分" + _loc1_ % 3600 % 60 + "秒";
         }
         if(Main.player1.buffNine[3] > 0)
         {
            Play1_mc["yuhuo1"].gotoAndStop(4);
            _loc1_ = int(Main.player1.buffNine[3]);
            yhcs_txt.title_txt.text = "狱焰：四层";
            yhcs_txt._txt.text = "经验值获得15%   \n 防御力+10%   \n 魔法值+10%   \n 生命值+10%  ";
            yhcs_txt.time_txt.text = "剩余" + Math.floor(_loc1_ / 3600) + "小时" + Math.floor(_loc1_ % 3600 / 60) + "分" + _loc1_ % 3600 % 60 + "秒";
         }
         if(Main.player1.buffNine[4] > 0)
         {
            Play1_mc["yuhuo1"].gotoAndStop(5);
            _loc1_ = int(Main.player1.buffNine[4]);
            yhcs_txt.title_txt.text = "狱焰：五层";
            yhcs_txt._txt.text = "经验值获得15%   \n 防御力+10%   \n 魔法值+10%   \n 生命值+10%   \n 攻击力+10%   ";
            yhcs_txt.time_txt.text = "剩余" + Math.floor(_loc1_ / 3600) + "小时" + Math.floor(_loc1_ % 3600 / 60) + "分" + _loc1_ % 3600 % 60 + "秒";
         }
         if(Main.player1.buffNine[5] > 0)
         {
            Play1_mc["yuhuo1"].gotoAndStop(6);
            _loc1_ = int(Main.player1.buffNine[5]);
            yhcs_txt.title_txt.text = "狱焰：六层";
            yhcs_txt._txt.text = "经验值获得15%   \n 防御力+10%   \n 魔法值+10%   \n 生命值+10%   \n 攻击力+10%    \n 移动速度+2   ";
            yhcs_txt.time_txt.text = "剩余" + Math.floor(_loc1_ / 3600) + "小时" + Math.floor(_loc1_ % 3600 / 60) + "分" + _loc1_ % 3600 % 60 + "秒";
         }
         if(Main.player1.buffNine[6] > 0)
         {
            Play1_mc["yuhuo1"].gotoAndStop(7);
            _loc1_ = int(Main.player1.buffNine[6]);
            yhcs_txt.title_txt.text = "狱焰：七层";
            yhcs_txt._txt.text = "经验值获得15%   \n 防御力+10%   \n 魔法值+10%   \n 生命值+10%   \n 攻击力+10%    \n 移动速度+2     \n 暴击+20%  ";
            yhcs_txt.time_txt.text = "剩余" + Math.floor(_loc1_ / 3600) + "小时" + Math.floor(_loc1_ % 3600 / 60) + "分" + _loc1_ % 3600 % 60 + "秒";
         }
         if(Main.player1.buffNine[7] > 0)
         {
            Play1_mc["yuhuo1"].gotoAndStop(8);
            _loc1_ = int(Main.player1.buffNine[7]);
            yhcs_txt.title_txt.text = "狱焰：八层";
            yhcs_txt._txt.text = "经验值获得15%   \n 防御力+10%   \n 魔法值+10%   \n 生命值+10%   \n 攻击力+10%    \n 移动速度+2     \n 暴击+20%   \n 魔抗+20%  ";
            yhcs_txt.time_txt.text = "剩余" + Math.floor(_loc1_ / 3600) + "小时" + Math.floor(_loc1_ % 3600 / 60) + "分" + _loc1_ % 3600 % 60 + "秒";
         }
         if(Main.player1.buffNine[8] > 0)
         {
            Play1_mc["yuhuo1"].gotoAndStop(9);
            _loc1_ = int(Main.player1.buffNine[8]);
            yhcs_txt.title_txt.text = "狱焰：九层";
            yhcs_txt._txt.text = "经验值获得15%   \n 防御力+10%   \n 魔法值+10%   \n 生命值+10%   \n 攻击力+10%    \n 移动速度+2     \n 暴击+20%   \n 魔抗+5%   \n 破魔+5%  ";
            yhcs_txt.time_txt.text = "剩余" + Math.floor(_loc1_ / 3600) + "小时" + Math.floor(_loc1_ % 3600 / 60) + "分" + _loc1_ % 3600 % 60 + "秒";
         }
         if(Main.player1.buffNine[9] > 0)
         {
            Play1_mc["yuhuo1"].gotoAndStop(10);
            _loc1_ = int(Main.player1.buffNine[9]);
            yhcs_txt.title_txt.text = "狱焰：十层";
            yhcs_txt._txt.text = "经验值获得30%   \n 防御力+20%   \n 魔法值+20%   \n 生命值+20%   \n 攻击力+20%    \n 移动速度+4     \n 暴击+30%   \n 魔抗+10%   \n 破魔+10% ";
            yhcs_txt.time_txt.text = "剩余" + Math.floor(_loc1_ / 3600) + "小时" + Math.floor(_loc1_ % 3600 / 60) + "分" + _loc1_ % 3600 % 60 + "秒";
            if(Main.player1.reBorn > 0)
            {
               yhcs_txt.time_txt.text += "\n重生冷却" + Math.floor(Main.player1.reBorn / 60) + "分" + Main.player1.reBorn % 60 + "秒";
            }
            yhcs_txt.cs_txt.visible = true;
         }
         else
         {
            yhcs_txt.cs_txt.visible = false;
         }
      }
      
      public function showYHCS2() : *
      {
         var _loc1_:int = 0;
         if(Main.player2.buffNine[0] > 0)
         {
            Play2_mc["yuhuo2"].gotoAndStop(1);
            _loc1_ = int(Main.player2.buffNine[0]);
            yhcs_txt.title_txt.text = "狱焰：一层";
            yhcs_txt._txt.text = "经验值获得15%  ";
            yhcs_txt.time_txt.text = "剩余" + Math.floor(_loc1_ / 3600) + "小时" + Math.floor(_loc1_ % 3600 / 60) + "分" + _loc1_ % 3600 % 60 + "秒";
         }
         if(Main.player2.buffNine[1] > 0)
         {
            Play2_mc["yuhuo2"].gotoAndStop(2);
            _loc1_ = int(Main.player2.buffNine[1]);
            yhcs_txt.title_txt.text = "狱焰：二层";
            yhcs_txt._txt.text = "经验值获得15%   \n 防御力+10%   ";
            yhcs_txt.time_txt.text = "剩余" + Math.floor(_loc1_ / 3600) + "小时" + Math.floor(_loc1_ % 3600 / 60) + "分" + _loc1_ % 3600 % 60 + "秒";
         }
         if(Main.player2.buffNine[2] > 0)
         {
            Play2_mc["yuhuo2"].gotoAndStop(3);
            _loc1_ = int(Main.player2.buffNine[2]);
            yhcs_txt.title_txt.text = "狱焰：三层";
            yhcs_txt._txt.text = "经验值获得15%   \n 防御力+10%   \n 魔法值+10%  ";
            yhcs_txt.time_txt.text = "剩余" + Math.floor(_loc1_ / 3600) + "小时" + Math.floor(_loc1_ % 3600 / 60) + "分" + _loc1_ % 3600 % 60 + "秒";
         }
         if(Main.player2.buffNine[3] > 0)
         {
            Play2_mc["yuhuo2"].gotoAndStop(4);
            _loc1_ = int(Main.player2.buffNine[3]);
            yhcs_txt.title_txt.text = "狱焰：四层";
            yhcs_txt._txt.text = "经验值获得15%   \n 防御力+10%   \n 魔法值+10%   \n 生命值+10%  ";
            yhcs_txt.time_txt.text = "剩余" + Math.floor(_loc1_ / 3600) + "小时" + Math.floor(_loc1_ % 3600 / 60) + "分" + _loc1_ % 3600 % 60 + "秒";
         }
         if(Main.player2.buffNine[4] > 0)
         {
            Play2_mc["yuhuo2"].gotoAndStop(5);
            _loc1_ = int(Main.player2.buffNine[4]);
            yhcs_txt.title_txt.text = "狱焰：五层";
            yhcs_txt._txt.text = "经验值获得15%   \n 防御力+10%   \n 魔法值+10%   \n 生命值+10%   \n 攻击力+10%   ";
            yhcs_txt.time_txt.text += "剩余" + Math.floor(_loc1_ / 3600) + "小时" + Math.floor(_loc1_ % 3600 / 60) + "分" + _loc1_ % 3600 % 60 + "秒";
         }
         if(Main.player2.buffNine[5] > 0)
         {
            Play2_mc["yuhuo2"].gotoAndStop(6);
            _loc1_ = int(Main.player2.buffNine[5]);
            yhcs_txt.title_txt.text = "狱焰：六层";
            yhcs_txt._txt.text = "经验值获得15%   \n 防御力+10%   \n 魔法值+10%   \n 生命值+10%   \n 攻击力+10%    \n 移动速度+2   ";
            yhcs_txt.time_txt.text = "剩余" + Math.floor(_loc1_ / 3600) + "小时" + Math.floor(_loc1_ % 3600 / 60) + "分" + _loc1_ % 3600 % 60 + "秒";
         }
         if(Main.player2.buffNine[6] > 0)
         {
            Play2_mc["yuhuo2"].gotoAndStop(7);
            _loc1_ = int(Main.player2.buffNine[6]);
            yhcs_txt.title_txt.text = "狱焰：七层";
            yhcs_txt._txt.text = "经验值获得15%   \n 防御力+10%   \n 魔法值+10%   \n 生命值+10%   \n 攻击力+10%    \n 移动速度+2     \n 暴击+20%  ";
            yhcs_txt.time_txt.text = "剩余" + Math.floor(_loc1_ / 3600) + "小时" + Math.floor(_loc1_ % 3600 / 60) + "分" + _loc1_ % 3600 % 60 + "秒";
         }
         if(Main.player2.buffNine[7] > 0)
         {
            Play2_mc["yuhuo2"].gotoAndStop(8);
            _loc1_ = int(Main.player2.buffNine[7]);
            yhcs_txt.title_txt.text = "狱焰：八层";
            yhcs_txt._txt.text = "经验值获得15%   \n 防御力+10%   \n 魔法值+10%   \n 生命值+10%   \n 攻击力+10%    \n 移动速度+2     \n 暴击+20%   \n 魔抗+20%  ";
            yhcs_txt.time_txt.text = "剩余" + Math.floor(_loc1_ / 3600) + "小时" + Math.floor(_loc1_ % 3600 / 60) + "分" + _loc1_ % 3600 % 60 + "秒";
         }
         if(Main.player2.buffNine[8] > 0)
         {
            Play2_mc["yuhuo2"].gotoAndStop(9);
            _loc1_ = int(Main.player2.buffNine[8]);
            yhcs_txt.title_txt.text = "狱焰：九层";
            yhcs_txt._txt.text = "经验值获得15%   \n 防御力+10%   \n 魔法值+10%   \n 生命值+10%   \n 攻击力+10%    \n 移动速度+2     \n 暴击+20%   \n 魔抗+5%   \n 破魔+5%  ";
            yhcs_txt.time_txt.text = "剩余" + Math.floor(_loc1_ / 3600) + "小时" + Math.floor(_loc1_ % 3600 / 60) + "分" + _loc1_ % 3600 % 60 + "秒";
         }
         if(Main.player2.buffNine[9] > 0)
         {
            Play2_mc["yuhuo2"].gotoAndStop(10);
            _loc1_ = int(Main.player2.buffNine[9]);
            yhcs_txt.title_txt.text = "狱焰：十层";
            yhcs_txt._txt.text = "经验值获得30%   \n 防御力+20%   \n 魔法值+20%   \n 生命值+20%   \n 攻击力+20%    \n 移动速度+4     \n 暴击+30%   \n 魔抗+10%   \n 破魔+10% ";
            yhcs_txt.time_txt.text = "剩余" + Math.floor(_loc1_ / 3600) + "小时" + Math.floor(_loc1_ % 3600 / 60) + "分" + _loc1_ % 3600 % 60 + "秒";
            if(Main.player2.reBorn > 0)
            {
               yhcs_txt.time_txt.text += "\n重生冷却" + Math.floor(Main.player2.reBorn / 60) + "分" + Main.player2.reBorn % 60 + "秒";
            }
            yhcs_txt.cs_txt.visible = true;
         }
         else
         {
            yhcs_txt.cs_txt.visible = false;
         }
      }
   }
}

