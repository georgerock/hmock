let AppEnv=./.env.dhall
let conf=./types.dhall
let testEnv = assert: (env: APP_ENV as Text) === "dev"
in
  confog AppEnv.dev