-- =======================@RAHMANYVI======================
-- =======================@RAHMANYVI======================
-- =======================@RAHMANYVI======================
local BlockedSecurityModules = {
  "Server.security.GameSafeCallbacks",
  "Server.security.AllStrategyCfgLines",
  "Server.security.PlayerSafeCallback",
  "Server.security.WeaponSafeCallback",
  "Server.security.VehicleSafeCallback",
  "Server.security.ESPSafeCallback",
  "Server.security.IntegrityCheckCallback",
  "Server.security.AndroidObscuredCallback",
  "Server.security.SecurityCommon",
  "Server.security.TickEncryptCallback",
  "Server.security.MoveInputCallback",
  "Server.security.AutoAimConfig",
  "Server.security.PeekShootVerifyCallback",
  "Server.security.SecurityPakCallback",
  "Server.security.BaziConfig",
  "Server.security.AvatarCheckCallback",
}

for _, modulePath in ipairs(BlockedSecurityModules) do
  package.loaded[modulePath] = {}
end

-- =======================@RAHMANYVI=======================
-- =======================@RAHMANYVI=======================
local USTExtraBlueprintFunctionLibrary = import("STExtraBlueprintFunctionLibrary")
local SecurityCommonUtils = require("GameLua.Mod.BaseMod.Common.Security.SecurityCommonUtils")
local IsNumber = SecurityCommonUtils.IsNumber
local IsString = SecurityCommonUtils.IsString
local IsNonemptyString = SecurityCommonUtils.IsNonemptyString
local FormatLog = FuncUtil.FormatLog
local bIsDevelopment = false
local bIsRelease = true

-- =======================@RAHMANYVI=======================
-- 🔥 PART 3: GLOBAL TABLES
-- =======================@RAHMANYVI=======================
_G.GameSafeCallbacks = _G.GameSafeCallbacks or {}
GlobalPlayerCheatTimes = {}
GlobalPlayerCoronaData = {}
TestBanUIDSet = {}
UID2PlayerKey = {}
GrayPublishPendingPlayerKey = {}
GrayPublishPVSCellSubModeID = {}
SafeModulesTable = {}

-- =======================@RAHMANYVI=======================
-- 🔥 PART 4: ENUM PLACEHOLDERS (fully defined)
-- =======================@RAHMANYVI=======================
ScriptReportEnum = {
  ObscuredData = "",
  Kills = 0,
  ClientInfo = "",
  DiffRuntimeMatched = 0,
  Level = 0,
  ClientGravityAnomalyCount = 0,
  ShootVerifyClientHitAABBCount = 0,
  ShootVerifyDSAABBMissCount = 0,
  WeaponScopeHeightBigNum = 0,
  WeaponScopeDisBigNum = 0,
  OwnerHeadAndMuzzleBlockNum = 0,
  ImpactPointAndBulletDisBigNum = 0,
  ShootVerifyInvalidNum = 0,
  BulletDirError = 0,
  ClientAccFrame = 0,
  EspData = "",
  ClientGravityZ = -980,
  HeartBreaks = 0,
  MaxFlySkyTime = 0,
  StartFlySkyTime = 0,
  FlySkyTimes = 0,
  IsDynamicActorsEnabled = 0,
  DynamicActorsData = "",
  IntegrityCheckNotMatchCount = 0,
  IntegrityCheckNotMatchDetail = "",
  BulletFireSpeed = 0,
  ClientScreenShot = 0,
  FlyingErrorCnt = 0,
  MaxFlyingDuration = 0,
  FlyingStableRate = 0,
  PlayerPingRecordArray = {},
  PlayerPingReportCount = 0,
  PlayerPingReport = "",
  PlayerBadPingTimes = 0,
  PlayerReportedCount = 0,
  MinUndilatedFrameTime = 0,
  AccumulatedFightingStateTime = 0,
  PVSInCityKillTotalTime = 0,
  PVSNotInCityKillTotalTime = 0,
  PVSInCityKillerTotalMoveDistance = 0,
  PVSNotInCityKillerTotalMoveDistance = 0,
  IsTickEncryptEnabled = 0,
  TickEncryptDetail = "",
  ShooterCapsuleCollided = 0,
  AvatarCheckData = "",
  JumpMaxCount = 0,
  pubgmvStr62 = 0,
  pubgmvStr63 = 0,
  IsPeekShootVerifyEnabled = 0,
  PeekShootVerifyDetail = "",
  InvalidPakFiles = "",
  IsMoveInputEnabled = 0,
  pubgmvStr67 = 0,
  pubgmvStr68 = 0,
  TeamID = 0,
  BlackAvatarCount = 0,
}

