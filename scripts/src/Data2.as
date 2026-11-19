package src
{
   import com.hotpoint.braveManIII.repository.achievement.*;
   import com.hotpoint.braveManIII.repository.chest.*;
   import com.hotpoint.braveManIII.repository.elves.*;
   import com.hotpoint.braveManIII.repository.equipShop.*;
   import com.hotpoint.braveManIII.repository.jingLingCatch.*;
   import com.hotpoint.braveManIII.repository.monsterCard.*;
   import com.hotpoint.braveManIII.repository.pet.*;
   import com.hotpoint.braveManIII.repository.petEquip.*;
   import com.hotpoint.braveManIII.repository.plan.*;
   import com.hotpoint.braveManIII.repository.probability.*;
   import com.hotpoint.braveManIII.repository.skill.*;
   import com.hotpoint.braveManIII.repository.task.*;
   import com.hotpoint.braveManIII.repository.title.*;
   import com.hotpoint.braveManIII.repository.tuijianShop.*;
   import com.hotpoint.braveManIII.repository.wantedTask.*;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.net.*;
   import src._data.*;
   import src.tool.*;
   
   public class Data2
   {
      
      public static var Enemy_md5_2:String;
      
      public static var skill_md5_2:String;
      
      public static var renWu_md5_2:String;
      
      public static const petHit_data:Class = Data2_petHit_data;
      
      public static const pet_set:Class = Data2_pet_set;
      
      public static const AchNum:Class = Data2_AchNum;
      
      public static const title:Class = Data2_title;
      
      public static const reward:Class = Data2_reward;
      
      public static const taskData:Class = Data2_taskData;
      
      public static const elves:Class = Data2_elves;
      
      public static const chestData:Class = Data2_chestData;
      
      public static const probability:Class = Data2_probability;
      
      public static const property:Class = Data2_property;
      
      public static const monster:Class = Data2_monster;
      
      public static const xingLing:Class = Data2_xingLing;
      
      public static const jihua:Class = Data2_jihua;
      
      public static const petEquip:Class = Data2_petEquip;
      
      public static const shopData:Class = Data2_shopData;
      
      public static const gameObjData:Class = Data2_gameObjData;
      
      public static const duiHuanData:Class = Data2_duiHuanData;
      
      public static const eShop:Class = Data2_eShop;
      
      public static const tjShop:Class = Data2_tjShop;
      
      public static const jinglingbuzhuo:Class = Data2_jinglingbuzhuo;
      
      public static const sengJi:Class = Data2_sengJi;
      
      public static var Enemy_md5_1:String = "04be96d98e10a9be010fa9583a183cb8";
      
      public static var skill_md5_1:String = "4403453a814caa72e285c76e9ec5084a";
      
      public static var renWu_md5_1:String = "694736f000cbac673240c805eab670fd";
      
      public function Data2()
      {
         super();
      }
      
      public static function Init() : *
      {
         Data2_data.关卡数据1();
         Data2_data.关卡数据2();
         Data2_data.关卡数据3();
         Data2_data.关卡数据4();
         Data2_data.关卡数据5();
         Data2_data.EnemyXML_1();
         Data2_data.EnemyXML_2();
         Data2_data.EnemyXML_3();
         Data2_data.EnemyXML_4();
         Data2_data.EnemyXML_5();
         Data2_data.EnemySkinXML_1();
         Data2_data.EnemySkinXML_2();
         Data2_data.EnemySkinXML_3();
         Data2_data.EnemySkinXML_4();
         Data2_data.EnemySkinXML_5();
         EnemySkinXML_Init();
         PaiHang_Data.creatFactory();
         PetEquipFactory.creatpetEquipFactory();
         PetFactory.creatPetFactory();
         ChongWu.get_XML_data();
         AchNumFactory.creatAchNumFactory();
         TitleFactory.creatTitleFactory();
         WantedFactory.creatWantedFactory();
         TaskFactory.creatTaskFactory();
         ElvesFactory.creatElvesFactory();
         ChestFactory.creatChestFactory();
         EquipProbabilityFactory.creatProbabilltyData();
         EquipPropertyFactory.creatEquipData();
         MonsterFactory.creatMonsterFactory();
         PlanFactory.creatPlanFactory();
         XingLingFactory.creatFactory();
         GaneObjFactory.creatFactory();
         ShopFactory.creatFactory();
         equipShopFactory.creatEquipShopFactory();
         tuijianFactory.creatTuiJianFactory();
         JLCFactory.creatJLCFactory();
         DataMD5();
      }
      
      public static function EnemySkinXML_Init() : *
      {
         var _loc2_:XML = null;
         var _loc3_:* = undefined;
         var _loc4_:int = 0;
         var _loc5_:XML = null;
         var _loc6_:XML = null;
         var _loc1_:int = 1;
         while(_loc1_ <= 5)
         {
            _loc2_ = EnemySkin.EnemySkinXmlArr[_loc1_][0];
            for(_loc3_ in _loc2_.怪物攻击)
            {
               _loc4_ = int(_loc2_.怪物攻击[_loc3_].关卡);
               if(!EnemySkin.EnemySkinXmlArr[_loc1_][_loc4_])
               {
                  EnemySkin.EnemySkinXmlArr[_loc1_][_loc4_] = new XML();
                  EnemySkin.EnemySkinXmlArr[_loc1_][_loc4_] = <root></root>;
               }
               _loc5_ = EnemySkin.EnemySkinXmlArr[_loc1_][_loc4_];
               _loc6_ = _loc2_.怪物攻击[_loc3_];
               _loc5_.appendChild(_loc6_);
            }
            _loc1_++;
         }
      }
      
      public static function DataMD5() : *
      {
         var _loc1_:int = 0;
         while(_loc1_ < Enemy.EnemyXmlArr.length + 1)
         {
            Enemy.EnemyXmlArrMd5[_loc1_] = Obj_Compare.getObj_ByteArray(Enemy.EnemyXmlArr[_loc1_]);
            _loc1_++;
         }
         Enemy_md5_2 = MD5contrast.getObj_MD5String(Enemy.EnemyXmlArr);
         if(Enemy_md5_1 != Enemy_md5_2)
         {
            Main.NoGame("怪物数据验证错误");
         }
         skill_md5_2 = MD5contrast.getObj_MD5String(SkillFactory.myXml);
         if(skill_md5_1 != skill_md5_2)
         {
            Main.NoGame("技能列表数据异常");
         }
         renWu_md5_2 = MD5contrast.getObj_MD5String(TaskFactory.myXml);
         if(renWu_md5_1 != renWu_md5_2)
         {
            Main.NoGame("任务列表数据异常");
         }
      }
      
      public static function EmenyDataMD5() : *
      {
         var _loc1_:int = 0;
         while(_loc1_ < Enemy.EnemyXmlArr.length + 1)
         {
            Enemy.EnemyXmlArrMd5[_loc1_] = Obj_Compare.getObj_ByteArray(Enemy.EnemyXmlArr[_loc1_]);
            _loc1_++;
         }
         Enemy_md5_2 = MD5contrast.getObj_MD5String(Enemy.EnemyXmlArr);
         if(Enemy_md5_1 != Enemy_md5_2)
         {
            Main.NoGame("怪物数据验证错误");
         }
      }
   }
}

