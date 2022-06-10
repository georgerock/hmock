let Zone = <Central: Text | West: Text>

let RegionConfig = < Local: {host: Text, port: Natural, zone: Zone} | AWSZone: Zone>

let S3Config = < S3CfgLocal: RegionConfig | S3CfgTest: RegionConfig | S3CfgRepl: RegionConfig | S3CfgDev: RegionConfig >

let BaseConfig: Type = 
  { appEnv : Text
  , testApiUrl: Text
  }

let AppConfig: Type =
  { baseConfig : BaseConfig
  , s3Config : S3Config
  }

let AppEnv = ./env.dhall

let getBaseConfig: AppEnv -> BaseConfig = \(e: AppEnv) ->
  
  let apiUrl = env:TEST_API_URL as Text
  let aEnv = env:APP_ENV as Text

  in
    { appEnv = aEnv
    , testApiUrl = apiUrl
    }

let getConfig: AppEnv -> AppConfig = \(e: AppEnv) ->
  
  let regName = "eu-central-1"
  let reg = Zone.Central regName

  let lsHostname = env:LOCALSTACK_HOSTNAME as Text
  ? "localhost"

  let localS3Cfg = RegionConfig.Local { host = lsHostname, port = 4566, zone = reg }
  let devS3Cfg = RegionConfig.AWSZone reg
  let testS3Cfg = RegionConfig.AWSZone reg
  let replS3Cfg = RegionConfig.AWSZone reg

  let s3Cfg = merge
    { dev = S3Config.S3CfgDev devS3Cfg
    , local = S3Config.S3CfgLocal localS3Cfg
    , test = S3Config.S3CfgTest testS3Cfg
    , repl = S3Config.S3CfgRepl replS3Cfg
    }
    e
  
  in 
    { baseConfig = getBaseConfig e
    , s3Config = s3Cfg
    }

in
  getConfig