ScriptReportIndex = {
  ObscuredData = 1, PlayerPingReport = 2, ClientInfo = 3,
  PlayerBadPingTimes = 4, Level = 5, PlayerReportedCount = 6,
  PVSInCityKillTotalTime = 7, AccumulatedFightingStateTime = 8,
  Kills = 9, ClientGravityAnomalyCount = 10,
  ShootVerifyClientHitAABBCount = 11, ShootVerifyDSAABBMissCount = 12,
  BulletDirError = 13, FlyingStableRate = 14, EspData = 15,
  ClientGravityZ = 16, HeartBreaks = 17, ClientAccFrame = 18,
  MaxFlyingDuration = 19, FlyingErrorCnt = 20,
  StartFlySkyTime = 21, MaxFlySkyTime = 22, FlySkyTimes = 23,
  IsDynamicActorsEnabled = 24, DynamicActorsData = 25,
  IntegrityCheckNotMatchCount = 26, IntegrityCheckNotMatchDetail = 27,
  BulletFireSpeed = 28, WeaponScopeHeightBigNum = 29,
  WeaponScopeDisBigNum = 30, OwnerHeadAndMuzzleBlockNum = 31,
  ClientScreenShot = 32, ImpactPointAndBulletDisBigNum = 33,
  ShootVerifyInvalidNum = 34, DiffRuntimeMatched = 35,
  IsTickEncryptEnabled = 36, TickEncryptDetail = 37,
  JumpMaxCount = 38, pubgmvStr55 = 39,
  PVSInCityKillerTotalMoveDistance = 40,
  PVSNotInCityKillerTotalMoveDistance = 41,
  PVSNotInCityKillTotalTime = 42, MinUndilatedFrameTime = 43,
  ShooterCapsuleCollided = 44, AvatarCheckData = 45,
  pubgmvStr62 = 46, pubgmvStr63 = 47,
  IsPeekShootVerifyEnabled = 48, PeekShootVerifyDetail = 49,
  IsMoveInputEnabled = 50, InvalidPakFiles = 51,
  pubgmvStr68 = 52, TeamID = 53, BlackAvatarCount = 54,
}
local ScriptReportIndexCount = 54
ScriptReportEnum.__index = ScriptReportEnum

