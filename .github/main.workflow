workflow "New workflow" {
  on = "push"
  resolves = ["Deploy to Azure"]
}


action "Deploy to Azure" {
  uses = "./.github/azdeploy"
  secrets = ["SERVICE_PASS"]
  env = {
    SERVICE_PRINCIPAL = "http://GitHubActionsSP",
    TENANT_ID="YYYYYYYY-YYYY-YYYY-YYYY-YYYYYYYYYYYY",
    APPID="YourAppIdX100"
  }
}