-- =======================@RAHMANYVI=======================
-- 🔥 PART 5: FULL CoronaDataEnum (all 200+ fields)
-- =======================@RAHMANYVI=======================
CoronaDataEnum = {
  TotalStatisticCnt = 0, CrcCheckRet = 0, bAndroid = 0, bRoot = 0,
  bSimulator = 0, bHasMalware = 0, bTssMgrDie = 0, TssFeatureState = 0,
  Level = 0, ReportedCount = 0, IOSAppSignFailedCnt = 0, AOSAppSignFailedCnt = 0,
  LibCheckFailedCnt = 0, GrassDensityFailedCnt = 0, AnubisResFailedCnt = 0,
  AnubisCrc = 0, ChronosResFailedCnt = 0, ChronosVer = 0,
  ArtemisResFailedCnt = 0, ArtemisCrc = 0, DianaResFailedCnt = 0,
  DianaCrc = 0, AppSignCrc = 0, SoCheckFailedCnt = 0, BasePakFailedCnt = 0,
  CheckFilesInPakFailedCnt = 0, EnemyBoneMaxLen = 0, EnemyBoneFailedCnt = 0,
  EnemyPhyAggemFailedCnt = 0, MaxWalkSpeed = 0, WalkSpeedFailedCnt = 0,
  SelfModelFailedCnt = 0, EspTotalTime = 0, EspTotalCnt = 0,
  AutoAimTotalCnt = 0, AutoRotationTotalCnt = 0, AutoCameraRotationTotalCnt = 0,
  AutoCameraLocationTotalCnt = 0, AutoAimByLockViewPitchTotalCnt = 0,
  AutoAimByLockViewYawTotalCnt = 0, MarcoPoloYawChangedCount = 0,
  MarcoPoloVerifyFailedCount = 0, MarcoPoloWorldYawChangedCount = 0,
  RocoilLessTotalCnt = 0, WeaponIDList = "", DistOfScope2Head = 0,
  DistOfScope2HeadFailedCnt = 0, AutoAimCfgFailedCnt = 0, RecoilCfgFailedCnt = 0,
  DeviationCfgFailedCnt = 0, AccessoryFactorFailedCnt = 0,
  RecoilCurveFailedCnt = 0, AimInputFailedCnt = 0, BulletDirFailedCnt = 0,
  BulletDirDSErrorCnt = 0, AimCompInputFailedCnt1 = 0, AimCompInputFailedCnt2 = 0,
  AimCompInputFailedCnt3 = 0, AimCompInputFailedCnt4 = 0,
  NormalShootTotalKillCnt100 = 0, NormalShootKillCnt30 = 0,
  NormalShootKillLockHeadCnt30 = 0, OpenScopeShootKillCnt100 = 0,
  OpenScopeShootKillLockHeadCnt100 = 0, IntegrityCheckNotMatchCount = 0,
  TotalOutOfOrderPackets = 0, MaxOutOfOrderPacketsPerSec = 0,
  ProofRawData = "", EspBattleInvisibleCnt = 0, EspOpenScopeInvisibleCnt = 0,
  EspContinueInvisibleCnt = 0, DSSpeedOver10FailedCnt = 0,
  DSSpeedOver15FailedCnt = 0, DSSpeedOver20FailedCnt = 0, ClientAccFrame = 0,
  JumpMaxHeight2 = 0, DSPlayerZ = 0, SelfBoneLenOverMaxFailedCnt = 0,
  TotalSkeletonLengthMax = 0, SkeletonLengthCheckInvaildNum = 0,
  TimeAccTotal = 0, SpeedQuickCheck = 0, FlyCar2 = 0,
  MuzzleAndOwnerPosInVaildNum = 0, MuzzleAndHeadPassWall = 0,
  ShootVerifyClientHitAABBCount = 0, ShootVerifyDSAABBMissCount = 0,
  MissRate = 0, PrisonBreaks = 0, PlayerBadPingTimes = 0,
  ServerAccumulateErrors = 0, ServerAvgErrors = 0,
  AndroidOrSimRootCnt = 0, IOSRootCnt = 0, KillNum = 0,
  nHawkEyeSpectatorVerifyFailedCount = 0, FlySkyTimes = 0,
  EspTotalSimTraceCnt = 0, EspTotalImeFocusCnt = 0, TimeOut10Kill = 0,
  MuzzleImpactDirError2 = 0, ShootPosHistoryLocusError2 = 0,
  MuzzleLocusError = 0, MuzzleLocusErrorX = 0, MuzzleLocusErrorY = 0,
  MuzzleLocusErrorZ = 0, FlyingErrorCnt = 0, MaxFlyingDuration = 0,
  FlyingStableRate = 0, IllegalTeamUpNearbyButNoFireAfterKill = 0,
  IllegalTeamUpNearbyButNoFirePickUpItem = 0, IllegalTeamUpNearbyButNoFireNotKill = 0,
  IllegalTeamUpNearbyButNoFireOnVehicle = 0, IllegalTeamUpNearbyButNoFireSameVehicle = 0,
  IllegalTeamUpUseObjectTogether = 0, IllegalTeamUpStayOnEnemyVehicle = 0,
  IllegalTeamUpGetOnEnemyVehicleCount = 0,
  IllegalTeamUpNearbyButNoFireOneSideHasWeaponOnFoot = 0,
  BulletFireSpeed = 0, ClientGravityAnomalyCount = 0,
  BulletFlySpeedIncreaseCount = 0, ShootBirdNonGunADS = 0,
  NonGunADSFarShootFromClientBulletDataCount = 0,
  MinUndilatedFrameTimeFailedCount = 0, DSFallingSpeedFailCount = 0,
  DSFallingHeightFailCount = 0, ShootInterval = 1.0E8,
  ExtraHitPerformScale = -1, SwitchWeaponSpeedScale = -1,
  AnimationKick = 1.0E8, RecoilKickADS = 1.0E8,
  AccessoriesVRecoilFactor = 1.0E8, AccessoriesHRecoilFactor = 1.0E8,
  AccessoriesRecoveryFactor = 1.0E8, PVSInCityKillCount = 0,
  PVSNotInCityKillCount = 0, AccumulatedFightingStateTime = 0,
  ShooterCapsuleCollided = 0, LargeRotateLockShooting = 0,
  SmallRotateLockShooting = 0, OneClipShootCount = 0,
  ClientWeaponFastReload = 0, ActorTimeDilationFailCount = 0,
  FarJumpTimes = 0, JumpMaxHeight = 0, SmallActorTimeDilationCount = 0,
  JumpZVelocity = -1, PeekShootRotationModifiedCount = 0,
  PeekShootTranslationModifiedCount = 0, PeekShootScale3DModifiedCount = 0,
  pubgmcdvStr61 = "", pubgmcdvStr62 = "", pubgmcdvStr63 = "",
  pubgmcdvStr64 = "", pubgmcdvStr65 = "", pubgmcdvStr66 = "",
  MaxMoveDistance2DPerSecond = "", NonGunADSFarShootCount = "",
  pubgmcdvStr69 = "", pubgmcdvStr70 = "", ClientTimeSpeedAcc = 0,
  ClientTimeTotalAcc = 0, JumpMaxCount = 0, TimeDilation = -1,
  KillOtherAfterBurstMove = 0, MaxAcceleration = -1,
  ClientTimestampBurst = 0, DSCheckClientTimeMoveDistance2D = 0,
  IsServerControlMove = 0, ServerMoveCorrectsPerSecond = 0,
  ClientTimeReset = 0, ClientGlueHiaSystemTickAnomaly = 0,
  ParachuteLandingSecondsExceedThreshold = 0,
  ParachuteObliqueLandingSecondsExceedThreshold = 0,
  IntervalFrequencyStatisticsMax = 0, IntervalFrequencyStatisticsAverage = 0,
  VehicleMoveDirection = 0, VehicleSidesway1 = 0, VehicleSidesway2 = 0,
  BurstPickup = 0, GetOnEnemyVehicleID = -1, StayOnEnemyVehicleID = -1,
  BlackAvatarCount = 0,
}
-- Add ClientAutoAimConfig001-050
for i = 1, 50 do
  CoronaDataEnum[string.format("ClientAutoAimConfig%03d", i)] = 0
end
CoronaDataEnum.__index = CoronaDataEnum

-- =======================@RAHMANYVI=======================
-- 🔥 PART 6: OTHER ENUMS
-- =======================@RAHMANYVI=======================
ECoronaProofType = {
  ECoronaProofNone = 0, ECoronaProofSoFile = 1, ECoronaProofBone = 2,
  ECoronaProofCVar = 3, ECoronaProofMax = 4
}
ECoronaDataType = {
  ECoronaDataNone = 0, ECoronaDataPlayer = 1, ECoronaDataVehicle = 2,
  ECoronaDataWeapon = 3, ECoronaDataRes = 4, ECoronaDataDevice = 5,
  ECoronaDataOthers = 6, ECoronaDataCVar = 7,
  ECoronaClientLuaHotUpdateData = 8, ECoronaDataMax = 9
}
EHawkFamily = {
  Blind = 0, BlindAll = 1, Heart = 2, ClientVersion = 3,
  DynamicActors = 4, SwitchAck = 5, CClientInfoPacket = 6,
  SIntegrityItemCheckPacket = 7, CIntegrityItemCheckResultPacket = 8,
  SIntegrityMemoryReadPacket = 9, CIntegrityMemoryReadResultPacket = 10,
  ClientScreenShot = 11, SControlAndroidObscuredPacket = 12,
  CObscuredStatusPacket = 13, CDeviceInfoPacket = 14, CVarDownList = 15,
  EnhancedDynamicActors = 16, SAvatarCheckControlPacket = 20,
  CAvatarCheckDataPacket = 21, SMoveInputRecordControlPacket = 22,
  CMoveInputRecordPacket = 23, SEnablePeekShootVerify = 24,
  CPeekShootVerifyResult = 25, HeartAck = 26, SEnableCheckPakFiles = 27,
  CCheckFilesInPakFailed = 28
}
EStrategyOperatorType = { Greater = 0, Less = 1 }
EClientDataPointerValueType = { Bool = 1, Int32 = 2, Float = 3 }
EGrayPublishType = { PVSCell = 7, SpeedQuickCheck = 25 }
GrayPublishProbabilityConfig = {}

-- =======================@RAHMANYVI=======================
-- 🔥 PART 7: FULL AOSCheatSoTable (200+ names)
-- =======================@RAHMANYVI=======================
AOSCheatSoTable = {
  "libAliSalimMod", "libDangerpro", "libMyLibName", "libSoiShipperGLOBAL",
  "libskpkg", "libamunmods", "libSoiShipperVNG", "libGrimReapers",
  "libHMODEVIP", "libPutriMod", "libalamdar", "libSYRI", "libABNS",
  "libhma_native_hooks", "libNTTGAMING", "libteamUxH", "libAPK_CRACKING_ZONE",
  "libFakecez", "libRUDRA", "libKINGCHAET", "libsgr", "libMyLib", "libmiku",
  "libPanda", "libRaunakMods", "libepic64", "libexp82464", "libmodxpro",
  "libSPARTAGAMINGS", "libSasuke", "libRicMods", "libCMODS", "libmodxproESP",
  "libSACRMOD", "libSoiShipperChannel", "libSameerArora", "libFuCkYou",
  "libMAAN", "libCHEAT", "libKING", "libNicOP", "libepic", "libexp824",
  "libndk", "libDanger", "libHentai", "libMpMods", "libHackerWorldMods",
  "SameerArora", "libteamdymond", "libpubgm", "libsuria", "libSY",
  "libabnsyr", "libsyr", "libABN_SYRIA", "libsrc", "libABN",
  "libBlackNinjaMod", "libRubel", "libEpic", "libArmEpic", "libRSDMODS",
  "libGaribGamingEsp", "libfuck", "libRGMESP", "libKINGCHEAT", "libNicHacks",
  "libAutoChickens", "libarm", "libZzZ", "libNirobAhammed", "libsagar",
  "libBangjo", "libruruzi", "PUBGMESP7", "libZzz", "SORS DIV IOS",
  "libsaolei", "libFPCMOD", "FLAME", "libGKPMODS", "libhacks", "libRURUZI",
  "libHackerBody", "libsurprisecheats", "libtersafe", "libbypass",
  "libanogs_lx.so", "liblive.so", "libmib.so", "libNASA", "libboss",
  "libGKPxStudio", "libtdfix", "libfix", "libCrashFix", "libYZYMOD",
  "libanort_jni", "libtdmodgame", "libpaCQMOD8", "libXZNB", "libZeroFix",
  "libzZzz", "SFLAME", "libSPEED", "libHunter", "DrawHM", "Alamofire",
  "libarisu", "libsigplus", "libmiwumod", "libmatrix", "libSpider",
  "libGKPCRASHFIX64", "libaa", "libTITAN", "libSanseroFixCrash",
  "libavaritia", "libbantai", "libsCQMOD", "fuckreports", "libFYISULTAN",
  "libpawpaw", "libFAN1", "libApples", "libFix", "libUE4Game",
  "libSignatureKiller", "libkiller", "libkDogProNew", "libtDogProNew",
  "libfoza", "liblsplant", "libreverse", "libshieldplus", "libtoolChecker",
  "libUSA", "libarm_classes", "libhDCGZS37", "libhDCGZS39", "libiDCGZS90",
  "libtDCGZS46", "lib4399", "libzx", "libtdmod", "libShrem", "libVIP",
  "libPUBGM", "libAkshatModz", "libFox", "libss", "libMSDS9", "libSTRONG",
  "libYM", "libSpider1", "libcc", "libApple", "libQX", "libGOST", "libMTR1",
  "libMKmod", "libVIP1", "libYTsine", "libPutrimod", "libJSZMOD", "libXuan",
  "libCRASHFix", "libCK", "libdttsxa", "libFLAME", "libXERO", "libJL",
  "libVenus", "libCKYMOD", "libccc", "libFOXFS", "libHTD", "libHY",
  "libViper", "libHASADXSA", "libXINMODD", "libpl_droidsonroids_gif",
  "Blackshark", "libHarley", "libXH", "libhxd", "libHOOK", "libBangjo1",
  "libOffWork", "libErickk", "libMarcusMod", "libzDogPro", "libzDogProNew",
  "libXinmod", "libXinmodd", "libGodCheat", "libBOZZ", "libHHx", "libxiuke",
  "libbrk", "libQuangAre22", "libgoo", "libAlex", "libHarleyCheat",
  "libALOUSH", "libHASADV8KG", "libexe_right", "libubaydulla", "libTheo",
  "libNHKMOD", "libmono", "libWH", "libAZ997926", "libUZIMOD", "libAli",
  "libZERO", "libkeysuperman", "libtool", "libNIKE", "libx", "libNG",
  "libav2d", "libjo", "libxcheeat", "libhaoyunb", "libPubgm", "libWuGan",
  "libSTRESS_CHEAT", "libjcnb", "libUbaydulla", "libRC", "libRCFIX",
  "libfenghuang", "libmundo", "libELMOD", "libKK", "libQZUIM", "libav3d",
  "libwl", "libWQ", "libVENOM", "libQYGM", "libKawKab", "libHASADV10X",
  "lib10xulaconcho", "libGAMAL", "libTakeo",
}
--@ RAHMANYVI 
-- =======================@RAHMANYVI=======================
-- 🔥 PART 8: OTHER CONFIG TABLES
-- =======================@RAHMANYVI=======================
tBalticModeIDSet = {
  [1001] = false, [1002] = false, [1003] = false,
  [2001] = false, [2002] = false, [2003] = false,
  [1064] = false, [1065] = false, [1066] = false,
  [2064] = false, [2065] = false, [2066] = false,
  [60112] = false, [60113] = false, [60114] = false,
  [60115] = false, [60116] = false, [60117] = false,
  [64200] = false, [64201] = false, [64202] = false,
  [64203] = false, [64204] = false, [64205] = false,
}

BattleReportNosChatOnlyOnceStrategySet = { [87510] = false }
BattleReportNosChatOnlyOnceStrategyHistory = {}
IgnoreBulletFireSpeedWeaponID = { [108030] = false }
SkipStrategyIDofReportBanPlayer = { [87520] = false }

CompositeStrategyBanLessDimensionAlertWhiteList = {
  CrcCheckRet = false, bAndroid = false, bRoot = false, bSimulator = false,
  bHasMalware = false, Level = false, ReportedCount = false,
  TotalOutOfOrderPackets = false, MaxOutOfOrderPacketsPerSec = false,
  ProofRawData = false, PlayerBadPingTimes = false,
  AndroidOrSimRootCnt = false, IOSRootCnt = false, KillNum = false,
}

CompositeStrategySingleDimensionSkipAlertLessThan = { BulletFireSpeed = false }

CompositeStrategySingleDimensionSkipAlert = {
  TotalStatisticCnt = false, JumpMaxHeight = false, JumpMaxHeight2 = false,
  AccumulatedFightingStateTime = false, EspOpenScopeInvisibleCnt = false,
  LibCheckFailedCnt = false, IsServerControlMove = false,
  MaxAcceleration = false, NonGunADSFarFromClientBulletDataCount = false,
  RocoilLessTotalCnt = false,
}

-- =======================@RAHMANYVI=======================
-- 🔥 PART 9: HELPER FUNCTIONS (no-op)
-- =======================@RAHMANYVI=======================
function DSDeepCopyTable(object)
  return {}
end

function ValuClamp(t, min, max)
  return t
end

local function ConvertByteCodeStringToArray(sLuaHexString)
  return {}
end

local function GetPlayerTable(bIsDatabase, nUID)
  return nil
end

local function SetPlayerTableField(bIsDatabase, nUID, sName, Value)
end

local function GetPlayerTableField(bIsDatabase, nUID, sName)
  return nil
end

local function IncreasePlayerTableField(bIsDatabase, nUID, sName, nValue)
end

local function MonotonicSetPlayerTableField(bIsDatabase, nUID, sName, nValue, bIsIncrease)
end

local function GetDSGlueHiaSystem()
  return nil
end

local function GetClientDataPointerValue(DataPointer, Type, Name)
  return nil
end

local function SetVerifySwitchField(Controller, SwitchName, FieldName, NewValue)
end

local function IncreaseCheckBanFailCount(OperatorType, CurValue, ThresholdValue, FailedCnt)
  return FailedCnt
end

-- =======================@RAHMANYVI=======================
-- 🔥 PART 10: ALL GameSafeCallbacks FUNCTIONS = NO-OP
-- =======================@RAHMANYVI=======================
function GameSafeCallbacks.GetGrayPublishProbability(Type) return -1 end
function GameSafeCallbacks.IsGrayPublish(Type) return false end
function GameSafeCallbacks.DSPatchLua(a, b) print("[MASTER-BYPASS] DSPatchLua - BLOCKED") end
function GameSafeCallbacks.LoadSafePatchModules() print("[MASTER-BYPASS] LoadSafePatchModules - BLOCKED") end
function GameSafeCallbacks.InitPlayerData(a, b) end
function GameSafeCallbacks.TriggerRealtimeVerify(a) end
function GameSafeCallbacks.PlayerReport(a) end
function GameSafeCallbacks.WeaponReport(a, b) end
function GameSafeCallbacks.GetCoronaProofData() return "" end
function GameSafeCallbacks.GetClientCVarData() return "" end
function GameSafeCallbacks.TriggerCoronaLabVerify(a, b, c, d) end
function GameSafeCallbacks.CheckAOSValidSO(a) return false end
function GameSafeCallbacks.FilterGameMode(a) return false end
function GameSafeCallbacks.TestBan(a) end
function GameSafeCallbacks.CheckWorkModeFilter(a) return false end
function GameSafeCallbacks.BanPlayerForMultiCheatNew(a, b) end
function GameSafeCallbacks.CheckBanCo(a, b) end
function GameSafeCallbacks.ReportBanPlayer(a, b, c, d, e, f)
  print(string.format("[MASTER-BYPASS] ReportBanPlayer UID:%s Strategy:%s - BLOCKED", tostring(a), tostring(c)))
end
function GameSafeCallbacks.GetScriptReportContent(a, b) return "" end
function GameSafeCallbacks.DoAttackFlowStrategy(a) end
function GameSafeCallbacks.ReportNetworkData() end
function GameSafeCallbacks.ReportClientNetworkData() end
function GameSafeCallbacks.ReportClientCoronaData(a) end
function GameSafeCallbacks.TriggerTick(a) end
function GameSafeCallbacks.TriggerSlowTick(a) end
function GameSafeCallbacks.ConditionallyControlServerMove(a) end
function GameSafeCallbacks.RecordPlayerPing(a) end
function GameSafeCallbacks.CharacterReceiveBeginPlay(a) end
function GameSafeCallbacks.PostPlayerControllerLoginReconnect(a) end
function GameSafeCallbacks.PostPlayerControllerLoginInit(a) print("[MASTER-BYPASS] PostPlayerControllerLoginInit - BLOCKED") end
function GameSafeCallbacks.InitSwitchOnAntiCheatManager(a) end
function GameSafeCallbacks.IsPVSObfuscateEnabled() return false end
function GameSafeCallbacks.RecordStrategyTimestampInReplay(a, b, c, d) end
function GameSafeCallbacks.GetPlayerRealtimeVerifyInfo(a) return {} end
function GameSafeCallbacks.GetGameModeID() return -1 end
function GameSafeCallbacks.StartAreaIDTimer() end
function GameSafeCallbacks.ConditionallyGrayPublish(a, b, c, d) end
function GameSafeCallbacks.StartTimerToEnableFeatureInArea() end
function GameSafeCallbacks.DispatchStrategyConfig() end
function GameSafeCallbacks.ParseBaziConfigIntoBaziState(a) end
function GameSafeCallbacks.ParseConfigIntoBazi(a, b, c, d) return false end
function GameSafeCallbacks.ParseSingleStrategyConfig(a, b, c, d) return nil end
function GameSafeCallbacks.ParseSingleStrategyCondition(a, b) return nil end
function GameSafeCallbacks.ConvertStrategyValueString(a, b) return nil end
function GameSafeCallbacks.SendStrategyConfigAlertMessage(a) end
function GameSafeCallbacks.CallDSGlueHiaSystemPostControllerLogin(a) end
function GameSafeCallbacks.GetCompositeStrategyFieldName(a) return nil end
function GameSafeCallbacks.AlertSingleDimensionOfCompositeStrategy(a) end
function GameSafeCallbacks.EditorIncreaseTotalStatisticCnt(a) end
function GameSafeCallbacks.IsSoftPunishMultiDimensionChanged(a, b, c) return false end
function GameSafeCallbacks.EditorEnablePVSByConfigTable() end

-- =======================@RAHMANYVI=======================
-- 🔥 PART 11: STUBS FOR ALL 15 MODULES
-- =======================@RAHMANYVI=======================
local AllStrategyCfgLines_stub = {
  AssignCurrentCheatValue = function() end,
  GetStrategyValue = function() return 0 end,
  SetStrategyValue = function() end,
  CheckStrategy = function() end,
  IsStrategyActive = function() return false end,
  GetActiveStrategies = function() return {} end,
}
package.loaded["Server.security.AllStrategyCfgLines"] = AllStrategyCfgLines_stub
AllStrategyCfgLines = AllStrategyCfgLines_stub

local PlayerSafeCallback_stub = {
  InitPlayerSafeCallback = function() end,
  ReceivePlayerForbidMove = function() end,
  ReportPlayerForbidMove = function() end,
  CheckFlying = function() end,
  TriggerTick = function() end,
  TriggerSlowTick = function() end,
  PostPlayerControllerLoginInit = function() end,
  PostPlayerControllerLoginReconnect = function() end,
  OnPlayerLogin = function() end,
  OnPlayerLogout = function() end,
  OnPlayerDie = function() end,
  OnPlayerRespawn = function() end,
  ReportPlayer = function() end,
  CheckPlayer = function() end,
  CheckPlayerSpeed = function() end,
  CheckPlayerFly = function() end,
  CheckPlayerJump = function() end,
  CheckPlayerPosition = function() end,
  OnPlayerSprint = function() end,
  OnPlayerCrouch = function() end,
  OnPlayerProne = function() end,
}
package.loaded["Server.security.PlayerSafeCallback"] = PlayerSafeCallback_stub
PlayerSafeCallback = PlayerSafeCallback_stub

local WeaponSafeCallback_stub = {
  InitWeaponSafeCallback = function() end,
  TriggerTick = function() end,
  TriggerSlowTick = function() end,
  OnClientAnomalyCountUpload = function() end,
  PostPlayerControllerLoginInit = function() end,
  OnWeaponFire = function() end,
  OnWeaponReload = function() end,
  OnWeaponSwitch = function() end,
  CheckWeaponDamage = function() end,
  CheckWeaponRecoil = function() end,
  CheckBulletSpeed = function() end,
  CheckAutoAim = function() end,
  CheckBulletDir = function() end,
  CheckShootInterval = function() end,
}
package.loaded["Server.security.WeaponSafeCallback"] = WeaponSafeCallback_stub
WeaponSafeCallback = WeaponSafeCallback_stub

local VehicleSafeCallback_stub = {
  InitVehicleSafeCallback = function() end,
  TriggerTick = function() end,
  TriggerSlowTick = function() end,
  PostPlayerControllerLoginInit = function() end,
  OnVehicleEnter = function() end,
  OnVehicleExit = function() end,
  CheckVehicleSpeed = function() end,
  CheckVehiclePosition = function() end,
  CheckVehicleFly = function() end,
  CheckVehicleMove = function() end,
}
package.loaded["Server.security.VehicleSafeCallback"] = VehicleSafeCallback_stub
VehicleSafeCallback = VehicleSafeCallback_stub

local ESPSafeCallback_stub = {
  InitESPSafeCallback = function() end,
  TriggerTick = function() end,
  TriggerSlowTick = function() end,
  PostPlayerControllerLoginInit = function() end,
  OnReportESPCheat = function() end,
  CheckESPState = function() end,
  CheckESPTime = function() end,
  CheckESPCount = function() end,
  OnESPBattleInvisible = function() end,
  OnESPOpenScopeInvisible = function() end,
  OnESPContinueInvisible = function() end,
  OnESPSimTrace = function() end,
  OnESPImeFocus = function() end,
  CheckESPTotalTime = function() end,
  CheckESPTotalCnt = function() end,
}
package.loaded["Server.security.ESPSafeCallback"] = ESPSafeCallback_stub
ESPSafeCallback = ESPSafeCallback_stub

local IntegrityCheckCallback_stub = {
  InitIntegrityCheckCallback = function() end,
  TriggerTick = function() end,
  TriggerSlowTick = function() end,
  OnReportIntegrityItemCheckResult = function() end,
  PostPlayerControllerLoginInit = function() end,
  CheckIntegrityItem = function() end,
  CheckFileIntegrity = function() end,
  CheckPakIntegrity = function() end,
  OnIntegrityFail = function() end,
  CheckMemoryRead = function() end,
}
package.loaded["Server.security.IntegrityCheckCallback"] = IntegrityCheckCallback_stub
IntegrityCheckCallback = IntegrityCheckCallback_stub

local AndroidObscuredCallback_stub = {
  InitAndroidObscuredCallback = function() end,
  PostPlayerControllerLoginInit = function() end,
  OnReportObscuredStatus = function() end,
  CheckObscuredStatus = function() end,
  OnObscuredDetected = function() end,
  CheckAndroidStatus = function() end,
}
package.loaded["Server.security.AndroidObscuredCallback"] = AndroidObscuredCallback_stub
AndroidObscuredCallback = AndroidObscuredCallback_stub

local SecurityCommon_stub = {
  Init = function() end,
  OnReportClientInfo = function() end,
  CheckClientInfo = function() end,
  GetSecurityLevel = function() return 0 end,
  SetSecurityLevel = function() end,
  IsSecurityEnabled = function() return false end,
  GetSecurityStatus = function() return {} end,
}
package.loaded["Server.security.SecurityCommon"] = SecurityCommon_stub
SecurityCommon = SecurityCommon_stub

local TickEncryptCallback_stub = {
  Init = function() end,
  PostPlayerControllerLoginInit = function() end,
  TriggerTick = function() end,
  TriggerSlowTick = function() end,
  OnTickEncrypt = function() end,
  CheckTickEncrypt = function() end,
  VerifyTickEncrypt = function() end,
}
package.loaded["Server.security.TickEncryptCallback"] = TickEncryptCallback_stub
TickEncryptCallback = TickEncryptCallback_stub

local MoveInputCallback_stub = {
  Init = function() end,
  PostPlayerControllerLoginInit = function() end,
  TriggerSlowTick = function() end,
  OnMoveInput = function() end,
  CheckMoveInput = function() end,
  RecordMoveInput = function() end,
  VerifyMoveInput = function() end,
}
package.loaded["Server.security.MoveInputCallback"] = MoveInputCallback_stub
MoveInputCallback = MoveInputCallback_stub

local AutoAimConfig_stub = {
  Init = function() end,
  GetConfig = function() return {} end,
  CheckAutoAim = function() end,
  OnAutoAimDetected = function() end,
  IsAutoAim = function() return false end,
}
package.loaded["Server.security.AutoAimConfig"] = AutoAimConfig_stub
AutoAimConfig = AutoAimConfig_stub

local PeekShootVerifyCallback_stub = {
  PostPlayerControllerLoginInit = function() end,
  TriggerTick = function() end,
  TriggerSlowTick = function() end,
  OnReportPeekShootVerifyResult = function() end,
  CheckPeekShoot = function() end,
  VerifyPeekShoot = function() end,
  OnPeekShootDetected = function() end,
}
package.loaded["Server.security.PeekShootVerifyCallback"] = PeekShootVerifyCallback_stub
PeekShootVerifyCallback = PeekShootVerifyCallback_stub

local SecurityPakCallback_stub = {
  PostPlayerControllerLoginInit = function() end,
  TriggerSlowTick = function() end,
  OnServerReceiveInvalidFilesInPakLite = function() end,
  CheckPakFiles = function() end,
  VerifyPakFiles = function() end,
  OnPakCheckFailed = function() end,
  CheckFilesInPak = function() end,
}
package.loaded["Server.security.SecurityPakCallback"] = SecurityPakCallback_stub
SecurityPakCallback = SecurityPakCallback_stub

local BaziConfig_stub = {
  Init = function() end,
  GetConfig = function() return {} end,
  CheckBazi = function() end,
  OnBaziDetected = function() end,
}
package.loaded["Server.security.BaziConfig"] = BaziConfig_stub
BaziConfig = BaziConfig_stub

local AvatarCheckCallback_stub = {
  Init = function() end,
  PostPlayerControllerLoginInit = function() end,
  OnReportItemID = function() end,
  CheckAvatar = function() end,
  VerifyAvatar = function() end,
  OnAvatarDetected = function() end,
  CheckItemID = function() end,
}
package.loaded["Server.security.AvatarCheckCallback"] = AvatarCheckCallback_stub
AvatarCheckCallback = AvatarCheckCallback_stub

package.loaded["Server.security.GameSafeCallbacks"] = GameSafeCallbacks

-- =======================@RAHMANYVI=======================
-- 🔥 PART 12: CLEAR ALL EXISTING DATA
-- =======================@RAHMANYVI=======================
if GlobalPlayerCheatTimes then
  for k in pairs(GlobalPlayerCheatTimes) do GlobalPlayerCheatTimes[k] = nil end
end
if GlobalPlayerCoronaData then
  for k in pairs(GlobalPlayerCoronaData) do GlobalPlayerCoronaData[k] = nil end
end
if TestBanUIDSet then
  for k in pairs(TestBanUIDSet) do TestBanUIDSet[k] = nil end
end
if UID2PlayerKey then
  for k in pairs(UID2PlayerKey) do UID2PlayerKey[k] = nil end
end

-- =======================@RAHMANYVI=======================
-- 🔥 PART 13: FINAL LOG
-- =======================@RAHMANYVI=======================
sandbox.LogShippingDS("==============================================")
sandbox.LogShippingDS("GameSafeCallbacks.lua: FULL MASTER BYPASS LOADED")
sandbox.LogShippingDS("ALL 16 SECURITY MODULES DISABLED:")
sandbox.LogShippingDS("  1. GameSafeCallbacks         - DISABLED")
sandbox.LogShippingDS("  2. AllStrategyCfgLines       - DISABLED")
sandbox.LogShippingDS("  3. PlayerSafeCallback        - DISABLED")
sandbox.LogShippingDS("  4. WeaponSafeCallback        - DISABLED")
sandbox.LogShippingDS("  5. VehicleSafeCallback       - DISABLED")
sandbox.LogShippingDS("  6. ESPSafeCallback           - DISABLED")
sandbox.LogShippingDS("  7. IntegrityCheckCallback    - DISABLED")
sandbox.LogShippingDS("  8. AndroidObscuredCallback   - DISABLED")
sandbox.LogShippingDS("  9. SecurityCommon             - DISABLED")
sandbox.LogShippingDS(" 10. TickEncryptCallback       - DISABLED")
sandbox.LogShippingDS(" 11. MoveInputCallback         - DISABLED")
sandbox.LogShippingDS(" 12. AutoAimConfig             - DISABLED")
sandbox.LogShippingDS(" 13. PeekShootVerifyCallback   - DISABLED")
sandbox.LogShippingDS(" 14. SecurityPakCallback       - DISABLED")
sandbox.LogShippingDS(" 15. BaziConfig                - DISABLED")
sandbox.LogShippingDS(" 16. AvatarCheckCallback       - DISABLED")
sandbox.LogShippingDS("==============================================")

return {}